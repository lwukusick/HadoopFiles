CREATE DATABASE IF NOT EXISTS ${hiveconf:databaseName};
USE ${hiveconf:databaseName};

CREATE EXTERNAL TABLE IF NOT EXISTS archiveLogData
(blogName string, hitRatio float, errorRatio float, year int, month int, day int, hour int)
ROW FORMAT DELIMITED FIELDS TERMINATED BY '\t'
STORED AS TEXTFILE
LOCATION '${hiveconf:pigOutputDir}/${hiveconf:jobDate}';

CREATE TABLE IF NOT EXISTS logData
(blogName string, hitRatio float, errorRatio float)
PARTITIONED BY (year int, month, int, day int, hour int)
ROW FORMAT DELIMITED FIELDS TERMINATED BY ','
STORED AS ORC;

SET hive.exec.dynamic.partition.mode=nonstrict;
INSERT INTO TABLE logData partition(year, month, day, hour) SELECT * 
FROM archiveLogData 
WHERE year == ${hiveconf:year}, month == ${hiveconf:month}, day == ${hiveconf:day}, hour == ${hiveconf:hour};
