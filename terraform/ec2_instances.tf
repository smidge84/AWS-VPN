##################################################################################
# EC2 INSTANCE RESOURCES
##################################################################################

resource "aws_instance" "ec2_instance" {
  count                  = var.ec2_instance_count
  ami                    = nonsensitive(data.aws_ssm_parameter.amzn2_linux.value)
  instance_type          = var.ec2_instance_type
  subnet_id              = aws_subnet.private_subnets[(count.index % var.private_subnet_count)].id
  vpc_security_group_ids = [aws_security_group.ec2_sg1.id]
  key_name               = aws_key_pair.ec2_key.key_name

  tags = merge(
    local.global_tags,
    {
      Name = "${local.naming_prefix}-ec2-${count.index}"
    }
  )
}

# SSH Key Pair - required to be able to access the EC2 instances
resource "aws_key_pair" "ec2_key" {
  key_name   = "${var.naming_prefix}-ec2-key"
  public_key = data.local_file.ec2_pub_key.content

  tags = merge(
    local.global_tags,
    {
      Name = "${local.naming_prefix}-ec2-key"
    }
  )
}
