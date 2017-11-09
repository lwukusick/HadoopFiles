--Useage: hive -hiveconf year='<year>' DIST='<num>' -f countNearbyCrimes.sql
set hive.vectorized.execution.enabled=false;
set hive.vectorized.execution.reduce.enabled=false;

add jar ./esri-geometry-api.jar ./spatial-sdk-hadoop.jar ./DistanceLine.jar;

create temporary function ST_Point as 'com.esri.hadoop.hive.ST_Point';
create temporary function ST_MultiLineString as 'com.esri.hadoop.hive.ST_MultiLineString';
create temporary function ST_GeodesicLengthWGS84 as 'com.esri.hadoop.hive.ST_GeodesicLengthWGS84';
create temporary function ST_DistanceLine as 'ST_DistanceLine';
create temporary function ST_SetSRID as 'com.esri.hadoop.hive.ST_SetSRID';

create table if not exists crimeCount(name string, count int);
insert overwrite table crimeCount 
	select passageData.name, COUNT(*) 
	from yearCrimeData, passageData 
	where ST_GeodesicLengthWGS84(ST_SetSRID(ST_DistanceLine(ST_MultiLineString(passageData.geometry), ST_Point(longitude, latitude)), 4326)) <= ${hiveconf:dist} 
		and passageData.year == ${hiveconf:year} 
		and yearCrimeData.year == ${hiveconf:year}
	group by passageData.name;

select * from crimeCount order by count ASC limit 1;
