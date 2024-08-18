#!/bin/bash

# Verbose mode
set -e  # exit on failure
#set -x  # verbose

#envs=("dev" "stage" "prod")
envs=("dev")

for env in "${envs[@]}"; do
   echo "Creating gihub role for $env"
   ./create_github_role_for_env.sh $env
done
	   
	   
	   
