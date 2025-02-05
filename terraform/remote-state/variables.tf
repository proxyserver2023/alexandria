variable "stage" {
  description = "The deployment stage (dev, staging, prod)"
  type        = string
  default     = "dev"
}

variable "region" {
  description = "The AWS region to deploy resources"
  type        = string
  default     = "us-east-1"
}

variable "aws_profile" {
  description = "The AWS profile to use"
  type        = string
  default     = "sandbox-admin"
}
