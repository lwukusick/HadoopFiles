CREATE EXTERNAL TABLE crimeData 
(
latitude string,
longitude string,
description string--,
--arrest boolean,
--domestic boolean,
--fbi_code string
)
ROW FORMAT SERDE 'org.apache.hive.hcatalog.data.JsonSerDe'
STORED AS TEXTFILE
LOCATION  '/tmp/data/';
