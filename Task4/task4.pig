REGISTER ./GetNameAndHit.jar;
records = LOAD '$input' using PigStorage('\t');
precords = FOREACH records GENERATE GetName($7) as name:chararray, GetHit($13) as result:int;
grecords = GROUP precords by name;
out = FOREACH grecords GENERATE group, SUM(grecords.$13)/COUNT(grecords.$13) as Hitrate, 1 - SUM(grecords.$13)/COUNT(grecords.$13) AS Errorratio, GetYear(CurrentTime()) as Year, GetMonth(CurrentTime()) as Month, GetDay(CurrentTime()) as Day, GetHour(CurrentTime()) as Hour;
STORE out into '$output' using PigStorage('\t');
