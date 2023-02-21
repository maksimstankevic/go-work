resource "kubectl_manifest" "argocd_app_for_metrics_server" {
  yaml_body = <<YAML
apiVersion: argoproj.io/v1alpha1
kind: Application
metadata:
  name: "${var.metrics_server_argocd_app_name}"
  namespace: "${var.argocd_namespace}"
spec:
  project: default
  source:
    chart: "${var.metrics_server_helm_chart_name}"
    repoURL: ${var.metrics_server_repository}
    targetRevision: ${var.metrics_server_chart_version}
    helm:
      releaseName: "${var.metrics_server_helm_release_name}"
  destination:
    server: ${var.metrics_server_destination_server}
    namespace: kube-system
  syncPolicy:
    automated:
      prune: ${var.metrics_server_is_prune_enabled}
      selfHeal: ${var.metrics_server_is_selfheal_enabled}
YAML
}