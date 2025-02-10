variable "name" {
  description = "Name prefix for the VPC"
  type        = string
  default     = "my-vpc"
}

variable "cidr_block" {
  description = "CIDR block for the VPC"
  type        = string
  default     = "10.0.0.0/16"
}

variable "subnet_bits" {
  description = "Bits to further divide the CIDR for subnets"
  type        = number
  default     = 8
}
