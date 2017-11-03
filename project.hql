add jar hdfs:///tmp/esri-geometry-api.jar;
add jar hdfs:///tmp/spatial-sdk-hive-1.2.1-SNAPSHOT.jar;
add jar hdfs:///tmp/json-serde-1.1.9.2-Hive13-jar-with-dependencies.jar;
create temporary function ST_Point as 'com.esri.hadoop.hive.ST_Point';
create temporary function ST_Contains as 'com.esri.hadoop.hive.ST_Contains';
create temporary function ST_GeomFromGeoJson as 'com.esri.hadoop.hive.ST_GeomFromGeoJson';

create database IF NOT EXISTS stateProject;

use stateProject;

create table IF NOT EXISTS cityData (
   city string,
   state string,
   lat double,
   lng double,
   population int
)
ROW FORMAT DELIMITED FIELDS TERMINATED BY ',' STORED AS TEXTFILE;

LOAD DATA INPATH '/tmp/uscitiesv1.3_100_reduced.csv' INTO TABLE cityData;

 
CREATE TABLE IF NOT EXISTS states_text (
type string,
properties map<string,string>,
geometry string
)
ROW FORMAT SERDE 'org.openx.data.jsonserde.JsonSerDe'
STORED AS TEXTFILE;

LOAD DATA INPATH '/tmp/state_boundaries.json' OVERWRITE INTO TABLE states_text;

CREATE TABLE IF NOT EXISTS states_boundaries (
   name string,
   geometry string
)
STORED AS TEXTFILE;

set hive.execution.engine=mr;

INSERT INTO TABLE states_boundaries select cast(properties['name'] as string), geometry from states_text;

select state, COUNT(*) from states_boundaries join cityData
where ST_Contains(ST_GeomFromGeoJSON(states_boundaries.geometry), ST_Point(cityData.lng, cityData.lat)) 
GROUP BY state;
