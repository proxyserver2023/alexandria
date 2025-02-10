resource "aws_ecs_task_definition" "ec2_task" {
  family                   = var.family
  requires_compatibilities = ["EC2"]
  network_mode             = "bridge"
  cpu                      = var.cpu
  memory                   = var.memory
  execution_role_arn       = var.execution_role_arn
  task_role_arn            = var.task_role_arn

  container_definitions = jsonencode([
    {
      name      = "web"
      image     = var.image
      essential = true
      portMappings = [
        {
          # Dynamic Host Port Mapping:
          # For the EC2 service, the task definition uses "hostPort": 0 in bridge mode,
          # and the ECS agent automatically registers the actual host port in the target group.
          containerPort = var.container_port,
          hostPort      = 0,
          protocol      = "tcp"
        }
      ]
    }
  ])
}
