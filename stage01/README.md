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
