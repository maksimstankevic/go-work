output "argocd_app_version" {
  value = helm_release.argocd.metadata[0]["app_version"]
}

output "argocd_namespace" {
  value = helm_release.argocd.metadata[0]["namespace"]
}

output "argocd_revision" {
  value = helm_release.argocd.metadata[0]["revision"]
}

output "login_instruction" {
  value = <<LOGIN
    Login credentials:
      Username: admin
      Password: kubectl -n ${helm_release.argocd.metadata[0]["namespace"]} get secret argocd-initial-admin-secret -o jsonpath="{.data.password}" | base64 -d
    Run below command to  port forward and in the browser open https://localhost:8080 and paste credentials from previos point
      kubectl port-forward $(kubectl get svc -l app.kubernetes.io/name=argocd-server -n ${helm_release.argocd.metadata[0]["namespace"]} --output=name) -n ${helm_release.argocd.metadata[0]["namespace"]} 8080:443
  LOGIN
}