CREATE EXTERNAL TABLE IF NOT EXISTS manhattanData
(
name string,
x double,
y double
)
ROW FORMAT DELIMITED FIELDS TERMINATED BY ','
STORED AS TEXTFILE
LOCATION '${hiveconf:input}';

--Move ESRI GIS tools jars to the same file
add jar ./esri-geometry-api.jar ./spatial-sdk-hadoop.jar ManhattanDistance.jar;
create temporary function ST_Point as 'com.esri.hadoop.hive.ST_Point';
create temporary function ST_ManhattanDistance as 'edu.rosehulman.wukusil.ST_ManhattanDistance';

select name, ST_ManhattanDistance(ST_Point(${hiveconf:x}, ${hiveconf:y}), ST_Point(x, y)) 
from manhattanData;
