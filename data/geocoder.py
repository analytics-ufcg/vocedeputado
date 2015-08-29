# coding: utf-8

from pygeocoder import Geocoder
import csv
import sys
reload(sys)
sys.setdefaultencoding('utf8')

def transform(lat,lon):
    list = []
    geocod=Geocoder.reverse_geocode(lat	,lon)
    addresses = geocod.current_data["address_components"]

    for component in addresses:
        if ("administrative_area_level_2" in component["types"]):
            list.append(component['long_name'])

        if ("country" in component["types"]):
            list.append(component['long_name'])

        if ("administrative_area_level_1" in component["types"]):
            list.append(component['long_name'])
    return list


respostas_file = open("respostas.csv", 'rb')
respostas_file_reader = csv.reader(respostas_file, delimiter=',')

index = 0
users = set()
outputFile = open("localidades.csv", 'w')
# outFileWriter = csv.writer(outputFile, quoting=csv.QUOTE_NONE)

myfileError = open("error.txt", 'w')

for line in respostas_file_reader:
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
        print userList
        outputFile.write(userList.join(','))
    except:
        myfileError.write(user+"\n")


