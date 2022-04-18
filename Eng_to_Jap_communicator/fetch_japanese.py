import sys
import os
import re
import fileinput
####################################

####################################
fname = str(sys.argv[1])
fname2 = str(sys.argv[2])
fname3 = str(sys.argv[3])
fname4 = str(sys.argv[4])
f = open(fname, "r+")
f2 = open(fname2, "w+")
myfile = f.readlines()
####################################

pos = 0
engWrd = []
x = []
for line in myfile:  # to store all English words that are to be replaced by German words
    f2.write(line)
#       if line.find("_rel") != -1:    #to find german facts in clip file
#               print line
#               f2.write(line)         # to write german facts in second file
    rep = re.findall(r' \_.*?\_', line)  # to fetch words
    rep1 = str(rep).strip('[]')
    rep1 = rep1.replace("_", '')
    rep1 = rep1.replace("'", '')
    rep1 = rep1.replace(" ", '')
    if rep1 != '':
        engWrd.append(rep1)
f2.close()
#print engWrd
#############################################


def replaceAll(files, searchExp, replaceExp):  # Function to replace
    for line in fileinput.input(files, inplace=1):
        if searchExp in line:
            line = line.replace(searchExp, replaceExp)
#	    line = line.replace('\n','')
        sys.stdout.write(line)


#############################################
gerWrd = []
split_lines = []
wrdFetch = []
my_list = []  # to seperate all lines of concept dictionary on comma
with open(fname3, 'r') as file1:
    x = open(fname2, 'r')
    mylines = x.readlines()  # to read the file having german facts
    lines = file1.readlines()
    for string in lines:
        line1 = string.split(',')
        # to put all concept dictionary entries in list seprated by comma
        split_lines.append(line1)

string_str = []
x = open(fname2, 'r+')
mylines = x.readlines()
for word in engWrd:
    for wlist in split_lines:
        eng = wlist[2]  # english entry
        if word == eng.split('_')[0]:
            string_str.append(wlist[0])
#print string_str
wrd = ''
f2 = open(fname4, 'r')
line1 = f2.readlines()
for item in string_str:
    for string1 in line1:
        wrd = string1.split(',')[0]
        #print item,'----',wrd
        if (item == wrd):
            #	print string1
            replaceAll('jap_facts.txt', string1.split(',')[
                       1], string1.split(',')[2].replace('\n', ''))
