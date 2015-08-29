import json
import sys

reload(sys)
sys.setdefaultencoding('utf8')

if len(sys.argv) != 3:
    print 'sintaxe: json2csv.py input.json output.csv'
    sys.exit()

# json to dict
json_file = open(sys.argv[1])
json_str = json_file.read()
mapa = json.loads(json_str)

# destination file
out_file = open(sys.argv[2], 'w')
out_file.write('tema,usuario,lat,lon,opiniao,data\n')

lista_votacoes = mapa['results']

for votacao in lista_votacoes:

    if 'posicao' in votacao and votacao['posicao'] != None:
        posicao = votacao['posicao']
        lat = posicao['latitude']
        lon = posicao['longitude']
        data = votacao['createdAt']
        id_votacao = votacao['objectId']

        vot_temas = votacao['temas']
        for vot in vot_temas:
            tema = vot['Tema']
            opiniao = vot['value']
            if int(opiniao) == 0:
                s_opiniao = 'N'
            else:
                s_opiniao = 'S'
            out_file.write('%s,%s,%s,%s,%s,%s\n' % (tema, id_votacao, lat, lon, s_opiniao, data))

out_file.close()
