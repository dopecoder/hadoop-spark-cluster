#!/bin/bash

pidstat -druhl 1 -p $$ | awk '{ print $9 " "$14 " " $16 " " $17 }' | sed 's/%CPU RSS kB_rd\/s kB_wr\/s//' | sed -r '/^\s*$/d' > $4 &
# sysctl -w vm.drop_caches=3
# sleep 5
exec hadoop jar /home/hadoop/sf/HadoopSort/target/HadoopSort-*.jar /user/hadoop/input /user/hadoop/output > ~/sf/${1}-GB-${2}-hp-logs.txt
