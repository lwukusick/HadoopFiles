records = LOAD '$input' using PigStorage('\t');
datetime = CurrentTime();
precords = FOREACH records GENERATE GetName($7), GetHit($13) AS (name:chararray,result:int);
grecords = GROUP precords by name;
out = FOREACH grecords GENERATE group, SUM(grecords.$13)/COUNT(grecords.$13) AS Hitrate, 1 - SUM(grecords.$13)/COUNT(grecords.$13) AS Errorratio, GetYear(datetime) as Year, GetMonth(datetime) as Month, GetDay(datetime) as Day, GetHour(datetime) as Hour;
STORE out into '$output' using PigStorage('\t');
