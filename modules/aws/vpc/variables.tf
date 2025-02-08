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

variable "public_subnet_count" {
  description = "Number of public subnets"
  type        = number
  default     = 2
}

variable "public_subnet_bits" {
  description = "Bits to further divide the CIDR for public subnets"
  type        = number
  default     = 8
}

variable "availability_zones" {
  description = "List of availability zones"
  type        = list(string)
  default     = ["us-east-1a", "us-east-1b"] # TODO: Fetch AZ from provider using datablock
}
