terraform {
  required_version = ">= 1.10"
}

provider "aws" {
  region = var.region
}
