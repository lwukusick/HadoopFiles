#!/usr/bin/env python
import requests
import subprocess
# 130 for 6.5M entries
# loops = 130

def removeArray(content):
	return content[1:-2].replace("\n,", "\n")

years = {"1314":"nm24-d5en", "1415":"t8dp-yzqg", "1516":"kvm8-tw23", "1617":"65ce-agii"}

for key, value in years.iteritems():
	print("STARTING API DOWNLOAD WITH PYTHON FOR SCHOOL YEAR %s" % key)

	file = open("Passage.json","w")
	recount = 0
	flag = True
	response = requests.get("https://data.cityofchicago.org/resource/%s.json" % value)
	status = response.status_code 
	while flag:
		if status != 200:
			recount += 1
			if recount > 10:
				flag = False
				print("Failed to get record %s\noffset:%s" % (x,offset))
			else:
				response = requests.get("https://data.cityofchicago.org/resource/%s.json" % value)
		else:
			#record data
			cleaned_data = removeArray(response.text)
			file.write("%s\n" % cleaned_data)
			flag = False # just in case
			break

	file.close()
	print("COMPLETED API DOWNLOAD WITH PYTHON")
	
	bashCommand = "hadoop fs -mkdir -p /tmp/data/passage/year=%s" % key
	process = subprocess.Popen(bashCommand.split(), stdout=subprocess.PIPE)
	output, error = process.communicate()

	bashCommand = "hadoop fs -put -f Passage.json /tmp/data/passage/year=%s/" % key
	print("STARTING HADOOP DISTRIUBUTED FILE SYSTEM TRANSFER USING: %s" % bashCommand)
	process = subprocess.Popen(bashCommand.split(), stdout=subprocess.PIPE)
	output, error = process.communicate()
	print(error)

	#bashCommand = "rm Passage.json"
	#print("CLEANING UP %s" % key)
	#process = subprocess.Popen(bashCommand.split(), stdout=subprocess.PIPE)
	#output, error = process.communicate()

