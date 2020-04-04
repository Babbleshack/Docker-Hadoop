#!/bin/bash

kubectl delete -n yarn-subcluster-a statefulsets.app --all \
&& kubectl delete -n yarn-subcluster-b statefulsets.app --all \
&& kubectl delete -n yarn-subcluster-c statefulsets.app --all
