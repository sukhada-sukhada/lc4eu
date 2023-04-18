#!/bin/sh
##!/bin/sh
#i=1
#while [ $i -le 393 ]
#do
#    python3 generate_input_modularize_new.py verified_sent/$i > log.txt
#    i=$(($i+1))
#done

#Go to the directory and fetch file names
dir="../hindi_gen/verified_sent"
filenames=$(ls $dir)

# Iterate over the list of filenames and call another script for each one
for filename in $filenames; do
    # Call another script, passing the filename as an argument
    python3 generate_input_modularize_new.py $dir/$filename
done