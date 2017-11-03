#!/bin/bash

if python CrimeApiScript.py && pig -p output=/tmp/data/crime/cleaned -p input=/tmp/data/crime/ cleanCrimeData.pig && hive -f importCrimeJson.sql ; then
  echo "Imported crime data"
else 
  echo "Crime import failed! Moving on to safe passage data"
fi

if python PassageApiScript.py && pig -p output=/tmp/data/passage_cleaned/year=1516 -p input=/tmp/data/passage/year=1516 cleanPassageData.pig && pig -p output=/tmp/data/passage_cleaned/year=1617 -p input=/tmp/data/passage/year=1617 cleanPassageData.pig ; then
  echo "Imported passage data"
else 
  echo "Passage import failed!"
fi

