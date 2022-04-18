#to generate mrs_output from mrs_facts
import pdb
import sys
import os
import re
import math

file=open(sys.argv[1],'r')                  # input mrs facts file
ans=open(sys.argv[2],'w+')                  #mrs output file

id_arg0={}
id_gnp={}
arg0_gnp={}
arg0_set=[] # to keep record of the arg0 values whose gnp values we have written

def _mrs_info(l):
    temp=l.split()
    mrs_labels=temp[1].split("-")[2:]
    mrs_values=temp[4:]
    ans.write(temp[3]+" ")

    for i in range(0,len(mrs_values)):
        ans.write(mrs_labels[i]+": "+mrs_values[i]+" ")
        if mrs_labels[i]=="ARG0": # arg0 field has been found
            arg0=mrs_values[i]
            if (arg0 not in arg0_set) and (arg0 in list(arg0_gnp.keys())):
                labels=arg0_gnp[arg0][0]
                values=arg0_gnp[arg0][1]
                arg0_set.append(arg0)
                ans.write("[ "+arg0[0]+" ")
                for i in range(0,len(labels)):
                    if values[i] !="-":
                        ans.write(labels[i]+":"+" "+values[i]+" ")
                ans.write("] ")
    ans.write("]")

def _about_index(l):
    temp=l.split() #{ ,arg0,sf,tense,mood,prog,perf}
    for i in range(5,7):
        if temp[i].find("yes")!=-1:
            temp[i]="+"
        if temp[i].find("no")!=-1:
            temp[i]="-"
    ans.write(" [ e SF: "+temp[2]+" TENSE: "+temp[3]+" MOOD: "+temp[4]+" PROG: "+temp[5]+" PERF: "+temp[6]+" ]\n")

def _hcons(l):
    temp=l.split()
    ans.write(temp[1]+" qeq "+temp[2]+" ")

def main():
    f=list(file)
    for i in range(0,len(f)):  # to remove the leading and lagging spaces
        f[i]=f[i].strip()
        f[i]=f[i].strip("()")
        if f[i].startswith('LTOP'):
           temp=f[i].split()
           ans.write("[ LTOP: "+temp[1]+"\n"+"INDEX: "+temp[2])

    # writing info about the index
    for i in range(0,len(f)):
        if f[i].startswith("id-SF"):
            _about_index(f[i])

    ans.write("RELS: < ")
    count=0 # for the first line of hcons
    linecount=0 # for the first line of mrs_concept_lbl_features

    for i in range(0,len(f)):
        if f[i].startswith("MRS_info") and 'CARG' in f[i]: #Looking for proper_noun and adding " (double quotes) to it.
            name = '"' + f[i].split()[-1] + '"'
            mrslst =  f[i].split()
            mylst = mrslst[:-1] 
            mylst.append(name)
            mrs = ' '.join(mylst)
            f[i] = mrs
        #   making dict id_arg0   {key =id  , value= arg0}
        if f[i].startswith("MRS_info") and f[i].find("ARG0")!=-1:
            t=f[i].split()
            id_arg0[t[2]]=t[5]

        #   making dict id_gnp  {key =id  , value= two lists [labels,values]. firstlist i.e- labels contains the labels of the gnp . second list
        #                              i.e.- values  conatins the values of these labels}
        if f[i].startswith("id-GEN-NUM-PER"):
            t=f[i].split()
            z=[] 
            labels=t[0].split("-")
            labels=labels[1:]
            for i in range(0,len(labels)):
                if labels[i]=="GEN":
                    labels[i]="GEND"
                if labels[i]=="PER":
                    labels[i]="PERS"
            values=t[2:]
            z.append(labels)
            z.append(values)
            id_gnp[t[1]]=z

    # forming dict arg0_gnp from id_arg0 and id_gnp   ::::
    # dict arg0_gnp has :: { key= arg0  and value= two lists [labels,values]. firstlist i.e- labels contains the labels of the gnp . second list
    #                              i.e.- values  conatins the values of these labels}
    for x in list(id_arg0.keys()):
        if x in list(id_gnp.keys()):
            if id_arg0[x].startswith('x'):
                arg0_gnp[id_arg0[x]]=id_gnp[x]

    #print "id \t arg0"
    #for x in id_arg0.keys():
    #    print x+"\t"+id_arg0[x]
    #print "arg0 \t gnp labels    \t gnp values"
    #for x in arg0_gnp.keys():
    #    print x,arg0_gnp[x][0], arg0_gnp[x][1]

    for i in range(0,len(f)):
        if f[i].startswith("MRS_info"):
            if linecount==0:
                ans.write("[ ")
            else:
                ans.write("\n[ ")
            _mrs_info(f[i])
            linecount=linecount+1

        if f[i].startswith("Restr-Restricted"):
            if count==0:
                ans.write(" >\nHCONS: < ")
            _hcons(f[i])
            count=count+1
    ans.write("> ]")

main()
