#!/bin/bash

set -x

AWS_PROFILE=mydev
AWS_USERNAME=Dev
AWS_REGION="us-west-2"  # Replace with your AWS region
ROLE_NAME="IdentityCenterUserRole"
ACCOUNT_ID=$(aws sts get-caller-identity --query "Account" --output text)
USERNAME="your-username"  # Replace with your Identity Center username
POLICY_NAME="AllowAssumeIdentityCenterUserRole"
ASSUME_ROLE_ARN="arn:aws:iam::$ACCOUNT_ID:role/$ROLE_NAME"

# Get the Identity Store ID
IDENTITY_STORE_ID=$(aws sso-admin list-instances --query "Instances[0].IdentityStoreId" --output text)

# Get the User ID
USER_ID=$(aws identitystore list-users --identity-store-id $IDENTITY_STORE_ID --query "Users[?UserName=='$AWS_USERNAME'].UserId" --output text)

# Create the trust policy
TRUST_POLICY=$(cat <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "AWS": "arn:aws:iam::$ACCOUNT_ID:root"
      },
      "Action": "sts:AssumeRole",
      "Condition": {
        "StringEquals": {
          "aws:PrincipalTag/SSOUserId": "$USER_ID"
        }
      }
    }
  ]
}
EOF
)

# Create the IAM role with the trust policy
aws iam create-role --role-name $ROLE_NAME --assume-role-policy-document "$TRUST_POLICY"

# Attach a policy to the role (e.g., AdministratorAccess)
aws iam attach-role-policy --role-name $ROLE_NAME --policy-arn arn:aws:iam::aws:policy/AdministratorAccess

# Attach policy to user to allow user to assume role

# List assigned roles and get the PermissionSetArn for the user
PERMISSION_SET_ARN=$(aws sso-admin list-account-assignments \
  --instance-arn arn:aws:sso:::instance/$IDENTITY_STORE_ID \
  --account-id $ACCOUNT_ID \
  --query "AccountAssignments[?UserId=='$USER_ID'].PermissionSetArn" --output text)

# Describe the permission set to get the name
USER_ROLE_NAME=$(aws sso-admin describe-permission-set \
		     --instance-arn arn:aws:sso:::instance/$IDENTITY_STORE_ID \
		     --permission-set-arn $PERMISSION_SET_ARN \
		     --query "PermissionSet.Name" --output text)

# Output the role name
echo "The role name assigned to the Identity Center user $USERNAME is: $USER_ROLE_NAME"

# Create the policy document
POLICY_DOCUMENT=$(cat <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": "sts:AssumeRole",
            "Resource": "$ASSUME_ROLE_ARN"
        }
    ]
}
EOF
)

# Create the policy
echo "Creating IAM policy: $POLICY_NAME"
POLICY_ARN=$(aws iam create-policy \
  --policy-name "$POLICY_NAME" \
  --policy-document "$POLICY_DOCUMENT" \
  --query 'Policy.Arn' --output text)

# Attach the policy to the Identity Center role
echo "Attaching policy $POLICY_NAME to role $USER_ROLE_NAME"
aws iam attach-role-policy --role-name "$USER_ROLE_NAME" --policy-arn "$POLICY_ARN"

echo "IAM role $ROLE_NAME has been created and configured."
