sqoop export --connect jdbc:mysql://$1/sqooptest --password hadoop --username root -m 12 --table EmployeeExportData --export-dir /tmp/sqoop/Employees

sqoop export --connect jdbc:mysql://$1/sqooptest --password hadoop --username root -m 12 --table EmployeeExportData --export-dir /tmp/sqoop/Employees --update-key eid --update-mode allowinsert
