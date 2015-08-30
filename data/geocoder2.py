# coding: utf-8

import geocoder
import csv
import sys
import time
reload(sys)
sys.setdefaultencoding('utf8')

def transform(lat,lon):
    list = []
    geocod = geocoder.bing([lat,lon], method='reverse')
    #print "Cidade " + str(lat) + " " + str(lon) + " " + str(geocod)

    list.append(geocod.city) 
    list.append(geocod.state)
    list.append(geocod.country)
    return list

if __name__ == "__main__":
   if len(sys.argv) < 3:
	print "Uso: <inicio usuarios> <limite>"
	sys.exit(1)

linhaIni = int(sys.argv[1])
linhaFim = int(sys.argv[2])
contadorLinha = 0

respostas_file = open("respostas.csv", 'rb')
respostas_file_reader = csv.reader(respostas_file, delimiter=',')

index = 0
users = set()
locationsMap = {}

outputFile = open("localidades_"+str(linhaIni)+".dat", "w")
# outFileWriter = csv.writer(outputFile, quoting=csv.QUOTE_NONE)

myfileError = open("error.txt", 'wa')

for line in respostas_file_reader:

    if contadorLinha >= linhaIni and contadorLinha <= linhaFim:
	if index == 0:
	    index +=1
	    continue
	user = line[1]
	if (user in users):
	    continue
	
	users.add(user)

	#Grouping users by same location
	lat = line[2]
	lon = line[3]
	if locationsMap.has_key(lat+" "+lon):
		usersAtLatLon = locationsMap[lat+" "+lon]
	else:
		usersAtLatLon = []
	usersAtLatLon.append(user)

	locationsMap[lat+" "+lon] = usersAtLatLon

    contadorLinha = contadorLinha + 1

print str(len(locationsMap.keys()))

keys = list(locationsMap.keys())
keys.sort()

for i in range(0, len(keys)):

	latLon = keys[i]
	key = latLon.split(" ")
	lat = key[0]
	lon = key[1]

	usersAt = locationsMap[latLon]
	#print lat + " " + lon
	print str(usersAt)

	try:
		locationInfo = transform(float(lat),float(lon))
		time.sleep(0.1)

		for user in usersAt:
			userList =  [user] + locationInfo
			saida = str(','.join(userList))
			print saida
			#sys.stdout.flush()
			#print >> sys.stderr, userList.join(',')
			outputFile.write(saida + "\n")
			outputFile.flush()
	except:
		myfileError.write(str(linhaFim) + " " + str(latLon)+"\n")


outputFile.close()
myfileError.close()
respostas_file.close()
