
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
    bash exec-hp.sh $file_size $1 $pidstat_file_name #hadoop jar /home/hadoop/sf/HadoopSort/target/HadoopSort-*.jar /user/hadoop/input /user/hadoop/output > ~/sf/${file_size}-GB-${1}-hp-logs.txt
    echo "Finished Hadoop Sort"
    # hadoop fs -rm /user/hadoop/input/input.txt
    hadoop fs -rm -r -f /user/hadoop/output


    sleep 5

    threads=1
    pidstat_file_name="hp_pidstat_${file_size}GB.txt"
    iotop_file_name="hp_iotop_${file_size}GB.txt"
    pid_plot_name="hp_pid_plot_${file_size}GB.png"
    io_plot_name="hp_io_plot_${file_size}GB.png"
    out_file_name="hp_out.png"
    python3 nprocess_logs.py $file_size $threads $pidstat_file_name $iotop_file_name $pid_plot_name $io_plot_name >> $out_file_name


    echo "Starting Spark Sort"
    bash exec-sp.sh $file_size $1 $pidstat_file_name
    # time -p spark-submit \
    # --class SparkSort \
    # --master yarn \
    # --deploy-mode cluster \
    # --driver-memory 4g \
    # --executor-memory 9g \
    # --executor-cores 5 \
    # --num-executors 3 \
    # /home/hadoop/src/SparkSort.jar > ~/sf/${file_size}-GB-${1}-spark-logs.txt
    echo "Finished Spark Sort"

    sleep 5
    threads=1
    pidstat_file_name="sp_pidstat_${file_size}GB.txt"
    iotop_file_name="sp_iotop_${file_size}GB.txt"
    pid_plot_name="sp_pid_plot_${file_size}GB.png"
    io_plot_name="sp_io_plot_${file_size}GB.png"
    out_file_name="sp_out.png"
    python3 nprocess_logs.py $file_size $threads $pidstat_file_name $iotop_file_name $pid_plot_name $io_plot_name >> $out_file_name

    hadoop fs -rm -r -f /user/hadoop/output
    hadoop fs -rm /user/hadoop/input/input.txt
done