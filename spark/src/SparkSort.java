import org.apache.spark.SparkConf;
import org.apache.spark.api.java.JavaPairRDD;
import org.apache.spark.api.java.JavaRDD;
import org.apache.spark.api.java.JavaSparkContext;
import org.apache.spark.api.java.function.PairFunction;
import scala.Tuple2;

public class SparkSort {

    public static void main(String[] args) {
        SparkConf sc = new SparkConf().setAppName("Spark Sort");
        JavaSparkContext sparkContext = new JavaSparkContext(sc);

        String in = "/user/hadoop/input";
        String out = "/user/hadoop/output";
        JavaRDD<String> textFile = sparkContext.textFile(in);

        PairFunction<String, String, String> keyValuePairs =
               new PairFunction<String, String, String>() {
                    public Tuple2<String, String > call(String x) throws Exception{
                        return new Tuple2(x.substring(0,10), x.substring(11,98));
                    }
                };
        JavaPairRDD<String, String> pairs = textFile.mapToPair(keyValuePairs).sortByKey(true);
        pairs.map(x -> x._1 + " " + x._2 + "\r").saveAsTextFile(out);
    }
}
