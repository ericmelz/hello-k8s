# Define Local Values in Terraform
locals {
  name = "${var.cluster_name}"
  common_tags = {
  }
  eks_cluster_name = "${local.name}"  
} 
