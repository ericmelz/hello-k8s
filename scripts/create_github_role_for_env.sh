#!/bin/bash

env=$1

# Verbose mode
set -e  # exit on failure
#set -x  # verbose

AWS_PROFILE=mydev
AWS_USERNAME=Dev
AWS_REGION=us-west-2
ACCOUNT_ID=$(aws sts get-caller-identity --query "Account" --output text)
IDENTITY_STORE_ID=$(aws sso-admin list-instances --query "Instances[0].IdentityStoreId" --output text)
USER_ID=$(aws identitystore list-users --identity-store-id $IDENTITY_STORE_ID --query "Users[?UserName=='$AWS_USERNAME'].UserId" --output text)
IDENTITY_CENTER_USER_ARN="arn:aws:identitystore:$AWS_REGION:$ACCOUNT_ID:user/$USER_ID"

ROLE_NAME="${env}K8sCrawlerGithubRole"
POLICY_NAME="${env}K8sCrawlerGithubPolicy"
POLICY_DOCUMENT="{
        \"Version\": \"2012-10-17\",
        \"Statement\": [
            {
                \"Effect\": \"Allow\",
                \"Action\": \"secretsmanager:GetSecretValue\",
                \"Resource\": \"arn:aws:secretsmanager:$AWS_REGION:$ACCOUNT_ID:secret:/kubernetes/$env/*\"
            },
            {
                \"Effect\": \"Allow\",
                \"Action\": [
                    \"secretsmanager:ListSecrets\",
                    \"secretsmanager:DescribeSecrets\",
                    \"secretsmanager:GetResourcePolicy\",
                    \"secretsmanager:ListSecretVersionIds\"
                ],
                \"Resource\": \"*\"
            },
            {
                \"Effect\": \"Allow\",
                \"Action\": [
                    \"s3:*\",
                    \"dynamodb:*\"
                ],
                \"Resource\": \"*\"
            }
        ]
}"

echo $POLICY_DOCUMENT

# Create the IAM role
aws iam create-role \
    --role-name $ROLE_NAME \
    --assume-role-policy-document "{
        \"Version\": \"2012-10-17\",
        \"Statement\": [
            {
                \"Effect\": \"Allow\",
                \"Principal\": {
                    \"Federated\": \"arn:aws:iam::638173936794:oidc-provider/token.actions.githubusercontent.com\"
                },
                \"Action\": \"sts:AssumeRoleWithWebIdentity\",
                \"Condition\": {
                    \"StringEquals\": {
                       \"token.actions.githubusercontent.com:aud\": \"sts.amazonaws.com\"
                    },
                    \"StringLike\": {
                       \"token.actions.githubusercontent.com:sub\": [
                           \"repo:ericmelz/hello-k8s:*\"
                       ]
                    }
                }
            }

        ]
    }"


# Attach an inline policy to the role
aws iam put-role-policy \
    --role-name $ROLE_NAME \
    --policy-name $POLICY_NAME \
    --policy-document "$POLICY_DOCUMENT"


echo "Role $ROLE_NAME has been created and configured."
