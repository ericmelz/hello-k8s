#!/bin/bash

env=$1
# Verbose mode
#set -x

AWS_PROFILE=mydev

ROLE_NAME="${env}K8sCrawlerGithubRole"

# Step 1: Detach and delete inline policies
INLINE_POLICIES=$(aws iam list-role-policies --role-name $ROLE_NAME --query "PolicyNames" --output text)

for POLICY in $INLINE_POLICIES; do
    echo "Deleting inline policy $POLICY from role $ROLE_NAME"
    aws iam delete-role-policy --role-name $ROLE_NAME --policy-name $POLICY
done

# Step 2: Detach managed policies
MANAGED_POLICIES=$(aws iam list-attached-role-policies --role-name $ROLE_NAME --query "AttachedPolicies[].PolicyArn" --output text)

for POLICY_ARN in $MANAGED_POLICIES; do
    echo "Detaching managed policy $POLICY_ARN from role $ROLE_NAME"
    aws iam detach-role-policy --role-name $ROLE_NAME --policy-arn $POLICY_ARN
done

# Step 3: Delete the role
echo "Deleting role $ROLE_NAME"
aws iam delete-role --role-name $ROLE_NAME

echo "Role $ROLE_NAME has been deleted."
