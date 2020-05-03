
# README

## Available Configs
1) 1S - 1 small.instance
2) 1L - 1 large.instance
3) 4S - 4 small.instance

## Docker installation
1) sudo apt update
2) sudo apt install docker.io
3) sudo systemctl enable docker
4) sudo systemctl start docker

## Project Installation
1) cd into project root
2) cd scalabase
3) ./build.sh    # This builds the base java+scala debian container from openjdk9
4) cd ../spark
5) ./build.sh    # This builds sparkbase image
5) cd ..
6) run ./build.sh login

## Running

#### Example for runnning 4S - 4 small.instance config

```bash
chmod +x build.sh
sudo ./build.sh 4S
sudo ./cluster-4S.sh login
hadoop-cluster > chmod +x perm.sh
hadoop-cluster > ./perm.sh
hadoop-cluster > ./run.sh 4S #This will initaiate the job for both Spark and Hadoop for 1GB, 4GB, 16GB, 32GB.

# Once done
hadoop-cluster > exit
sudo ./build.sh 1L 4S # Here we are starting a new cluster 1L and destroying previous running cluster 4S and then continue the same process
```


## Options
```bash
sudo ./build.sh <CONFIG> <DESTROY_PREVIOUS_CONFIG> # use one of the configs from above, the second argument is optional and provide if you want to destroy a config that is installed
sudo ./cluster-4S.sh stop   # Stop the cluster
sudo ./cluster-4S.sh start   # Start the cluster
sudo ./cluster-4S.sh info    # Shows handy URLs of running cluster

# Warning! This will remove everything from HDFS
sudo ./cluster-4S.sh deploy  # Format the cluster and deploy images again
```