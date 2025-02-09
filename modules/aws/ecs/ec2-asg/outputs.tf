output "ondemand_asg_arn" {
  value = aws_autoscaling_group.ondemand_asg.arn
}

output "spot_asg_arn" {
  value = aws_autoscaling_group.spot_asg.arn
}
