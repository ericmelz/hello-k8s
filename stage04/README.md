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
docker buildx build --platform linux/amd64,linux/arm64 -t $ACCOUNT_ID.dkr.ecr.us-west-2.amazonaws.com/hello-k8s:latest --push .
```

## Deploy Manifests to EKS
```
cd ../..
aws eks --region us-west-2 update-kubeconfig --name stage04
kubectl get nodes
helm install hellok8s ./helm --values ./helm/values-eks.yaml
```

## Test the api
```
pod=$(kubectl get pod|grep hello|cut -d' ' -f 1)
kubectl exec -it $pod -- /bin/bash

curl -s localhost:8000/data| python -m json.tool
```

## Add ECR login secret to minikube
```
kubectl delete secret ecr-secret
export DOCKER_AUTH=$(echo -n "AWS:$(aws ecr get-login-password --region us-west-2)" | base64)
kubectl create secret generic ecr-secret \
--from-literal=.dockerconfigjson="{\"auths\":{\"$ACCOUNT_ID.dkr.ecr.us-west-2.amazonaws.com\":{\"auth\":\"$DOCKER_AUTH\"}}}" \
--type=kubernetes.io/dockerconfigjson
```

## Deploy Manifests to minikube
```
minikube start
kubectl config use-context minikube

kubectl delete svc --all
kubectl delete deploy --all
kubectl delete cm --all
kubectl delete pv --all
kubectl delete pvc --all
kubectl delete sc --all

helm install hellok8s ./helm
```

## Test the api
```
pod=$(kubectl get pod|grep hello|cut -d' ' -f 1)
kubectl exec -it $pod -- /bin/bash

curl -s localhost:8000/data| python -m json.tool
^D
```

## Interact with mysql from Python
In Terminal 1:
```
kubectl port-forward svc/mysql 3306:3306
```

In Terminal 2, from stage04 root dir:
```
mkdir -p ~/venvs/stage04
python3 -m venv ~/venvs/stage04
source ~/venvs/stage04/bin/activate
pip install --upgrade pip
pip install -r requirements.txt
cd src
export DATABASE_URL=mysql+pymysql://hellouser:hellopass@localhost:3306/hello
python3
from api.models import SessionLocal, Message
db = SessionLocal()
[m.message for m in db.query(Message).all()]
```

You should see
```
['Greetings from planet kube', 'The number you have dialed is not in service.']
```

## Configure Pycharm
If you wish to run and debug the API in PyCharm, set up the following run configuration:
~[Run Configuration](images/fastapi.png)


## Tear down
```
cd terraform/stage04-eks
terraform destroy -auto-approve
```


