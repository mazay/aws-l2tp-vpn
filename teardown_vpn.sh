#!/usr/bin/env bash

echo 'Removing AWS resources'

aws cloudformation delete-stack --stack-name L2TP-IPSec-VPN
aws ec2 delete-key-pair --key-name L2TP_VPN_key
