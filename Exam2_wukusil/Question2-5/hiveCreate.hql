CREATE DATABASE IF NOT EXISTS ${hiveconf:databaseName};
USE ${hiveconf:databaseName};

CREATE TABLE IF NOT EXISTS ${hiveconf:tempTableName}
(name String, cno String, cname String, grade String)
PARTITIONED BY (username String)
ROW FORMAT DELIMITED FIELDS TERMINATED BY '\t'
STORED AS TEXTFILE;

CREATE TABLE IF NOT EXISTS ${hiveconf:tableName}
(name String, cno String, cname String, grade String)
PARTITIONED BY (username String)
ROW FORMAT DELIMITED FIELDS TERMINATED BY '\t'
STORED AS ORC;
