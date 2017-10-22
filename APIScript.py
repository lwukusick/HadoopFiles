#!/usr/bin/env python
import requests
import subprocess
# 130 for 6.5M entries
# loops = 130

def removeArray(content):
	return content[1:-2].replace("\n,", "\n")

fileName = "CrimeTotalSample.json"
# def getLastOffset():
# 	try:
# 		file = open("OffsetFile")
# 	except:
# 		file = open("file","w")
# 		file.write("0")
# 	else:
# 		file = open("OffsetFile")
# 	return file.readline()

# initialOffset = getLastOffset()
# file.close()
limit = 1000 #(the max)
offset_K = limit
whileloopflag = True
x = 0
print("STARTING API DOWNLOAD WITH PYTHON")
file = open(fileName,"w")
for x in range(1,2):
	offset = offset_K*x
	x = x + 1
	recount = 0
	flag = True
	url = "https://data.cityofchicago.org/resource/6zsd-86xi.json?$limit=%s&$offset=%s&$order=date&$$app_token=CwFNFRUwnqGC8LqCmVWONgGE8" % (limit,offset)
	print(url)
	response = requests.get(url)
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
			file.write("%s\n" % cleaned_data)
			flag = False # just in case
			break

	# print(response.content)
file.close()
print("COMPLETED API DOWNLOAD WITH PYTHON")
bashCommand = "hadoop fs -put -f {} /tmp/data/{}".format(fileName, fileName)
print("STARTING HADOOP DISTRIUBUTED FILE SYSTEM TRANSFER USING %s" % bashCommand)
process = subprocess.Popen(bashCommand.split(), stdout=subprocess.PIPE)
output, error = process.communicate()
