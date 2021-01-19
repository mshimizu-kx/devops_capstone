#!/bin/bash

## @file deploy_app.sh
## @overview Deploy application.

# Variables
ENVIRONMENT_NAME="UdacityProject"

echo "  AWS_KEY: \"$(sed -n '1p' ../.env | base64 --decode)\"" >> configmap.yml
echo "  AWS_SECRET_KEY: \"$(sed -n '2p' ../.env | base64 --decode)\"" >> configmap.yml

# Create configmap for nodes
echo "Creating configmap."
kubectl apply -f configmap.yml

# Wait for change to complete
aws eks wait cluster-active  --name ${ENVIRONMENT_NAME}-KDBHDB

# Deploy application
echo "Deploying application."
kubectl apply -f deploy_service.yml

echo "Finished."