(defglobal ?*mrsdef* = samasa-fp)
(defglobal ?*defdbug* = samasa-dbug-fp)


(defrule samasa
(id-cl	 ?compounid	 ?nc_concept)
(cxnlbl-id-values ?nc_concept ?compounid $?var)
(cxnlbl-id-val_ids ?nc_concept ?compounid $?vv)
(test (neq (str-index "nc_"  ?nc_concept) FALSE)) 
=>
(printout ?*mrsdef* "(MRS_info id-MRS_concept "(+ ?compounid 100)" compound)"crlf)
(printout ?*defdbug* "(rule-rel-values samasa id-MRS_concept "(+ ?compounid 100)" compound)"crlf)
)

(defrule transfer_samasa
(id-hin_concept-MRS_concept ?compid ?hinconcept ?comp_mrs)
(test (neq (str-index "+"  ?comp_mrs) FALSE)) 
=>
(bind ?index (str-index "+" ?comp_mrs))
(bind ?purvapada (sub-string 0 (- ?index 1) ?comp_mrs))
(bind ?uttarapada (sub-string (+ ?index 1) (str-length  ?comp_mrs) ?comp_mrs))
(printout ?*mrsdef* "(MRS_info id-MRS_concept "(+ ?compid 1000)" "?purvapada")"crlf)
(printout ?*defdbug* "(rule-rel-values transfer_samasa id-MRS_concept "(+ ?compid 1000)" "?purvapada")"crlf)

(printout ?*mrsdef* "(MRS_info id-MRS_concept "?compid" "?uttarapada")"crlf)
(printout ?*defdbug* "(rule-rel-values transfer_samasa id-MRS_concept "?compid" "?uttarapada")"crlf)

(printout ?*mrsdef* "(MRS_info id-MRS_concept "(+ ?compid 100)" compound)"crlf)
(printout ?*defdbug* "(rule-rel-values transfer_samasa id-MRS_concept "(+ ?compid 100)" compound)"crlf)
)

