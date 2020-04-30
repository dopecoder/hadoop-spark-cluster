
hadoop com.sun.tools.javac.Main -cp $SPARK_HOME/jars/ SparkSort.java
jar cvf SparkSort.java SparkSort*.class

hadoop com.sun.tools.javac.Main HadoopSort.java
jar cf HadoopSort.jar HadoopSort*.class
