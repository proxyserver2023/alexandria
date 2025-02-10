variable "name" {
  type = string
}
variable "cluster_id" {
  type = string
}
variable "task_definition_arn" {
  type = string
}
variable "spot_cp_name" {
  type = string
}
variable "ondemand_cp_name" {
  type = string
}
variable "spot_weight" {
  type = number
}
variable "ondemand_weight" {
  type = number
}
variable "desired_count" {
  type = number
}
variable "subnets" {
  type = list(string)
}
variable "security_groups" {
  type = list(string)
}
variable "target_group_arn" {
  type = string
}
variable "container_name" {
  type = string
}
variable "container_port" {
  type = number
}
