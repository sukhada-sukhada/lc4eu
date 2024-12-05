import sys
import subprocess
import os
import re
from itertools import izip,izip_longest 
fname1 = str(sys.argv[1])
#fname2 = str(sys.argv[2])
#fname3 = str(sys.argv[3])
file1=open(fname1,'r')
file2=open('sentence1','w')
file3=open('sentence2','w')

for line in file1:
	if (line.find("s1\t")!=-1):
		word=line.split("\t")
		sent=word[1].replace("\n","")
		print sent
		file2.write(sent)
	if (line.find("s2\t")!=-1):
                word=line.split("\t")
                sent=word[1].replace("\n","")
                file3.write(sent)
		print sent
	if (line.find("s.g\t")!=-1):
		word=line.split("\t") 
		str1=re.findall(r'\+.*?\+',word[1])
		n=str(str1).strip('[]')
		n=n.replace('+','')
		n=n.replace('\'','')
                n=','+n + '_'
		f= open('../dic/concept_dictionary_user.txt','r')
		for lines in f:
			 if (lines.find(n)!=-1):
				str2=lines.split(",")
				gerwrd=str2[5]
				gerwrd=gerwrd.replace("_1","")
				print gerwrd

file2.close()
file3.close()
os.system("sh eng_to_ger_shell.sh " + 'sentence1')
F1=open('../Eng_to_Ger_communicator/German_run/'+'sentence1'+'_out','r')
os.system("sh eng_to_ger_shell.sh " + 'sentence2')
F2=open('../Eng_to_Ger_communicator/German_run/'+'sentence2'+'_out','r')
myline1 = F1.readlines()
myline2 = F2.readlines()
#or line1 in myline1 and line2 in myline2:
#for line1,line2 in izip(myline1,myline2):
for line1 in myline1:
   for line2 in myline2:
	if (line1.find('!')!=-1):
		print "\n" + line1.replace('!\n','') + " " + gerwrd + " " + line2.replace('\n','') 
	else:
		print "\n" + line1.replace('.\n','') + " " + gerwrd + " " + line2.replace('\n','')

