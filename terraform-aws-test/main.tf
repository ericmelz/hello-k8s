provider "aws" {
  profile = "mydev"
  region  = "us-west-2"
}

resource "aws_s3_bucket" "test_bucket" {
  bucket = "my-terraform-test-bucket-123456"

  tags = {
    Name        = "MyTestBucket"
    Environment = "Dev"
  }
}