
resource "aws_ecr_repository" "repo" {
  name                 = "${var.name}-repo"
  image_tag_mutability = "MUTABLE"
  image_scanning_configuration {
    scan_on_push = true
  }
  encryption_configuration {
    # TODO: Migrate to KMS
    encryption_type = "AES256"
  }
  tags = {
    Name    = "${var.name}-repo"
    service = var.name
  }
}

resource "aws_ecr_repository_policy" "repo_policy" {
  repository = aws_ecr_repository.repo.name
  policy = jsonencode({
    Version = "2008-10-17"
    Statement = [
      {
        Sid       = "AllowPushPull"
        Effect    = "Allow"
        Principal = { Service = "ecs-tasks.amazonaws.com" }
        Action = [
          "ecr:GetDownloadUrlForLayer",
          "ecr:BatchGetImage",
          "ecr:BatchCheckLayerAvailability",
        ]
      }
    ]
  })
}
