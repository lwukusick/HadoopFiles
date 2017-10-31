REGISTER hdfs:///tmp/Exams/wukusil.jar;
grades = LOAD '$gradeInput' using PigStorage(',') AS (fname:chararray, lname:chararray, coursenum:chararray, grade:int);
courses = LOAD '$courseInput' using PigStorage(',') AS (cnum:chararray, cname:chararray);

fgrades = FILTER grades BY grade <= 90;
tgrades = FOREACH fgrades GENERATE CatName(fname, lname) AS (name:chararray), ToLetterGrade(grade) AS (lettergrade:chararray);

jgrades = JOIN tgrades BY coursenum, courses BY cnum;

out = FOREACH jgrades GENERATE name, coursenum, cname, lettergrade;

STORE out into '${pigOutput}${username}' using PigStorage('\t')
