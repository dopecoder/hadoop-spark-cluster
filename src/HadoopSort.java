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
  private static final int totalChars = 128;

  public static class TokenizerMapper extends Mapper<Object, Text, Text, Text> {

    // private final static IntWritable one = new IntWritable(1);
    // private Text word = new Text();
    // private static final Logger logger = Logger.getLogger(TokenizerMapper.class);

    public void map(Object key, Text value, Context context) throws IOException, InterruptedException {
      // StringTokenizer itr = new StringTokenizer(value.toString());
      // while (itr.hasMoreTokens()) {
      // //logger.info("=======================Hello World=======================");
      // word.set(itr.nextToken());
      // context.write(word, one);
      // }

      String line = value.toString();
      // String[] tokens = line.split(" ");
      // String keypart = tokens[0];
      String keypart = line.substring(0, 10);
      String valuepart = line.substring(11, 98);
      valuepart += "\r";
      context.write(new Text(keypart), new Text(valuepart));
    }
  }

  public static class IntSumReducer extends Reducer<Text, Text, Text, Text> {
    // private IntWritable result = new IntWritable();
    // private static final Logger logger = Logger.getLogger(IntSumReducer.class);
    public void reduce(Text key, Iterable<Text> values, Context context) throws IOException, InterruptedException {
      // int sum = 0;
      for (Text val : values) {
        // logger.info("=======================FROM
        // IntSumReducer=======================");
        // sum += val.get();
        context.write(key, val);
      }
      // result.set(sum);
      // context.write(key, result);
    }
  }

  public static class customPartitioner extends Partitioner<Text, Text> {
    public int getPartition(Text key, Text value, int numReduceTasks) {
      int numCharsPerReducer = totalChars / numReduceTasks;
      int firstChar = (int) key.toString().charAt(0);
      int iter = 0;
      while (iter < numReduceTasks) {
        // breakers[iter] = iter*numReduceTasks;
        int start = iter * numCharsPerReducer;
        int end = (iter + 1) * numCharsPerReducer;
        if (firstChar >= start && firstChar < end) {
          return iter;
        }
        iter++;
      }
      // Go to the last reducer if 128 is not
      // exactly divisible by number of reducers
      return iter - 1;
    }
  }

  // public class SortPartitioner extends Partitioner<Text,Text>
  // {
  // public int getPartition(Text key, Text value, int numReduceTasks)
  // {
  // int numCharsPerReducer = totalChars/numReduceTasks;
  // int firstChar = (int)key.toString().charAt(0);
  // int iter = 0;
  // while(iter < numReduceTasks){
  // //breakers[iter] = iter*numReduceTasks;
  // int start = iter * numCharsPerReducer;
  // int end = (iter+1) * numCharsPerReducer;
  // if(firstChar >= start && firstChar < end){
  // return iter;
  // }
  // iter++;
  // }
  // //Go to the last reducer if 128 is not
  // // exactly divisible by number of reducers
  // return iter-1;
  // }
  // }

  public static void main(String[] args) throws Exception {
    logger.info("Starting timer");
    long start = System.currentTimeMillis();
    Configuration conf = new Configuration();
    Job job = Job.getInstance(conf, "hadoop sort");
    job.setJarByClass(HadoopSort.class);
    job.setMapperClass(TokenizerMapper.class);
    job.setCombinerClass(IntSumReducer.class);
    job.setPartitionerClass(customPartitioner.class);
    job.setReducerClass(IntSumReducer.class);
    //job.setNumReduceTasks(4);
    job.setNumReduceTasks(1);
    job.setOutputKeyClass(Text.class);
    //job.setOutputValueClass(IntWritable.class);
    job.setOutputValueClass(Text.class);
    FileInputFormat.addInputPath(job, new Path(args[0]));
    FileOutputFormat.setOutputPath(job, new Path(args[1]));

    if(job.waitForCompletion(true) == true){
            long finish = System.currentTimeMillis();
	    long timeElapsed = finish - start;
	    logger.info("Time elapsed in ms : \n");
	    logger.info(timeElapsed);
	    logger.warn("===============================================================================");

    	    System.exit(0);
    }
    else{
    	System.exit(1);
    }

//    System.exit(job.waitForCompletion(true) ? 0 : 1);

  }
}