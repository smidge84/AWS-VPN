##################################################################################
# EC2 INSTANCE RESOURCES
##################################################################################

resource "aws_instance" "nginx_instance" {
  count                  = var.ec2_instance_count
  ami                    = nonsensitive(data.aws_ssm_parameter.amzn2_linux.value)
  instance_type          = var.ec2_instance_type
  subnet_id              = aws_subnet.private_subnets[(count.index % var.private_subnet_count)].id
  vpc_security_group_ids = [aws_security_group.ec2_sg1.id]

  tags = merge(
    local.global_tags,
    {
      Name = "${local.naming_prefix}-nginx-${count.index}"
    }
  )
}
