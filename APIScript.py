#!/usr/bin/env python
import requests
import subprocess
# 129 for 6.45M entries
# limit = 50000 #(the max)

def removeArray(content):
	#return content[1:-2]
	removed_brackets = content.replace("[", "").replace("]", "")
	return removed_brackets.replace("\n", "")


print("STARTING API DOWNLOAD WITH PYTHON")
file = open("CrimeTotal.json","w")
for x in range(0,2):
	offset = 5*x
	limit = 5
	recount = 0
	flag = True
	response = requests.get("https://data.cityofchicago.org/resource/6zsd-86xi.json?$limit=%s&$offset=%s&$order=date&$$app_token=CwFNFRUwnqGC8LqCmVWONgGE8" % (limit,offset))
	status = response.status_code 
	while flag:
		if status != 200:
			recount += 1
			if recount > 10:
				flag = False
				print("Failed to get record\noffset:%s" % (offset))
			else:
				response = requests.get("https://data.cityofchicago.org/resource/6zsd-86xi.json?$limit=%s&$offset=%s&$order=date&$$app_token=CwFNFRUwnqGC8LqCmVWONgGE8" % (limit,offset))
		else:
			#record data
			cleaned_data = removeArray(response.text)
			file.write(cleaned_data)
			flag = False # just in case
			break


	# print(response.content)
file.close()
print("COMPLETED API DOWNLOAD WITH PYTHON")
bashCommand = "hadoop fs -put CrimeTotal.json /tmp/CrimeTotal.json"
print("STARTING HADOOP DISTRIUBUTED FILE SYSTEM TRANSFER USING %s" % bashCommand)
process = subprocess.Popen(bashCommand.split(), stdout=subprocess.PIPE)
output, error = process.communicate()
