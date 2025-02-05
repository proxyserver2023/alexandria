terraform {
  backend "s3" {
    region = var.region
  }

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.84"
    }
  }
}



provider "aws" {
  region  = var.region
  profile = var.aws_profile
}
