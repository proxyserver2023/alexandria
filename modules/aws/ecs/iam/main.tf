# This role is assumed by your tasks (whether on EC2 or Fargate) and grants your application the permissions
# to access AWS resources (like S3, DynamoDB, etc.).
resource "aws_iam_role" "ecs_task_role" {
  name = "${var.name}-ecs-task-role"
  path = "/"
  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Principal = {
          Service = "ecs-tasks.amazonaws.com"
        },
        Action = "sts:AssumeRole"
      }
    ]
  })
}


resource "aws_iam_role_policy_attachment" "ecs_runner_ecr_poweruser" {
  role       = aws_iam_role.ecs_task_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryPowerUser"
}


resource "aws_iam_role_policy" "ecs_runner_cloudwatch" {
  role = aws_iam_role.ecs_task_role.name
  # Write an inline policy that allows writing logs to log group created by the logger module
  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Action = [
          "logs:CreateLogStream",
          "logs:PutLogEvents"
        ],
        Resource = var.log_group_arn
      }
    ]
  })
}


# This role is used by the ECS agent to pull container images (from ECR or other registries) and to send logs to CloudWatch.
# This role is required for both EC2 and Fargate tasks.
resource "aws_iam_role" "ecs_execution_role" {
  name = "${var.name}-ecs-execution-role"
  path = "/"
  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Principal = {
          Service = "ecs-tasks.amazonaws.com"
        },
        Action = "sts:AssumeRole"
      }
    ]
  })
}


resource "aws_iam_role_policy_attachment" "ecs_runner_ecs_execution" {
  role       = aws_iam_role.ecs_execution_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
}

# This role is assigned to the EC2 instances that run your ECS tasks (only needed for EC2 launch type)
# so that the ECS agent on those instances can register with ECS, report instance metrics, and interact with AWS APIs.
resource "aws_iam_role" "ecs_instance_role" {
  name = "${var.name}-ecs-instance-role"
  path = "/"
  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Principal = {
          Service = "ec2.amazonaws.com"
        },
        Action = "sts:AssumeRole"
      }
    ]
  })
}

# Attach a managed policy that grants ECS container instance permissions.
resource "aws_iam_role_policy_attachment" "ecs_instance_managed_policy" {
  role       = aws_iam_role.ecs_instance_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonEC2ContainerServiceforEC2Role"
}

resource "aws_iam_instance_profile" "ecs_instance_profile" {
  name = "${var.name}-ecs-instance-profile"
  role = aws_iam_role.ecs_instance_role.name
}
