#!/bin/bash
DEVICE=${1:-"eth0"}
DELAY=${2:-"200ms"}
tc qdisc add dev $DEVICE root netem delay $DELAY
