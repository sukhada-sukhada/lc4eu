# the name of a USR folder which contains the verified USR files is given as 1st argumentand. 
# This program runs all the USR files and stores the output in "verified_USR-Hindi_NLG.txt".
# To run: python3 run_verified_USR-Hindi_NLG.py verified_USRs_with_correct_Hindi_NLG

import os, sys, subprocess


input_folder = sys.argv[1]
verified_out = "verified_USR-Hindi_NLG.txt"
output_file = " "
first_line = " "
script = "USR-to-hindi/generate_input_modularize_new.py"
hindi_output = "morph_input.txt-out.txt"
folder_input = os.listdir(input_folder)

folder_input.sort()
for filename in folder_input:
    with open(input_folder+"/"+filename, "r") as firstline:
        first_line = firstline.readline()
        #outf.write(fi)

        subprocess.run(["python3", script, input_folder+"/"+filename])
        
        with open(hindi_output,"r") as hout:
            hindiout = hout.read()
            #print(filename, hindiout)
            output_file = output_file + "\n" + filename + "\n" + first_line + hindiout + "\n"
            #print(output_file)

            with open(verified_out, "w") as outf:
                outf.write(output_file)

