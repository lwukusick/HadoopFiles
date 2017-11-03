REGISTER elephant-bird-pig-4.15.jar;
REGISTER elephant-bird-core-4.15.jar;
REGISTER elephant-bird-hadoop-compat-4.15.jar;
REGISTER json-simple-1.1.1.jar;
REGISTER FlattenPoints.jar;
DEFINE JsonLoader com.twitter.elephantbird.pig.load.JsonLoader();

passage_data = LOAD '$input' USING JsonLoader();
passage_data_subset = FOREACH passage_data GENERATE $0#'school_nam', FlattenPoints($0#'the_geom') AS geom;

STORE passage_data_subset INTO '$output' USING PigStorage('\t');
