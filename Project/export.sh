#!/bin/bash
## This script exports each of the Hive tables that matches the input arguements
## and places them in mysql tables of the same name.
## Note: The sql tables must be created beforehand and must be given the same columns as the hive tables

## Usage: ./export.sh [-c <rdbms connection string>] <table name>*

cString="127.0.0.1:3306"
dString=""

while getopts :cd option
do
  case "${option}"
  in 
  c) cString=${OPTARG};;
  d) dString=${OPTARG};;
  ?) echo "-${OPTARG} is not a valid flag";;
  esac
done

for table in "$@"
do
  sqoop export --connect jdbc:mysql://${cString}/project --username root -m 1 --table ${table} --hcatalog-table ${table} --hcatalog-database default --input-fields-terminated-by "${dString}" --input-lines-terminated-by "\n"
done
