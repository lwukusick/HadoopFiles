ADD JAR ./StripUpper.jar;
CREATE temporary function Strip as 'edu.rosehulman.wukusil.Strip';
CREATE temporary function Upper as 'edu.rosehulman.wukusil.Upper';

CREATE DATABASE IF NOT EXISTS ${hiveconf:databaseName};
USE ${hiveconf:databaseName};

--Table of all employees
CREATE EXTERNAL TABLE IF NOT EXISTS RoseEmployees
(firstName String, lastName String, speciality String, dept String, employeeNumber Int)
ROW FORMAT DELIMITED FIELDS TERMINATED BY ','
STORED AS TEXTFILE
LOCATION '${hiveconf:allEmployeesLocation}';

--Static Text Table
CREATE TABLE IF NOT EXISTS RoseStaticEmployees
(firstName String, lastName String, speciality String, employeeNumber Int)
PARTITIONED BY (dept String)
ROW FORMAT DELIMITED FIELDS TERMINATED BY ','
STORED AS TEXTFILE;

LOAD DATA INPATH '${hiveconf:csseEmployeesLocation}' INTO TABLE RoseStaticEmployees Partition(dept = 'csse');
LOAD DATA INPATH '${hiveconf:eceEmployeesLocation}' INTO TABLE RoseStaticEmployees Partition(dept = 'ece');
LOAD DATA INPATH '${hiveconf:admineEmployeesLocation}' INTO TABLE RoseStaticEmployees Partition(dept = 'admin');

--Dynamic ORC Table
CREATE TABLE IF NOT EXISTS RoseDynamicEmployees
(firstName String, lastName String, speciality String, employeeNumber Int)
PARTITIONED BY (dept String)
ROW FORMAT DELIMITED FIELDS TERMINATED BY ','
STORED AS ORC;

SET hive.exec.dynamic.partition.mode=nonstrict;
INSERT INTO TABLE RoseDynamicEmpoyees partition(dept) SELECT * FROM RoseStaticEmployees;

--Static ORC Table
CREATE TABLE IF NOT EXISTS RoseStaticEmployeesORC
(firstName String, lastName String, speciality String, employeeNumber Int)
PARTITIONED BY (dept String)
ROW FORMAT DELIMITED FIELDS TERMINATED BY ','
STORED AS ORC;

INSERT INTO TABLE RoseStaticEmployeesORC partition(dept='csse') select * from RoseEmployees where dept == 'csse';
INSERT INTO TABLE RoseStaticEmployeesORC partition(dept='ece') select * from RoseEmployees where dept == 'ece';
INSERT INTO TABLE RoseStaticEmployeesORC partition(dept='admin') select * from RoseEmployees where dept == 'admin';

SELECT COUNT(*) as TotalCount FROM RoseEmpoyees;
SELECT COUNT(*) as StaticCount FROM RoseStaticEmpoyees;
SELECT COUNT(*) as DynamicCount FROM RoseDynamicEmpoyees;
SELECT COUNT(*) as StaticCountORC FROM RoseStaticEmpoyeesORC;

SHOW partitions RoseStaticEmployees;
SHOW partitions RoseDynamicEmployees;
SHOW partitions RoseStaticEmployeesORC;

CREATE TABLE IF NOT EXISTS RoseDynamicEmployeesManualAdd
(firstName String, lastName String, speciality String, employeeNumber Int)
PARTITIONED BY (dept String)
ROW FORMAT DELIMITED FIELDS TERMINATED BY ','
STORED AS ORC;

