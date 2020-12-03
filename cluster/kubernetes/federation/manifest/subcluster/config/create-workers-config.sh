#!/bin/bash
SC=$1

echo "Creating workers config map for ${SC}"
kubectl create configmap workers -n ${SC} --from-file=./workers
