#!/bin/bash
kubectl delete pod -n zookeeper --all \
&& kubeclt delete pod -A -l yarn=master
