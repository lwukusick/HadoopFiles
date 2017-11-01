REGISTER hdfs:///tmp/Exams/wukusil.jar;
grades = LOAD '$gradeInput' using PigStorage(',') AS (fname:chararray, lname:chararray, coursenum:chararray, grade:int);
courses = LOAD '$courseInput' using PigStorage(',') AS (cnum:chararray, cname:chararray);

fgrades = FILTER grades BY grade <= 90;
tgrades = FOREACH fgrades GENERATE edu.rosehulman.wukusil.CatName(fname, lname) AS (name:chararray), coursenum, edu.rosehulman.wukusil.ToLetterGrade(grade) AS (lettergrade:chararray);

jgrades = JOIN tgrades BY coursenum, courses BY cnum;

out = FOREACH jgrades GENERATE name, cnum, cname, lettergrade;

STORE out into '${pigOutput}${username}' using PigStorage('\t');
