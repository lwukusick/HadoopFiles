--Useage: have -hiveconf LINESTRING='x y, [x y]*' DIST='<num>' -f withinRangeLine.sql
add jar ./esri-geometry-api.jar ./spatial-sdk-hadoop.jar ./DistanceLine.jar;

create temporary function ST_Point as 'com.esri.hadoop.hive.ST_Point';
create temporary function ST_Distance as 'com.esri.hadoop.hive.ST_Distance';
create temporary function ST_LineString as 'com.esri.hadoop.hive.ST_LineString';

select * from crimeData where latitude is not null and ST_GeodesicLengthWGS84(DistanceLine(ST_LineString('linestring (${hiveconf:linestring})'), ST_Point(latitude, longitude))) <= ${hiveconf:dist};
