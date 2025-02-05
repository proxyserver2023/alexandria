resource "aws_iam_role" "terraform_service_deployment_iam_role" {
  name = "terraform-service-deployment-iam-role-${var.stage}"
  managed_policy_arns = [
    "arn:aws:iam::aws:policy/AdministratorAccess"
  ]
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "ec2.amazonaws.com"
        }
      },
      {
        "Effect" : "Allow",
        "Principal" : { "Federated" : "arn:aws:iam::625377802426:oidc-provider/token.actions.githubusercontent.com" },
        "Action" : "sts:AssumeRoleWithWebIdentity"
        "Condition" : {
          "StringEquals" : {
            "token.actions.githubusercontent.com:aud" : "sts.amazonaws.com"
          },
          "StringLike" : {
            "token.actions.githubusercontent.com:sub" : "repo:proxyserver2023/*"
          }
        }
      }
    ]
  })
}
