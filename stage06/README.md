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

## Deploy the helm chart
Copy `helm/values-eks3-template.yaml` to `helm/values-eks3.yaml`.  Replace the database url with the appropriate value.

```
cd ../..
helm install hellok8s ./helm --values ./helm/values-eks3.yaml
```
