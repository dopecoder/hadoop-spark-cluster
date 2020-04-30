#!/bin/bash

# Bring the services up
function startServices {
  docker start nodemaster 1Small
  sleep 5
  echo ">> Starting hdfs ..."
  docker exec -u hadoop -it nodemaster hadoop/sbin/start-dfs.sh
  sleep 5
  echo ">> Starting yarn ..."
  docker exec -u hadoop -d nodemaster hadoop/sbin/start-yarn.sh
  sleep 5
  echo ">> Starting Spark ..."
  docker exec -u hadoop -d nodemaster /home/hadoop/sparkcmd.sh start
  docker exec -u hadoop -d 1Small /home/hadoop/sparkcmd.sh start
  show_info
}

function show_info {
  masterIp=`docker inspect -f "{{ .NetworkSettings.Networks.sparknet.IPAddress }}" nodemaster`
  echo "Hadoop info @ nodemaster: http://$masterIp:8088/cluster"
  echo "Spark info @ nodemaster:  http://$masterIp:8080/"
  echo "DFS Health @ nodemaster:  http://$masterIp:9870/dfshealth.html"
}

if [[ $1 = "start" ]]; then
  startServices
  exit
fi

if [[ $1 = "stop" ]]; then
  docker exec -u hadoop -d nodemaster /home/hadoop/sparkcmd.sh stop
  docker exec -u hadoop -d 1Small /home/hadoop/sparkcmd.sh stop
  docker stop nodemaster 1Small
  exit
fi

if [[ $1 = "deploy" ]]; then
  mkdir hadoop_mp
  docker rm -f `docker ps -a | grep sparkbase | awk '{ print $1 }'` # delete old containers
  docker network rm sparknet
  docker network create --driver bridge sparknet # create custom network

  # 3 nodes
  echo ">> Starting nodes master and worker nodes ..."
  docker run -dP -v $(pwd)/hadoop_mp:/home/hadoop/sf --cpus="4" --memory="8g" --network sparknet --name nodemaster -h nodemaster -it sparkbase
  docker run -dP --cpus="4" --memory="8g" --network sparknet --name 1Small -it -h 1Small sparkbase

  # Format nodemaster
  echo ">> Formatting hdfs ..."
  docker exec -u hadoop -it nodemaster hadoop/bin/hdfs namenode -format
  startServices
  exit
fi

if [[ $1 = "info" ]]; then
  show_info
  exit
fi

if [[ $1 = "login" ]]; then
  sudo docker exec -it nodemaster bash
  exit
fi

echo "Usage: cluster-1S.sh deploy|start|stop"
echo "                 deploy - create a new Docker network"
echo "                 start  - start the existing containers"
echo "                 stop   - stop the running containers" 
echo "                 info   - useful URLs" 
