resource "aws_cloudwatch_log_group" "ecs_log_group" {
  name = "${var.name}-ecs-log-group"
}

output "ecs_log_group_name" {
  value = aws_cloudwatch_log_group.ecs_log_group.name
}

output "ecs_log_group_arn" {
  value = aws_cloudwatch_log_group.ecs_log_group.arn
}
