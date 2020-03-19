#!/bin/bash

RUNS=25 # 25*4 = 100

hadoop fs -mkdir -p /
for i in {1..25}
do
	declare -a pids
	echo "--------------------[$i]-----------------------------"
	nohup yarn jar $MAPRED_EXAMPLES wordcount /wordcount/input/40G-file.txt /wordcount/output/wc_$(date +%s) &
	pids+=($!)
	nohup yarn jar $MAPRED_EXAMPLES wordcount /wordcount/input/40G-file.txt /wordcount/output/wc_$(date +%s) &
	pids+=($!)
	nohup yarn jar $MAPRED_EXAMPLES wordcount /wordcount/input/40G-file.txt /wordcount/output/wc_$(date +%s) &
	pids+=($!)
	nohup yarn jar $MAPRED_EXAMPLES wordcount /wordcount/input/40G-file.txt /wordcount/output/wc_$(date +%s) &
	pids+=($!)
	for pid in "${pids[@]}"
	do
		wait $pid
	done
done

