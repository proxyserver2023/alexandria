variable "name" {
  type = string
}
variable "cluster_id" {
  type = string
}
variable "task_definition_arn" {
  type = string
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

variable "fargate_spot_weight" {
  type = number
}
variable "fargate_on_demand_weight" {
  type = number
}
