#!/bin/bash

# Step One: Create a Security Group and Set Rules
aws ec2 create-security-group --group-name t2s-sg --description "Allow HTTP and SSH"

aws ec2 authorize-security-group-ingress --group-name t2s-sg --protocol tcp --port 22 --cidr 0.0.0.0/0

aws ec2 authorize-security-group-ingress --group-name t2s-sg --protocol tcp --port 80 --cidr 0.0.0.0/0


# Step Two: Launch an EC2 Instance Using the user data script
# Find the latest Ubuntu AMI ID
# Create or use an existing key pair
aws ec2 run-instances --image-id ami-04b70fa74e45c3917 --count 1 --instance-type t2.micro --key-name nginx --security-group-ids sg-0c846b1771214dd52 --user-data file://userdata.txt


# Step Three: Create a Load Balancer
aws elbv2 create-load-balancer --name t2s-alb --subnets subnet-05cb29a9a04e93491 subnet-0fd1861f670e2f8a6 --security-groups sg-0c846b1771214dd52


# Step Four: Create a Target Group
aws elbv2 create-target-group --name t2s-tg --protocol HTTP --port 80 --vpc-id vpc-02110db7947ceb3f5


# Step Five: Register Targets
# aws elbv2 register-targets --target-group-arn arn:aws:elasticloadbalancing:us-east-1:730335276920:targetgroup/t2s-tg/b1d3ec75adb182e7 --targets Id=i-044ce8b7c21f07dfb

# Step Six: Create a Listener
# aws elbv2 create-listener --load-balancer-arn arn:aws:elasticloadbalancing:region:account-id:loadbalancer/app/t2s-alb/de0cf33548c7fba7 --protocol HTTP --port 80 --default-actions Type=forward,TargetGroupArn=arn:aws:elasticloadbalancing:us-east-1:730335276920:targetgroup/t2s-tg/b1d3ec75adb182e7

# Step Seven: Verify the Load Balancer and open the DNS name in a browser
aws elbv2 describe-load-balancers

# Step Eight: Verify the Target Group
aws elbv2 describe-target-groups

# Step Nine: Verify the Listener
# aws elbv2 describe-listeners

