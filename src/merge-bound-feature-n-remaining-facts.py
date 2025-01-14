# Writen by Sukhada. 24/04/2019
# This program chackes the facts that are in mrs_info_binding_features_values.dat
# which are processed based on feature value binding info and mrs_feature_info.dat 
# which are just the raw facts. If for a word a processed fact exists in 
# mrs_info_binding_features_values.dat, we remove the unprocessed fact from 
# mrs_feature_info.dat and write the remaining facts and all the facts from
# mrs_info_binding_features_values.dat in 'updated_mrs_feature_info.dat'
# To run:
# python3 merge-bound-feature-n-remaining-facts.py mrs_info_binding_features_values.dat mrs_feature_info.dat 

import sys, copy
f1 = open(sys.argv[1], 'r') # mrs_info_binding_features_values.dat
fr1 = f1.readlines()
fr1.sort()

f2 = open(sys.argv[2], 'r') # mrs_feature_info.dat  
fr2 = f2.readlines()
fr2copy = copy.deepcopy(fr2) # deep copy,a copy of object is copied in other object. It means that any changes made to a copy of object do not reflect in the original object. 

fw = open('updated_mrs_feature_info.dat', 'w') # Creating new file for writing processed facts from mrs_info_binding_features_values.dat and the remaining facts from  mrs_feature_info.dat

for i in range(len(fr1)):
    orig = fr1[i].split()
    if fr1[i].strip().startswith('(MRS_info'): # checking for the unprocessed/original mrs facts
        for j in range(len(fr2)):
            modifd = fr2[j].split()
            if orig[0:4] == modifd[0:4]:  # comparing and removing unprocessed/original mrs facts 
                try:
                    fr2copy.remove(fr2[j]) 
                    fw.write(fr1[i])
                except:
                    pass
                    #print('The fact was already deleted', fr1[j])
                    #print('The fact was already deleted', fr2[i])
    else:
        fw.write(fr1[i])

for i in fr2copy:
    fw.write(i)



