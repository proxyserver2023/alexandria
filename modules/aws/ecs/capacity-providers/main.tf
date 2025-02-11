resource "aws_ecs_capacity_provider" "ondemand_provider" {
  name = "EC2_ONDEMAND_CP"

  auto_scaling_group_provider {
    auto_scaling_group_arn         = var.ondemand_asg_arn
    managed_termination_protection = "DISABLED"
    managed_scaling {
      status                    = "ENABLED"
      target_capacity           = 10
      minimum_scaling_step_size = 1
      maximum_scaling_step_size = 1000
    }
  }
}

resource "aws_ecs_capacity_provider" "spot_provider" {
  name = "EC2_SPOT_CP"

  auto_scaling_group_provider {
    auto_scaling_group_arn         = var.spot_asg_arn
    managed_termination_protection = "DISABLED"
    managed_scaling {
      status                    = "ENABLED"
      target_capacity           = 90
      minimum_scaling_step_size = 1
      maximum_scaling_step_size = 1000
    }
  }
}

resource "aws_ecs_cluster_capacity_providers" "cluster_providers" {
  cluster_name = var.cluster_name
  capacity_providers = [
    aws_ecs_capacity_provider.ondemand_provider.name,
    aws_ecs_capacity_provider.spot_provider.name,
    "FARGATE",
    "FARGATE_SPOT"
  ]
}
