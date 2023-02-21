variable "region" {
  type    = string
  default = "eu-central-1"
}

variable "cluster_name" {
  type    = string
  default = "go-work-eks"
}

### ArgoCD
variable "argocd_namespace" {
  type    = string
  default = "argocd"
}

variable "helm_release_name" {
  type    = string
  default = "argocd"
}

variable "argocd_repository" {
  description = "Repository contains argocd helm chart"
  type        = string
  default     = "https://argoproj.github.io/argo-helm"
}

variable "argocd_chart_name" {
  description = "Argocd helm chart name"
  type        = string
  default     = "argo-cd"
}

variable "argocd_chart_version" {
  description = "Argocd helm chart version"
  type        = string
  default     = "5.21.1"
}

variable "argocd_overwrite_values" {
  description = "Name of file contains overwrite helm chart values for Argocd"
  type        = string
  default     = null
}

### Metrics server

variable "metrics_server_argocd_app_name" {
  type        = string
  default     = "metrics-server"
}

variable "metrics_server_helm_chart_name" {
  type        = string
  default     = "metrics-server"
}

variable "metrics_server_helm_release_name" {
  type        = string
  default     = "metrics-server"
}

variable "metrics_server_repository" {
  description = "Metrics server github repository"
  type        = string
  default     = "https://kubernetes-sigs.github.io/metrics-server/"
}

variable "metrics_server_chart_version" {
  description = "Revision to use for metrics-server"
  type        = string
  default     = "v3.8.3"
}

variable "metrics_server_destination_server" {
  description = "Destination server where application will be deployed to"
  type        = string
  default     = "https://kubernetes.default.svc"
}

variable "metrics_server_is_selfheal_enabled" {
  description = "ArgoCD option to selfheal application: true/false"
  type        = bool
  default     = true
}

variable "metrics_server_is_prune_enabled" {
  description = "Determine if ArgoCD can prun resources during sync command: true/false"
  type        = bool
  default     = true
}

### Polaris shared

variable "polaris_namespace" {
  type    = string
  default = "polaris"
}

variable "polaris_app_set_name" {
  type        = string
  default     = "polaris"
}

variable "polaris_destination_server" {
  description = "Destination server where application will be deployed to"
  type        = string
  default     = "https://kubernetes.default.svc"
}

variable "polaris_is_selfheal_enabled" {
  description = "ArgoCD option to selfheal application: true/false"
  type        = bool
  default     = true
}

variable "polaris_is_prune_enabled" {
  description = "Determine if ArgoCD can prun resources during sync command: true/false"
  type        = bool
  default     = true
}

variable "polaris_repository" {
  description = "Metrics server github repository"
  type        = string
  default     = "https://charts.fairwinds.com/stable"
}


### Polaris dashboard

variable "polaris_dashboard_helm_chart_name" {
  type        = string
  default     = "polaris"
}

variable "polaris_dashboard_helm_release_name" {
  type        = string
  default     = "polaris-dashboard"
}

variable "polaris_dashboard_revision" {
  description = "Revision to use for metrics-server"
  type        = string
  default     = "5.7.2"
}




### Polaris Goldilocks

variable "polaris_goldilocks_helm_chart_name" {
  type        = string
  default     = "goldilocks"
}

variable "polaris_goldilocks_helm_release_name" {
  type        = string
  default     = "polaris-goldilocks"
}

variable "polaris_goldilocks_revision" {
  description = "Revision to use for metrics-server"
  type        = string
  default     = "6.5.1"
}

### EFS


variable "efs_id" {
  type        = string
  default     = "fs-0125dee35f072ede6"
}