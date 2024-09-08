# Stage 03 - Create an EKS cluster

## Configure an IAM User
We will create an AWS user used for running [IAC](https://chatgpt.com/share/924dd791-c6aa-494b-90dd-a61b26603af9) scripts.
In your AWS account, Navigate to IAM > Users.  Create a user with a name like `gituser2`.  It's not necessary to give this user
access to the AWS Management Console.  Attach the AdministratorAccess policy to the user.  Click on the user and navigate to the
Security Credentials Tab.  Click Create access keys, then select the CLI Use Case.  Copy the Access key and Secret access key and
save them in a secure place.

Navigate to `~/.aws/config`.  If there is a `[default]` section, rename it or delete it.  Do the same for `~/.aws/credentials`.
In the terminal execute
```
aws configure
AWS Access Key ID [None]: <your access key>
AWS Secret Access Key [None]: <your secret key>
Default region name [None]: us-east-1
Default output format [None]: json
```

Confirm that there are new `[default]` sections in `~/.aws/config` and `~/.aws/credentials`.

Execute
```
aws sts get-caller-identity
```
And observe the Arn to confirm that it matches the new user.

## Create an S3 bucket and DynamoDB for the terraform state file.
Edit `terraform/eks-tfstate/main.tf`.  Change the organization name to your organization name.  This will be used
to name the s3 bucket, so it should be something unique.

Execute:
```
cd terraform/eks-tfstate
terraform init
terraform validate
terraform plan
terraform apply -auto-approve
```

Execute
```
aws s3 ls|grep tfstate
```
and confirm that your bucket has been created.

Execute
```
aws dynamodb list-tables --region us-west-2|grep tfstate-lock
```
and confirm that your DynamoDB tables have been created.

## Create an EKS cluster
In the AWS console, navigate to EC2 > Key Pairs.  Click Create key pair and create a keypair
named hellok8s.  Copy the generated key to ~/keys and execute
```
chmod 400 ~/keys/hellok8s.pem
```

Change to the terraform/stage03-eks directory:
```
cd ../stage03-eks
```
Edit the `bucket` and `tfstate_bucket` arguments in `main.tf` to match your bucket (replace `dev-mcdevface` with your org)
Edit the `vpc_cidr_block` in `main.tf` to specify the desired CIDR block for the VPC that will be created.
Edit the `vpc_public_subnets` and `vpc_private_subnets` in `main.tf` to specify the desired subnet CIDRs.

Execute Terraform:
```
terraform init
terraform validate
terraform plan
terraform apply -auto-approve
```
Update ~/.kube/config:
```
aws eks --region us-west-2 update-kubeconfig --name stage03
```
Execute kubectl
```
kubectl get nodes
```

Change to the terraform/stage03-eks directory:
```
cd ../stage03-eks-ebs
```
Edit the `bucket` and `tfstate_bucket` arguments in `main.tf` to match your bucket (replace `dev-mcdevface` with your org)

Execute Terraform:
```
terraform init
terraform validate
terraform plan
terraform apply -auto-approve
```

Verify the ebs csi driver is installed:
```
kubectl -n kube-system get ds | grep csi
```

## Create an ECR repository
```
cd ../ecr
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


## Build and push the api docker image

```
cd ../..

# Use buildx to support for multi-architecture docker images (e.g., building on an ARM-based Mac and deployoing to AWS x86 machines)
docker run --rm --privileged multiarch/qemu-user-static --reset -p yes
docker buildx create --use
ACCOUNT_ID=$(aws sts get-caller-identity --query Account --output text)
aws ecr get-login-password --region us-west-2 | docker login --username AWS --password-stdin $ACCOUNT_ID.dkr.ecr.us-west-2.amazonaws.com
docker login
docker buildx build --platform linux/amd64 -t hello-k8s:latest --load .
docker image inspect hello-k8s --format '{{.Os}}/{{.Architecture}}'
# You should see amd64 (not arm64)
docker tag hello-k8s:latest $ACCOUNT_ID.dkr.ecr.us-west-2.amazonaws.com/hello-k8s:latest
docker push $ACCOUNT_ID.dkr.ecr.us-west-2.amazonaws.com/hello-k8s:latest
```

## Edit manifests
```
echo $ACCOUNT_ID
```
Update k8s/deployment.yaml to pull from the ECR repository, e.g.:
        image: hello-k8s:latest
        <aws-account-id>.dkr.ecr.us-west-2.amazonaws.com/hello-k8s:latest


## Deploy Manifests
```
cd ../..
kubectl apply -f k8s
```

## Test the api
pod=$(kubectl get pod|grep hello|cut -d' ' -f 1)
kubectl exec -it $pod -- /bin/bash

curl -s localhost:8000/data| python -m json.tool
