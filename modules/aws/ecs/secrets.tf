resource "aws_secretsmanager_secret" "git_runner_gh_token" {
  name = "github-selfhostedrunner-sm-${var.stage}-gh-token"
}

data "aws_iam_policy_document" "secret_access_policy" {
  statement {
    actions   = ["secretsmanager:GetSecretValue"]
    resources = [aws_secretsmanager_secret.git_runner_gh_token.arn]
    principals {
      type        = "AWS"
      identifiers = [aws_iam_role.git_runner.arn]
    }
  }
}

resource "aws_secretsmanager_secret_policy" "git_runner_gh_token_policy" {
  secret_arn = aws_secretsmanager_secret.git_runner_gh_token.arn
  policy     = data.aws_iam_policy_document.secret_access_policy.json
}

