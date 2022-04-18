# all header files
import re
import difflib
import sys
#################


def sub(x):  # function for lines in MRS that start with SENT and RELS
    fname = str(sys.argv[1])
    with open(fname, 'r') as f:
        a1 = []
        a = []
        me = []
        st = []
        str1 = ''
        for line in f:
            if line.startswith('SENT'):
                k = line.index(': ')
                str1 = line[k+2:]
                str1 = str1.replace('\n', '')
            if line.startswith('RELS'):
                str4 = line.replace('RELS: < ', '')
                n = re.findall(r'\<.*?\:.*?\>', str4)
                b = a.append(n)
            elif re.findall(r'\<.*?\:.*?\>', line):
                n = re.findall(r'\<.*?\:.*?\>', line)
                b = a.append(n)
        a.sort()
        for i in a:
            if i not in me:
                me.append(i)
                n = str(me).strip('[]')
                n = n.replace("\'", "")
        # To store the location of each word.For ex:"This is an apple."This-1,is-2,an-3,apple-4"
        for index, item in enumerate(me, start=1):
            n = str(item).strip('[]')
            n = n.replace("\'", "")
            st = re.findall(r'\:.*?\>', n)
            st1 = re.findall(r'\<.*?\:', n)
            for j in range(len(st)):
                st[j] = st[j].replace(":", "")
                st[j] = st[j].replace(">", "")
            for j in range(len(st1)):
                st1[j] = st1[j].replace(":", "")
                st1[j] = st1[j].replace("<", "")
            n = str(st).strip('[]')
            n = n.replace("\'", "")
            in1 = int(n)
            n1 = str(st1).strip('[]')
            n1 = n1.replace("\'", "")
            in2 = int(n1)
            s1 = str1.split(' ')
            s = str1[int(n1):int(n)]
            for index, item in enumerate(s1, start=1):
                s2 = str(n1)+str(':')+str(n)
                if s == item:
                    if s2 in x:
                        return index
############################################################################


def _named(line):  # For lines in MRS that starts with "named"
    #	p1 = str(sys.argv[2])
    p = open(p1, 'a+')
    n = '(named-mrs_id-mrs_hndl-CARG '
    p.write(n)
    p.write(" ")
    p.write("named ")
    if (line.find("ARG0: ") != -1):
        k = line.index("ARG0: ")
        str1 = line[k+6:]
        word = str1.split()
        p.write(word[0])
        p.write(" ")
    if (line.find("LBL: ") != -1):
        k = line.index("LBL: ")
        str1 = line[k+5:]
        word = str1.split()
        p.write(word[0])
        p.write(" ")
    if (line.find("CARG: ") != -1):
        k = line.index("CARG: ")
        str1 = line[k+6:]
        n = re.findall(r'\".*?\"', str1)
        str1 = n
        n = str(str1).strip('[]')
        n = n.replace("\'", "")
        p.write(n)
        p.write(" ")
    p.write(" )\n")
###########################################################################


# For lines in MRS that contains all nodes. (For ex: "This is an apple." => [ _apple_n_1<11:17> LBL: h12 ARG0: x8 ] )
def _loc(line):
    #	p1 = str(sys.argv[2])
    p = open(p1, 'a+')
    f1 = []
    f1 = re.findall(r' \[ .*?\<.*?\:.*?\> .*?\]', line)
    for i in range(len(f1)):
        if (f1[i].find(" [ _") != -1):
            break
        elif (f1[i].find(" [ ") != -1):
            if (f1[i].find("named") != -1):
                break
#			  elif (f1[i].find("compound")!=-1):
#				break
            else:
                n = '(name-mrs_id-mrs_hndl-id '
                p.write(n)
                p.write(" ")
                st = re.findall(r' .*?\<', f1[i])
                nt = str(st).strip('[]')
                nt = nt.replace("\'", "")
                nt = nt.replace(' [ ', '')
                nt = nt.replace('<', '')
                p.write(str(nt))
                p.write(" ")
                if (line.find("ARG0: ") != -1):
                    k = line.index("ARG0: ")
                    str1 = line[k+6:]
                    word = str1.split()
                    p.write(word[0])
                    p.write(" ")
                if (line.find("LBL: ") != -1):
                    k = line.index("LBL: ")
                    str1 = line[k+5:]
                    word = str1.split()
                    p.write(word[0])
                    p.write(" ")
                res = sub(line)
                p.write("%s" % res)
            p.write(" )\n")

############################################################################


def _name(line):
 #       p1 = str(sys.argv[2])
    p = open(p1, 'a+')
    n = '(name-mrs_id-mrs_hndl-id '
    #print n
    p.write(n)
    p.write(" ")
    head, sep, tail = line.partition('<')
    str2 = head.replace(" [ ", "")
    if head.startswith("RELS"):  # [ _xx_x<?:?> LBL: ? ARG0: ?]
        str2 = tail
        s = re.sub(r'\<.*?\]\n', r'', str2)
        st = re.sub(r'\[ ', r'', s)
        p.write(st)
    #	  print st
        p.write(" ")
    else:
        p.write(str2)
        p.write(" ")
    if (line.find("ARG0: ") != -1):
        k = line.index("ARG0: ")
        str1 = line[k+6:]
        word = str1.split()
        p.write(word[0])
        p.write(" ")
    if (line.find("LBL: ") != -1):
        k = line.index("LBL: ")
        str1 = line[k+5:]
        word = str1.split()
        p.write(word[0])
        p.write(" ")
    res = sub(line)
    p.write("%s" % res)
    p.write(" )\n")


############################################################################

def _x(line):  # For storing details of nouns ,i.e. , the nodes with ARG0 value starting with x
    #	p1 = str(sys.argv[2])
    p = open(p1, 'a+')
    if (line.find('PT: ') != -1):
        n = '(pr_mrs_id-pers-Num-Pt '
        p.write(n)
    else:
        n = '(x_mrs_id-pers-Num-Ind '
        p.write(n)
    p.write(" ")
    k = line.index("[ x")
    str3 = line[k-4:k-1]
    str3 = str3.replace(' ', '')
    p.write(str3)
    p.write(" ")
    if (line.find("PERS: ") != -1):
        k = line.index("PERS: ")
        str3 = line[k+6:]
        word = str3.split()
        p.write(word[0])
        p.write(" ")
    if (line.find("NUM: ") != -1):
        k = line.index("NUM: ")
        str3 = line[k+5:]
        word = str3.split()
        p.write(word[0])
        p.write(" ")
    if (line.find("GEND: ") != -1):
        k = line.index("GEND: ")
        str3 = line[k+6:]
        word = str3.split()
        p.write(word[0])
        p.write(" ")
    if (line.find("IND: ") != -1):
        k = line.index("IND: ")
        str3 = line[k+5:]
        word = str3.split()
        p.write(word[0])
        p.write(" ")
    if (line.find("PT: ") != -1):
        k = line.index("PT: ")
        str3 = line[k+4:]
        word = str3.split()
        p.write(word[0])
        p.write(" ")
    p.write(" )\n")
###########################################################################


def _rstr(line):  # For restricted nodes
    #    p1 = str(sys.argv[2])
    p = open(p1, 'a+')
    n = '(q_mrs_hndl-Rstr-Body '
    p.write(n)
    p.write(" ")
    k = line.index("ARG0: ")
    str3 = line[k+6:]
    word = str3.split()
    p.write(word[0])
    p.write(" ")
    if (line.find("RSTR: ") != -1):
        k = line.index("RSTR: ")
        str3 = line[k+6:]
        word = str3.split()
        p.write(word[0])
        p.write(" ")
    if (line.find("BODY: ") != -1):
        k = line.index("BODY: ")
        str3 = line[k+6:]
        word = str3.split()
        p.write(word[0])
    p.write(" )\n")
##########################################################################


def _hcons(line):  # For HCONS node in MRS
   #     p1 = str(sys.argv[2])
    p = open(p1, 'a+')
    f1 = []
    st = re.sub(r'HCONS', r'', line)
    if (st.find("qeq") != -1):
        f1 = re.findall(r'h.*? qeq h.*? ', st)
        for i in range(len(f1)):
            n = '(Restrictor-Restricted '
            p.write(n)
            p.write(" ")
            k = f1[i].index("qeq")
            str3 = f1[i][k-3:k-1]
            if (str3.find("h") == -1):
                p.write("h")
            str3 = str3.replace(" ", "")
            p.write(str3)
            p.write(" ")
            k = f1[i].index("qeq")
            str3 = f1[i][k+4:]
            word = str3.split()
            p.write(word[0])
            p.write(" )\n")
    p.write("\n")
###########################################################################


def _arg(line):  # To store details of all the ARGs
 #       p1 = str(sys.argv[2])
    p = open(p1, 'a+')
    # [ _xx_x<?:?> LBL:? ARG0:? [e SF:? TENSE:? PERF: ? ] ARG1:?]
    n = '(mrs_id-Args '
    p.write(n)
    p.write(" ")
    if (line.find("ARG0: ") != -1):
        k = line.index("ARG0: ")
        str3 = line[k+6:]
        word = str3.split()
        p.write(word[0])
        p.write(" ")
    if (line.find("ARG1: ") != -1):
        k = line.index("ARG1: ")
        str3 = line[k+6:]
        word = str3.split()
        p.write(word[0])
        p.write(" ")
    if (line.find("ARG2: ") != -1):
        k = line.index("ARG2: ")
        str3 = line[k+6:]
        word = str3.split()
        p.write(word[0])
        p.write(" ")
    if (line.find("ARG3: ") != -1):
        k = line.index("ARG3: ")
        str3 = line[k+6:]
        word = str3.split()
        p.write(word[0])
        p.write(" ")
    if (line.find("ARG4: ") != -1):
        k = line.index("ARG4: ")
        str3 = line[k+6:]
        word = str3.split()
        p.write(word[0])
        p.write(" ")

    p.write(" )\n")

###########################################################################


def _e(line):  # For storing details of verbs, adjectives etc. ,i.e. , the nodes with ARG0 value starting with e
    #        p1 = str(sys.argv[2])
    #print line
    p = open(p1, 'a+')
    f1 = []
    if line.startswith('INDEX'):
        p.write("")
    else:
        if (line.find("[ e") != -1):
            f1 = re.findall(r' e.*? \[ e .*?\]', line)
            for i in range(len(f1)):
                n = '(e_mrs_id-SF-Tns-Mood-prog-perf '
                p.write(n)
                p.write(" ")
                if (f1[i].find("[ e") != -1):
                    k = f1[i].index("[ e")
                    str3 = f1[i][k-4:k-1]
                    p.write(str3)
                    p.write(" ")
                if (f1[i].find("SF: ") != -1):
                    k = f1[i].index("SF: ")
                    str3 = f1[i][k+4:]
                    word = str3.split()
                    p.write(word[0])
                    p.write(" ")
                if (f1[i].find("TENSE: ") != -1):
                    k = f1[i].index("TENSE: ")
                    str3 = f1[i][k+7:]
                    word = str3.split()
                    p.write(word[0])
                    p.write(" ")
                if (f1[i].find("MOOD: ") != -1):
                    k = f1[i].index("MOOD: ")
                    str3 = f1[i][k+6:]
                    word = str3.split()
                    p.write(word[0])
                    p.write(" ")
                if (f1[i].find("PROG: ") != -1):
                    k = f1[i].index("PROG: ")
                    str3 = f1[i][k+6:]
                    word = str3.split()
                    p.write(word[0])
                    p.write(" ")
                if (f1[i].find("PERF: ") != -1):
                    k = f1[i].index("PERF: ")
                    str3 = f1[i][k+6:k+7]
                    word = str3.split()
                    p.write(word[0])
                    p.write(" ")
                p.write(" )\n")


############################################################################

# def _store(x):
#	return x

###########################################################################

fname = str(sys.argv[1])
p1 = str(sys.argv[2])


def main():  # main()

    # fname = str(sys.argv[1])
    # p1 = str(sys.argv[2])
    str1 = ""
    str2 = ""
    str3 = ''
    res = ''
    res1 = ""
    a = []
    _index = ''
    flag = 0
    with open(fname, 'r+') as f:
        p = open(p1, 'w+')
        for line in f:
            p = open(p1, 'a+')
            if (flag == 1):
                break
            else:
                if (line.find('[ LTOP: ') != -1):
                    n = '(ltop-index '
                    p.write(n)
                    word = line.split()
                    p.write(word[2])
                    p.write(" ")
                if (line.find('INDEX: ') != -1):
                    _index = line.replace('INDEX:', '')
                    word = line.split()
                    p.write(word[1])
                    res1 = word[1]
                    p.write(" )\n")
#		if (line.find('RELS: ')!=-1):
#			if ( line.find('[ _')!=-1):
#				_name(line)
                if (line.find(' [ named') != -1):
                    _named(line)
                if (line.find('[ ') != -1):
                    _loc(line)
                if (line.find('[ _') != -1):
                    _name(line)
                if (line.find("[ x") != -1):
                    _x(line)
                if (line.find("RSTR: ") != -1):
                    _rstr(line)
                if (line.find("[ e") != -1):
                    _e(line)
                if (line.find('ARG1:' or 'ARG2:' or 'ARG3:') != -1):
                    if (line.find("ARG0: ") != -1):
                        k = line.index("ARG0: ")
                        str3 = line[k+6:]
                        word = str3.split()
                        if(word[0] == res1):
                            #print _index
                            #print word[0]
                            _e(_index)
                        _arg(line)
                if line.startswith('HCONS'):
                    _hcons(line)
                    flag = 1


main()
