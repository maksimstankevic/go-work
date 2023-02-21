terraform {
  required_providers {

    aws = {
      source  = "hashicorp/aws"
      version = "= 4.53.0"
    }
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "2.18.0"
    }    
  }

  required_version = "~> 1.3.7"
}

provider "aws" {
  region  = var.region
  assume_role {
    role_arn = var.role_arn
  }
}