#!/usr/bin/env bash

# before you can run this file, you need to run:
# aws sso login
# # Then export your aws_profile
# export AWS_PROFILE=

# You then pass in the account id of the accout you logged in to as the first argument

ACCOUNT=${1:-default} 

if [ "ACCOUNT" == "default" ]; then  # Check if NODE_IP is provided
    echo "Error: Account Number is required for publishing image"
    exit 1
  fi

docker build -t stagingnet:latest .

aws ecr get-login-password --region us-east-1 | docker login --username AWS --password-stdin $ACCOUNT.dkr.ecr.us-east-1.amazonaws.com

docker tag stagingnet:latest $ACCOUNT.dkr.ecr.us-east-1.amazonaws.com/localnet_images

docker push $ACCOUNT.dkr.ecr.us-east-1.amazonaws.com/localnet_images


