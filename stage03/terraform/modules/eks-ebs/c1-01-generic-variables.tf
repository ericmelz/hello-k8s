# Input Variables - Placeholder file
# AWS Region
variable "aws_region" {
  description = "Region in which AWS Resources to be created"
  type = string
  default = "us-west-2"  
}

variable "tfstate_bucket" {
  description = "Bucket to access tfstate"
  type = string
  default = "dev-mcdevface-tfstate"  
}

variable "cluster_name" {
  description = "Name of the cluster"
  type = string
  default = "stage03"  
}
