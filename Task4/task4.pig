REGISTER ./GetNameAndHit.jar;
%declare dateString `date +%Y-%m-%d`
%declare outpath '${output}/${dateString}'

records = LOAD '$input' using PigStorage('\t');
trecords =  FOREACH records GENERATE (chararray)$7 as name:chararray, (chararray)$13 as result:chararray;
frecords = FILTER trecords BY name is not null and result is not null;
precords = FOREACH frecords GENERATE GetName(name) as name:chararray, GetHit(result) as hitresult:int, GetError(result) as errresult:int;
precords = FILTER precords BY name is not null;
grecords = GROUP precords BY name;
out = FOREACH grecords GENERATE group, (double)SUM(precords.hitresult)/(double)COUNT(precords.hitresult) as Hitrate, (double)SUM(precords.errresult)/(double)COUNT(precords.errresult) AS Errorratio, GetYear(CurrentTime()) as Year, GetMonth(CurrentTime()) as Month, GetDay(CurrentTime()) as Day, GetHour(CurrentTime()) as Hour;
STORE out into '$outpath' using PigStorage('\t');
