#To run:  python3 lc-debugger.py ../tmp_dir/2/2_mrs "The teacher has just come."

import sys
import re
import os,subprocess


class bcolors:
    HEADER = '\033[95m'
    OKBLUE = '\033[94m'
    OKCYAN = '\033[96m'
    OKGREEN = '\033[92m'
    WARNING = '\033[93m'
    FAIL = '\033[91m'
    ENDC = '\033[0m'
    BOLD = '\033[1m'
    UNDERLINE = '\033[4m'


try:
    lcMrsPath = sys.argv[1]#'/root/Documents/language_communicator/tmp_dir/160/160_mrs'
    engSent = sys.argv[2]#"The food got eaten by me."
    ## Output Got
    try:
        f = open(lcMrsPath, 'r')
        fr = f.read()
    except:
        print(f'{bcolors.FAIL + bcolors.BOLD}(lc mrs output path) is Not Valid {bcolors.ENDC}')
        sys.exit(0)

except:
    print(f'{bcolors.FAIL + bcolors.BOLD}Command is not Valid => eg (python3 mrs-binding.py "lc mrs output path" "English Sentence"){bcolors.ENDC}')
    sys.exit(0)



open('.ace_input','w').write(engSent)
runACE_Command = ["/home/sukhada/ace-0.9.24/ace", "-g","/home/sukhada/ace-0.9.24/erg-1214-x86-64-0.9.24.dat","-1Tf",".ace_input"]
result = subprocess.run(runACE_Command, stdout=subprocess.PIPE)
aceOut = str(result.stdout,'utf-8')




def compareResults(expectedSW,gotSW):
    #ectract LTOP 
    expectedS = expectedSW.splitlines()
    gotS = gotSW.splitlines()

    finalData = {'LTOP': None,'INDEX': None,'HCONS': None,'RELS': None}
    for cdata in expectedS:
        temp = cdata.split('LTOP: ')
        if len(temp)>1:
            finalData['LTOP']= temp[1].split('\n')[0]
        
        temp = cdata.split('INDEX: ')
        if len(temp)>1:
            finalData['INDEX']=temp[1].split(' ')[0]
        
        temp = cdata.split('HCONS: ')
        if len(temp)>1:
            finalData['HCONS']=temp[1].split('\n')[0]
    
    ## ADD Relations
    temp = expectedSW.split('RELS: < ')
    if len(temp)>1:
        temp = temp[1].split('>\n')[0].splitlines()
        pat = r'\<.*?\>'
        pat1 = r'\[.*?\]'
        finalRels = {}
        for cdt in temp:
            spi = re.findall(pat,cdt)[0]
            key,val = cdt.split(spi)
            key = key.strip().split(' ')[1].strip()
            val = re.sub(pat1,'',val).split(']')[0]
            val = val.replace(': ',':').strip().split(' ')
            fRels = {}
            for vv in val:
                tt = vv.split(':')
                if len(tt)==2:
                    fRels[tt[0]]=tt[1]
            finalRels[key] = fRels
    finalData['RELS'] = finalRels
    print(finalRels)

    finalData1 = {'LTOP': None,'INDEX': None,'HCONS': None,'RELS': None}
    for cdata in gotS:
        temp = cdata.split('LTOP: ')
        if len(temp)>1:
            finalData1['LTOP']= temp[1].split('\n')[0]
        temp = cdata.split('INDEX: ')
        if len(temp)>1:
            finalData1['INDEX']=temp[1].split(' ')[0]
        temp = cdata.split('HCONS: ')
        if len(temp)>1:
            finalData1['HCONS']=temp[1].split('\n')[0]

    ## ADD Relations
    temp = gotSW.split('RELS: < ')
    if len(temp)>1:
        temp = temp[1].split('>\n')[0].splitlines()
        pat = r'\<.*?\>'
        pat1 = r'\[.*?\]'
        finalRels = {}
        for cdt in temp:
            spi = re.findall(pat,cdt)
            if spi:
                key,val = cdt.split(spi)
            else:
                ttt = cdt.strip().split(' ')
                key = ttt[1]
                val = ' '.join(ttt[2:])

            val = re.sub(pat1,'',val).split(']')[0]
            val = val.replace(': ',':').strip().split(' ')
            fRels = {}
            for vv in val:
                tt = vv.split(':')
                if len(tt)==2:
                    fRels[tt[0]]=tt[1]
            finalRels[key] = fRels
    finalData1['RELS'] = finalRels

    del finalData1['HCONS']
    del finalData['HCONS']
    return (finalData,finalData1)
    

aceOutRes,lcOutRes = compareResults(aceOut,fr)



seperator = '\n\t\t'+'*'*40+ '    End   '+ '*'*40 + '\n\n'
print('\n\t\t'+'*'*40+ '    ACE MRS Output:   '+ '*'*40 )
print(aceOut.strip(),end=seperator)
print('\n\t\t'+'*'*40+ '    lc.sh Script MRS Output   '+ '*'*40 )

print(fr,end=seperator+'\n')



# print RELS which are not present
aceRels = aceOutRes['RELS']
lcRels = lcOutRes['RELS']

# aceRelsKeys = list(aceRels.keys())
# lcRelsKeys = list(lcRels.keys())
print('\n\t\t'+'*'*40+ '    MATCHING RELS:   '+ '*'*40 )
for i in aceRels:
    try:
        tt = lcRels[i]
    except:
        print(f'{bcolors.FAIL + bcolors.BOLD}"{i}" RELS are not Present in LC Output.{bcolors.ENDC}')

for i in lcRels:
    try:
        tt = aceRels[i]
    except:
        print(f'{bcolors.FAIL + bcolors.BOLD}"{i}" RELS are not Present in ACE Output.{bcolors.ENDC}')
print('\t\t'+'*'*40+ '    End   '+ '*'*40 + '\n\n')
# find common
alllcUV = {}
allaceUV = {}
for ii in aceRels:
    for jj in aceRels[ii]:
        val = aceRels[ii][jj]
        try:
            allaceUV[val].append(f"{ii}[{jj}]")
        except:
            allaceUV[val] = [f"{ii}[{jj}]"]

for ii in lcRels:
    for jj in lcRels[ii]:
        val = lcRels[ii][jj]
        try:
            alllcUV[val].append(f"{ii}[{jj}]")
        except:
            alllcUV[val] = [f"{ii}[{jj}]"]


## ace combination which are not in lc

## reverse the dict
rvAlllcUV = {}
rvAllaceUV = {}
for ii in alllcUV:
    for jj in alllcUV[ii]:
        rvAlllcUV[jj] = ii
for ii in allaceUV:
    for jj in allaceUV[ii]:
        rvAllaceUV[jj] = ii


print('\n\t\t'+'*'*40+ '    BINDING MATCHING:   '+ '*'*40 )
allaceM = sorted(list(allaceUV.keys()),reverse=True)

for ii in allaceM:
    curntData = allaceUV[ii]

    tempComp = []
    for n,jj in enumerate(curntData):
        try:
            if '$$'.join(sorted(curntData)) == '$$'.join(sorted(alllcUV[rvAlllcUV[jj]])):
                break
            else:
                if jj not in tempComp:
                    print(f'{bcolors.WARNING + bcolors.BOLD}Wrong Binding: ({jj}) Expected: ({curntData}) => {rvAllaceUV[jj][0]}*) Got: ({alllcUV[rvAlllcUV[jj]]}) => {rvAlllcUV[jj]}{bcolors.ENDC}')
                    tempComp.extend(alllcUV[rvAlllcUV[jj]])
        except:
            print(f'{bcolors.WARNING + bcolors.BOLD}Missing Binding: ({jj}) Expected: ({curntData}) => {rvAllaceUV[jj][0]}*){bcolors.ENDC}')

print('\t\t'+'*'*40+ '    End   '+ '*'*40 + '\n\n')
