CREATE EXTERNAL TABLE IF NOT EXISTS crimeDataTest
(
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
LOCATION  '/tmp/data/crime/cleaned2/';
