#!/usr/bin/env bash

###
# HADOOP 3.2.1
##
set -e
rm -rf $HADOOP_HOME/hdfs/namenode/*
rm -rf $HADOOP_HOME/hdfs/datanode/*
rm -rf $HADOOP_HOME/hadooptmpdata/*
/etc/init.d/ssh start
$HADOOP_HOME/bin/hdfs datanode
echo "HDFS datanode died, going for sleep..."
sleep infinity
