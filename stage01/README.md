# Stage 01 - Create a containerized api
This example shows how to create an API that reads from an environment variable.

## Prerequisites
* [Docker](https://docs.docker.com/desktop/install/mac-install/)
* [AWS CLI](https://docs.aws.amazon.com/cli/latest/userguide/getting-started-install.html)
* [minikube](https://minikube.sigs.k8s.io/docs/start/?arch=%2Fmacos%2Farm64%2Fstable%2Fbinary+download)
* [Terraform](https://developer.hashicorp.com/terraform/install)

## Create a virtual environment
```
mkdir -p ~/venvs/stage01
python3 -m venv ~/venvs/stage01
source ~/venvs/stage01/bin/activate
pip install --upgrade pip
pip install -r requirements.txt
```

## Run the application with defaults
Terminal1:
```
cd src/api
uvicorn greet:app -reload
```

Terminal2:
```
curl localhost:8000/greet
```

You should see
```
{"message":"Hello, K8s, from local!"}
```


## Run the application with environment variables
In terminal, quit uvicorn by typing `Ctrl-C`.  Execute

Terminal 1:
```
greeting='Yo K8s from a foreign environment!' uvicorn greet:app --reload
```

Terminal2:
```
curl localhost:8000/greet
```

You should see
```
{"message":"Yo K8s from a foreign environment!"}
```

## Build the docker image and run the docker container
```
docker build -t hello-k8s:latest .
docker images|grep hello
docker run -d -p 8000:8000 --name hello-k8s hello-k8s:latest
docker ps|grep hello
```

You should see something like
```
18ca1a2a56d5   hello-k8s:latest   "uvicorn greet:app -…"   5 seconds ago   Up 5 seconds   0.0.0.0:8000->8000/tcp     hello-k8s
```
Execute
```
curl localhost:8000/greet
```
You should see
```
{"message":"Hello k8s from docker!"}
```

## Stop the container
```
cid=$(docker ps|grep hello|cut -d' ' -f 1)
echo $cid
docker stop $cid
```

## Run on minikube
```
minikube start
minikube update-context
eval $(minikube docker-env)
kubectl delete svc --all
kubectl delete deploy --all
docker build -t hello-k8s:latest .
kubectl apply -f k8s/deployment.yaml
kubectl apply -f k8s/service.yaml
kubectl get all
```

You should see something like
```
NAME                             READY   STATUS         RESTARTS   AGE
pod/hello-k8s-5898688f58-np6vk   0/1     ErrImagePull   0          31s

NAME                        TYPE        CLUSTER-IP      EXTERNAL-IP   PORT(S)        AGE
service/hello-k8s-service   NodePort    10.110.37.229   <none>        80:32673/TCP   15s
service/kubernetes          ClusterIP   10.96.0.1       <none>        443/TCP        2m1s

NAME                        READY   UP-TO-DATE   AVAILABLE   AGE
deployment.apps/hello-k8s   0/1     1            0           31s

NAME                                   DESIRED   CURRENT   READY   AGE
replicaset.apps/hello-k8s-5898688f58   1         1         0       31s
```

Execute
```
minikube service hello-k8s-service --url
```

You should see the url the service is running on, e.g.
```
http://127.0.0.1:62412
```

Execute
```
curl http://127.0.0.1:62412/greet
```

You should see
```
{"message":"Hello k8s from Minikube!"}
```
