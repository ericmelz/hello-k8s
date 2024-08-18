provider "aws" {
  region  = "us-west-2"
}

variable "bucket_name_suffix" {
  description = "Suffix to append to the bucket name"
  type        = string
}

resource "aws_s3_bucket" "test_bucket" {
  bucket = "my-terraform-test-bucket-${var.bucket_name_suffix}"

  tags = {
    Name        = "MyTestBucket"
    Environment = "Dev"
  }
}