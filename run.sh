for file_size in 1 4 16 64
do
    total_file_size=$(( file_size*1024*1024*1024 / 100 ))
    ~/sf/sort/gensort -a ${file_size} input.txt
    hadoop fs -put input.txt /user/hadoop/input
    rm input.txt
    hadoop -jar /home/hadoop/sf/HadoopSort/target/HadoopSort-*.jar /user/hadoop/input /user/hadoop/output >> ~/sf/${file_size}-GB-logs.txt
    hadoop fs -rm /user/hadoop/input/input.txt
    hadoop fs -rm -r -f /user/hadoop/output
done