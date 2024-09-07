# Define Local Values in Terraform
locals {
  common_tags = {
  }
  eks_cluster_name = "${data.terraform_remote_state.eks.outputs.eks_cluster_id}"
} 
