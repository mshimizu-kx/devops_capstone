#!/bin/bash

## @file deploy_app.sh
## @overview Deploy application.

# Variables
ENVIRONMENT_NAME="UdacityProject"

# Change directory to manifest/
cd ../manifest

echo "  AWS_KEY: \"$(sed -n '1p' ../.env | base64 --decode)\"" >> configmap.yml
echo "  AWS_SECRET_KEY: \"$(sed -n '2p' ../.env | base64 --decode)\"" >> configmap.yml

# Create configmap for nodes
echo "Creating configmap."
apply -f configmap.yml

# Wait for change to complete
aws eks wait cluster-active  --name ${ENVIRONMENT_NAME}-KDBHDB

# Create daemonset for S3 mount
echo "Creating dademonset."
apply -f daemonset.yml

# Wait for change to complete
aws eks wait cluster-active  --name ${ENVIRONMENT_NAME}-KDBHDB

# Deploy application
echo "Deploying application."
apply -f autoscale.yml

echo "Finished."