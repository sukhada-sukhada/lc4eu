(defglobal ?*mrsdef* = samasa-fp)
(defglobal ?*defdbug* = samasa-dbug-fp)

;Rules for generating implicit compound nodes 
;Ex. 307:   usane basa+addA xeKA.
;Ex. 311:   #usane rAma ke kAryAlaya kI AXAraSilA raKI.
(defrule samasa
(id-concept_label	?compid	?comp)
(id-hin_concept-MRS_concept ?compid ?comp ?comp_mrs)
(test (neq (str-index "+"  ?comp_mrs) FALSE)) ;no implicit compound nodes for 312: usane muJe KeloM meM pramANa pawra xiyA.
(test (eq (str-index "recip_pro"  ?comp_mrs) FALSE))
=>
(printout ?*mrsdef* "(MRS_info id-MRS_concept "(+ ?compid 2) " compound)"crlf)
(printout ?*defdbug* "(rule-rel-values samasa id-MRS_concept " (+ ?compid 2)" compound)"crlf)

(printout ?*mrsdef* "(MRS_info id-MRS_concept "(+ ?compid 1001) " udef_q)"crlf)
(printout ?*defdbug* "(rule-rel-values samasa id-MRS_concept "(+ ?compid 1001)" udef_q)"crlf)

(bind ?index (str-index "+" ?comp_mrs))
(bind ?purvapada (sub-string 0 (- ?index 1) ?comp_mrs))
(bind ?uttarapada (sub-string (+ ?index 1) (str-length  ?comp_mrs) ?comp_mrs))
(printout ?*mrsdef* "(MRS_info id-MRS_concept "(+ ?compid 1000)" "?purvapada")"crlf)
(printout ?*defdbug* "(rule-rel-values samasa id-MRS_concept "(+ ?compid 1000)" "?purvapada")"crlf)

(printout ?*mrsdef* "(MRS_info id-MRS_concept "?compid" "?uttarapada")"crlf)
(printout ?*defdbug* "(rule-rel-values samasa id-MRS_concept "?compid" "?uttarapada")"crlf)
)

;326: hama eka xUsare se pyAra karawe hEM. We love each other.
(defrule recip_pro
(id-concept_label    ?compid    ?comp)
(id-hin_concept-MRS_concept ?compid ?comp ?comp_mrs)
(test (neq (str-index "+"  ?comp_mrs) FALSE))
(test (neq (str-index "recip_pro"  ?comp_mrs) FALSE))
=>
(bind ?index (str-index "+" ?comp_mrs))
(bind ?purvapada (sub-string 0 (- ?index 1) ?comp_mrs))
(bind ?uttarapada (sub-string (+ ?index 1) (str-length  ?comp_mrs) ?comp_mrs))
(printout ?*mrsdef* "(MRS_info id-MRS_concept "(+ ?compid 1000)" "?purvapada")"crlf)
(printout ?*defdbug* "(rule-rel-values recip_pro id-MRS_concept "(+ ?compid 1000)" "?purvapada")"crlf)

(printout ?*mrsdef* "(MRS_info id-MRS_concept "?compid" "?uttarapada")"crlf)
(printout ?*defdbug* "(rule-rel-values recip_pro id-MRS_concept "?compid" "?uttarapada")"crlf)
)


