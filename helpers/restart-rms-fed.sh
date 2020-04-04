#!/bin/bash
for SC in a b c
do
	echo "Restarting Subcluster $SC"
	kubectl exec -n yarn-subcluster-$SC yarn-master-0 stop-yarn.sh \
		&& kubectl exec -n yarn-subcluster-$SC yarn-master-0 start-yarn.sh
done

