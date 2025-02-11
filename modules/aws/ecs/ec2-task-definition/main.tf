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
      ],
      logConfiguration = {
        logDriver = "awslogs"
        options = {
          "awslogs-group"         = var.log_group_name
          "awslogs-region"        = var.region
          "awslogs-stream-prefix" = "ecs"
        }
      },
      # Non-sensitive environment variables
      environment = [
        { name = "APP_MODE", value = "production" },
        { name = "LOG_LEVEL", value = "info" }
      ],
      # Sensitive values pulled securely from SSM Parameter Store or Secrets Manager
      # secrets = [
      #   {
      #     name      = "DB_PASSWORD",
      #     valueFrom = var.db_password_ssm_parameter_arn   # e.g., arn:aws:ssm:region:account-id:parameter/db_password
      #   },
      #   {
      #     name      = "API_KEY",
      #     valueFrom = var.api_key_secret_arn               # e.g., arn:aws:secretsmanager:region:account-id:secret:my-api-key
      #   }
      # ]
    }
  ])
}
