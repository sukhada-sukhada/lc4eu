clips -f gen-hin_concept-to-mrs_concept-1.clp
clips -f gen-mrs_info-def.clp
clips -f gen-prp-info.clp
clips -f gen-mrs-info-pron.clp
clips -f gen-initial-mrs_info-1.clp
clips -f bind-RSTR_values_2.clp
clips -f gen-neg_info.clp
clips -f bind-RSTR_RSTD-values1.clp
sort -u mrs_info_with_rstr_rstd_values.dat -o mrs_info_with_rstr_rstd_values.dat
grep "(MRS_info  id-MRS_concept-LBL" mrs_info_with_rstr_values-1.dat > temp.txt
cut -d " " -f 1-5 temp.txt > temp2.txt
sh final_step.sh
sed -n wfile.merge mrs_info_with_rstr_values-1.dat id-concept_label-mrs_concept.dat mrs_info_with_rstr_rstd_values.dat_tmp mrs_info_neg.dat
