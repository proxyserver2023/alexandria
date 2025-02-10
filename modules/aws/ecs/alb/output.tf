output "alb_dns_name" {
  value = aws_lb.app_alb.dns_name
}

output "ec2_target_group_arn" {
  value = aws_lb_target_group.ec2_tg.arn
}

output "fargate_target_group_arn" {
  value = aws_lb_target_group.fargate_tg.arn
}
