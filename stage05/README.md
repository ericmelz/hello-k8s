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
Copy `/helm/values-eks2-template.yaml` to `/helm/values-eks2.yaml`,
and `/home/values-minikube2-template.yaml` to `/home/values-minikube2.yaml`
In `helm/values-eks2.yaml` and `helm/values-minikube2.yaml` you will see the line
```
    DATABASE_URL: ***REPLACE-ME***
```
Replace that line with the value in `terraform/stage05-rds/local-exec-output-file/generated-values.yaml`

## Test
### minikube1
```
kubectl config use-context minikube
helm uninstall hellok8s
kubectl delete pv --all
kubectl delete secret ecr-secret
aws ecr get-login-password --region us-west-2 | \
kubectl create secret docker-registry ecr-secret \
--docker-server=638173936794.dkr.ecr.us-west-2.amazonaws.com \
--docker-username=AWS \
--docker-password=$(aws ecr get-login-password --region us-west-2) \
--docker-email=dev@emelz.dev 
helm install hellok8s ./helm
kubectl exec -it $(kubectl get po|grep hello|cut -d' ' -f1) -- /bin/bash
curl -s localhost:8000/greet | python -mjson.tool
curl -s localhost:8000/data | python -mjson.tool
```
You should see
```
{
    "messages": [
        "Greetings from planet kube",
        "The number you have dialed is not in service."
    ]
}
```

### minikube2
```
helm uninstall
helm install ./helm --values values-minikube2.yaml
```


### eks1

### eks2
