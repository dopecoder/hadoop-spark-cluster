import java.io.IOException;
import java.util.StringTokenizer;

import org.apache.hadoop.conf.Configuration;
import org.apache.hadoop.fs.Path;
import org.apache.hadoop.io.IntWritable;
import org.apache.hadoop.io.Text;
import org.apache.hadoop.mapreduce.Job;
import org.apache.hadoop.mapreduce.Mapper;
import org.apache.hadoop.mapreduce.Reducer;
import org.apache.hadoop.mapreduce.Partitioner;
import org.apache.log4j.Logger;
import org.apache.hadoop.mapreduce.lib.input.FileInputFormat;
import org.apache.hadoop.mapreduce.lib.output.FileOutputFormat;

public class HadoopSort {

  private static final Logger logger = Logger.getLogger(HadoopSort.class);

  public static class DataPartitioner extends Partitioner<Text, Text> {
    public int getPartition(Text key, Text value, int numReduceTasks) {
      int numChars = 128;
      int numCharsPerReducer = numChars / numReduceTasks;
      int firstChar = (int) key.toString().charAt(0);
      int step = 0;
      while (step < numReduceTasks) {
        int start = step * numCharsPerReducer;
        int end = (step + 1) * numCharsPerReducer;
        if (firstChar >= start && firstChar < end) {
          return step;
        }
        step++;
      }
      return step - 1;
    }
  }

  public static class DataMapper extends Mapper<Object, Text, Text, Text> {
    public void map(Object key, Text value, Context context) throws IOException, InterruptedException {
      String line = value.toString();
      String keypart = line.substring(0, 10);
      String valuepart = line.substring(11, 98);
      valuepart += "\r";
      context.write(new Text(keypart), new Text(valuepart));
    }
  }

  public static class DataReducer extends Reducer<Text, Text, Text, Text> {
    public void reduce(Text key, Iterable<Text> values, Context context) throws IOException, InterruptedException {
      for (Text val : values) {
        context.write(key, val);
      }
    }
  }
  public static void main(String[] args) throws Exception {
    long start = System.currentTimeMillis();
    Configuration conf = new Configuration();

    Job job = Job.getInstance(conf, "Hadoop Sort");
    job.setJarByClass(HadoopSort.class);
    job.setMapperClass(DataMapper.class);
    job.setCombinerClass(DataReducer.class);
    job.setPartitionerClass(DataPartitioner.class);
    job.setReducerClass(DataReducer.class);
    job.setNumReduceTasks(1);
    job.setOutputKeyClass(Text.class);
    job.setOutputValueClass(Text.class);

    FileInputFormat.addInputPath(job, new Path(args[0]));
    FileOutputFormat.setOutputPath(job, new Path(args[1]));

    if(job.waitForCompletion(true) == true){
      long end = System.currentTimeMillis();
      long total = end - start;
	    logger.info("Time Taken :");
	    logger.info(total);
	    logger.info("\n");
      System.exit(0);
    }
    System.exit(1);
  }
}