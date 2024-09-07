variable "organization_name" {
  type        = string
  description = "The organization name for naming the resources (e.g., dev-mcdevface)."
}

variable "resource_type" {
  type        = string
  description = "The type of resource (e.g., eks)."
}

variable "resource_name" {
  type        = string
  description = "The name of the resource (e.g., stage03)."
}

provider "aws" {
  region = "us-west-2"  # Change this to your preferred region
}

# S3 Bucket for Terraform state
resource "aws_s3_bucket" "tfstate" {
  bucket = "${var.organization_name}-tfstate"
}

resource "aws_s3_bucket_versioning" "versioning" {
  bucket = "${var.organization_name}-tfstate"
  versioning_configuration {
    status = "Enabled"
  }
}

# S3 Bucket folder structure
resource "aws_s3_object" "state_folder" {
  bucket = aws_s3_bucket.tfstate.bucket
  key    = "${var.resource_type}/${var.resource_name}/"  # Creates the folder structure
}

# DynamoDB Table for state locking
resource "aws_dynamodb_table" "tfstate_lock" {
  name         = "${var.resource_type}-${var.resource_name}-tfstate-lock"
  billing_mode = "PAY_PER_REQUEST"

  hash_key = "LockID"

  attribute {
    name = "LockID"
    type = "S"
  }

  ttl {
    enabled = false
  }
}

output "s3_bucket_name" {
  value = aws_s3_bucket.tfstate.bucket
}

output "dynamodb_table_name" {
  value = aws_dynamodb_table.tfstate_lock.name
}
