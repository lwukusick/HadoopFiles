-- Params:
  -- dist - the distance (in meters) a crime can be from a route for it to be counted as "near" the route

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
  select earliestRoutes.name, crimeDataTest.year, count(*)
  from crimeDataTest, earliestRoutes
  where ((earliestRoutes.geometry RLIKE "multilinestring.*") 
      AND ST_GeodesicLengthWGS84(ST_SetSRID(ST_DistanceLine(ST_MultiLineString(passageData.geometry), ST_Point(longitude, latitude)), 4326)) <= ${hiveconf:dist})
    OR ((earliestRoutes.geometry RLIKE "multipolygon.*") 
      AND ST_Contains(ST_MultiPolygon(passageData.geometry), ST_Point(longitude, latitude)))
  group by earliestRoutes.name, crimeDataTest.year;
