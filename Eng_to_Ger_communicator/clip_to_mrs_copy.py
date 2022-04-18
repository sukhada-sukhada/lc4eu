import sys

fname = str(sys.argv[1])
fname1 = str(sys.argv[2])
file2 = open(fname1, 'w+')

new_str = ''
new_flag = 0
mydict = {}
rstdic = {}
mrsdic = {}
namedic = {}
nameddic = {}
qdict = {}
lbl = ''
arg = ''
ab = {}


def e_(li, xi):  # To split CLIPS fact and store information of verb
    word = li.split()
    str1 = " [ e  SF: "+word[2]+" TENSE: "+word[3].replace(')', '')

    print(word[3])
    if ' +)' in li:
        k = li.index(" +)")
        str3 = li[k+1:]
        wrd = str3.split()
        str1 = str1+" STAT: "+wrd[0].replace(')', '')
        #/[int str1
    if ' -)' in li:
        k = li.index(" -)")
        str3 = li[k+1:]
        wrd = str3.split()
        str1 = str1+" STAT: "+wrd[0].replace(')', '')
        #/[int str1

    if 'apsv' in li:
        str1 = str1+" --PSV: "+word[4]+" MOOD: "+word[5].replace(')', '')
    else:
        str1 = str1+""
    file2.write(str1)
    file2.write(' ]')
    del mydict[xi]


def x_(li, xi):  # To split CLIPS fact and store information of noun
    word = li.split()
    str1 = " [ x PERS: "+word[2].replace(')', '')
    if ' sg' or ' pl' in li:
        if ' sg' in li:
            k = li.index(" sg")
            str3 = li[k+1:]
            wrd = str3.split()
            str1 = str1+" NUM: "+wrd[0].replace(')', '')
        elif ' pl' in li:
            k = li.index(" pl")
            str3 = li[k+1:]
            wrd = str3.split()
            str1 = str1+" NUM: "+wrd[0].replace(')', '')
    else:
        file2.write("")
        str1 = str1+""
    file2.write(str1)
    file2.write(' ]')
    del mydict[xi]


def pr_(li, xi):  # To split CLIPS fact and store information of pronoun nodes
    word = li.split()
    str1 = " [ x PERS: "+word[2]
    if ' m ' or ' f ' in li:
        if ' m ' in li:
            k = li.index(" m ")
            str3 = li[k+1:]
            wrd = str3.split()
            str1 = str1+" GEND: "+wrd[0].replace(')', '')
        elif ' f ' in li:
            k = li.index(" f ")
            str3 = li[k+1:]
            wrd = str3.split()
            str1 = str1+" GEND: "+wrd[0].replace(')', '')

    else:
        file2.write("")
        str1 = str1+""
    if ' sg' or ' pl' in li:
        if ' sg' in li:
            k = li.index(" sg")
            str3 = li[k+1:]
            wrd = str3.split()
            str1 = str1+" NUM: "+wrd[0].replace(')', '')
        elif ' pl' in li:
            k = li.index(" pl")
            str3 = li[k+1:]
            wrd = str3.split()
            str1 = str1+" NUM: "+wrd[0].replace(')', '')
    else:
        file2.write("")
        str1 = str1+""
    file2.write(str1)
    file2.write(' ]')
    del mydict[xi]


def rs_(li, xi):  # To split CLIPS fact and store information of Restricted nodes
    word = li.split()
    str1 = " RSTR: "+word[2]+" BODY: "+word[3].replace(')', '')
    file2.write(str1)
    del rstdic[xi]


def named_(li, xi):  # To split CLIPS fact and store information of named(proper noun) nodes
    file2.write(" ]\n [ ")
    word = li.split()
    str1 = word[1]+'<-1:-1>'+" LBL: "+word[3]+" CARG: " + \
        word[4].replace(')', '')+" ARG0: "+word[2]
    file2.write(str1)
    del nameddic[xi]


def name_(li, xi):  # To split CLIPS fact and store information of all nodes
    word = li.split()
    file2.write('\n [ ')
    str1 = word[1]+'<-1:-1>'+" LBL: "+word[3]+" ARG0: "+word[2]
    file2.write(str1)
    if '_q' in word[1]:
        del qdict[xi]
    else:
        del namedic[xi]
    if xi in list(mydict.keys()):
        if 'e' in xi:
            e_(mydict[xi], xi)
        elif 'pr_mrs_id' in mydict[xi]:
            pr_(mydict[xi], xi)
        elif 'x_mrs_id' in mydict[xi]:
            if '_q' in word[1]:
                print("")
            else:
                x_(mydict[xi], xi)
    if xi in list(rstdic.keys()):
        if '_q' in word[1]:
            rs_(rstdic[xi], xi)
    if xi in list(mrsdic.keys()):
        mrs_(mrsdic[xi], xi)
    if xi in list(nameddic.keys()):
        named_(nameddic[xi], xi)
        if xi in list(mydict.keys()):
            if 'e' in xi:
                e_(mydict[xi], xi)
            else:
                x_(mydict[xi], xi)
    file2.write(' ]')


def mrs_(li, xi):  # To store information of all the ARGs
    #print li,':',xi
    word = li.split()
    for i in range(len(word)):
        if (i >= 2) and (word[i] != ')'):
            #print word[i]
            file2.write(' ARG')
            file2.write(str(i-1))
            file2.write(': ')
            file2.write(word[i].replace(')', ''))
            if (xi == word[i].replace(')', '')):
                e_(li, xi)

            if (xi == word[i].replace(')', '')):
                x_(li, xi)

            if (xi == word[i].replace(')', '')):
                pr_(li, xi)

    del mrsdic[xi]


with open(fname, 'r') as file1:
    #	global mylines
    #	mylines=file1
    #	for lines in mylines:
    #		if '_v_modal' in lines:
    #			print lines

    # To read CLIPS facts and call functions accordingly
    str1 = ''
    flag = 0
    f = 0
    for line in file1:
        #pos = file1.tell()
        #print(pos)
        if (line.find('ltop-index') != -1):
            if (flag == 1):
                _str1 = "[ LTOP: "
                file2.write("\n")
                word = line.split()
                _str1 = _str1+word[1]
                file2.write(_str1)
                file2.write("\n")
                _str1 = 'INDEX: '+word[2].replace(')', '')
                file2.write(_str1)
                file2.write("\n")

            if (flag == 0):
                flag = 1
                _str1 = "[ LTOP: "
                word = line.split()
                _str1 = _str1+word[1]
                file2.write(_str1)
                file2.write("\n")
                _str1 = 'INDEX: '+word[2].replace(')', '')
                arg = word[2].replace(')', '')
                file2.write(_str1)
                file2.write("\nRELS: <")

        if (line.find('Restrictor-Restricted') != -1):
            word = line.split()
            if (word[1] == 'h0'):
                _str = "HCONS: < "+word[1]+" qeq "+word[2].replace(')', '')+" "
                lbl = word[2].replace(')', '')

            else:
                _str = word[1] + " qeq "+word[2].replace(')', '')+" "
            _str = _str+""
            new_str = new_str+_str

        else:

            if (line.find('name-mrs_id-mrs_hndl-id') != -1):
                word = line.split()
                x = word[2]
                if (word[1] == 'parg_d_rel'):
                    f = 1
            #	y=word[1]
                if '_q' in line:
                    qdict[x] = line
                #	print qdict
                else:
                    namedic[x] = line
            #		print namedic[x]
                # if (word[1].find('_v_modal')!=-1):
                #	lbl = word[3]
                #	arg = word[2]
                #	new_flag=1
                # if (word[1].find('_v_n')!=-1):
                #	lb = word[3]
                #	ar = word[2]

            if (line.find('x_mrs_id-pers-Num-Ind') != -1):
                line2 = line
                word = line.split()
                x2 = word[1]
                mydict[x2] = line2

            if (line.find('named-mrs_id-mrs_hnd') != -1):
                word = line.split()
                x = word[2]
                nameddic[x] = line
            #	print nameddic

            if (line.find('pr_mrs_id-pers-Num-Pt') != -1):
                word = line.split()
                line3 = line
                x3 = word[1]
                mydict[x3] = line3

            if (line.find('q_mrs_hndl-Rstr-Body') != -1):
                word = line.split()
                line4 = line
                xr = word[1]
                rstdic[xr] = line4

            if (line.find('e_mrs_id') != -1):
                line1 = line
                word = line1.split()
                x1 = word[1]
                mydict[x1] = line1

            if (line.find('mrs_id-Args') != -1):
                word = line.split()
                line5 = line
                xm = word[1]
                mrsdic[xm] = line5
#	if (line.find('topic-or-focus_d_rel')!=-1):

    #print qdict
    for k, v in list(namedic.items()):
        #	print "key: "+ k;
        #	print "value: "+v;
        if k in list(mydict.keys()):
            name_(v, k)

    for k, v in list(qdict.items()):
        name_(v, k)
  #	print k
#	if (new_flag == 1):
#		print lbl,arg
#		str1="\n [ topic-or-focus_d_rel<-1:-1> LBL: "+lbl+" ARG1: "+arg+" ARG0: e22 ] >\n"
#	else:
#		#print global lb,global ar
    #	if(f == 1):
        #	str1="\n [ topic-or-focus_d_rel<-1:-1> LBL: "+lbl+" ARG1: "+arg+" ARG0: e22 ARG2: "+k+" ] >\n"
    #	else:
    #	str1="\n [ topic-or-focus_d_rel<-1:-1> LBL: "+lbl+" ARG1: "+arg+" ARG0: e22 ] >\n"
    if (line.find('topic-or-focus_d_rel') != -1):
        line5 = line
        word = line5.split()
        str1 = "\n ["+word[0].replace('(', ' ')+""+word[1]+" "+word[2]+" "+word[3] + \
            " "+word[4]+" "+word[5]+" "+word[6] + \
            " "+word[7].replace(')', '')+" ] >\n"
    #	str1="\n [ "+line+" ] >\n"
    file2.write(str1)
    new_str = new_str+'> ]'
    file2.write(new_str)
file2.close()
