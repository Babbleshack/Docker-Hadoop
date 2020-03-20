#!/usr/bin/env bash
/etc/init.d/ssh start
$HADOOP_HOME/bin/yarn.sh nodemanager
"ResourceManager failed, sleeping..."
sleep infinity
