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

variable "subnets" {
  description = "List of subnet IDs"
  type        = list(string)
}

variable "is_public" {
  description = "Flag to determine if the instance should have a public IP"
  type        = bool
  default     = false
}

variable "ecs_sg_id" {
  description = "Security group ID for ECS instances"
  type        = string
}

variable "ondemand_min" {
  type    = number
  default = 1
}

variable "ondemand_max" {
  type    = number
  default = 1
}

variable "ondemand_desired" {
  type    = number
  default = 1
}

variable "spot_min" {
  type    = number
  default = 1
}
variable "spot_max" {
  type    = number
  default = 3
}
variable "spot_desired" {
  type    = number
  default = 2
}

variable "public_key_path" {
  description = "The local file path to your public SSH key."
  type        = string
  default     = "~/.ssh/id_rsa.pub"
}

variable "instance_profile" {
  description = "Name of the ECS instance profile"
  type        = string
}
