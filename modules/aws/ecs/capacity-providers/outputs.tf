output "ondemand_cp_name" {
  value = aws_ecs_capacity_provider.ondemand_provider.name
}

output "spot_cp_name" {
  value = aws_ecs_capacity_provider.spot_provider.name
}
