#!/usr/bin/env bash
/etc/init.d/ssh start
/hadoop/scripts/writeFederatedVars.sh
$HADOOP_HOME/bin/yarn --daemon start resourcemanager
$HADOOP_HOME/bin/mapred --daemon start historyserver
while true
do
	tail -f $HADOOP_HOME/logs/*.log
  sleep 5
done
