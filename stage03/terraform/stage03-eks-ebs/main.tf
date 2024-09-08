# Terraform Settings Block
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
    key    = "eks-ebs/stage03/terraform.tfstate"
    region = "us-west-2" 
 
    # For State Locking
    dynamodb_table = "eks-ebs-stage03-tfstate-lock"
  }  
}

# Terraform Provider Block
provider "aws" {
  region = var.aws_region
}

module "eks-ebs" {
  source               = "../modules/eks-ebs"
  tfstate_bucket       = "dev-mcdevface-tfstate"
}

