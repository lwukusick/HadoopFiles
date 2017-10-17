REGISTER ./Upper.jar;
records = LOAD '$input' using PigStorage('\t') AS (c1:chararray);
trecords = FOREACH records GENERATE FLATTEN(TOKENIZE(c1)) AS (words:chararray);
urecords = FOREACH trecords GENERATE Upper(words) AS (words:chararray);
grecords = GROUP urecords by words;
grecords = FILTER grecords BY urecords.words is not null;
cnt = FOREACH grecords GENERATE group, COUNT(urecords.words) AS Count;
cnt = FILTER cnt BY Count != 0;
STORE cnt into '$output' using PigStorage(',');
