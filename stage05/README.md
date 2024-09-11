# Stage05 - RDS

In this stage, we'll set up an RDS database.  This will enable 4 configurations:
* minikube + containerized mysql
* EKS + RDS mysql
* EKS + containerized mysql
* EKS + RDS mysql

## Setup RDS database
```
cd terraform/stage05-rds
terraform init
terraform plan
terraform apply -auto-approve
```