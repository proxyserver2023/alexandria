variable "project_name" {
  description = "Project name prefix"
  type        = string
  default     = "ecs-hello-world"
}

variable "region" {
  description = "AWS region to deploy to"
  type        = string
  default     = "us-east-1"
}

variable "vpc_cidr" {
  description = "CIDR block for the VPC"
  type        = string
  default     = "10.0.0.0/16"
}

variable "availability_zones" {
  description = "List of availability zones to use"
  type        = list(string)
  default     = ["us-east-1a", "us-east-1b"]
}

variable "container_image" {
  description = "Container image to run in the ECS task"
  type        = string
  default     = "nginxdemos/hello"
}

variable "desired_count" {
  description = "Number of desired ECS tasks"
  type        = number
  default     = 1
}
