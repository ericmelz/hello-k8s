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
