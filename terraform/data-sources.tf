##################################################################################
# DATA SOURCES
##################################################################################

# Discover the AMI image id for Amazon Linux 2
data "aws_ssm_parameter" "amzn2_linux" {
  name = "/aws/service/ami-amazon-linux-latest/amzn2-ami-hvm-x86_64-gp2"
}

# Discover the available availability zones
data "aws_availability_zones" "available" {
  state = "available"
}

# Read in SSH public key for EC2 instance access
data "local_file" "ec2_pub_key" {
  filename = "data/aws_ec2_key.pub"
}
