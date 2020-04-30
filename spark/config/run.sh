
hadoop fs -mkdir -p /user/hadoop/input

echo "Running Config : ${1}"
for file_size in 1 4 16 48
do
    echo "Creating ${file_size} GB file..."
    total_file_size=$(( file_size*1024*1024*1024 / 100 ))
    cd sf/sort/
    ./gensort -a ${total_file_size} input.txt
    echo "Finished creating ${file_size} GB file..."
    hadoop fs -put input.txt /user/hadoop/input
    echo "Stord the ${file_size} GB file in HDFS..."
    rm input.txt
    echo "Deleted the ${file_size} GB file in local FS..."
    cd ../../
    echo "Starting Hadoop Sort"
    hadoop jar /home/hadoop/sf/HadoopSort/target/HadoopSort-*.jar /user/hadoop/input /user/hadoop/output > ~/sf/${file_size}-GB-${1}--logs.txt
    echo "Finished Hadoop Sort"
    # hadoop fs -rm /user/hadoop/input/input.txt
    hadoop fs -rm -r -f /user/hadoop/output

    echo "Starting Spark Sort"
    spark-submit \
    --class SparkSort \
    --master yarn \
    --deploy-mode cluster \
    --driver-memory 4g \
    --executor-memory 2g \
    --executor-cores 1 \
    /home/hadoop/src/SparkSort.jar    
    echo "Finished Spark Sort"
    hadoop fs -rm -r -f /user/hadoop/output
    hadoop fs -rm /user/hadoop/input/input.txt
done