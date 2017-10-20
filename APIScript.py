#!/usr/bin/env python
import requests
import subprocess
# 130 for 6.5M entries
# loops = 130

def removeArray(content):
	#return content[1:-2]
	removed_brackets = content.replace("[", "").replace("]", "")
	return removed_brackets.replace("\n,", "\n")

limit = 50000 #(the max)
offset_K = limit
whileloopflag = True
x = 0
print("STARTING API DOWNLOAD WITH PYTHON")

file = open("CrimeTotal.json","w")
while whileloopflag:
	offset = offset_K*x
	x = x + 1
	recount = 0
	flag = True
	response = requests.get("https://data.cityofchicago.org/resource/6zsd-86xi.json?$limit=%s&$offset=%s&$order=date&$$app_token=CwFNFRUwnqGC8LqCmVWONgGE8" % (limit,offset))
	status = response.status_code 
	while flag:
		if status != 200:
			recount += 1
			if recount > 10:
				flag = False
				print("Failed to get record %s\noffset:%s" % (x,offset))
			else:
				response = requests.get("https://data.cityofchicago.org/resource/6zsd-86xi.json?$limit=%s&$offset=%s&$order=date&$$app_token=CwFNFRUwnqGC8LqCmVWONgGE8" % (limit,offset))
		else:
			#record data
			if len(response.content) == 3:
				whileloopflag = False
			cleaned_data = removeArray(response.text)
			file.write(cleaned_data)
			flag = False # just in case
			break

	# print(response.content)
file.close()
print("COMPLETED API DOWNLOAD WITH PYTHON")
bashCommand = "hadoop fs -put -f CrimeTotal.json /tmp/CrimeTotal.json"
print("STARTING HADOOP DISTRIUBUTED FILE SYSTEM TRANSFER USING %s" % bashCommand)
process = subprocess.Popen(bashCommand.split(), stdout=subprocess.PIPE)
output, error = process.communicate()