#!/usr/bin/env bash

PASSIVE=${PASSIVE_MODE:-false}

/etc/init.d/ssh start

echo "Copying configs for nm..."
#cp -fv /hadoop/node/* /opt/hadoop/etc/hadoop/

echo "Setting federated vars..."
/hadoop/scripts/writeFederatedVars.sh

echo "Starting traffic control"
/hadoop/scripts/addNetworkLatency.sh

if [ "$PASSIVE" = false ]; then
	echo "Starting Nodemanager" 
	$HADOOP_HOME/bin/yarn --daemon start nodemanager
else
	echo "In passive mode, waiting for rm..."
fi

while true
do
	tail -f $HADOOP_HOME/logs/*.log
  sleep 5
done
