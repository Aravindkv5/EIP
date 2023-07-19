#!/bin/bash

# Get the instance ID
INSTANCE_ID=$(curl -s http://169.254.169.254/latest/meta-data/instance-id)

# Get the region of the instance
REGION=$(curl -s http://169.254.169.254/latest/meta-data/placement/availability-zone | sed 's/.$//')

# Get the two Elastic IP addresses
EIP1="x.x.x.x" # Replace with your first Elastic IP address
EIP2="y.y.y.y" # Replace with your second Elastic IP address

# Check which Elastic IP is available
if aws ec2 describe-addresses --public-ips $EIP1 --region $REGION | grep -q "AssociationId"; then
  echo "Elastic IP $EIP1 is already associated with an instance"
  aws ec2 associate-address --instance-id $INSTANCE_ID --public-ip $EIP2 --region $REGION
else
  echo "Assigning Elastic IP $EIP1 to instance $INSTANCE_ID"
  aws ec2 associate-address --instance-id $INSTANCE_ID --public-ip $EIP1 --region $REGION
fi
