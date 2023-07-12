import os

input_folder = "/home/riya/lc4eu/hindi_gen/isma"
sentence_file = "input.txt"
single_concept_inp = "concept.txt"
single_concept_out = "concept.txt-out.txt"
output_file = "output.txt"

input_file_path = os.path.join(input_folder, sentence_file) #for input file
output_file_path = os.path.join(input_folder, output_file)  #for output file


with open(output_file_path, "w") as out:
    out.write("")

if os.path.isfile(input_file_path):
    with open(input_file_path, "r") as inp:
        sentence = inp.read().strip()
        words = sentence.split()
        #print(words)

        for word in words:  #read the word one by one
            with open(single_concept_inp, "w") as sc:
                sc.write(word)

            os.system("sh run_morph-analyser.sh " + single_concept_inp)

            with open(single_concept_out, "r") as con_out:
                output = con_out.read().strip()

            with open(output_file_path, "a") as out:  
                out.write(output + "\n")

            # Clear the content of the intermediate files("concept.txt" and "concept.txt-out.txt")
            with open(single_concept_inp,"w") as sc:
                sc.write("")

            with open(single_concept_out,"w") as con_out:
                con_out.write("")