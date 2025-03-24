Creates a simple VPC in AWS with:

- 3 public and 3 private subnets
- Route tables and security groups for each of the above 
- The private security group allows ingress from/egress to only the same VPC
- The public security group allows ingress/egress from the internet
- The public route table likewise allows routing to the internet, but the private only routes within the VPC

- Instances created in the public subnet can be accessed via EC2 Instance Connect. However, to do so the instance will need to have an IAM role such as `AmazonSSMRoleForInstancesQuickSetup` 
