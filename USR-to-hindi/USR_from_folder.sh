
FOLDER_PATH="6stnd_4ch/*"
for f in $FOLDER_PATH; 
    do 
        python3 generate_input_modularize_new.py $f > log.txt; 
    done
    