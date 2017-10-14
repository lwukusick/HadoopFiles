REGISTER /tmp/jars/Upper.jar;
records = LOAD '$input' using PigStorage('\t') AS (c1:chararray);
trecords = FOREACH records GENERATE FLATTEN(TOKENIZE(c1));
urecords = FOREACH trecords Upper(trecords);
grecords = GROUP urecords by $0;
cnt = FOREACH grecords GENERATE group, COUNT(urecords.$0);
STORE cnt into '$output' using PigStorage(',');
