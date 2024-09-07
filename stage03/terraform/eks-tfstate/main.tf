module "terraform_state" {
  source            = "../modules/tfstate"  # Path to the module
  organization_name = "dev-mcdevface"
  resource_type     = "eks"
  resource_name     = "stage03"
}

output "s3_bucket_name" {
  value = module.terraform_state.s3_bucket_name
}

output "dynamodb_table_name" {
  value = module.terraform_state.dynamodb_table_name
}
