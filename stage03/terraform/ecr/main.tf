# Specify the AWS provider and region
provider "aws" {
  region = "us-west-2" # Change the region as per your requirement
}

# Create an ECR repository
resource "aws_ecr_repository" "hello_k8s" {
  name                 = "hello-k8s"   # Name of your ECR repository
  image_tag_mutability = "MUTABLE"       # Image tag mutability (MUTABLE or IMMUTABLE)
  image_scanning_configuration {
    scan_on_push = true  # Enable scanning on image push
  }
  tags = {
    Name        = "hello-k8s"
    Environment = "Development"
  }
}

# Output the repository URL
output "ecr_repository_url" {
  value = aws_ecr_repository.hello_k8s.repository_url
  description = "URL of the created ECR repository"
}
