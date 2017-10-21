ADD JAR ./StripUpper.jar;
CREATE temporary function Strip as 'edu.rosehulman.wukusil.Strip';
CREATE temporary function Upper as 'edu.rosehulman.wukusil.Upper';

CREATE DATABASE IF NOT EXISTS ${hiveconf:databaseName};
USE ${hiveconf:databaseName};
CREATE EXTERNAL TABLE IF NOT EXISTS ${hiveconf:tableName}
(line String)
ROW FORMAT DELIMITED FIELDS TERMINATED BY '\t'
STORED AS TEXTFILE
LOCATION '${hiveconf:inputLocation}';

SELECT word, COUNT(*)
FROM ${hiveconf:tableName} LATERAL VIEW explode(split(Strip(Upper(line)), " ")) flatTable AS word
GROUP BY word;
