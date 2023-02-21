provider "aws" {
  region  = var.region
  assume_role {
    role_arn = var.role_arn
  }
}

resource "aws_s3_bucket" "tf-state" {
  bucket = var.state_bucket_name

  tags = {
    Purpose = "State"
  }

  lifecycle {
    prevent_destroy = true
  }

}

resource "aws_s3_bucket_server_side_encryption_configuration" "tf-state" {
  bucket = aws_s3_bucket.tf-state.id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm     = "AES256"
    }
  }
}

resource "aws_s3_bucket_versioning" "tf-state" {
  bucket = aws_s3_bucket.tf-state.id
  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_bucket_acl" "tf-state" {
  bucket = aws_s3_bucket.tf-state.id
  acl = "private"
}

resource "aws_s3_bucket_public_access_block" "tf-state" {
  bucket = aws_s3_bucket.tf-state.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

resource "aws_dynamodb_table" "terraform_locks" {
  name         = var.locking_table_name
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "LockID"
  attribute {
    name = "LockID"
    type = "S"
  }
}
