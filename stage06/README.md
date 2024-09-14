# Stage06 - Install and use SecretsManager CSI driver
In this stage, we install a driver that allows pods to access secrets stored in AWS Secrets Manager.

## Install driver
```
cd terraform/stage06-eks
terraform init
terraform validate
terraform plan
terraform apply -auto-approve
```

## Create a secret
```
cd ../stage06-create-secret
terraform init
terraform validate
terraform plan
terraform apply -auto-approve
```