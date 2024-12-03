import sys

input_file_path = sys.argv[1] # input file in old format
output_file_path = sys.argv[2] # output file for new format 

with open(input_file_path, "r") as file:
    lines = file.readlines()

    for line in lines:
        if line.startswith('#'): 
            get_sem_cat_index = lines.index(line) + 3 # read sementic category row
            get_gnp_index = lines.index(line) + 4 # read GNP row

            sem_cat = lines[get_sem_cat_index].strip().split(',')
            gnp = lines[get_gnp_index].strip().split(',')

            for gnp_index, gnp_value in enumerate(gnp):
                if gnp_value == "":
                    gnp[gnp_index] = ''

            gnp_row = gnp

            for sem_index, sem_value in enumerate(sem_cat):
                if sem_value == "":
                    sem_cat[sem_index] = ''

            sem_row = sem_cat

            for val in range(len(gnp_row)):
                if "]" in gnp_row[val]:
                    gnp_two_value = gnp_row[val].split("]") # Split on the basis of "]" if GNP row has other info like "mawupa"
                    gnp_only = gnp_two_value[0]

                    if " " in gnp_only: # Condition for GNP info 
                        gnp_only = gnp_only.split()
                        num = gnp_only[1]
                        #print(gnp_only[0])
                        gnp_row[val] = num
                        if gnp_only[1] == '-':
                            gnp_row[val] = ""
                    else:
                        single_info = gnp_only.strip("[") # if info other than GNP
                        gnp_row[val] = single_info

                    if len(gnp_two_value) == 3:
                        other_info = gnp_two_value[1].strip(" [")
                        gnp_row[val] = num + " " + other_info

                    if gnp_only[0] == "[m":
                        sem_val = sem_row[val]
                        #print(sem_val)
                        sem_val = "male " + sem_val
                        sem_row[val] = sem_val
                    elif gnp_only[0] == "[f":
                        sem_val = sem_row[val]
                        sem_val = "female " + sem_val
                        sem_row[val] = sem_val

            lines[get_sem_cat_index] = ','.join(sem_row) + '\n'
            lines[get_gnp_index] = ','.join(gnp_row) + '\n'

with open(output_file_path, "w") as output_file: # Write the output in the output file
    output_file.writelines(lines)
