#!/bin/bash

# Get HTTP endpoint
HDB_ENDPOINT=$(kubectl get service/hdb | awk '{print $4}' | sed '1d')

# Send a query
curl -d "$1" -H "Content-Type:plaintext" -X POST ${HDB_ENDPOINT}
