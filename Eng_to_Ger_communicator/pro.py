import sys,os
f=open(sys.argv[1],'r')
line=f.readlines()
ln=len(line)
c=0
for i in line:
        c=c+1
f1=open("demo","w")
f1.write(line[c-1])

#print(line[c-1])
f1.close()
f1=open("demo","r")
f2=open("demo1","w")
li=f1.readline()
lne=len(li)
for j in li:
	if j=='"':
		str1=li.replace(j,'')
		print(str1)
		f2.write(str1)
		break
	#	f2.write(li.replace(j,''))
        elif (li.find('n\'t')):
                str1=li.replace('\'','no')
                print(str1)
                f2.write(str1)
                break

	else:
		f2.write(li)
		break
