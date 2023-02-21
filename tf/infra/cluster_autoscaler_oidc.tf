resource "aws_iam_role" "iam_role_for_cluster_autoscaler" {
  name        = "roleForClusterAutoscaler"
  description = "role for Cluster Autoscaler for managing ASGs"

  inline_policy {
    name = "asg-perms"

    policy = jsonencode({
    "Version": "2012-10-17",
    "Statement": [
        {
            "Sid": "VisualEditor0",
            "Effect": "Allow",
            "Action": [
                "autoscaling:SetDesiredCapacity",
                "autoscaling:TerminateInstanceInAutoScalingGroup"
            ],
            "Resource": "*",
            "Condition": {
                "StringEquals": {
                    "aws:ResourceTag/k8s.io/cluster-autoscaler/${var.cluster_name}": "owned"
                }
            }
        },
        {
            "Sid": "VisualEditor1",
            "Effect": "Allow",
            "Action": [
                "autoscaling:DescribeAutoScalingInstances",
                "autoscaling:DescribeAutoScalingGroups",
                "ec2:DescribeLaunchTemplateVersions",
                "autoscaling:DescribeTags",
                "autoscaling:DescribeLaunchConfigurations",
                "ec2:DescribeInstanceTypes"
            ],
            "Resource": "*"
        }
    ]
    })
  }

  assume_role_policy = jsonencode({
    "Version" : "2012-10-17",
    "Statement" : [
      {
        "Effect" : "Allow",
        "Principal" : {
          "Federated" : module.eks.oidc_provider_arn
        },
        "Action" : "sts:AssumeRoleWithWebIdentity",
        "Condition" : {
          "StringEquals" : {
            "${split("/", module.eks.oidc_provider_arn)[1]}/id/${split("/", module.eks.oidc_provider_arn)[3]}:aud" : "sts.amazonaws.com",
            "${split("/", module.eks.oidc_provider_arn)[1]}/id/${split("/", module.eks.oidc_provider_arn)[3]}:sub" : "system:serviceaccount:kube-system:cluster-autoscaler"
          }
        }
      }
    ]
  })
}

resource "kubernetes_service_account" "cluster_autoscaler_service_account" {
  metadata {
    name = "cluster-autoscaler"
    namespace = "kube-system"
    annotations = {
      "eks.amazonaws.com/role-arn" = aws_iam_role.iam_role_for_cluster_autoscaler.arn
    }
  }
}