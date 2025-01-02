##################################################################################
# CONFIGURATION FOR AWS CLIENT VPN CONNECTION
##################################################################################

# Create some certificates (external pre-requisite)

# # Add certificate for VPN server host to AWS Certificate Manager
# resource "aws_acm_certificate" "vpn_server" {
#   domain_name = "*.initiate.resonate.tech"
#   validation_method = "DNS"

#   tags = merge(
#     local.global_tags,
#     {
#       Name = "${local.naming_prefix}-vpn-server-cert"
#     }
#   )

#   lifecycle {
#     create_before_destroy = true
#   }
# }

# # Validate the certificate
# resource "aws_acm_certificate_validation" "vpn_server" {
#   certificate_arn = aws_acm_certificate.vpn_server.arn

#   timeouts {
#     create = "1m"
#   }
# }

# Don't think the above is required when providing our own server certificate which we importing into AWS ACM separately
# We just need to retrieve the ARN of the server certificate which we wish to associate with the VPN endpoint
data "aws_acm_certificate" "vpn_server" {
  statuses = ["ISSUED"]
  domain   = "server" # This is set when the server certificate is created, so we need to plan names ahead
}

# Add root certificate to AWS Certificate Manager
resource "aws_acm_certificate" "vpn_client_root_cert" {
  private_key       = file("data/certs/initiate_vpn_client1.key")
  certificate_body  = file("data/certs/initiate_vpn_client1.crt")
  certificate_chain = file("data/certs/ca.crt")

  tags = merge(
    local.global_tags,
    {
      Name = "${local.naming_prefix}-vpn-client-root-cert"
    }
  )
}


# Create Security Group for VPN connections
resource "aws_security_group" "vpn_access" {
  name   = "${local.naming_prefix}-sg-vpn-access"
  vpc_id = aws_vpc.main.id

  # Only allow SSH connections to a targeted subnet
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["10.0.0.0/24"]
  }

  # Allow all return traffic
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = merge(
    local.global_tags,
    {
      Name = "${local.naming_prefix}-sg-vpn-access"
    }
  )
}

# Create client VPN endpoint - connected only to the first subnet
resource "aws_ec2_client_vpn_endpoint" "vpn_endpoint" {
  description            = "Initiate Training VPN endpoint"
  vpc_id                 = aws_vpc.main.id
  client_cidr_block      = "10.0.60.0/22" # This should be parameterised
  split_tunnel           = true
  session_timeout_hours  = 24
  server_certificate_arn = data.aws_acm_certificate.vpn_server.arn
  security_group_ids     = [aws_security_group.vpn_access.id]

  authentication_options {
    type                       = "certificate-authentication"
    root_certificate_chain_arn = aws_acm_certificate.vpn_client_root_cert.arn
  }

  connection_log_options {
    enabled = false
  }

  client_login_banner_options {
    banner_text = "Welcome to Rich's Sandpit VPC"
    enabled     = true
  }

  tags = merge(
    local.global_tags,
    {
      Name = "${local.naming_prefix}-vpn-endpoint"
    }
  )
}

# Create client VPN endpoint attachment(s)
resource "aws_ec2_client_vpn_network_association" "vpn_subnet_assoc" {
  client_vpn_endpoint_id = aws_ec2_client_vpn_endpoint.vpn_endpoint.id
  subnet_id              = aws_subnet.private_subnets[0].id
}

# Create client VPN authorisation rule
resource "aws_ec2_client_vpn_authorization_rule" "apn_auth_rule" {
  client_vpn_endpoint_id = aws_ec2_client_vpn_endpoint.vpn_endpoint.id
  target_network_cidr    = aws_subnet.private_subnets[0].cidr_block
  authorize_all_groups   = true
  description            = "Allow all access to the first subnet only"
}
