#!/bin/bash

if [[ $# -lt 1 ]]
then
    echo "Please mention the config : 1-Large 1-Small 4-Small"
    exit
fi


if [[ $# -eq 2 ]]
then
    ./cluster-${2}.sh stop
fi

cp workers-${1} spark/config/workers

cd scalabase
./build.sh
cd ../spark
./build.sh
cd ..
./cluster-${1}.sh deploy