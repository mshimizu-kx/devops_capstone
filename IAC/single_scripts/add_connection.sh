#!/bin/bash

# Add connection detail of the cluster
aws eks --region us-west-2 update-kubeconfig --name $1