#!/usr/bin/env bash

read -p 'Please specify AWS region name in which you host the VPN solution: ' aws_region
read -p 'Have you configured the AWS CLI? y/n: ' aws_cli_config

if [[ ${aws_cli_config} != "y" && ${aws_cli_config} != "Y" ]]; then
    read -p 'AWS Access Key ID: ' aws_access_key_id
    read -p 'AWS Secret Access Key: ' aws_secret_access_key
    export AWS_ACCESS_KEY_ID=${aws_access_key_id}
    export AWS_SECRET_ACCESS_KEY=${aws_secret_access_key}
    export AWS_DEFAULT_REGION=${aws_region}
fi

echo 'Removing AWS resources'

aws cloudformation delete-stack --stack-name L2TP-IPSec-VPN --region ${aws_region}
aws ec2 delete-key-pair --key-name L2TP_VPN_key --region ${aws_region}
