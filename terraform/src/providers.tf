terraform {
  backend "s3" {
    region = "us-east-1"

  }

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.84"
    }
  }
}

provider "aws" {
  region = "us-east-1"

  default_tags {
    tags = {
      Name        = "Terraform"
      service     = "terraform"
      environment = "sandbox"
      customer    = "shared"
      stage       = "${var.stage}"
    }
  }
}
