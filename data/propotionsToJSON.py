__author__ = 'andryw'
import csv
import json
deputados_votos_file = open("proportions.csv", 'rb')
deputados_reader = csv.reader(deputados_votos_file, delimiter=',')
map = []
"tema","opiniao","n","prop"

keys = []
i = 0
for line in deputados_reader:
    if i == 0:
        i += 1
        continue
    key = line[1]
    label = line[0]
    value = line[3]
    index = 0
    if not (key in keys):
        keys.append(key)
        map.append({"key":key,"values":[]})
    index = keys.index(key)
    if (key == "N"):
        value = -float(value)
    else:
        value = float(value)

    map[index]["values"].append({"label":label,"value":value})
deputados_json = open("propotions.json","w")

json.dump(map, deputados_json, ensure_ascii=False,indent=4)

