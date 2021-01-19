#!/bin/bash

## @file launch_eks.sh
## @overview Create stacks for newtwork and EKS cluster.

# Variables
AWS_DEFAULT_REGION=us-west-2
ENVIRONMENT_NAME="UdacityProject"
NETWORK_STACKNAME="capstone-network"
SERVER_STACKNAME="capstone-server"

# Create stack for network
echo "Create network stack: ${NETWORK_STACKNAME}"
single_scripts/create_stack.sh ${NETWORK_STACKNAME} kdbhdb_network.yml kdbhdb_network_parameter.json

# Wait for network stack to be completed
echo -n "Waiting until network-stack build completion..."
aws cloudformation wait stack-create-complete --stack-name ${NETWORK_STACKNAME}
if [[ $? -ne 0 ]]; then
  echo -e "\e[31mfail\e[0m"
  exit 1
else
  echo -e "\e[32mok\e[0m"
fi

# Create stack for servers
echo "Create server stack: ${SERVER_STACKNAME}"
single_scripts/create_stack.sh ${SERVER_STACKNAME} kdbhdb_server.yml kdbhdb_server_parameter.json

# Wait for server stack to be completed
echo -n "Waiting until server-stack build completion..."
aws cloudformation wait stack-create-complete --stack-name ${SERVER_STACKNAME}
if [[ $? -ne 0 ]]; then
  echo -e "\e[31mfail\e[0m"
  exit 1
else
  echo -e "\e[32mok\e[0m"
fi

# Update cluster to enable private access
#echo "Enable private access for the cluster: ${ENVIRONMENT_NAME}-KDBHDB"
#single_scripts/update_cluster.sh ${ENVIRONMENT_NAME}-KDBHDB

# Add new context (cluster connection detail) to kubectl
echo "Add connection detail to kubectl: ${ENVIRONMENT_NAME}-KDBHDB"
single_scripts/add_connection.sh ${ENVIRONMENT_NAME}-KDBHDB

# Get Node role ARN for cluster authorization
echo -n "Get Node Role ARN from built stack..."
NODE_ROLE_ARN=$(aws cloudformation describe-stacks --stack-name  ${SERVER_STACKNAME} --query 'Stacks[0].Outputs[?OutputKey==`NodeInstanceRole`].OutputValue' --output text)
echo -e "\e[32mok\e[0m"
echo "Found Node Role ARN from built stack: ${NODE_ROLE_ARN}"

# Insert ARN to manifest
echo "Copy configuration map to current directory."
cp ../manifest/aws-auth-cm.yml aws-auth-cm.yml
sed -i'.bak' 's@<NODE_ROLE_ARN>@'${NODE_ROLE_ARN}'@g' aws-auth-cm.yml

# Apply configuration
echo "Applying configuration map."
kubectl apply -f aws-auth-cm.yml

#echo "Delete copied configuration map."
#rm aws-auth-cm.yml

# Wait until node becomes available
echo "Checking if node is available..."
until kubectl get nodes | grep -m 1 " Ready ";
  do echo "Checking if node is available..." && sleep 2;
done
echo -e "\e[32mSuccessfully launched EKS.\e[0m"
