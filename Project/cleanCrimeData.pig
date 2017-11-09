REGISTER elephant-bird-pig-4.15.jar;
REGISTER elephant-bird-core-4.15.jar;
REGISTER elephant-bird-hadoop-compat-4.15.jar;
REGISTER json-simple-1.1.1.jar;
REGISTER SafePigUDF-2.jar
DEFINE JsonLoader com.twitter.elephantbird.pig.load.JsonLoader();
DEFINE HourUDF edu.rosehulman.bcw.GetHour();
DEFINE MonthUDF edu.rosehulman.bcw.GetMonth();
DEFINE SchoolYearUDF edu.rosehulman.bcw.SchoolYear();
DEFINE TimeFilterUDF edu.rosehulman.bcw.SchoolTime();

crime_data = LOAD '$input' USING JsonLoader();
crime_data_subset = FOREACH crime_data GENERATE HourUDF($0#'date') AS hour, MonthUDF($0#'date') AS month, $0#'date' AS date, $0#'latitude' AS latitude, $0#'longitude' AS longitude, $0#'primary_type', $0#'description', $0#'fbi_code', $0#'arrest', $0#'domestic', SchoolYearUDF($0#'date') AS year;

cleaned_crime_data = FILTER crime_data_subset BY latitude is not null AND longitude is not null  AND TimeFilterUDF(date) == TRUE;

STORE cleaned_crime_data INTO '$output' USING PigStorage(',');
