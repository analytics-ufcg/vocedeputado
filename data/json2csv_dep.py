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
out_file.write('partido,nome,uf,id_dep,tema,s_opiniao\n')

for deputado in mapa:

    nome    = deputado['nome']
    partido = deputado['partido']
    uf      = deputado['uf']
    id_dep  = deputado['id_dep']

    for tema in deputado['temas']:

        opiniao = tema['value']
        tema      = tema['tema']

        if int(opiniao) == 0:
            s_opiniao = 'N'
        else:
            s_opiniao = 'S'   

        out_file.write('%s,%s,%s,%s,%s,%s\n' % (partido, nome, uf, id_dep, tema, s_opiniao))

out_file.close()
