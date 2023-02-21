variable "region" {
  type    = string
  default = "eu-central-1"
}

variable "cluster_name" {
  type    = string
  default = "go-work-eks"
}

variable "argocd_namespace" {
  type    = string
  default = "argocd"
}

### Go-Work app
variable "go_work_app_namespace" {
  type    = string
  default = "go-work-app"
}


variable "go_work_app_argocd_app_name" {
  type        = string
  default     = "go-work-app"
}


variable "go_work_app_chart_repository" {
  type        = string
  default     = "https://github.com/maksimstankevic/go-work.git"
}

variable "go_work_app_chart_repository_path" {
  type        = string
  default     = "go-work-chart"
}

variable "go_work_app_chart_repository_revision" {
  type        = string
  default     = "HEAD"
}

variable "go_work_app_destination_server" {
  type        = string
  default     = "https://kubernetes.default.svc"
}

variable "go_work_app_is_selfheal_enabled" {
  type        = bool
  default     = true
}

variable "go_work_app_is_prune_enabled" {
  type        = bool
  default     = true
}
