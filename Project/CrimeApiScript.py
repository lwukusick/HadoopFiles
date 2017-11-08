#!/usr/bin/env python
import requests
import subprocess
# 130 for 6.5M entries
# loops = 130

def removeArray(content):
	return content[1:-2].replace("\n,", "\n")

try:
	print("OFFSET FILE FOUND")
	offsetFile = open("OffsetFile.txt","r")
	offsetFile.close()
except:
	print("NO OFFSET FILE FOUND. DOWNLOADING ENTIRE DATABASE")
	offsetFile = open("OffsetFile.txt","w")
	offsetFile.write("0")
	offsetFile.close()
	print("MADE NEW FILE")

offsetFile = open("OffsetFile.txt","r")
initialOffset = int(offsetFile.readline())
offsetFile.close()
print("INITIAL OFFSET: %d" % initialOffset)

### Initialization Values ###
limit = 50000 #(the max)
offset_K = limit
whileloopflag = True
x = 0
recordWriteFile = "CrimeTotal.json"
print("STARTING API DOWNLOAD WITH PYTHON, WRITING TO %s" % recordWriteFile)

writeFile = open(recordWriteFile,"w")
while whileloopflag:
# for x in range(0,2):
	offset = offset_K*x + initialOffset
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
			writeFile.write("%s\n" % cleaned_data)
			flag = False # just in case
			break

	# print(response.content)

print("CLOSING %s" % recordWriteFile)
writeFile.close()

# TODO make offset saving more accurate
# calc_offset = offset + cleaned_data.count('crime')

print("SAVING %s TO OFFSET FILE" % str(offset))
offsetFile = open("OffsetFile.txt","w")
offsetFile.write(str(offset))
offsetFile.close()

print("COMPLETED API DOWNLOAD WITH PYTHON")

bashCommand = "hadoop fs -put -f %s /tmp/data/crime/%s" % (recordWriteFile,recordWriteFile)
print("STARTING HADOOP DISTRIUBUTED FILE SYSTEM TRANSFER USING: %s" % bashCommand)
process = subprocess.Popen(bashCommand.split(), stdout=subprocess.PIPE)
output, error = process.communicate()

bashCommand = "rm %s" % recordWriteFile
print("CLEANING UP LOCAL FILES USING: %s" % bashCommand)
process = subprocess.Popen(bashCommand.split(), stdout=subprocess.PIPE)
output, error = process.communicate()
