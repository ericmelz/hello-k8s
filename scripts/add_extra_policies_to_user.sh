#!/bin/bash

# Variables
AWS_PROFILE=mydev
ROLE_NAME="AWSReservedSSO_AWSAdministratorAccess_cbe98bbf24ca347f"  # Replace with your actual Identity Center role name
POLICY_NAME="AllowSSOAdminPermissions"

# Create the policy document
POLICY_DOCUMENT=$(cat <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": [
                "sso:ListPermissionSets",
                "sso:ListAccountAssignments",
                "sso:DescribePermissionSet"
            ],
            "Resource": "*"
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
echo "Attaching policy $POLICY_NAME to role $ROLE_NAME"
aws iam attach-role-policy --role-name "$ROLE_NAME" --policy-arn "$POLICY_ARN"

echo "Policy $POLICY_NAME has been attached to role $ROLE_NAME."
