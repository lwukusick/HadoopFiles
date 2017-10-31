SET hive.exec.dynamic.partition.mode=nonstrict;
USE ${hiveconf:databaseName};

LOAD DATA INPATH '${hiveconf:pigOutput}${hiveconf:username}' INTO table ${hiveconf:tempTableName} PARTITION(username = 'wukusil');
INSERT INTO TABLE ${tableName} partition(username) select * from ${hiveconf:tempTableName};
