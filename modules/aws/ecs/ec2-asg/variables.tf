variable "name" {
  description = "Name prefix for EC2 ASG resources"
  type        = string
}

variable "instance_type" {
  description = "EC2 instance type"
  type        = string
  default     = "m5.large"
}

variable "key_name" {
  description = "EC2 key pair name"
  type        = string
}

variable "ecs_cluster_name" {
  description = "ECS Cluster name to register in /etc/ecs/ecs.config"
  type        = string
}

variable "public_subnets" {
  description = "List of public subnet IDs"
  type        = list(string)
}

variable "ecs_sg_id" {
  description = "Security group ID for ECS instances"
  type        = string
}

variable "ondemand_min" {
  type    = number
  default = 2
}
variable "ondemand_max" {
  type    = number
  default = 10
}
variable "ondemand_desired" {
  type    = number
  default = 2
}

variable "spot_min" {
  type    = number
  default = 2
}
variable "spot_max" {
  type    = number
  default = 10
}
variable "spot_desired" {
  type    = number
  default = 2
}
