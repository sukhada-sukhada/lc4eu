(defglobal ?*mrsdef* = samasa-fp)
(defglobal ?*defdbug* = samasa-dbug-fp)


;Rules for generating implicit compound nodes 
;Ex. 307:   usane basa+addA xeKA.
;Ex. 311:   #usane rAma ke kAryAlaya kI AXAraSilA raKI.
(defrule samasa
(id-concept_label	?compid	?comp)
(rel_name-ids	rt	?id1 ?id2)
(id-hin_concept-MRS_concept ?compid ?comp ?comp_mrs)
(test (neq (str-index "+"  ?comp_mrs) FALSE)) ;no implicit compound nodes for 312: usane muJe KeloM meM pramANa pawra xiyA.
(not (id-per ?compid yes))
=>
(printout ?*mrsdef* "(MRS_info id-MRS_concept "(+ ?compid 20)" compound)"crlf)
(printout ?*defdbug* "(rule-rel-values samasa id-MRS_concept " (+ ?compid 20)" compound)"crlf)

(printout ?*mrsdef* "(MRS_info id-MRS_concept "(+ ?compid 1010) " udef_q)"crlf)
(printout ?*defdbug* "(rule-rel-values samasa id-MRS_concept "(+ ?compid 1010)" udef_q)"crlf)

(bind ?index (str-index "+" ?comp_mrs))
(bind ?purvapada (sub-string 0 (- ?index 1) ?comp_mrs))
(bind ?uttarapada (sub-string (+ ?index 1) (str-length  ?comp_mrs) ?comp_mrs))
(printout ?*mrsdef* "(MRS_info id-MRS_concept "(+ ?compid 1000)" "?purvapada")"crlf)
(printout ?*defdbug* "(rule-rel-values samasa id-MRS_concept "(+ ?compid 1000)" "?purvapada")"crlf)

(printout ?*mrsdef* "(MRS_info id-MRS_concept "?compid" "?uttarapada")"crlf)
(printout ?*defdbug* "(rule-rel-values samasa id-MRS_concept "?compid" "?uttarapada")"crlf)
)



