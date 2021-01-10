#!/bin/bash

kubectl autoscale deployment hdb --cpu-percent=30 --min=1 --max=2