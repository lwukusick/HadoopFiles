CREATE EXTERNAL TABLE IF NOT EXISTS crimeData 
(
hour int,
month int,
year int,
crimeDate string,
latitude double,
longitude double,
primaryType string,
description string,
fbi_code string,
arrest boolean,
domestic boolean
)
ROW FORMAT DELIMITED FIELDS TERMINATED BY ','
STORED AS TEXTFILE
LOCATION  '/tmp/data/crime/cleaned/';

CREATE TABLE IF NOT EXISTS yearCrimeData
(
hour int,
month int,
crimeDate string,
latitude double,
longitude double,
primaryType string,
description string,
fbi_code string,
arrest boolean,
domestic boolean
)
PARTITIONED BY (year int)
ROW FORMAT DELIMITED FIELDS TERMINATED BY ','
STORED AS ORC;

Set hive.exec.dynamic.partition.mode=nonstrict;
INSERT INTO TABLE yearCrimeData partition(year) select hour, month, year, crimeDate, latitude, longitude, primaryType, description, fbi_code, arrest, domestic from crimeData;
