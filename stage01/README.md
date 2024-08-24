# Stage 01 - Create an api
This example shows how to create an API that reads from an environment variable.

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
docker ps|greep hello
```

You should see something like
```
18ca1a2a56d5   hello-k8s:latest   "uvicorn greet:app -…"   5 seconds ago   Up 5 seconds   0.0.0.0:8000->8000/tcp     hello-k8s
```
