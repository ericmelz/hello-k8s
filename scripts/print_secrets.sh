#!/bin/bash

# Define the environments, components, and keynames
environments=("prod" "stage" "dev")
components=("indexer" "manager" "spider" "parser")
keynames=("dbpass" "apikey")

# Iterate over each environment, component, and keyname
for env in "${environments[@]}"; do
  echo
  echo "Environment: $env"
  for component in "${components[@]}"; do
    echo "  Component: $component"

    prefix="/kubernetes/${env}/${component}"
    secrets=$(aws secretsmanager list-secrets --query "SecretList[?contains(Name, '${prefix}')].Name" --output text)

    for secret in $secrets; do
      secret_name=$(basename $secret)
      secret_value=$(aws secretsmanager get-secret-value --secret-id $secret --query SecretString --output text)
      echo "    $secret_name=$secret_value"
    done

    echo
  done
done
