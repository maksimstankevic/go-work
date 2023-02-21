data "aws_eks_cluster" "cluster" {
  name = var.cluster_name
}

data "aws_eks_cluster_auth" "cluster" {
  name = var.cluster_name
}

provider "kubernetes" {
   host                   = data.aws_eks_cluster.cluster.endpoint
   cluster_ca_certificate = base64decode(data.aws_eks_cluster.cluster.certificate_authority.0.data)
   token                  = data.aws_eks_cluster_auth.cluster.token
   #load_config_file       = false
}

resource "kubernetes_namespace" "go_work_app_namespace" {
  metadata {
    name = var.go_work_app_namespace
    labels = {
      "goldilocks.fairwinds.com/enabled" = "true"
    }
  }
}



resource "kubectl_manifest" "pvc" {
  apply_only      = false
  force_conflicts = false
  yaml_body = <<YAML
apiVersion: v1
kind: PersistentVolumeClaim
metadata:
  name: efs-claim
  namespace: ${var.go_work_app_namespace}
spec:
  accessModes:
    - ReadWriteMany
  storageClassName: go-work-efs-sc
  resources:
    requests:
      storage: 1Gi
YAML
}

resource "kubectl_manifest" "argocd_app_for_go_work_app" {
  yaml_body = <<YAML
apiVersion: argoproj.io/v1alpha1
kind: Application
metadata:
  name: ${var.go_work_app_argocd_app_name}
  namespace: ${var.argocd_namespace}
spec:
  project: default
  source:
    repoURL: ${var.go_work_app_chart_repository}
    path: ${var.go_work_app_chart_repository_path}
    targetRevision: ${var.go_work_app_chart_repository_revision}
  destination:
    server: ${var.go_work_app_destination_server}
    namespace: ${var.go_work_app_namespace}
  syncPolicy:
    automated:
      prune: ${var.go_work_app_is_prune_enabled}
      selfHeal: ${var.go_work_app_is_selfheal_enabled}
YAML
}