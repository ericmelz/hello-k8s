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

## Build and push the docker image
```
cd ../..
ACCOUNT_ID=$(aws sts get-caller-identity --query Account --output text)
aws ecr get-login-password --region us-west-2 | docker login --username AWS --password-stdin $ACCOUNT_ID.dkr.ecr.us-west-2.amazonaws.com
docker buildx build --platform linux/amd64,linux/arm64 -t $ACCOUNT_ID.dkr.ecr.us-west-2.amazonaws.com/hello-k8s:latest --push .
```



## Deploy the helm chart
Copy `helm/values-eks3-template.yaml` to `helm/values-eks3.yaml`.  Replace the database url,
aws region, and account_id with the correct values.
```
cd ../..
helm install hellok8s ./helm --values ./helm/values-eks3.yaml
```

## See the secret
```
kubectl exec -it $(kubectl get po|grep hello|cut -d' ' -f1) -- /bin/bash
cat /mnt/secrets-store/*
echo $DB_PASSWORD
```

Execute the secrets endpoint
```
curl -s localhost:8000/secrets|python -mjson.tool
```
You should see
```
{
    "db_password": "supersecret"
}
```
