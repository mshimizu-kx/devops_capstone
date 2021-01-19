#/bin/bash

## @file smoke_test.sh
## @overview Test if application returns correct response.

# Wait for 10 minutes at the longest
COUNTER=0

until [[ $(./query.sh "select from daily" | grep HIO | wc -l) -eq 1 || $COUNTER -eq 120 ]];
  do echo -n "Waiting until load balancer becomes running..." && \
     COUNTER=$((COUNTER + 1)) && \
     echo "$COUNTER" && \
     sleep 5;
done

if [[ $(./query.sh "select from daily" | grep price | wc -l) -eq 1 ]]; then
  echo "done"
  exit 0
else
  echo "Load balancer seems not working."
  exit 1
fi
