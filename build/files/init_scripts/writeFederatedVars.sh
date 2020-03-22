C_ID=${CLUSTER_ID:-"hadoop-cluster"}
EPOCH_VALUE=$((1000 + RANDOM % 100000))
sed --in-place "s/<\!--CLUSTER-ID-VALUE-->/$CLUSTER_ID/g" $HADOOP_HOME/etc/hadoop/yarn-site.xml
sed --in-place "s/<\!--RESOURCEMANAGER-EPOCH-VALUE-->/$EPOCH_VALUE/g" $HADOOP_HOME/etc/hadoop/yarn-site.xml
sed --in-place "s/<\!--CLUSTER-ID-VALUE-->/$CLUSTER_ID/g" /hadoop/federation/router/yarn-site.xml

