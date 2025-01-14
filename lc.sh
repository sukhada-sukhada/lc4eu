var=`echo $lang_comm`


#to check language communicator path is set or not
if ! [[ "$var" =~ "lc4eu" ]]; then
	echo "Please set the path of language_communicator tool in bashrc."
	exit
fi

#Creating tmp dir
if ! [ -d $var/tmp_dir ] ; then
	echo $var"/tmp_dir  directory does not exist "
	echo "Creating  $var/tmp_dir"
	mkdir $var/tmp_dir
fi


ls $2 > f 
sed -i 's/.*\/\(.*\)/\1/g' f 
file_name=`cat f`
lang="$1"
echo $file_name
#Creating sentence dir
if ! [ -d $var/tmp_dir/$file_name ] ; then
	echo "$var/tmp_dir/$file_name  directory does not exist "
        echo "Creating  $var/tmp_dir/$file_name"
        mkdir $var/tmp_dir/$file_name
else
	rm -rf $var/tmp_dir/$file_name	
        echo "Creating  $var/tmp_dir/$file_name"
        mkdir $var/tmp_dir/$file_name
fi

rm -f f 

cd $var/tmp_dir/$file_name
cp $var/dictionaries/*.dat  .
echo $var > global_path.clp

python3 $var/src/USR_coref_GNP_mapping.py $var/$2  $var/tmp_dir/$file_name/USR_coref_mapped.dat $var/corefFile
python3 $var/src/USR-CLIPS_facts.py $var/tmp_dir/$file_name/USR_coref_mapped.dat $var/tmp_dir/$file_name/USR-CLIPS-facts.dat
python3 $var/src/gen_clips_from_multiling_dict.py $lang $var/$2 $var/tmp_dir/$file_name/compiled_dict.dat $var/tmp_dir/$file_name/tam_mapped.dat

echo "(defglobal ?*path* = $var)" > global_path.clp

clips -f  $var/src/clp_files/run_modules.bat > err

python3 $var/src/merge-bound-feature-n-remaining-facts.py mrs_info_binding_features_values.dat mrs_feature_info.dat implicit_mrs_concept-pron.dat
clips -f  $var/src/clp_files/run_modules2.bat >> err

sort -u mrs_info_with_rstr_rstd_values.dat -o mrs_info_with_rstr_rstd_values.dat
sed -n wfile.merge  GNP_values.dat  bound_MRS_tense.dat mrs_info_with_rstr_rstd_values.dat 

uniq file.merge > file.merge.uniq
#sort -u file.merge > file.merge.uniq
python3 $var/src/MRS_facts_gen_frn_clips.py file.merge.uniq $file_name"_mrs"
sed -i 's/_INDEX/-INDEX/g' $file_name"_mrs"
sed -i 's/_HNDL/-HNDL/g' $file_name"_mrs"

echo "Calling ACE parser for generating English sentence"
#$HOME/ace-0.9.24/ace -g $HOME/ace-0.9.24/erg-1214-x86-64-0.9.24.dat -e $file_name"_mrs" 
$HOME/ace-0.9.34/ace -g $HOME/ace-0.9.34/erg-1214-x86-64-0.9.34.dat -e $file_name"_mrs" >english_sentence.txt 

python3 $var/src/replace-unknown-word-in-Eng-sentence.py $var/tmp_dir/$file_name/unknown_mrs_concept_replaced.dat $var/tmp_dir/$file_name/english_sentence.txt
cat $var/tmp_dir/$file_name/final_english_sent.txt
