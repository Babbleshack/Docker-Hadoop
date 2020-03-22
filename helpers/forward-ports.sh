#!/bin/bash

CLUSTER_ID=$1

if [ -z "$CLUSTER_ID" ]
then
	echo "Error please enter cluster_id\n"
	exit 1
fi

ROUTER_WEB=8089
RM_WEB=8088
JH_WEB=19888
kubectl port-forward -n $CLUSTER_ID svc/yarn-master-service $ROUTER_WEB $RM_WEB $JH_WEB --address 0.0.0.0 
