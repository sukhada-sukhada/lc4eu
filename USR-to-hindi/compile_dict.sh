#sh get_canonical_dic.sh  apertium_hn.dix
#lt-comp lr apertium_hn_in_canonical_form.dix hi.morf.bin
#lt-comp rl apertium_hn_in_canonical_form.dix hi.gen.bin
#lt-expand  apertium_hn_in_canonical_form.dix hi_expanded

#sh get_canonical_dic.sh  apertium_hn.dix
#lt-comp lr apertium_hn.dix hi.morf.bin
#lt-comp rl apertium_hn.dix hi.gen.bin
#lt-expand  apertium_hn.dix hi_expanded

lt-comp lr apertium_hn_LC.dix hi.morfLC.bin
lt-comp rl apertium_hn_LC.dix hi.gen_LC.bin
lt-expand  apertium_hn_LC.dix hi_expanded_LC

