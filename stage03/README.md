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


