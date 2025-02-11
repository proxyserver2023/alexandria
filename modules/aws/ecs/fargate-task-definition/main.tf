resource "aws_ecs_task_definition" "fargate_task" {
  family                   = var.family
  requires_compatibilities = ["FARGATE"]
  network_mode             = "awsvpc"
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
          hostPort      = var.container_port,
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
