# Stage04 - Local and remote development
## Set up the cluster
```
cd terraform/stage04-eks
terraform init
terraform validate
terraform plan
terraform apply -auto-approve
```

## (Optional) Clean docker containers, volumes and images
```
docker images
docker stop $(docker ps -q)
docker rm -f $(docker ps -a -q)
docker volume prune
docker rmi $(docker images -a -q)
docker system prune -a -f
docker images
```

## Build and push the docker image
```
cd ../..

# Use buildx to support for multi-architecture docker images (e.g., building on an ARM-based Mac and deployoing to AWS x86 machines)
docker run --rm --privileged multiarch/qemu-user-static --reset -p yes
docker buildx create --use
ACCOUNT_ID=$(aws sts get-caller-identity --query Account --output text)
aws ecr get-login-password --region us-west-2 | docker login --username AWS --password-stdin $ACCOUNT_ID.dkr.ecr.us-west-2.amazonaws.com
docker buildx build --platform linux/amd64,linux/arm64 -t hello-k8s:latest --load .
docker image inspect hello-k8s --format '{{.Os}}/{{.Architecture}}'
# You should see amd64 and arm64
docker tag hello-k8s:latest $ACCOUNT_ID.dkr.ecr.us-west-2.amazonaws.com/hello-k8s:latest
docker push $ACCOUNT_ID.dkr.ecr.us-west-2.amazonaws.com/hello-k8s:latest
```

## Deploy Manifests
```
cd ../..
kubectl apply -f k8s
```

## Test the api
```
pod=$(kubectl get pod|grep hello|cut -d' ' -f 1)
kubectl exec -it $pod -- /bin/bash

curl -s localhost:8000/data| python -m json.tool
```

## Tear down
```
cd terraform/stage04-eks
terraform destroy -auto-approve
```


