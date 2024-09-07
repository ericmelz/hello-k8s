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
    key    = "eks/stage03/terraform.tfstate"
    region = "us-west-2" 
 
    # For State Locking
    dynamodb_table = "eks-stage03-tfstate-lock"
  }  
}

# Terraform Provider Block
provider "aws" {
  region = var.aws_region
}

module "eks" {
  source               = "../modules/eks"
  cluster_name         = "stage03"
  vpc_cidr_block       = "10.26.0.0/16"
  vpc_public_subnets   = ["10.26.101.0/24", "10.26.102.0/24"]
  vpc_private_subnets  = ["10.26.1.0/24", "10.26.2.0/24"]  
  vpc_database_subnets = ["10.26.151.0/24", "10.26.152.0/24"]
}

output "eks_cluster_id" {
  value = module.eks.cluster_id
}

output "aws_iam_openid_connect_provider_arn" {
  value = module.eks.aws_iam_openid_connect_provider_arn
}

output "aws_iam_openid_connect_provider_extract_from_arn" {
  value = module.eks.aws_iam_openid_connect_provider_extract_from_arn
}

output "cluster_certificate_authority_data" {
  value = module.eks.cluster_certificate_authority_data
}

output "cluster_endpoint" {
  value = module.eks.cluster_endpoint
}

/*
module "eks-ebs" {
  source               = "../modules/eks-ebs"
  tfstate_bucket       = "dev-mcdevface-tfstate"
}
*/

