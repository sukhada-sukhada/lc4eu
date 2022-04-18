;generates output file "info_neg_rstr-rstd.dat" which has info of restrictor-restricted for negation.

(defglobal ?*rstr-rstd* = open-rstr)
(defglobal ?*rstr-rstd-dbg* = debug_rstr)

;changing the ARG0 value (i.e. e*) of neg to i300
(defrule neg-arg0-i
(sentence_type  imperative)
(rel_name-ids neg ?kri	?negId)
?f<-(MRS_info ?rel1 ?negId neg ?lbl ?arg0  ?ARG1)
(not (modified_ARG0_value_to_i ?negId))
=>
(retract ?f) 
(assert (modified_ARG0_value_to_i ?negId))
(bind ?i (str-cat "i" (sub-string 2 (str-length ?arg0) ?arg0)))  
(assert (MRS_info ?rel1 ?negId neg ?lbl ?i  ?ARG1))
(printout ?*rstr-rstd-dbg* "(rule-rel-values neg-arg0-i MRS_info "?rel1" "?negId" neg "?lbl" "?i" " ?ARG1")"crlf)
)



;Restrictor-Restricted between ARG1 value neg and LBL value of verb
;Ex. 236: "ayAn ne KAnA nahIM KAyA WA." = Ayan had not eaten food.
;    25: "ladake ne KAnA nahIM KAyA." = The boy did not eat food.	
(defrule neg-rstd
(rel_name-ids neg ?x	?negId)
?f<-(MRS_info ?rel1 ?negId neg ?lbl ?  ?ARG1)
(MRS_info ?rel3 ?m ?verbORprep ?V_lbl  ?V_A0  ?V_A1 $?vars)
(test (or (neq (str-index _v_ ?verbORprep) FALSE) (neq (str-index _p ?verbORprep) FALSE) ) )
=>
(retract ?f) 
(printout ?*rstr-rstd* "(Restr-Restricted     "?ARG1  "  " ?V_lbl ")"crlf)
(printout ?*rstr-rstd-dbg* "(rule-rel-values neg-rstd Restr-Restricted  "?ARG1"  "?V_lbl")"crlf)
)


; Ex. mEM so nahIM sakawA hUz.
; Ex. I can not sleep. I cannot sleep. I can't sleep.
(defrule neg-modal
?f<-(MRS_info ?rel1 ?id1 ?modal ?lbl ?ARG0  ?ARG1)
?f1<-(MRS_info ?rel2 ?id2 neg ?lbl2 ?ARG0_2 ?ARG1_2 $?vars)
?f2<-(MRS_info ?rel3 ?id3 ?v ?lbl3 ?ARG0_3 ?ARG1_3 $?var)
(test (neq (str-index _v_modal ?modal) FALSE))
(test (neq (str-index _v_ ?v) FALSE))
(test (neq ?id1 ?id3))
(test (neq ?id2 ?id3))
=>
(retract ?f ?f1) 
(printout ?*rstr-rstd* "(Restr-Restricted     "?ARG1 " " ?lbl3 ")" crlf)
(printout ?*rstr-rstd-dbg* "(rule-rel-values neg-modal  Restr-Restricted  "?ARG1" "?lbl3")"crlf)

(printout ?*rstr-rstd* "(Restr-Restricted     "?ARG1_2" "?lbl")"crlf)
(printout ?*rstr-rstd-dbg* "(rule-rel-values neg-modal  Restr-Restricted  "?ARG1_2" "?lbl")"crlf)
)

