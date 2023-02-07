provider "aws" {
  region = "us-east-1"
}

resource "aws_s3_bucket" "backend_bucket" {
  bucket = "base-infra-bucket-state"
  tags = {
    Name = "S3 Remote Terraform State Holder"
  }
}

resource "aws_s3_bucket_acl" "backend_bucket" {
  bucket = aws_s3_bucket.backend_bucket.id
  acl    = "private"
}

resource "aws_s3_bucket_versioning" "backend_bucket" {
  bucket = aws_s3_bucket.backend_bucket.id
  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_dynamodb_table" "dynamo_lock_table" {
  name = "base-infra-lock-table-state"
  read_capacity = 5
  write_capacity = 5
  hash_key = "LockID"
  attribute {
    name = "LockID"
    type = "S"
  }
  tags = {
    Name = "DynamoDB Terraform State Lock Table"
  }
}