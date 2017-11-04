add jar esri-geometry-api.jar spatial-sdk-hadoop.jar DistanceLine.jar;
create temporary function ST_Point as 'com.esri.hadoop.hive.ST_Point';
create temporary function ST_GeodesicLengthWGS84 as 'com.esri.hadoop.hive.ST_GeodesicLengthWGS84';
create temporary function ST_SetSRID as 'com.esri.hadoop.hive.ST_SetSRID';
create temporary function ST_DistanceLine as 'edu.rosehulman.wukusil.ST_DistanceLine';
create temporary function ST_LineString as 'com.esri.hadoop.hive.ST_LineString';

select name, ST_GeodesicLengthWGS84(ST_SetSRID(ST_DistanceLine(ST_LineString(multilinestring), ST_Point(long, lat)), 4326)) from customUdfActivity;
