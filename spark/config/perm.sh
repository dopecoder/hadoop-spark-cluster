source .bashrc
export HADOOP_CLASSPATH=$JAVA_HOME/lib/tools.jar
chown hadoop /home/hadoop/sf/sort
chown hadoop /home/hadoop/sf/sort/gensort
chown hadoop /home/hadoop/sf/sort/valsort
chmod +x exec-hp.sh
chmod +x exec-sp.sh
chmod +x nprocess_logs.py
chmod +x run.sh
cd src
chmod +x build.sh
./build.sh
cd ..
su hadoop