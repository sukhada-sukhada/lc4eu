MYPATH=`pwd`
cat $1 
#bash $HOME/ace-0.9.24/generate_multiple_mrs_nd_dmrs.sh $1
$HOME/ace-0.9.31/ace -g $HOME/ace-0.9.31/erg-2018-x86-64-0.9.31.dat -Tf $1 > output/$1_mul_mrs.txt
python3 mrs_facts_gen.py output/$1_mul_mrs.txt clip.txt
cp clip.txt mrs_facts.dat
clips -f eng_jap_rules.clp >/dev/null
python3 fetch_japanese.py jap_mrs.dat jap_facts.txt $lang_comm/dictionaries/concept_dictionary_user.txt japanese_dict
python3 clip_to_mrs_copy.py jap_facts.txt mrs_generated
bash mod_mrs_sent.sh mrs_generated > $MYPATH/Japnese_run/$1_out
cat $MYPATH/Japnese_run/$1_out
