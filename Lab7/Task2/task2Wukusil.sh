sqoop export --connect jdbc:mysql://$1/sqooptest --username root -m 1 --input-null-string 'This is a Null String' --table EmployeesExportData --export-dir /tmp/sqoop/Employees

sqoop export --connect jdbc:mysql://$1/sqooptest --username root -m 1 --input-null-string 'This is a Null String' --table EmployeesExportData --export-dir /tmp/sqoop/Employees --update-key eid --update-mode allowinsert
