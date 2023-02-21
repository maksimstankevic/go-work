
resource "aws_iam_role" "iam_role_for_ebs_csi_driver" {
  name        = "roleForEFSCSIDriverToManageEFS"
  description = "role for EFS CSI Driver to assume for volume handling"

  inline_policy {
    name = "efs-perms"

    policy = jsonencode({
        "Version": "2012-10-17",
        "Statement": [
            {
            "Effect": "Allow",
            "Action": [
                "elasticfilesystem:DescribeAccessPoints",
                "elasticfilesystem:DescribeFileSystems",
                "elasticfilesystem:DescribeMountTargets",
                "ec2:DescribeAvailabilityZones"
            ],
            "Resource": "*"
            },
            {
            "Effect": "Allow",
            "Action": [
                "elasticfilesystem:CreateAccessPoint"
            ],
            "Resource": "*",
            "Condition": {
                "StringLike": {
                "aws:RequestTag/efs.csi.aws.com/cluster": "true"
                }
            }
            },
            {
            "Effect": "Allow",
            "Action": "elasticfilesystem:DeleteAccessPoint",
            "Resource": "*",
            "Condition": {
                "StringEquals": {
                "aws:ResourceTag/efs.csi.aws.com/cluster": "true"
                }
            }
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
            "${split("/", module.eks.oidc_provider_arn)[1]}/id/${split("/", module.eks.oidc_provider_arn)[3]}:sub" : "system:serviceaccount:kube-system:efs-csi-controller-sa"
          }
        }
      }
    ]
  })
}

/* resource "kubernetes_service_account" "efs_driver_service_account" {
  metadata {
    name = "efs-csi-controller-sa"
    namespace = "kube-system"
    annotations = {
      "eks.amazonaws.com/role-arn" = aws_iam_role.iam_role_for_ebs_csi_driver.arn
    }
  }
} */