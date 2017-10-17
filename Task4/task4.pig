REGISTER ./GetNameAndHit.jar;
records = LOAD '$input' using PigStorage('\t');
trecords =  FOREACH records GENERATE $7 as name:chararray, $13 as result:chararray;
frecords = FILTER trecords BY name is not null and result is not null;
precords = FOREACH frecords GENERATE GetName(name) as name:chararray, GetHit(result) as result:int;
grecords = GROUP precords BY name;
out = FOREACH grecords GENERATE group, SUM(precords.result)/COUNT(precords.result) as Hitrate, 1 - SUM(precords.result)/COUNT(precords.result) AS Errorratio, GetYear(CurrentTime()) as Year, GetMonth(CurrentTime()) as Month, GetDay(CurrentTime()) as Day, GetHour(CurrentTime()) as Hour;
STORE out into '$output' using PigStorage('\t');
