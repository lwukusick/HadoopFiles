CREATE DATABASE IF NOT EXISTS ${hiveconf:databaseName};
USE ${hiveconf:databaseName};
CREATE EXTERNAL TABLE IF NOT EXISTS ${hiveconf:tableName}
(year String, temp Int, quality Int)
ROW FORMAT DELIMITED FIELDS TERMINATED BY '\t'
STORED AS TEXTFILE
LOCATION '${hiveconf:inputLocation';

SELECT year, MAX(temp), MIN(temp), AVG(temp) 
FROM ${hivecong:tableName} 
WHERE quality == 0 OR quality == 1
GROUP BY year;

