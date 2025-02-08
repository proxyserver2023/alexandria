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
          containerPort = var.container_port,
          hostPort      = 0,
          protocol      = "tcp"
        }
      ]
    }
  ])
}
