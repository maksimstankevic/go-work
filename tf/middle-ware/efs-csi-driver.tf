resource "helm_release" "efs_csi_driver" {
  name       = "aws-efs-csi-driver"
  repository = "https://kubernetes-sigs.github.io/aws-efs-csi-driver/"
  chart = "aws-efs-csi-driver"
  namespace = "kube-system"
  set {
    name  = "controller.serviceAccount.create"
    value = "false"
  }
  set {
    name  = "controller.serviceAccount.name"
    value = "efs-csi-controller-sa"
  }
}


resource "kubectl_manifest" "sc" {
  apply_only      = false
  force_conflicts = false
  yaml_body = <<YAML
kind: StorageClass
apiVersion: storage.k8s.io/v1
metadata:
  name: go-work-efs-sc
provisioner: efs.csi.aws.com
parameters:
  provisioningMode: efs-ap
  fileSystemId: ${var.efs_id}
  directoryPerms: "700"
YAML
}



