CREATE EXTERNAL TABLE IF NOT EXISTS passageData 
(
name string,
multilinestring string
)
partitioned by (year int)
ROW FORMAT DELIMITED FIELDS TERMINATED BY '\t'
STORED AS TEXTFILE
LOCATION  '/tmp/data/passage_formatted';
msck repair table passageData;
