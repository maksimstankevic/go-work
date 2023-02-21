output "state_bucket_name" {
  value       = resource.aws_s3_bucket.tf-state.bucket
}

output "locking_table_name" {
  value       = resource.aws_dynamodb_table.terraform_locks.id
}