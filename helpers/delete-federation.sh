#!/bin/bash
##
#Delete pods - note replication controllers with restart them
##
kubectl delete pod -n zookeeper --all \
&& kubectl delete pod -A -l yarn=master \
&& kubectl delete pod -A -l yarn=worker
