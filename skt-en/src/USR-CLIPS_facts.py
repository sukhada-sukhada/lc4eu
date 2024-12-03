# Written by Sukhada on 17/03/2019, Email: sukhada8@gmail.com, sukhada.hss@iitbhu.ac.in
# Objective: Convert the information given in a Hindi  USR csv file into CLIPS facts.
#   Input:  Hindi USR.csv file
#   Output: Hindi USR converted into CLIPS facts
# To run: python3 USR-clips_clips_facts.py <_usr.csv file> <output file>
#    Ex. python3 USR-clips_facts.py rAma-ne-basa-adde-para-eka-acCe-hI-ladake-ke-sAWa-bAwa-kI_user.csv USR-clips_facts.dat
######################################################################
import sys, re

fr = open(sys.argv[1], 'r')
hinUsrCsv = list(fr)
ans=open(sys.argv[2],'w+')

conceptDict = hinUsrCsv[1].strip().split(',')    # row 2: concept dict info
wid = hinUsrCsv[2].strip().split(',')            # row 3: concept ids
pos = hinUsrCsv[3].strip().split(',')            # row 4: semantic cat of nouns
morphoSem = hinUsrCsv[4].strip().split(',')            # row 5: morpho-Semantic info
depRels = hinUsrCsv[5].strip().split(',')        # row 6: dependency relations
discorseRel = hinUsrCsv[6].strip().split(',')    # row 7: discourse relations
speakerView = hinUsrCsv[7].strip().split(',')    # row 8: Speaker's view
scope = hinUsrCsv[8].strip().split(',')          # row 9: scope
if len(hinUsrCsv) > 10:
    construction = hinUsrCsv[10].split()         # row 11: construction
    #print(construction, hinUsrCsv)

# Writing kriyA and their TAM value
for i in range(len(conceptDict)):
    if '-' in conceptDict[i]:
        id = (i+1)*10000
        TAM = conceptDict[i].split('-')[1]
        ans.write('(kriyA-TAM\t' + str(id) + '\t' + TAM + ')\n')


# Creating id-concept_label dictionary
idConcept = {}
for i in range(len(conceptDict)):
    myid = int(float(i+1)*10000)
    if '-' in conceptDict[i]: 
        idConcept[str(myid)] = conceptDict[i].split('-')[0]
    else:
        idConcept[str(myid)] = conceptDict[i]

# Writing id-concept_label 
for k in idConcept.keys():
    ans.write('(id-concept_label\t'+ k +'\t'+idConcept[k] + ')\n')


# Writing gender,number,person:
for i in range(len(morphoSem)):
    if morphoSem[i] !='':
        if 'superl' in morphoSem[i]:
            ans.write('(id-degree\t' + str((i+1)*10000) + '\tsuperl)\n')
        elif 'comper' in morphoSem[i]:
            ans.write('(id-degree\t' + str((i+1)*10000) + '\t' + morphoSem[i] + ')\n')
        elif 'doublecausative' in morphoSem[i]:
            ans.write('(id-doublecausative\t' + str((i+1)*10000) + '\tyes)\n')        
        elif 'causative' in morphoSem[i]:
            ans.write('(id-causative\t' + str((i+1)*10000) + '\tyes)\n')
        elif 'sg' in morphoSem[i]:
            ans.write('(id-num\t' + str((i+1)*10000) + '\tsg)\n')
        elif 'pl' in morphoSem[i]:
            ans.write('(id-num\t' + str((i+1)*10000) + '\tpl)\n')
        else:
            pass

# Writing POS values
for i in range(len(wid)):
    if pos[i] != '': 
        if ' ' in pos[i]:
            poslst = pos[i].split()
            for j in range(len(poslst)):
                ans.write('(id-'+poslst[j]+'\t' + str((i+1)*10000) + '\t' + 'yes)\n')
        else:
            ans.write('(id-'+pos[i]+'\t' + str((i+1)*10000) + '\t' + 'yes)\n')
            

# Writing dependency relations
for i in range(len(depRels)):
    idRels = depRels[i].strip().split(' ')
    for j in range(len(idRels)):
        if idRels[j] != '':
            idRel = idRels[j]
            if 'samAnAXi' in idRel: # Assmption: there would be only two occurences of samAnAXi in a sentence. This part of program would generate two samAnAXi facts, one of them would be duplicate which will be deleted automatically by CLIPS while loading the facts' file.
                sam1 = [i for i, n in enumerate(depRels) if n == 'samAnAXi'][0]
                sam2 = [i for i, n in enumerate(depRels) if n == 'samAnAXi'][1]
                ans.write('(rel_name-ids\tsamAnAXi\t' + str(((sam1+1)*10000)) + '  ' + str(((sam2+1)*10000)) + ')\n' )
            elif 'anuBAvya' in idRel: #
                anuBava = [i for i, n in enumerate(depRels) if n == 'anuBava'][0]
                anuBAvaka = [i for i, n in enumerate(depRels) if n == 'anuBAvaka'][0]
                anuBAvya = [i for i, n in enumerate(depRels) if n == 'anuBAvya'][0]
                ans.write('(rel_name-ids\tanuBava-anuBAvaka-anuBAvya\t' + str(((anuBava+1)*10000)) + '  ' + str(((anuBAvaka+1)*10000)) + ' ' + str(((anuBAvya+1)*10000)) + ')\n' )
            elif 'anuBava' in idRel and 'anuBAvya' not in depRels:
                anuBava = [i for i, n in enumerate(depRels) if n == 'anuBava'][0]
                anuBAvaka = [i for i, n in enumerate(depRels) if n == 'anuBAvaka'][0]
                ans.write('(rel_name-ids\tanuBava-anuBAvaka\t' + str(((anuBava+1)*10000)) + '  ' + str(((anuBAvaka+1)*10000)) + ')\n' )
            elif 'anuBAvaka' in idRel:
                pass
            else:
                try:
                    if '/' in idRel: # Computing compound relations
                        headId = str(int(float(idRel.split('/')[0])*10000))
                        depId = str(int(float(idRel.split('/')[1].split(':')[0])*10000))
                        myrel = 'rel_name-ids\t' +  idRel.split(':')[1]
                        ans.write('('+ myrel + '\t' + headId + '\t' + depId + ')\n')
                    else:
                        kriId = str(int(float(idRel.split(':')[0]))*10000)
                        karakaId = str((i+1)*10000)
                        myrel = 'rel_name-ids\t' +  idRel.split(':')[1]
                        ans.write('('+ myrel + '\t' + kriId + '\t' + karakaId + ')\n')
                except:
                    print('Sukhada Warning: Value Error')

# Writing discourse information
for i in range(len(discorseRel)):
    if discorseRel[i] != '':
        idrel = discorseRel[i].split(':')
        if '.' in idrel[0]:
            sentid = idrel[0].split('.')[0] + '.' #beyond sentence level discourse
            indexid = idrel[0].split('.')[1]
            headId = sentid + str(int(indexid)*10000)
            depId = str((i+1)*10000)
            ans.write('(rel_name-ids ' +idrel[1]+ ' ' + headId + '\t' + depId + ')\n')
        else:
            headId = str(int(float(idrel[0])*10000)) #sentence level discourse
            depId = str((i+1)*10000)
            ans.write('(rel_name-ids ' +idrel[1]+ ' ' + headId + '\t' + depId + ')\n')


for k in idConcept.keys():
    if k.endswith('100'):
        ans.write('(viSeRya-emp\t'+ str(int(k)-100) +'\t'+ k +')\n')

# Writing Speaker's View values
for i in range(len(wid)):
    if speakerView[i] != '':
        if ' ' in speakerView[i].strip():
            lst = speakerView[i].split(' ')
            for j in range(len(lst)):
                if ':' in lst[j]: 
                    idrel = lst[j].split(':')
                    if 'shade:' in lst[j]: 
                        ans.write('(id-shade\t' +  str((i+1)*10000) + ' ' + idrel[1][:-1] +')\n') # 375: 
                else:
                        ans.write('(id-'+lst[j]+'\t' + str((i+1)*10000) + '\t' + 'yes)\n')
        else:
            if ':' in speakerView[i]:   
                idrel = speakerView[i].split(':')
                depId = str((i+1)*10000)
                if 'shade:' in speakerView[i]: 
                    ans.write('(id-shade\t' +  str((i+1)*10000) + ' ' + idrel[1][:-1] +')\n') # 375: 
            else:
                ans.write('(id-'+speakerView[i]+'\t' + str((i+1)*10000) + '\t' + 'yes)\n')


# Writing scope facts
for i in range(len(scope)):
    if scope[i] != '':
        idrel = scope[i].split(':')
        ans.write('(rel_name-ids\t' + idrel[1] + '\t' + str(int(idrel[0])*10000 ) + '\t' + str((i+1)*10000) + ')\n')


# writing sentence type
ans.write('(sentence_type\t' + hinUsrCsv[9].strip() + ')\n')

# Constructions
if len(hinUsrCsv) > 10:
    for c in range(len(construction)):
        myc = construction[c].split(':')
        constructionName = myc[0]
        constructionIds  = myc[1][1:-1].split(',')
        myIds = []
        for i in range(len(constructionIds)):
            myIds.append(str(int(constructionIds[i])*10000))
        ans.write('(construction-ids\t' + constructionName + '\t' + ' '.join(myIds) + ')\n')
    

