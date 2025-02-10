resource "aws_ecs_service" "ec2_service" {
  name            = var.name
  cluster         = var.cluster_id
  task_definition = var.task_definition_arn
  launch_type     = "EC2"

  capacity_provider_strategy {
    capacity_provider = var.spot_cp_name
    weight            = var.spot_weight
  }
  capacity_provider_strategy {
    capacity_provider = var.ondemand_cp_name
    weight            = var.ondemand_weight
  }

  desired_count = var.desired_count

  deployment_minimum_healthy_percent = 50
  deployment_maximum_percent         = 200

  load_balancer {
    target_group_arn = var.target_group_arn
    container_name   = var.container_name
    container_port   = var.container_port
  }
}
