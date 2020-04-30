
hadoop javac -cp ../hadoop_mp SparkSort.java
jar cvf SparkSort.java SparkSort*.class

hadoop javac HadoopSort.java
jar cf HadoopSort.jar HadoopSort*.class
