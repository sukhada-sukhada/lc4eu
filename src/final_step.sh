#!/bin/bash
filename='temp2.txt'
file1='mrs_info_with_rstr_rstd_values.dat'
file2='mrs_info_with_rstr_rstd_values.dat_tmp'
cat>$file2<$file1
while read line; do
# reading each line
grep -v "$line" $file2>tempx
cat>$file2<tempx
done < $filename
#diff file23 temp
