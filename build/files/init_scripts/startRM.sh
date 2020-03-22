#!/usr/bin/env bash
echo "SubCluster $CLUSTER_ID" 
/etc/init.d/ssh start
echo "Setting federated vars..."
/hadoop/scripts/writeFederatedVars.sh

echo "Configuring workers file"
cp -fv /workers/workers /opt/hadoop/etc/hadoop/workers
sed --in-place "s/<\!--CLUSTER-ID-VALUE-->/$CLUSTER_ID/g" $HADOOP_HOME/etc/hadoop/workers
echo "Starting resourcemanager..."
#$HADOOP_HOME/bin/yarn --daemon start resourcemanager
$HADOOP_HOME/sbin/start-yarn.sh --daemon start resourcemanager
echo "Starting historyserver..."
$HADOOP_HOME/bin/mapred --daemon start historyserver

echo "Waiting for RM's to start"
sleep 5
if [ -z $ROUTER ]
then 
	echo "Router var not set..."
else
	echo "Starting router..."
	$HADOOP_HOME/bin/yarn --daemon start router
fi
cat /opt/hadoop/logs/hadoop-root-resourcemanager-yarn-master-0.log
while true
do
	tail -f /opt/hadoop/logs/hadoop-root-resourcemanager-yarn-master-0.log
  sleep 5
done
