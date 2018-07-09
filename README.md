# AWS L2TP/IPSec VPN

A fully automated solution for setting up L2TP over IPSec VPN solution in AWS cloud.

## Getting Started

### Prerequisites

* AWS account
* AWS access key
* AWS CLI

### Spinning up the VPN

Clone the repository:
```bash
git clone git@github.com:mazay/aws-l2tp-vpn.git
```

Switch to the project directory:
```bash
cd aws-l2tp-vpn
```

Start the _spinup_vpn.sh_ script and input details for your VPN setup, you can find the list of AWS regions [here](https://docs.aws.amazon.com/AmazonRDS/latest/UserGuide/Concepts.RegionsAndAvailabilityZones.html).
```
Please specify AWS region name in which you would like to host the VPN solution: 
Have you configured the AWS CLI? [y/n]: 
VPN username: 
VPN password: 
VPN passphrase: 
```

This will create EC2 key pair for you and a CloudFormation stack containing the following resources:
* VPC
* Internet Gateway
* VPC Subnet
* VPC Route Table along with the default route
* EC2 Security Group allowing access to the following ports:
    * TCP/UDP 500
    * TCP/UDP 4500
    * TCP 22022 - custom SSH port
* EC2 instance - the instance will be provisioned with the VPN server software
* Elastic IP

**The overall hosting cost should be about $5, depending on the selected AWS region.**

### Tearing down the VPN

Start the _teardown_vpn.sh_ which will delete the EC2 key pair and CloudFormation stack, please note that the stack deletion procedure on AWS side might take up to 10 minutes.
```
Please specify AWS region name in which you host the VPN solution: 
Have you configured the AWS CLI? [y/n]: 
```
