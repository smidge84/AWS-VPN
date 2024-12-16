##################################################################################
# NETWORKING RESOURCES
##################################################################################

# VPC #

resource "aws_vpc" "main" {
  cidr_block = var.vpc_cidr_block

  tags = merge(
    local.global_tags,
    {
      Name = "${local.naming_prefix}-vpc"
    }
  )
}

# PRIVATE SUBNETS #

resource "aws_subnet" "private_subnets" {
  count                   = length(var.private_subnets_cidr_blocks)
  vpc_id                  = aws_vpc.main.id
  cidr_block              = cidrsubnet(var.vpc_cidr_block, 8, count.index)
  map_public_ip_on_launch = var.map_public_ip_on_launch
  availability_zone       = data.aws_availability_zones.available.names[count.index]

  tags = merge(local.global_tags, {
    Name = "${local.naming_prefix}-subnet-${count.index}"
  })
}

# SECURITY GROUPS #

# Security Group for EC2 instances
resource "aws_security_group" "ec2_sg1" {
  name   = "${local.naming_prefix}-sg-ec2s"
  vpc_id = aws_vpc.main.id

  # SSH access from anywhere
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # outbound internet access
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = merge(local.global_tags, {
    Name = "${local.naming_prefix}-sg-ec2s"
  })
}

# Seciruty group for EC2 instance connect endpoint
resource "aws_security_group" "ec2_ic_sg1" {
  name   = "${local.naming_prefix}-sg-ec2-ic"
  vpc_id = aws_vpc.main.id

  # Outbound SSH traffic to instances on other SG
  egress {
    from_port       = 22
    to_port         = 22
    protocol        = "tcp"
    security_groups = [aws_security_group.ec2_sg1.id]
  }

  # Inbound all traffic
  ingress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = merge(local.global_tags, {
    Name = "${local.naming_prefix}-sg-ec2-ic"
  })
}



# AWS Instance Connect private endpoints #
# So we can connect to the EC2 insances throught the AWS console #

resource "aws_ec2_instance_connect_endpoint" "ec2_ic_endpoint" {
  count              = length(aws_subnet.private_subnets)
  subnet_id          = aws_subnet.private_subnets[count.index].id
  security_group_ids = [aws_security_group.ec2_ic_sg1.id]

  tags = merge(local.global_tags, {
    Name = "${local.naming_prefix}-ec2-ic-endpoint-${count.index}"
  })
}
