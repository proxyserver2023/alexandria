variable "stage" {
  description = "The environment stage name"
  type        = string
  default     = "dev"
}

variable "vpc_cidr" {
  description = "The CIDR block for the VPC"
  type        = string
  default     = "10.11.0.0/16"
}

variable "availability_zones" {
  description = "The availability zones to deploy the VPC subnets"
  type        = list(string)
  default     = ["us-east-1a", "us-east-1b", "us-east-1c", "us-east-1d"]
}

variable "cidr_blocks" {
  description = "List of CIDR blocks for the subnets"
  type        = list(string)
  default     = ["10.11.12.0/28", "10.11.13.0/28", "10.11.14.0/28", "10.11.15.0/28"]
}

variable "cpu" {
  description = "The amount of CPU units used by the task. It can be expressed as an integer using CPU units, for example 1024, or as a string using vCPUs, for example 1 vCPU or 1 vcpu, in a task definition but not both."
  type        = string
  default     = "256"
}

variable "memory" {
  description = "The amount (in MiB) of memory used by the task. It can be expressed as an integer using MiB, for example 1024, or as a string using GB, for example 1GB or 1 gb, in a task definition but not both."
  type        = string
  default     = "256"
}
