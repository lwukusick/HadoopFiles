#!/bin/bash

if python CrimeApiScript.py && pig -p output=/tmp/data/crime/cleaned -p input=/tmp/data/crime/ cleanCrimeData.pig && hive -f importCrimeJson.sql ; then
  echo "Imported crime data"
else 
  echo "Crime import failed! Moving on to safe passage data"
fi

if python PassageApiScript.py ; then
  echo "Imported passage data"
else 
  echo "Passage import failed!"
fi

