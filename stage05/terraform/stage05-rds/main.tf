terraform {
  required_version = ">= 1.6.0"
  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = ">= 5.31"      
     }
  }

  backend "s3" {
    bucket = "dev-mcdevface-tfstate"
    key    = "eks/stage05/terraform.tfstate"
    region = "us-west-2" 
 
    # For State Locking
    dynamodb_table = "eks-stage03-tfstate-lock"
  }  
}


provider "aws" {
  region = "us-west-2"  # Update this to your preferred region
}

# Fetch VPC ID from a state file stored in an S3 bucket
data "terraform_remote_state" "vpc" {
  backend = "s3"
  config = {
    bucket = "dev-mcdevface-tfstate"
    key    = "eks/stage05/terraform.tfstate"  # Replace with the key path to the state file in S3
    region = "us-west-2"  # Replace with the region where your S3 bucket is located
  }
}

# Fetch subnets by their names
data "aws_subnet" "subnet_a" {
  filter {
    name   = "tag:Name"
    values = ["stage04-db-us-west-2a"]  # Replace with your subnet name
  }
}

data "aws_subnet" "subnet_b" {
  filter {
    name   = "tag:Name"
    values = ["stage04-db-us-west-2b"]  # Replace with your subnet name
  }
}

# Create a security group in the existing VPC
resource "aws_security_group" "db_sg" {
  name        = "stage05-db-sg"
  description = "Allow MySQL traffic"
  vpc_id      = data.terraform_remote_state.vpc.outputs.vpc_id

  ingress {
    from_port   = 3306
    to_port     = 3306
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]  # Update this to your trusted IP range for security
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# Use the fetched subnets in the RDS DB subnet group
resource "aws_db_subnet_group" "main" {
  name       = "main"
  subnet_ids = [data.aws_subnet.subnet_a.id, data.aws_subnet.subnet_b.id]

  tags = {
    Name = "Main DB subnet group"
  }
}

# RDS MySQL instance
resource "aws_db_instance" "mysql" {
  allocated_storage    = 20
  engine               = "mysql"
  engine_version       = "8.0"
  instance_class       = "db.t3.micro"
  name                 = var.db_name
  username             = var.db_username
  password             = var.db_password
  parameter_group_name = "default.mysql8.0"
  skip_final_snapshot  = true
  publicly_accessible  = true
  db_subnet_group_name = aws_db_subnet_group.main.name

  vpc_security_group_ids = [aws_security_group.db_sg.id]

  tags = {
    Name = "Terraform MySQL RDS"
  }
}

# Wait for the RDS instance to be available
resource "null_resource" "wait_for_db" {
  depends_on = [aws_db_instance.mysql]

  provisioner "local-exec" {
    command = "sleep 120"  # Adjust the time as necessary to wait for the DB to be available
  }
}

# Run the SQL initialization script after the RDS instance is available
resource "null_resource" "initialize_db" {
  depends_on = [null_resource.wait_for_db]

  provisioner "local-exec" {
    command = <<EOT
      mysql -h ${aws_db_instance.mysql.endpoint} -u ${var.db_username} -p${var.db_password} -e "source ./init.sql"
    EOT
  }
}
