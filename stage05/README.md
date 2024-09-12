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

## Configure helm
In `helm/values-eks2` and `helm/values-minikube2` you will see the line
```
    DATABASE_URL: ***REPLACE-ME***
```
Replace that line with the value in `terraform/stage05-rds/local-exec-output-file/generated-values.yaml`

## Test
### minikube1
```
kubectl config use-context minikube
helm uninstall hellok8s
kubectl delete secret ecr-secret
aws ecr get-login-password --region us-west-2 | \
kubectl create secret docker-registry ecr-secret \
--docker-server=638173936794.dkr.ecr.us-west-2.amazonaws.com \
--docker-username=AWS \
--docker-password=$(aws ecr get-login-password --region us-west-2) \
--docker-email=dev@emelz.dev 
helm install hellok8s ./helm
kubectl exec -it $(kubectl get po|grep hello|cut -d' ' -f1) -- /bin/bash
curl localhost:8000/greet
curl localhost:8000/data
```


### minikube2

### eks1

### eks2
