#!/usr/bin/env bash
###
# HADOOP 3.2.1
##
#set -e
rm -rf $HADOOP_HOME/hdfs/namenode/*
rm -rf $HADOOP_HOME/hdfs/datanode/*
rm -rf $HADOOP_HOME/hadooptmpdata/*
/etc/init.d/ssh start
$HADOOP_HOME/bin/hdfs namenode -format -clusterId $CLUSTER_ID
$HADOOP_HOME/bin/hdfs namenode 
echo "HDFS namenode died, going for sleep..."
sleep infinity
