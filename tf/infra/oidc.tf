data "aws_caller_identity" "current" {}

resource "aws_iam_openid_connect_provider" "github" {
  client_id_list  = ["sts.amazonaws.com"]
  thumbprint_list = ["6938fd4d98bab03faadb97b34396831e3780aea1"]
  url             = "https://token.actions.githubusercontent.com"
}


resource "aws_iam_role" "iam_role_for_github_oidc" {
  name        = "roleForGithubToPushToEcr"
  description = "role for Github to push to ECR"

  managed_policy_arns = [
    aws_iam_policy.iam_policy_for_ECR.arn#,
    #"arn:aws:iam::aws:policy/AdministratorAccess"
  ]

  assume_role_policy = jsonencode({
    "Version" : "2012-10-17",
    "Statement" : [
      {
        "Effect" : "Allow",
        "Principal" : {
          "Federated" : "arn:aws:iam::${data.aws_caller_identity.current.account_id}:oidc-provider/token.actions.githubusercontent.com"
        },
        "Action" : "sts:AssumeRoleWithWebIdentity",
        "Condition" : {
          "StringEquals" : {
            "token.actions.githubusercontent.com:sub" : "repo:maksimstankevic/go-work:environment:${var.environment}",
            "token.actions.githubusercontent.com:aud" : "sts.amazonaws.com"
          }
        }
      }
    ]
  })
}

resource "aws_iam_policy" "iam_policy_for_ECR" {
  name = "iam_policy_for_ECR"

  policy = jsonencode({
    "Version" : "2012-10-17",
    "Statement" : [
      {
        "Effect": "Allow",
        "Action": [
          "ecr:*"
        ],
        "Resource": "*"
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "role_policy_attachment_for_ECR" {
  role       = aws_iam_role.iam_role_for_github_oidc.name
  policy_arn = aws_iam_policy.iam_policy_for_ECR.arn
}