terraform {
  backend "s3" {
    bucket  = "go-work-state"
    key     = "infra/terraform.tfstate"
    region  = "eu-central-1"
    encrypt = true
    dynamodb_table = "go-work-locks"
  }
}