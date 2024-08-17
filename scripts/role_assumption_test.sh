#!/bin/bash

# Set variables
AWS_PROFILE=mydev
ROLE_NAME1="IdentityCenterUserRole"
ROLE_NAME2="GitHubActionsTerraformRole"
SESSION_NAME1="IdentityCenterSession"
SESSION_NAME2="GitHubActionsSession"
BUCKET_NAME="my-unique-bucket-$(date +%s)"  # Replace with your desired S3 bucket name
AWS_REGION="us-west-2"  # Replace with your AWS region

# Assume the first IAM role (IdentityCenterUserRole)
echo "Assuming IAM role: $ROLE_NAME1"
CREDS1=$(aws sts assume-role \
  --role-arn "arn:aws:iam::$ACCOUNT_ID:role/$ROLE_NAME1" \
  --role-session-name "$SESSION_NAME1")

# Extract the temporary credentials from the first assumed role
export AWS_ACCESS_KEY_ID=$(echo $CREDS1 | jq -r '.Credentials.AccessKeyId')
export AWS_SECRET_ACCESS_KEY=$(echo $CREDS1 | jq -r '.Credentials.SecretAccessKey')
export AWS_SESSION_TOKEN=$(echo $CREDS1 | jq -r '.Credentials.SessionToken')

# Assume the second IAM role (GitHubActionsTerraformRole) using the temporary credentials from the first role
echo "Assuming IAM role: $ROLE_NAME2"
CREDS2=$(aws sts assume-role \
  --role-arn "arn:aws:iam::$ACCOUNT_ID:role/$ROLE_NAME2" \
  --role-session-name "$SESSION_NAME2")

# Extract the temporary credentials from the second assumed role
export AWS_ACCESS_KEY_ID=$(echo $CREDS2 | jq -r '.Credentials.AccessKeyId')
export AWS_SECRET_ACCESS_KEY=$(echo $CREDS2 | jq -r '.Credentials.SecretAccessKey')
export AWS_SESSION_TOKEN=$(echo $CREDS2 | jq -r '.Credentials.SessionToken')


# Create an S3 bucket
echo "Creating S3 bucket: $BUCKET_NAME"
aws s3api create-bucket --bucket "$BUCKET_NAME" --region "$AWS_REGION" --create-bucket-configuration LocationConstraint="$AWS_REGION"

# List all S3 buckets
echo "Listing all S3 buckets:"
aws s3 ls

# Delete the S3 bucket
echo "Deleting S3 bucket: $BUCKET_NAME"
aws s3api delete-bucket --bucket "$BUCKET_NAME" --region "$AWS_REGION"

# List all S3 buckets again to confirm deletion
echo "Listing all S3 buckets after deletion:"
aws s3 ls

# Clean up (unsetting the temporary credentials)
unset AWS_ACCESS_KEY_ID
unset AWS_SECRET_ACCESS_KEY
unset AWS_SESSION_TOKEN
