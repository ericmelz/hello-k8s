resource "aws_s3_bucket" "terraform_state" {
  bucket = "dev-mcdevface-terraform-state-bucket"
}

output "s3_bucket" {
  value = aws_s3_bucket.terraform_state.bucket
}