#!/bin/bash

# Verbose mode
set -x

AWS_PROFILE=mydev
AWS_USERNAME=Dev
ACCOUNT_ID=$(aws sts get-caller-identity --query "Account" --output text)
IDENTITY_STORE_ID=$(aws sso-admin list-instances --query "Instances[0].IdentityStoreId" --output text)
USER_ID=$(aws identitystore list-users --identity-store-id $IDENTITY_STORE_ID --query "Users[?UserName=='$AWS_USERNAME'].UserId" --output text)
IDENTITY_CENTER_USER_ARN="arn:aws:identitystore:$AWS_REGION:$ACCOUNT_ID:user/$USER_ID"

ROLE_NAME="GitHubActionsTerraformRole"
POLICY_NAME="GitHubActionsTerraformPolicy"
POLICY_DOCUMENT='{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": [
                "s3:*",
                "secrets:*"
            ],
            "Resource": "*"
        }
    ]
}'

# Create the IAM role
aws iam create-role \
    --role-name $ROLE_NAME \
    --assume-role-policy-document "{
        \"Version\": \"2012-10-17\",
        \"Statement\": [
            {
                \"Effect\": \"Allow\",
                \"Principal\": {
                    \"AWS\": \"arn:aws:iam::$ACCOUNT_ID:role/IdentityCenterUserRole\"
                },
                \"Action\": \"sts:AssumeRole\",
                \"Condition\": {}
            }
        ]
    }"


# Attach an inline policy to the role
aws iam put-role-policy \
    --role-name $ROLE_NAME \
    --policy-name $POLICY_NAME \
    --policy-document "$POLICY_DOCUMENT"


echo "Role $ROLE_NAME has been created and configured."
