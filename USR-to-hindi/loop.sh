#!/bin/sh
#i=1
#while [ $i -le 15 ]
#do
  #python3 generate_input_modularize_new.py 6stnd_4ch/$i > log.txt
  #  i=$(($i+1))
#done
for FILE in 6stnd_4ch
do 
    #python3 generate_input_modularize_new.py 6stnd_4ch/$FILE > log.txt
  echo $FILE
done