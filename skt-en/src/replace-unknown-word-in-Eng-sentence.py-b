#python code for replace orginal word to unknown word after the endlish sentence generated in the english_sentence output. 
#input_file = english_sentence.txt
#output_file= final_english_sent.txt 
#rAma kaserA nahIM hE. #mEMne AleKa paDI. for NN.*_u_unknown.
#mEMne avinaSvara kiwAba paDI for JJ.*_u_unknown.
#mEM kala sarAha. for VB.*_u_unknown.
#mEM akAraNa kAma kara huZ. for RB.*_u_unknown.
import sys
fr = open(sys.argv[1], 'r') # input file: unknown_mrs_concept_replaced.dat
myf = fr.readlines()
eng = open(sys.argv[2], 'r') # input file: english_sentence
mysent = eng.read()

fw = open('final_english_sent.txt', 'w')

if len(myf) > 0:
    for line in range(len(myf)):
        #if myf.read()
        myline = myf[line].split()
        origword = myline[1]
        if 'leviathan' in myline[2] and 'leviathan' in mysent:  #rAma kaserA nahIM hE. #mEMne AleKa paDI.
            mysent = mysent.replace('leviathan', origword)
            fw.write(mysent.strip())
            fw.write('\n')
        elif 'ostentatious' in myline[2] and 'ostentatious' in mysent: #mEMne avinaSvara kiwAba paDI
            mysent = mysent.replace('ostentatious', origword)
            fw.write(mysent.strip())
            fw.write('\n')
        elif 'winnow' in myline[2] and 'winnow' in mysent: #mEM kala sarAha.
            mysent = mysent.replace('winnow', origword)
            fw.write(mysent.strip())
            fw.write('\n')
        elif 'discordant' in myline[2] and 'discordant' in mysent: #mEM akAraNa kAma kara huZ.
            mysent = mysent.replace('discordant', origword)
            fw.write(mysent.strip())
            fw.write('\n')            
else:
    fw.write(mysent.strip())
    fw.write('\n')
    
fw.close()
