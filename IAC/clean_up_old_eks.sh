#!/bin/bash

OLD_WORKFLOW_ID=$(($WORKFLOW_ID-3))
NETWORK_STACKNAME="capstone-network"
SERVER_STACKNAME="capstone-server"

echo "Delete network stack: ${SERVER_STACKNAME}-${OLD_WORKFLOW_ID}"
single_scripts/delete_stack.sh ${SERVER_STACKNAME}-${OLD_WORKFLOW_ID}

echo "Waiting until server-stack is deleted..."
aws cloudformation wait stack-delete-complete --stack-name ${NETWORK_STACKNAME}-${WORKFLOW_ID}

echo "Delete server stack: ${NETWORK_STACKNAME}-${OLD_WORKFLOW_ID}"
single_scripts/delete_stack.sh ${NETWORK_STACKNAME}-${OLD_WORKFLOW_ID}

# echo "Waiting until server-stack is deleted..."
# aws cloudformation wait stack-delete-complete --stack-name ${NETWORK_STACKNAME}-${WORKFLOW_ID}

echo "Clean."
