# main.tf

provider "aws" {
  region = "us-west-2" # Replace with your AWS region
}

# Create a Secrets Manager secret
resource "aws_secretsmanager_secret" "my_secret" {
  name = "my-secret"

  description = "An example secret created with Terraform"
}

# Create a secret version with the secret value
resource "aws_secretsmanager_secret_version" "my_secret_version" {
  secret_id     = aws_secretsmanager_secret.my_secret.id

  secret_string = jsonencode({
    username = "admin"
    password = "supersecret"
  })
}
