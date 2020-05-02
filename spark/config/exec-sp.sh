#!/bin/bash

pidstat -druhl 1 -p $$ | awk '{ print $9 " "$14 " " $16 " " $17 }' | sed 's/%CPU RSS kB_rd\/s kB_wr\/s//' | sed -r '/^\s*$/d' > $4 &
# sysctl -w vm.drop_caches=3
# sleep 5
exec spark-submit \
    --class SparkSort \
    --master yarn \
    --deploy-mode cluster \
    --driver-memory 4g \
    --executor-memory 9g \
    --executor-cores 5 \
    --num-executors 3 \
    /home/hadoop/src/SparkSort.jar > ~/sf/${1}-GB-${2}-spark-logs.txt
    echo "Finished Spark Sort"
