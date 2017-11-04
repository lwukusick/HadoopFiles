CREATE EXTERNAL TABLE storeData (name string, double lat, double long)
ROW FORMAT DELIMITED FIELDS TERMINATED BY ','
STORED AS TEXTFILE
LOCATION ${hiveconf:input};

--Move ESRI GIS tools jars to the same file
add jar ./esri-geometry-api.jar ./spatial-sdk-hadoop.jar;
create temporary function ST_Point as 'com.esri.hadoop.hive.ST_Point';
create temporary function ST_LineString as 'com.esri.hadoop.hive.ST_LineString';
create temporary function ST_Distance as 'com.esri.hadoop.hive.ST_Distance':

--line param format: 'long1 lat1' and 'long2 lat2'
select name 
from storeData
order by MIN(ST_Distance(ST_Point(long, lat), ST_LineString('linestring(${hiveconf:point1},${hiveconf:point2)'))) desc
limit 1;
