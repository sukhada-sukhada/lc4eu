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

ls $1 > f 
sed -i 's/.*\/\(.*\)/\1/g' f 
file_name=`cat f`
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

python3 $var/src/user_csv_to_CLIPS_facts.py $var/$1 $var/tmp_dir/$file_name/hin-clips-facts.dat
echo "(defglobal ?*path* = $var)" > global_path.clp

clips -f  $var/src/clp_files/run_modules.bat > err

python3 $var/src/merge-bound-feature-n-remaining-facts.py mrs_info_binding_features_values.dat mrs_feature_info.dat
clips -f  $var/src/clp_files/run_modules2.bat >> err

sort -u mrs_info_with_rstr_rstd_values.dat -o mrs_info_with_rstr_rstd_values.dat
sed -n wfile.merge  hin_concept-to-mrs_concept.dat GNP_values.dat mrs_info_with_rstr_rstd_values.dat  mrs_info_neg_rstr-rstd.dat
sed -n wdebug.merge mrs_info_binding_features_values_debug.dat hin_concept-to-mrs_concept_debug.dat implicit_mrs_concept_debug.dat implicit_mrs_concept-prep_debug.dat implicit_mrs_concept-pron_debug.dat mrs_feature_info_debug.dat mrs_info_with_rstr_rstd_values_debug.dat mrs_info_neg_rstr-rstd_debug.dat
python3 $var/src/MRS_facts_gen_frn_clips.py file.merge $file_name"_mrs"

#$HOME/ace-0.9.31/ace -g $HOME/ace-0.9.31/erg-2018-x86-64-0.9.31.dat -e $file_name"_mrs" 
echo "Calling ACE parser for generating English sentence"
#$HOME/ace-0.9.24/ace -g $HOME/ace-0.9.24/erg-1214-x86-64-0.9.24.dat -e $file_name"_mrs" 
$HOME/ace-0.9.34/ace -g $HOME/ace-0.9.34/erg-1214-x86-64-0.9.34.dat -e $file_name"_mrs"
 
