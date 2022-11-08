#To run:  python3 lc-debugger.py ../tmp_dir/2/2_mrs "The teacher has just come."

import sys
import re
import os,subprocess
from pathlib import Path
HOME = str(Path.home())


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

def fail_print(s):
    print(f'{bcolors.FAIL + bcolors.BOLD}{s}{bcolors.ENDC}')

try:
    lcMrsPath = sys.argv[1]#'/root/Documents/language_communicator/tmp_dir/160/160_mrs'
    english_sentence = sys.argv[2]#"The food got eaten by me."
    ## Output Got
    try:
        with open(lcMrsPath, 'r') as f:
            fr = f.read()
    except:
        fail_print('(lc mrs output path) is Not Valid.')
        sys.exit(0)

except:
    fail_print('Command is not Valid => eg (python3 mrs-binding.py "lc mrs output path" "English Sentence")')
    sys.exit(0)


try:
    with open('.ace_input','w') as f:
        f.write(english_sentence)
except:
    fail_print("Unable to write temporary file .ace_input")


run_ace_command = [HOME + "/ace-0.9.34/ace",
                   "-g",
                   HOME + "/ace-0.9.34/erg-1214-x86-64-0.9.34.dat",
                   "-1Tf",
                   ".ace_input"
                ]
try:
    result = subprocess.run(run_ace_command, stdout=subprocess.PIPE)
    ace_output = str(result.stdout,'utf-8')
except:
    fail_print("Failed to run ace.")
if ace_output == "":
    fail_print("Failed to run ace.")




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

    return (finalData,finalData1)

seperator = '\n\t\t'+'*'*40+ '    End   '+ '*'*40 + '\n\n'
print('\n\t\t'+'*'*40+ '    ACE MRS Output:   '+ '*'*40 )
print(ace_output.strip(),end=seperator)
print('\n\t\t'+'*'*40+ '    lc.sh Script MRS Output   '+ '*'*40 )

print(fr,end=seperator+'\n')


try:
    aceOutRes,lcOutRes = compareResults(ace_output,fr)
except:
    print('Result Comparison Failed.\n')


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
