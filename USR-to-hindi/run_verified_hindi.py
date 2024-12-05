import os
import subprocess
import sys

input_folder = sys.argv[1]  # Get the input_folder from command-line arguments
verified_out = "hindi_verified_out"
output_file = " "
first_line = " "
script = "generate_input_modularize_new.py"
hindi_output = "morph_input.txt-out.txt"
folder_input = os.listdir(input_folder)

folder_input.sort()
for filename in folder_input:
    with open(input_folder+"/"+filename, "r") as firstline:
        first_line = firstline.readline()
        # outf.write(fi)

        subprocess.run(["python3", script, input_folder+"/"+filename])

        with open(hindi_output, "r") as hout:
            hindiout = hout.read()
            # print(filename, hindiout)
            output_file = output_file + "\n" + filename + "\n" + first_line + hindiout + "\n"
            # print(output_file)

            with open(verified_out, "w") as outf:
                outf.write(output_file)
