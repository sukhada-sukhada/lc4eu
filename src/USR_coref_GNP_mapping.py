#345: vaha apane piwA  ke sAWa vixyAlaya gayI
#343: rAma apane piwA  ke sAWa vixyAlaya gayA
#To run:  python3 USR_coref_GNP_mapping.py <USR_FILE> <OUTPUT_FILE_NAME> 

import sys, copy, os
fr = open(sys.argv[1], 'r')
hinUSR = list(fr)
hinUSRcopy = copy.deepcopy(hinUSR)
newHinUSR = open(sys.argv[2], 'w')
discourseRow = hinUSR[6].strip()

if ':coref' in discourseRow:
    discourseRel = discourseRow.strip().split(',')
    myUSRgnplist = []
    mysemcatlist=[] #taking an empty list to append semantic categories
    myspovlist=[]
    origspovlist=hinUSR[7].split(",")#getting list for spov from original input file
    origsemcatlist=hinUSR[3].split(",")#getting list of sem categories from original input file
    origGNPlist = hinUSR[4].split(',') #getting list of GNP values from original input file
    for j in range(len(discourseRel)):
        if 'coref' in discourseRel[j]:
            mycoref = discourseRel[j].split(':')
            if '.' in mycoref[0]: #When the strings before and after '.' respectively refer to another file name and concept index for coref
                corefFile = mycoref[0][:mycoref[0].rindex('.')] #Getting coref file name 
                corefIndex = mycoref[0].split('.')[1] #Get coref index from coref file. Assumes that coref file exists in the same folder where the input USR exists.
                myfile = open(os.path.dirname(sys.argv[1])+'/'+corefFile, 'r')         #reading coref file
                corefUSR = list(myfile)                
                corefsemcatlist=corefUSR[3].split(",")#getting list of sem cat from corefUSR
                corefGNPlist = corefUSR[4].split(',') #getting list of GNP values from coref file
                corefspovlist= corefUSR[7].split(",")#getting list of spov values from coref file
                if corefGNPlist[int(corefIndex)-1] == '\n':
                    myUSRgnplist.append('')
                else: 
                    myUSRgnplist.append(corefGNPlist[int(corefIndex)-1]) #getting GNP values from coref file
                if corefsemcatlist[int(corefIndex)-1]=="\n":
                    mysemcatlist.append('')
                else:
                    mysemcatlist.append(corefsemcatlist[int(corefIndex)-1])#getting semcat values from coref file
                if corefspovlist[int(corefIndex)-1]=="\n":
                    myspovlist.append('')
                else:
                    myspovlist.append(corefspovlist[int(corefIndex)-1]) #getting spov values from coref file
            else:
                corefIndex = mycoref[0] #Getting coref index 
                myUSRgnplist.append(origGNPlist[int(corefIndex)-1]) #getting GNP values from coref file
                mysemcatlist.append(origsemcatlist[int(corefIndex)-1])#getting sem cat values from coref file
                myspovlist.append(origspovlist[int(corefIndex)-1])#getting spov values from coref file
        else:
            myUSRgnplist.append(origGNPlist[j]) #appending GNP values from original input file
            #print(hinUSRcopy)
            mysemcatlist.append(origsemcatlist[j])
            myspovlist.append(origspovlist[j])
    hinUSRcopy[4] = ','.join(myUSRgnplist)
    hinUSRcopy[3] =",".join(mysemcatlist)
    hinUSRcopy[7] =",".join(myspovlist)
    for k in range(len(hinUSRcopy)): #writing updated coref USR
        newHinUSR.write(hinUSRcopy[k])
else:
    for k in range(len(hinUSR)):
        newHinUSR.write(hinUSR[k])

newHinUSR.close()


