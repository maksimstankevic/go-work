variable "state_bucket_name" {
  type    = string
  default = "go-work-state"
}

variable "locking_table_name" {
  type    = string
  default = "go-work-locks"
}

variable "region" {
  type    = string
  default = "eu-central-1"
}

variable "role_arn" {
  type    = string
}