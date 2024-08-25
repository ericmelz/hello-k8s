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

## Initialize alembic
Execute
```
```
You should see
```
```