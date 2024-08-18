#!/bin/bash

#set -e
set -x

# Declare secrets as an array of key-value pairs
secrets=(
  "/kubernetes/dev/indexer/dbpass:dev_pass1"
  "/kubernetes/stage/indexer/dbpass:stage_pass1"
  "/kubernetes/prod/indexer/dbpass:prod_pass1"
  "/kubernetes/dev/manager/dbpass:dev_pass2"
  "/kubernetes/stage/manager/dbpass:stage_pass2"
  "/kubernetes/prod/manager/dbpass:prod_pass2"
  "/kubernetes/dev/manager/apikey:dev_key2"
  "/kubernetes/stage/manager/apikey:stage_key2"
  "/kubernetes/prod/manager/apikey:prod_key2"
)

# Loop through the array and create secrets in AWS Secrets Manager
for secret in "${secrets[@]}"; do
  secret_name="${secret%%:*}"
  secret_value="${secret##*:}"

  # Check if the secret already exists
  existing_secret=$(aws secretsmanager describe-secret --secret-id "$secret_name" 2>/dev/null)

  if [ -z "$existing_secret" ]; then
    # Create the secret if it does not exist
    aws secretsmanager create-secret --name "$secret_name" --secret-string "$secret_value"
    echo "Created secret: $secret_name"
  else
    # Update the secret if it already exists
    aws secretsmanager put-secret-value --secret-id "$secret_name" --secret-string "$secret_value"
    echo "Updated secret: $secret_name"
  fi
done

echo "All secrets have been stored successfully."
