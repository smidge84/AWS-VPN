##################################################################################
# NETWORKING RESOURCES
##################################################################################

# module "app" {
#   source  = "terraform-aws-modules/vpc/aws"
#   version = "5.12.0"

#   cidr = var.vpc_cidr_block

#   azs            = slice(data.aws_availability_zones.available.names, 0, var.public_subnet_count)
#   public_subnets = [for subnet in range(var.public_subnet_count) : cidrsubnet(var.vpc_cidr_block, 8, subnet)]

#   enable_nat_gateway      = false
#   enable_vpn_gateway      = false
#   enable_dns_hostnames    = var.enable_dns_hostnames
#   map_public_ip_on_launch = var.map_public_ip_on_launch

#   tags = {
#     Terratags = merge(
#       local.global_tags,
#       {
#         Name = "${local.naming_prefix}-vpc"
#       }
#     )
#   }
# }


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

resource "aws_security_group" "ec2_sg1" {
  name = "${local.naming_prefix}-sg1"
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

  tags = local.global_tags
}