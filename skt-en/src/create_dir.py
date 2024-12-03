#Creating dir inside tmp_anu_dir
#Written by Roja(19-08-19)
###################################
import sys, os, shutil

f=str(sys.argv[1])
f1=f.split('/')
file_name=f1[-1] #To get file name

f2=open(sys.argv[2], 'w')

path=os.getcwd()

for line in open(sys.argv[2]):
    lst = line.strip().split('\t')
    if(file_name == lst[1]):
        dir_name = lst[0]
        var =  path + '/tmp_dir/' + dir_name
        try:
            if(os.path.exists(var)):
                shutil.rmtree(var)
                os.mkdir(var)
            else:
                os.mkdir(var)
        except OSError:
            print(("Creation of the directory %s failed" % var))
            f2.write("failed")
        else:
            print(("Successfully created the directory %s " % var))
            f2.write(var)
            

        


