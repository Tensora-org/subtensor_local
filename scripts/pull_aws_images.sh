#!/bin/bash

ACCOUNT=${1:-default} 

if [ "ACCOUNT" == "default" ]; then  # Check if NODE_IP is provided
    echo "Error: Account Number is required for publishing image"
    exit 1
  fi

# Set up profile as aws
# aws sso config

export AWS_PROFILE=aws

aws ecr get-login-password --region us-east-1 | docker login --username AWS --password-stdin $ACCOUNT.dkr.ecr.us-east-1.amazonaws.com

docker pull $ACCOUNT.dkr.ecr.us-east-1.amazonaws.com/localnet_images