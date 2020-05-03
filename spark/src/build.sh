
# Compile Spark
javac -cp $SPARK_HOME/jars/spark-core_2.11-2.4.0.jar:$SPARK_HOME/jars/scala-library-2.11.12.jar SparkSort.java
jar cvf SparkSort.jar SparkSort*.class

# Compile Hadoop
hadoop com.sun.tools.javac.Main HadoopSort.java
jar cf HadoopSort.jar HadoopSort*.class