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

provider "helm" {
  kubernetes {
    config_path = "~/.kube/config"
  }
}

resource "kubernetes_namespace" "argocd_namespace" {
  metadata {
    name = var.argocd_namespace
    labels = {
      "goldilocks.fairwinds.com/enabled" = "true"
    }
  }
}

resource "helm_release" "argocd" {
  depends_on = [kubernetes_namespace.argocd_namespace]
  name       = var.helm_release_name
  repository = var.argocd_repository
  chart      = var.argocd_chart_name
  namespace  = var.argocd_namespace
  version    = var.argocd_chart_version
  values     = var.argocd_overwrite_values != null ? [file("${var.argocd_overwrite_values}")] : []
}