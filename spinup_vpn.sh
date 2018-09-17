#!/usr/bin/env bash

read -p 'Please specify AWS region name in which you would like to host the VPN solution: ' aws_region
read -p 'Have you configured the AWS CLI? [y/n]: ' aws_cli_config

if [[ ${aws_cli_config} != "y" && ${aws_cli_config} != "Y" ]]; then
    read -p 'AWS Access Key ID: ' aws_access_key_id
    read -p 'AWS Secret Access Key: ' aws_secret_access_key
    export AWS_ACCESS_KEY_ID=${aws_access_key_id}
    export AWS_SECRET_ACCESS_KEY=${aws_secret_access_key}
    export AWS_DEFAULT_REGION=${aws_region}
fi

read -sp 'VPN username: ' vpn_username
echo
read -sp 'VPN password: ' vpn_password
echo
read -sp 'VPN passphrase: ' vpn_passphrase
echo

# Get latest Amazon Linux AMI ID
ami_id="$(aws ec2 describe-images --owners amazon --filters Name=name,Values=amzn-ami-hvm-*ebs\
 --query "reverse(sort_by(Images, &CreationDate))[0].ImageId" --output text --region ${aws_region})"

echo 'Creating EC2 key pair'

# Create EC2 keypair
ec2_keypair_output="$(aws ec2 create-key-pair --key-name L2TP_VPN_key --region ${aws_region})"
echo ${ec2_keypair_output} > ec2_keypair_output

# Create CloudFormation stack
vpn_stack_output="$(aws cloudformation create-stack --stack-name L2TP-IPSec-VPN --template-body file://VPN_CF_template.yaml\
 --parameters ParameterKey=VPNUsername,ParameterValue=${vpn_username} ParameterKey=VPNPassword,ParameterValue=${vpn_password}\
 ParameterKey=VPNPhrase,ParameterValue=${vpn_passphrase} ParameterKey=EC2AMIID,ParameterValue=${ami_id}\
 ParameterKey=EC2KeyName,ParameterValue=L2TP_VPN_key --region ${aws_region})"

echo 'Creating CloudFormation stack'

stack_status=""

while [ "${stack_status}" != "CREATE_COMPLETE" ]; do
    stack_status="$(aws cloudformation describe-stacks --stack-name L2TP-IPSec-VPN --query\
     'Stacks[0].StackStatus' --output text --region ${aws_region})"
    echo -n "."
    sleep 2
done

vpn_ip="$(aws cloudformation describe-stacks --stack-name L2TP-IPSec-VPN --query\
 'Stacks[0].Outputs[?OutputKey==`VPNServerIP`].OutputValue' --output text --region ${aws_region})"

echo
echo "Your VPN IP address is: "${vpn_ip}
