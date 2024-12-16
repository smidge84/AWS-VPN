##################################################################################
# GLOBAL TERRAFROM CONFIGURATION
##################################################################################

terraform {

  required_version = ">= 1.0, <2.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}
