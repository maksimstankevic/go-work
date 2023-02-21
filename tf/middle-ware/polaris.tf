resource "kubernetes_namespace" "polaris_namespace" {
  metadata {
    name = var.polaris_namespace
  }
}

resource "kubectl_manifest" "argocd_app_set_for_polaris_applications" {
  depends_on = [kubernetes_namespace.polaris_namespace]  
  yaml_body = <<YAML
apiVersion: argoproj.io/v1alpha1
kind: ApplicationSet
metadata:
  name: "${var.polaris_app_set_name}"
  namespace: "${var.argocd_namespace}"
spec:
  generators:
  - list:
      elements:
      - chart: "${var.polaris_dashboard_helm_chart_name}"
        argocd_app_name: "${var.polaris_dashboard_helm_release_name}"
        version: "${var.polaris_dashboard_revision}"
      - chart: "${var.polaris_goldilocks_helm_chart_name}"
        argocd_app_name: "${var.polaris_goldilocks_helm_release_name}"
        version: "${var.polaris_goldilocks_revision}"
  template:
    metadata:
      name: '{{argocd_app_name}}'
    spec:
      project: default
      source:
        chart: '{{chart}}'
        repoURL: "${var.polaris_repository}"
        targetRevision: '{{version}}'
        helm:
          releaseName: '{{argocd_app_name}}'
          parameters:
          - name: "vpa.enabled"
            value: "true"
      destination:
        server: "${var.polaris_destination_server}"
        namespace: "${var.polaris_namespace}"
      syncPolicy:
        automated:
          prune: ${var.polaris_is_prune_enabled}
          selfHeal: ${var.polaris_is_selfheal_enabled}
YAML
}