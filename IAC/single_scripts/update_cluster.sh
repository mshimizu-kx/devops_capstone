#!/bin/bash

# Enable private access for the stack
aws eks update-cluster-config --region us-west-2 --name $1 --resources-vpc-config endpointPrivateAccess=true
