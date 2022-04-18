import sys
import subprocess
import os
import re

fname1 = str(sys.argv[1])
fname2 = str(sys.argv[2])
fname3 = str(sys.argv[3])
file1=open(fname1,'r')
file2=open(fname2,'w')
file3=open(fname3,'w')

path ='/home/user/'
path1=path+'communicator-tool/Eng_to_Ger_communicator/German_run/'
path2=path+'communicator-tool/Eng_to_Ger_communicator/German_run/'
for line in file1:
	if (line.find("s1:\t")!=-1):
		word=line.split("\t")
		sent=word[1].replace("\n","")
		sent=sent.replace(" ","_")
#		myfile = open('/create-hindi-parser/chl_to_dmrs/output/'+sent+'_dev.csv_sent.txt','r')
		myfile = open(os.path.join(path,'create-hindi-parser/chl_to_dmrs/output/'+sent+'_dev.csv_sent.txt'),'r')
		myline = myfile.readline()
		file2.write(myline)
	if (line.find("s2:\t")!=-1):
                word=line.split("\t")
                sent=word[1].replace("\n","")
                sent=sent.replace(" ","_")
#                myfile = open('/create-hindi-parser/chl_to_dmrs/output/'+sent+'_dev.csv_sent.txt','r')
                myfile = open(os.path.join(path,'create-hindi-parser/chl_to_dmrs/output/'+sent+'_dev.csv_sent.txt'),'r')
                myline = myfile.readline()
                file3.write(myline)
		print(myline)
	if (line.find("s.g:\t")!=-1):
		word=line.split("\t") 
		str1=re.findall(r'\+.*?\+',word[1])
		n=str(str1).strip('[]')
		n=n.replace('+','')
		n=n.replace('\'','')
                n=','+n + '_'
#		f=open ('/home/arpita/communicator-tool/Eng_to_Ger_communicator/dict.txt','r')
		f= open(os.path.join(path,'communicator-tool/concept_dict'),'r')
		for lines in f:
			 if (lines.find(n)!=-1):
				str2=lines.split(",")
				gerwrd=str2[5]
				gerwrd=gerwrd.replace("_1\n","")
				print(gerwrd)

file2.close()
file3.close()
#		print subprocess.check_output(["./home/user/Eng_to_Ger_communicator/eng_to_ger_shell.sh " + str(sys.argv[2])], shell=True) 
#os.system("sh /home/user/Eng_to_Ger_communicator/eng_to_ger_shell.sh " + fname2)

os.system("sh eng_to_ger_shell.sh " + fname2)
F1=open(os.path.join(path1,fname2+'_out'),'r')
os.system("sh eng_to_ger_shell.sh " + fname3)
F2=open(os.path.join(path2,fname3+'_out'),'r')
myline1 = F1.readline()
myline2 = F2.readline()
print("\n" + myline1.replace('.\n','') + " " + gerwrd + " " + myline2.replace('\n','')) 
