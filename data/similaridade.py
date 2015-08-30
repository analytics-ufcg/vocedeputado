import json
import sys

from pprint import pprint


reload(sys)
sys.setdefaultencoding('utf8')
# json to dict
json_file = open("Resposta.json")
mapa = json.load(json_file)
lista_votacoes = mapa['results']


json_file_dep = open("deputados_votos.json")
lista_votacoes_dep = json.load(json_file_dep)
# lista_votacoes_dep = mapa_dep['results']


def calculaSimilaridade(vot_temas, deputado_temas,user,deputado):
    sum = 0.0
    total = 0.0
    for tema in vot_temas:
        for deput_tema in deputado_temas:
            if not (deput_tema['tema'] == tema['Tema']):
                continue
            if deput_tema['value'] >= 0 and tema['value'] >= 0:
                total = total + 1
                if deput_tema['value'] == tema['value']:
                    sum = sum + 1
    if total == 0:
        print user +","+deputado+",NONE"
    else:
        print user +","+deputado+","+str(sum / total)

for votacao in lista_votacoes:

    #if 'posicao' in votacao and votacao['posicao'] != None:
        # posicao = votacao['posicao']
        # lat = posicao['latitude']
        # lon = posicao['longitude']
        # data = votacao['createdAt']
        user_id = votacao['objectId']

        vot_temas = votacao['temas']
        for deputado in lista_votacoes_dep:
            deputado_temas = deputado['temas']
            calculaSimilaridade(vot_temas, deputado_temas,user_id,deputado['nome'])