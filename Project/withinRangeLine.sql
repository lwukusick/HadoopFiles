--Useage: have -hiveconf LINESTRING='x y, [x y]*' DIST='<num>' -f withinRangeLine.sql
add jar ./esri-geometry-api.jar ./spatial-sdk-hadoop.jar;

create temporary function ST_Point as 'com.esri.hadoop.hive.ST_Point';
create temporary function ST_Distance as 'com.esri.hadoop.hive.ST_Distance';
create temporary function ST_LineString as 'com.esri.hadoop.hive.ST_LineString';

select * from crimeData where latitude is not null and ST_Distance(ST_Point(latitude, longitude), ST_LineString('linestring (${hiveconf:linestring})')) <= ${hiveconf:dist};
