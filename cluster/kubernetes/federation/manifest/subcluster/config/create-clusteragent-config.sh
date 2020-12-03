#!/bin/bash
SC=$1

echo "Creating clusteragent config map for ${SC}"
kubectl create configmap clusteragent-${SC} -n ${SC} --from-file=./clusteragent/clusteragent.${SC}.json
