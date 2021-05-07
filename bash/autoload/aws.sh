#!/usr/bin/env bash

# Get all instances state
function aws.print-all-instances()
{
    REGIONS=`aws ec2 describe-regions --region eu-central-1 --output text --query Regions[*].[RegionName]`
    for REGION in $REGIONS
    do
        echo -e "\nInstances in '$REGION'..";
        aws ec2 describe-instances --region $REGION | \
            jq '.Reservations[].Instances[] | "EC2: \(.InstanceId): \(.State.Name)"'
    done
}

# Get all instances public IPs
function aws.print-all-public-ip()
{
    REGIONS=`aws ec2 describe-regions --region eu-central-1 --output text --query Regions[*].[RegionName]`
    for REGION in $REGIONS
    do
        echo -e "\nInstances in '$REGION'..";
        aws ec2 describe-instances --region $REGION | \
            jq '.Reservations[].Instances[] | "EC2: \(.InstanceId): \(.PublicIpAddress)"'
    done
}

# Get all instances private IPs
function aws.print-all-private-ip()
{
    REGIONS=`aws ec2 describe-regions --region eu-central-1 --output text --query Regions[*].[RegionName]`
    for REGION in $REGIONS
    do
        echo -e "\nInstances in '$REGION'..";
        aws ec2 describe-instances --region $REGION | \
            jq '.Reservations[].Instances[] | "EC2: \(.InstanceId): \(.PrivateIpAddress)"'
    done
}

alias aws-profiles='aws configure list-profiles'
