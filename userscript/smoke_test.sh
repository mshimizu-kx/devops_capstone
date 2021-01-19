#/bin/bash

## @file smoke_test.sh
## @overview Test if application returns correct response.

# Get HTTP endpoint
export HDB_ENDPOINT=$(kubectl get service/hdb | awk '{print $4}' | sed '1d')

if [[ $(./query.sh "select from daily" | grep price | wc -l) -eq 1 ]]; then
  echo "GOOD"
  exit 0
else
  echo "BAD"
  exit 1
fi
