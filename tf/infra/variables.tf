variable "region" {
  type    = string
  default = "eu-central-1"
}

variable "role_arn" {
  type    = string
}

variable "environment" {
  type    = string
  default = "prod"
}

variable "repo_name" {
  type    = string
  default = "go-work"
}

### VPC

variable "vpc_cidr_range" {
  type    = string
  default = "10.0.0.0/16"
}

variable "public_subnets" {
  type    = list(string)
  default = ["10.0.101.0/24", "10.0.102.0/24", "10.0.103.0/24"]
}

variable "private_subnets" {
  type    = list(string)
  default = ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24"]
}


### EKS

variable "cluster_name" {
  type    = string
  default = "go-work-eks"
}

variable "eks_access_ip_list" {
  type    = list(string)
  default = ["0.0.0.0/0"]
}
