sqoop import --connect jdbc:mysql://$1/sqooptest --username root --table Employees --split-by eid --target-dir /tmp/sqoopOutput

sqoop import --connect jdbc:mysql://$1/sqooptest --username root --table Employees -m 1 --target-dir /tmp/sqoopMapOutput

sqoop import --connect jdbc:mysql://$1/sqooptest --username root --table Employees -m 2 --target-dir /tmp/sqoopSeqOutput --as-sequencefile

sqoop import --connect jdbc:mysql://$1/sqooptest --username root --table Employees -m 2 --warehouse-dir /tmp/sqoop

sqoop import --connect jdbc:mysql://$1/sqooptest --username root --table Employees -m 2 --warehouse-dir /tmp/sqoop --null-string "This is a Null String" --fields-terminated-by '\t'

hive -e "create database if not exists sqooptest"

sqoop import --connect jdbc:mysql://$1/sqooptest --username root -m 2 --table Employees --hive-import --create-hive-table --hive-table sqooptest.Employees 

sqoop import --connect jdbc:mysql://$1/sqooptest --username root -m 2 --table Employees --hive-import --create-hive-table --hive-table sqooptest.Employees --null-string "This is a Null String" --fields-terminated-by '\t'

sqoop import-all-tables --connect jdbc:mysql://$1/sqooptest --username root -m 1 --warehouse-dir /tmp/sqoopAll

