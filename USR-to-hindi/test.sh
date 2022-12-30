#!/bin/sh
i=1
while [ $i -le 52 ]
do
    python3 generate_input_modularize_new.py 6stnd_4ch/$i > log.txt
    i=$(($i+1))
done
