#!/bin/bash
clusters=(yarn-subcluster-a yarn-subcluster-b yarn-subcluster-c)
for SC in "${clusters[@]}";
do
	kubectl exec -n $SC yarn-master-0 -c yarn-master -- stop-yarn.sh \
	&& kubectl exec -n $SC yarn-master-0 -c yarn-master -- start-yarn.sh

done
