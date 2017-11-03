REGISTER elephant-bird-pig-4.15.jar;
REGISTER elephant-bird-core-4.15.jar;
REGISTER elephant-bird-hadoop-compat-4.15.jar;
REGISTER json-simple-1.1.1.jar;
DEFINE JsonLoader com.twitter.elephantbird.pig.load.JsonLoader();

crime_data = LOAD '$input' USING JsonLoader();
crime_data_subset = FOREACH crime_data GENERATE $0#'date', $0#'latitude' AS latitude, $0#'longitude' AS longitude, $0#'primary_type', $0#'description', $0#'fbi_code', $0#'arrest', $0#'domestic';

cleaned_crime_data = FILTER crime_data_subset BY latitude is not null AND longitude is not null;

STORE cleaned_crime_data INTO '$output' USING PigStorage(',');
