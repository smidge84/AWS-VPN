##################################################################################
# INPUT VARIABLES
##################################################################################

variable "aws_region" {
  type        = string
  description = "AWS region for resources"
  default     = "eu-west-2"
}

variable "aws_profile" {
  type        = string
  description = "AWS CLI profile to use for authentication"
  default     = "Rich-Sandpit-DevOps"
}

variable "ec2_instance_type" {
  type        = string
  description = "EC2 instance type"
  default     = "t3.micro"
}

variable "ec2_instance_count" {
  type        = number
  description = "The number of EC2 instances to create"
  default     = 1
}

variable "author" {
  type        = string
  description = "The person who crerated this resource"
}

variable "common_tags" {
  type        = map(string)
  description = "A map of tag names and values"
  default     = {}
}

variable "vpc_cidr_block" {
  type        = string
  description = "The network CIDR block for the whole VPC"
  default     = "10.0.0.0/16"
}

variable "private_subnet_count" {
  type        = number
  description = "The number of private subnets to create"
  default     = 2
}

variable "private_subnets_cidr_blocks" {
  type        = list(string)
  description = "The network CIDR block for private subnets within the VPC"
  default     = ["10.0.0.0/24", "10.0.1.0/24 "]
}

variable "map_public_ip_on_launch" {
  type        = bool
  description = "Map a public IP for all EC2 instances attached to the subnet"
  default     = true
}
variable "enable_dns_hostnames" {
  type        = bool
  description = "Enable DNS hostnames in the VPC"
  default     = true
}

variable "naming_prefix" {
  type        = string
  description = "Naming prefix to apply to all resources"
  default     = "aws-vpn"
}

variable "environment" {
  type        = string
  description = "Environment for resources"
  default     = "dev"
}
