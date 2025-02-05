resource "aws_s3_bucket" "terraform_s3_state" {
  bucket = "proxyserver2023-sandbox-terraform-state-${var.stage}"

  lifecycle {
    prevent_destroy = true
  }

  tags = {
    Name = "proxyserver2023-sandbox-terraform-state-${var.stage}"
  }
}

resource "aws_s3_bucket_versioning" "terraform_s3_state_versioning" {
  bucket = aws_s3_bucket.terraform_s3_state.id
  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_dynamodb_table" "terraform_state_lock" {
  name           = "terraform-state-lock-${var.stage}"
  read_capacity  = 1
  write_capacity = 1
  hash_key       = "LockID"

  attribute {
    name = "LockID"
    type = "S"
  }
}

resource "aws_iam_policy" "terraform_state_policy" {
  name        = "terraform-state-management-policy-${var.stage}"
  description = "Enables remote state management for the Terraform service"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = [
          "s3:GetObject",
          "s3:PutObject",
          "s3:DeleteObject"
        ]
        Effect   = "Allow"
        Sid      = "StateBucketCRUD"
        Resource = "arn:aws:s3:::${aws_s3_bucket.terraform_s3_state.id}/*"
      },
      {
        Action   = "s3:ListBucket"
        Effect   = "Allow"
        Sid      = "ListStateBucket"
        Resource = "arn:aws:s3:::${aws_s3_bucket.terraform_s3_state.id}"
      }
    ]
  })
}
