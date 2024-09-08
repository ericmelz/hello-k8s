# Terraform Settings Block
terraform {
  required_version = ">= 1.6.0"
  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = ">= 5.31"      
     }
  }
}

provider "aws" {
  region = "us-west-2"
}

variable "organization_name" {
  type        = string
  description = "The organization name for naming the resources (e.g., dev-mcdevface)."
  default     = "dev-mcdevface"
}

variable "resource_name" {
  type        = string
  description = "The unique name for the resource (e.g., stage03)."
  default     = "stage03"
}

# S3 Bucket for Terraform state
resource "aws_s3_bucket" "tfstate" {
  bucket = "${var.organization_name}-tfstate"
}

resource "aws_s3_bucket_versioning" "versioning" {
  bucket = "dev-mcdevface-tfstate"
  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_object" "eks_state_folder" {
  bucket = aws_s3_bucket.tfstate.id
  key    = "eks/${var.resource_name}/"
}

resource "aws_s3_object" "eks_ebs_state_folder" {
  bucket = aws_s3_bucket.tfstate.id
  key    = "eks-ebs/${var.resource_name}/"
}

resource "aws_dynamodb_table" "eks_tfstate_lock" {
  name         = "eks-${var.resource_name}-tfstate-lock"
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

resource "aws_dynamodb_table" "eks_ebs_tfstate_lock" {
  name         = "eks-ebs-${var.resource_name}-tfstate-lock"
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


