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
LOAD DATA INPATH '${hiveconf:adminEmployeesLocation}' INTO TABLE RoseStaticEmployees Partition(dept = 'admin');

--Dynamic ORC Table
CREATE TABLE IF NOT EXISTS RoseDynamicEmployees
(firstName String, lastName String, speciality String, employeeNumber Int)
PARTITIONED BY (dept String)
ROW FORMAT DELIMITED FIELDS TERMINATED BY ','
STORED AS ORC;

SET hive.exec.dynamic.partition.mode=nonstrict;
INSERT INTO TABLE RoseDynamicEmployees partition(dept) SELECT * FROM RoseStaticEmployees;

--Static ORC Table
CREATE TABLE IF NOT EXISTS RoseStaticEmployeesORC
(firstName String, lastName String, speciality String, employeeNumber Int)
PARTITIONED BY (dept String)
ROW FORMAT DELIMITED FIELDS TERMINATED BY ','
STORED AS ORC;

INSERT INTO TABLE RoseStaticEmployeesORC partition(dept='csse') select firstName, lastName, speciality, employeeNumber from RoseEmployees where dept == 'csse';
INSERT INTO TABLE RoseStaticEmployeesORC partition(dept='ece') select firstName, lastName, speciality, employeeNumber from RoseEmployees where dept == 'ece';
INSERT INTO TABLE RoseStaticEmployeesORC partition(dept='admin') select firstName, lastName, speciality, employeeNumber from RoseEmployees where dept == 'admin';

SELECT COUNT(*) as TotalCount FROM RoseEmployees;
SELECT COUNT(*) as StaticCount FROM RoseStaticEmployees;
SELECT COUNT(*) as DynamicCount FROM RoseDynamicEmployees;
SELECT COUNT(*) as StaticCountORC FROM RoseStaticEmployeesORC;

SHOW partitions RoseStaticEmployees;
SHOW partitions RoseDynamicEmployees;
SHOW partitions RoseStaticEmployeesORC;

CREATE TABLE IF NOT EXISTS RoseDynamicEmployeesManualAdd
(firstName String, lastName String, speciality String, employeeNumber Int)
PARTITIONED BY (dept String)
ROW FORMAT DELIMITED FIELDS TERMINATED BY ','
STORED AS ORC;

