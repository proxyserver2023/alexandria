resource "aws_ecs_service" "fargate_service" {
  name            = var.name
  cluster         = var.cluster_id
  task_definition = var.task_definition_arn

  capacity_provider_strategy {
    capacity_provider = "FARGATE_SPOT"
    weight            = var.fargate_spot_weight
  }
  capacity_provider_strategy {
    capacity_provider = "FARGATE"
    weight            = var.fargate_on_demand_weight
  }

  desired_count = var.desired_count

  deployment_minimum_healthy_percent = 50
  deployment_maximum_percent         = 200

  network_configuration {
    subnets          = var.subnets
    security_groups  = var.security_groups
    assign_public_ip = "true"
  }

  load_balancer {
    target_group_arn = var.target_group_arn
    container_name   = var.container_name
    container_port   = var.container_port
  }
}
