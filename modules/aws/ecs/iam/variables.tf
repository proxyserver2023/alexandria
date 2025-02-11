variable "name" {
  description = "Name prefix for IAM role"
  type        = string
}

variable "log_group_arn" {
  description = "ARN of the CloudWatch log group"
  type        = string
}
