REGISTER ./TempFilter.jar;
records = LOAD '$input' using PigStorage('\t') AS (year:chararray, temperature:int, quality:int);
frecords = FILTER records by temperature!=9999 and TempFilter(quality);
grecords = GROUP frecords by year;
temp = FOREACH grecords GENERATE group, MIN(frecords.temperature) as MinTemp, MAX(frecords.temperature) as MaxTemp, AVG(frecords.temperature) as AvgTemp;
STORE temp into '$output' using PigStorage(',');
