terraform {
  backend "s3" {
    bucket  = "go-work-state"
    key     = "middle-ware/terraform.tfstate"
    region  = "eu-central-1"
    encrypt = true
    dynamodb_table = "go-work-locks"
  }
}