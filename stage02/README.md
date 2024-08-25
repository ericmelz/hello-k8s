# Stage 02 - Add mysql
This example shows how to incorporate a containerized MySql into your application.

## Create a virtual environment
```
mkdir -p ~/venvs/stage02
python3 -m venv ~/venvs/stage02
source ~/venvs/stage02/bin/activate
pip install --upgrade pip
pip install -r requirements.txt
```

## Deploy containerized MySql
```
kubectl apply -f k8s/mysql-deployment.yaml
kubectl get all
```

## Exec mysql client
```
pod=$(kubectl get pod|grep mysql|cut -d' ' -f 1)
kubectl exec -it $pod -- /bin/bash
mysql -uhellouser -phellopass
show databases;
use hello;
show tables;
^D
^D
```

## Initialize database and fetch data
Execute
```
pod=$(kubectl get pod|grep hello|cut -d' ' -f 1)
kubectl exec -it $pod -- /bin/bash

alembic upgrade head
python3 -m api.seed
curl -s localhost:8000/data| python -m json.tool
```
You should see
```
{
    "messages": [
        "Hello, Kubernetes!",
        "Welcome to FastAPI!"
    ]
}
```