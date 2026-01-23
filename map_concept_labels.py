""" Written by Sukahda on 20/11/2023
Given TAM dictionary, concept_label dictionary, English parallel corpus for the USRs and a USR file as input, this program extracts corresponding English TAMs and concept labels.
To Run:
    python3 map_concept_labels.py tam_mapping.dat H_concept-to-mrs-rels.dat eng_parallel_sents usrs.txt
"""

import sys

tamf = open(sys.argv[1], 'r') # TAM dictionary
tamfr = tamf.readlines()
dict_tam = {}
for i in range(len(tamfr)):
    if len(tamfr[i].split()) > 1:
        mytam = tamfr[i].split()
        htam = mytam[1]
        etam = mytam[2]
        dict_tam[htam] = etam 

#print(dict_tam)

conf = open(sys.argv[2], 'r') # concept label dictionary
confr = conf.readlines()
con_dict = {}
for i in range(len(confr)):
    if len(confr[i].split()) > 2:
        if confr[i].split()[1] in con_dict.keys():
            myval = con_dict[confr[i].split()[1]] + '/' + confr[i].split()[2] 
            con_dict[confr[i].split()[1]] = myval
        else:
            con_dict[confr[i].split()[1]] = confr[i].split()[2] 

#print(con_dict)

#epcf = open(sys.argv[3], 'r') # parallel english corpora with sentence_ID and Eng sentence
#epcfr = epcf.readlines()
#ePCdict = {}
#for i in range(len(epcfr)):
#    if len(epcfr[i].split()) > 2:
#        ePCdict[epcfr[i].split('\t')[0]] = epcfr[i].split('\t')[1] 

#print(ePCdict['Geo_ncert_6stnd_1ch_0079'])

usrf = open(sys.argv[3], 'r') #USR file
usrfr = usrf.readlines()
for i in range(len(usrfr)-2):
#    try:
        if len(usrfr[i].split()) > 1 and usrfr[i].strip().startswith('#'):
            print('\n')
            engid = 'Eng_' +  usrfr[i-1].strip()[9:33]
            print(engid)
#            print('#' + ePCdict[engid].strip())
            print(usrfr[i].strip()) # print USR_sentence
            print(usrfr[i-1].strip()) # print sentence_ID
            print('### concept labels:::', usrfr[i+1].strip()) # print cocept labels
            conLabels = usrfr[i+1].split(',')
            conLabels = [con.replace(" ","") for con in conLabels]
            #print(conLabels)
            for j in range(len(conLabels)):
                if '-' in conLabels[j]: #checking concept label with TAM
                        tam = conLabels[j].split('-')[1].strip()
                        concept = conLabels[j].split('-')[0].strip()
                        try: 
                            #print(concept, '===========')
                            print(concept + '\t' + con_dict[concept])
                        except:
                            print(concept + '\t')
                        try:
                            #print(tam, 'TTTTTTTTTTTTT')
                            print(tam + '\t' + dict_tam[tam])
                        except:
                            print(tam + '\t')
                        concept = conLabels[j].split('-')[0].strip()
                else:
                    try:
                        print(conLabels[j] + '\t' + con_dict[conLabels[j]])
                    except:
                        print(conLabels[j])


