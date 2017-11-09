set hive.vectorized.execution.enabled=false;
set hive.vectorized.execution.reduce.enabled=false;

add jar ./esri-geometry-api.jar ./spatial-sdk-hadoop.jar ./DistanceLine.jar;

create temporary function ST_Point as 'com.esri.hadoop.hive.ST_Point';
create temporary function ST_MultiLineString as 'com.esri.hadoop.hive.ST_MultiLineString';
create temporary function ST_GeodesicLengthWGS84 as 'com.esri.hadoop.hive.ST_GeodesicLengthWGS84';
create temporary function ST_DistanceLine as 'ST_DistanceLine';
create temporary function ST_SetSRID as 'com.esri.hadoop.hive.ST_SetSRID';
create temporary function ST_MultiPolygon as 'com.esri.hadoop.hive.ST_MultiPolygon';
create temporary function ST_Contains as 'com.esri.hadoop.hive.ST_Contains';

create temporary table earliestRoutes (name string, geometry string, year int);
insert overwrite table earliestRoutes 
  select tb1.* from passageData tb1
  Inner Join
  (
    select name,MIN(year) minYear from passageData group by name
  ) tb2
  On tb2.name=tb1.name
  Where tb2.minYear=tb1.year;

create table if not exists routeCrimesByYear (routeName string, crimeSchoolYear int, crimeCount int);

insert overwrite table routeCrimesByYear 
  select earliestRoutes.name, yearCrimeData.year, count(*)
  from yearCrimeData, earliestRoutes
  where ((earliestRoutes.geometry RLIKE "multilinestring.*") 
      AND ST_GeodesicLengthWGS84(ST_SetSRID(ST_DistanceLine(ST_MultiLineString(earliestRoutes.geometry), ST_Point(longitude, latitude)), 4326)) <= ${hiveconf:dist})
    OR ((earliestRoutes.geometry RLIKE "multipolygon.*") 
      AND ST_Contains(ST_MultiPolygon(earliestRoutes.geometry), ST_Point(longitude, latitude)))
  group by earliestRoutes.name, yearCrimeData.year;
