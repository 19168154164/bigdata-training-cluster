from pyspark.sql import SparkSession
from pyspark.sql.functions import col, when, count, sum
import os

# 配置环境变量
os.environ['HADOOP_CONF_DIR'] = '/export/servers/hadoop-3.2.2/etc/hadoop'
os.environ['YARN_CONF_DIR'] = '/export/servers/hadoop-3.2.2/etc/hadoop'

# 创建SparkSession
spark = SparkSession.builder \
    .appName("Rebuy Analysis") \
    .master("yarn") \
    .config("spark.driver.memory", "2g") \
    .config("spark.executor.memory", "4g") \
    .config("spark.executor.cores", "2") \
    .config("spark.sql.shuffle.partitions", "200") \
    .getOrCreate()

# 从HDFS读取CSV文件
df = spark.read.csv("hdfs://hbase01-train:9000/user/hive/warehouse/dbtaobao/dataset/user_log/small_user_log.csv", \
                   header=False, \
                   schema="user_id STRING, item_id STRING, cat_id STRING, merchant_id STRING, brand_id STRING, month INT, day INT, action INT, age_range INT, gender INT")

# 数据预处理
df = df.withColumn("buy_num", when(col("action") == 3, 1).otherwise(0))
df = df.withColumn("buy_amount", when(col("action") == 3, 100).otherwise(0))  # 假设购买金额为100

# 计算用户购买次数
user_buy_count = df.groupBy("user_id").agg(count(when(col("action") == 3, 1)).alias("buy_count"))

# 预测回头客：购买次数大于1的用户被预测为回头客
df = df.join(user_buy_count, on="user_id", how="left")
df = df.withColumn("rebuy_prediction", when(col("buy_count") > 1, 1).otherwise(0))

# 计算预测分数：购买次数越多，分数越高
df = df.withColumn("prediction_score", col("buy_count") / 10.0)

# 选择需要的列
result_df = df.select(
    "user_id", "item_id", "cat_id", "merchant_id", "brand_id", 
    "month", "day", "buy_num", "buy_amount", 
    "rebuy_prediction", "prediction_score"
)

# 保存结果到MySQL
result_df.write \
    .format("jdbc") \
    .option("url", "jdbc:mysql://localhost:3306/dbtaobao?useSSL=false&allowPublicKeyRetrieval=true") \
    .option("dbtable", "rebuy") \
    .option("user", "root") \
    .option("password", "123456") \
    .mode("overwrite") \
    .save()

# 验证结果
print("=== 预测结果统计 ===")
result_df.groupBy("rebuy_prediction").count().show()

print("=== 预测分数分布 ===")
result_df.select("prediction_score").describe().show()

# 关闭SparkSession
spark.stop()

print("=== 任务完成 ===")