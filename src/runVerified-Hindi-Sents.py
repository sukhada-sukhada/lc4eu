#take dir name as 1st argument which contains the verified USR files and run all the files and stores the output in usr-hin-out.txt file.
#To run:
# python3 runVerified-Hindi-Sents.py verified_sent


import sys, subprocess, os
dire = sys.argv[1]
files = os.listdir(dire)

files.sort()
subprocess.run('rm my_temp.txt', shell=True)
fw = open('my_temp.txt', 'w')
for f in files :
    fw = open('my_temp.txt', 'a')
    sent = 'head -n 1 ' + dire + '/' + f 
    cmd = 'bash lc.sh ' + dire + '/' + f 
    inpSent = subprocess.run([sent], shell=True, stdout=fw, text=True)
    myout = subprocess.run([cmd], shell=True, capture_output=True, text=True)
    ot = subprocess.run(['grep', '-v', 'Creating'], stdout=fw, text=True, input=myout.stdout)
    #fw.write('\n')
    fw.close()


fr = open('my_temp.txt', 'r')
fw1 = open('my_temp-1.txt', 'w')
f = fr.readlines()
for i in range(len(f)):
    if f[i].startswith("Calling ACE parser for generating English sentence"):
        pass
    else:
        fw1.write(f[i])

fw1.close()
