# coding: utf-8

from pygeocoder import Geocoder
import csv
import sys
import time
reload(sys)
sys.setdefaultencoding('utf8')

def transform(lat,lon):
    list = []
    #print "Convertendo"
    geocod=Geocoder.reverse_geocode(lat,lon)
    addresses = geocod.current_data["address_components"]

    for component in addresses:
        if ("administrative_area_level_2" in component["types"]):
            list.append(component['long_name'])

        if ("country" in component["types"]):
            list.append(component['long_name'])

        if ("administrative_area_level_1" in component["types"]):
            list.append(component['long_name']) 
    return list

if __name__ == "__main__":
   if len(sys.argv) < 3:
	print "Uso: <inicio usuarios> <limite>"
	sys.exit(1)

usuarioIni = int(sys.argv[1])
usuarioFim = int(sys.argv[2])
contadorLinha = 0

respostas_file = open("respostas.csv", 'rb')
respostas_file_reader = csv.reader(respostas_file, delimiter=',')

index = 0
users = set()
outputFile = open("localidades_"+str(usuarioIni)+".dat", "w")
# outFileWriter = csv.writer(outputFile, quoting=csv.QUOTE_NONE)

myfileError = open("error.txt", 'wa')

for line in respostas_file_reader:

    if contadorLinha >= usuarioIni and contadorLinha <= usuarioFim:
	    try:
		if index == 0:
		    index +=1
		    continue
		user = line[1]
		if (user in users):
		    continue
		users.add(user)
		lat = line[2]
		lon = line[3]
		userList =  [user] + transform(float(lat),float(lon))
		time.sleep(0.5)
		saida = str(','.join(userList))
		print saida
		#sys.stdout.flush()
		#print >> sys.stderr, userList.join(',')
		outputFile.write(saida + "\n")
		outputFile.flush()
	    except:
		myfileError.write(user+"\n")

    contadorLinha = contadorLinha + 1

outputFile.close()
myfileError.close()
respostas_file.close()
