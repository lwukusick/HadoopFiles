#!/bin/bash
#### Description: Runs download py scripts, then pig cleaning scripts, 
#### and then hive import scripts or commands for both crime data and safe passage data

arg="all"

while getopts "s" opt ; do
  case ${opt} in
    s) arg=${opt} ;;
  esac
done

if [ "${arg}" == "all" ] || [ "${arg}" == "crime" ] ; then
	if python CrimeApiScript.py ; then
	  echo Downloaded crime data\n
	else 
	  echo Crime download script failed!
	  exit $?
	fi

	if pig -p output=/tmp/data/crime/cleaned -p input=/tmp/data/crime/ cleanCrimeData.pig ; then
	  echo Crime data cleaned and placed in /tmp/data/crime/cleaned\n
	else
	  echo Pig cleaning script failed!
	  exit $?
	fi

	if hive -f importCrimeJson.sql ; then
	  echo Imported crime data\n
	else 
	  echo Crime import failed!
	  exit $?
	fi
fi

if [ "${arg}" == "all" ] || [ "${arg}" == "passage" ] ; then
	if python PassageApiScript.py ; then
	  echo Downloaded passage data\n
	else
	  echo Passage download script failed!
	  exit $?
	fi

	for YEAR in 1415 1516 1617 ; do
	  if pig -p output=/tmp/data/passage_cleaned/year=$YEAR -p input=/tmp/data/passage/year=$YEAR cleanPassageData.pig ; then
	    echo Passage data for $YEAR cleaned\n
	  else
	    echo Passage data cleaning failed for the year $YEAR
	    exit $?
	  fi
	done
	  
	if hive -e "msck repair table passageData" ; then
	  echo Imported passage data\n
	else 
	  echo Passage import failed!
	fi
fi
