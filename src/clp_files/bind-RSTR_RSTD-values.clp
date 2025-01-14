;generates output file "mrs_info_with_rstr_rstd_values.dat" and contains information of all the restrictor restricted and MRS relation features values
(defglobal ?*rstr-rstd* = open-rstr)
(defglobal ?*rstr-rstd-dbg* = debug_rstr)

;This rule deletes a fact that belongs to a set id but the fact should not have the max ID and its MRS concept value should not end with "_q". For example, out of the following 3 facts for the phrase 'a new book' in the sentence: "The boy is reading a new book." "f-2' would be deleted.
  ;f-1    (initial_MRS_info id-MRS_concept-LBL-ARG0-RSTR-BODY 21000 _a_q h8 x9 h10 h11)
  ;f-2    (initial_MRS_info id-MRS_concept-LBL-ARG0-ARG1 22000 _new_a_1 h16 x17 x18)
  ;f-3    (initial_MRS_info id-MRS_concept-LBL-ARG0-ARG1 23000 _book_n_of h5 x6 x7)
;Deleting the facts prevents from generating unwanted "Restr-Restricted * *" relations by the "initial-mrs-info" rule.
(defrule rm-mrs-info
(declare (salience 10000))
?f1<-(MRS_info ?rel1 ?id1 ?noendsq  ?lbl1 ?arg  $?arg1)
?f2<-(MRS_info ?rel2 ?id2 ?noendsq1 ?lbl2 ?arg0 $?arg11)
(test (eq (sub-string 1 1 (implode$ (create$ ?id1))) (sub-string 1 1 (implode$ (create$ ?id2)))))
(test (neq (sub-string (- (str-length ?noendsq1)    1) (str-length ?noendsq1) ?noendsq1) "_q"))
(test (neq (sub-string (- (str-length ?noendsq)    1) (str-length ?noendsq) ?noendsq) "_q"))
(test (< ?id2 ?id1))
(test (eq (str-index _v_modal ?noendsq) FALSE))
(test (neq (str-index poss ?noendsq1) FALSE))
(test (neq (str-index _and_c ?noendsq1) FALSE)) ;For printing _and_c predicate. ;Ms. Rajini admitted her son and her daughter in the Kashi's largest school in Banaras. 
=>
(retract ?f1)
(printout ?*rstr-rstd-dbg* "(rule-rel-values  rm-mrs-info  "?rel1 " " ?id1 " " ?noendsq " " ?lbl1 " " ?arg " " (implode$ (create$ $?arg1)) ")"crlf)
)

;Restr-Trstricted fact for mrs concepts like _each_q, _which_q etc
(defrule rstr-rstd4non-implicit
(rel-ids ord|card|dem|quant ?head ?dep)
(MRS_info ?rel2 ?head ?mrsCon ?lbl2 ?ARG_0 $?v)
?f<-(MRS_info ?rel1 ?dep ?endsWith_q ?lbl1 ?x ?rstr $?vars)
(test (neq ?endsWith_q ?mrsCon))
(test (neq ?endsWith_q def_implicit_q))
(test (neq ?endsWith_q def_explicit_q))
(test (or
   (eq (sub-string (- (str-length ?endsWith_q) 1) (str-length ?endsWith_q) ?endsWith_q) "_q")
   (eq (sub-string (- (str-length ?endsWith_q) 3) (str-length ?endsWith_q) ?endsWith_q) "_dem") ) )
(test (neq (sub-string (- (str-length ?mrsCon) 1) (str-length ?mrsCon) ?mrsCon) "_p"))
(not (Restr-Restricted-fact-generated_for_comp ?dep))
(test (eq (str-index _v_ ?mrsCon) FALSE))
;(not (loc_nonsp_bind_notrequired ?dep)) ;Rama arrived that hour.
=>
(retract ?f)
(printout ?*rstr-rstd* "(Restr-Restricted     "?rstr  "  " ?lbl2 ")"crlf)
(printout ?*rstr-rstd-dbg* "(rule-rel-values rstr-rstd4non-implicit  Restr-Restricted  "?rstr"  "?lbl2 ")"crlf)

;(printout ?*rstr-rstd*   "(MRS_info  "?rel1 " " ?dep " " ?endsWith_q " " ?lbl1 " " ?ARG_0 " " ?rstr " " (implode$ (create$ $?vars)) ")"crlf)
;(printout ?*rstr-rstd-dbg* "(rule-rel-values rstr-rstd4non-implicit "?rel1 " " ?dep " " ?endsWith_q " " ?lbl1 " "?ARG_0 " " ?rstr " " (implode$ (create$ $?vars)) ")"crlf)
)

;Restr-Trstricted fact for implicit mrs concepts like _a_q, pronoun_q
;	then Generate (Restr-Restricted RSTR_of_*_q LBL_the_other_fact)
;	     Replace ARG0 value of *_q with ARG0 value of the other fact 	
;INPUT sentence: He will help a blind man.
;INPUT facts:
;(MRS_info id-MRS_concept-LBL-ARG0-RSTR-BODY 20010 _a_q h7 x8 h9 h10)
;OUTPUT: 
;(MRS_info id-MRS_concept-LBL-ARG0-RSTR-BODY 20010 _a_q h7 x12 h9 h10)
(defrule mrs-info_q
;(declare (salience 1000))
(MRS_info ?rel2 ?head ?mrsCon ?lbl2 ?ARG_0 $?v)
?f<-(MRS_info ?rel1 ?dep ?endsWith_q ?lbl1 ?x ?rstr $?vars)
(test (neq ?endsWith_q ?mrsCon))
(test (> ?dep ?head))
(test (eq  (+ ?head 10) ?dep)) 
(test (eq (sub-string 1 1 (implode$ (create$ ?head))) (sub-string 1 1 (implode$ (create$ ?dep)))))
(test (or (eq (str-index "_q" ?endsWith_q)FALSE) (eq (str-index "_qdem" ?endsWith_q)FALSE))) ;The boy is good. That book is beautiful.
(test (neq (sub-string (- (str-length ?mrsCon) 1) (str-length ?mrsCon) ?mrsCon) "_q"))
(test (neq (sub-string (- (str-length ?mrsCon) 1) (str-length ?mrsCon) ?mrsCon) "_p"))
(test (neq (sub-string (- (str-length ?mrsCon) 6) (str-length ?mrsCon) ?mrsCon) "_p_temp"))
(not (Restr-Restricted-fact-generated_for_comp ?dep))
;(test (eq (str-index _and_c ?mrsCon) FALSE))
;(test (eq (str-index implicit_conj ?mrsCon) FALSE))
(test (eq (str-index _or_c ?mrsCon) FALSE))
(test (eq (str-index _a_ ?mrsCon) FALSE))
(test (eq (str-index _v_ ?mrsCon) FALSE)) ;Imperatives
;(not (which_bind_notrequired ?dep)) ;kOna sA kuwwA BOMkA?
;(not (which_bind_notrequired2 ?dep)) ;Where did Rama come from?
;(not (udefq_bind_not_required ?lbl2)) ; Ms. Rajini admitted her son and her daughter in the Kashi's largest school in Banaras.
=>
(retract ?f)
(printout ?*rstr-rstd* "(Restr-Restricted     "?rstr  "  " ?lbl2 ")"crlf)
(printout ?*rstr-rstd-dbg* "(rule-rel-values mrs-info_q  Restr-Restricted  "?rstr"  "?lbl2 ")"crlf)
)


;Restrictor for ARG1 value of neg and LBL value of predicative adjective
;Ex. rAvaNa acCA nahIM hE.  Ravana is not good.
(defrule neg-pred_adj
(rel-ids	k1s	?kri	?adj)
(or (rel-ids	neg	?kri	?neg) (id-dis_part	?neg	hI_1)) ; They were not only obedient.
(MRS_info ?rel   ?neg neg ?lbl ?a0 ?a1)
(MRS_info ?rel1  ?adj ?mrs_adj ?l ?arg1 $?v)
(test (neq (str-index _a_ ?mrs_adj) FALSE))
=>
(printout ?*rstr-rstd* "(Restr-Restricted "?a1 " "?l")" crlf)
(printout ?*rstr-rstd-dbg* "(rule-rel-values  neg-pred_adj  Restr-Restricted "?a1" "?l")"crlf)
)

;;Restrictor for LTOP Restrictor-Restricted default value
(defrule LTOP-rstd
(MRS_info ?rel	?id ?mrsCon ?lbl $?vars)
(rel-ids	main	0	?id)
(test (neq (str-index _v_ ?mrsCon) FALSE))
(test (eq (str-index _v_qmodal ?mrsCon) FALSE)) ;Rama has to go home.
(not (MRS_info ?rel ?id ?mrsCon ?lbl2 $?vaa)) ;I cannot speak Rusi.
(not (Restr-Restricted-fact-generated))
(not (MRS_info ?rel1 ?id1 neg ?lbl1 $?v))
(not (id-morph_sem ?id causative))
(not (id-morph_sem	?id	doublecausative))
(not (rel-ids	rpk	?id	?kri_id))
;(not (rel-ids	krvn	?id	?kri_id))
(not (rel-ids	rsk	?id	?kri_id))
(not (rel-ids	rpk	?kri_id	?id))
(not (rel-ids	rblsk ?id 	?kri_id)) ;gAyoM ke xuhane se pahale rAma Gara gayA.
(not (rel-ids	rblak ?id 	?kri_id))
(not (rel-ids	rblpk ?id 	?kri_id)) ;rAma ke vana jAne para xaSaraWa mara gaye.
;(not (MRS_info ?rel2 ?id2  _make_v_cause ?lbl2 $?va))
(not(rel-ids vAkya_vn ?id_1 ?id_2))
(not (ltop_bind_notrequired ?kri_id))
(not (rel-ids samuccaya ?kri_id	?id))
(not (rel-ids anyawra ?kri_id	?id))
(not (rel-ids viroXi ?kri_id	?id))
(not (rel-ids AvaSyakwA-pariNAma ?kri_id	?id))
(not (rel-ids samAnakAla ?kri_id	?id))
(not (rel-ids kAryakAraNa ?kri_id	?id)) ;Because he has to go home.
=>
        (printout ?*rstr-rstd* "(Restr-Restricted  h0  "?lbl ")" crlf) 
        (printout ?*rstr-rstd-dbg* "(rule-rel-values LTOP-rstd  Restr-Restricted  h0 "?lbl ")"crlf)
)

;Restrictor for LTOP Restrictor-Restricted default value causative
(defrule LTOP-rstdc
(id-morph_sem	?id	causative)
(MRS_info ?rel1  ?id  ?mrsV ?lbl1 $?var)
?f<-(MRS_info  id-MRS_concept-LBL-ARG0-ARG1-ARG2 ?id _make_v_cause ?lbl ?arg0 ?a1 ?a2)
(test (eq (str-index _v_cause ?mrsV) FALSE))
=>
(retract ?f)
 (printout ?*rstr-rstd* "(Restr-Restricted  h0 "?lbl ")" crlf)
 (printout ?*rstr-rstd-dbg* "(rule-rel-values LTOP-rstdc Restr-Restricted  h0 "?lbl ")"crlf)

 (printout ?*rstr-rstd* "(Restr-Restricted  "?a2 " "?lbl1 ")" crlf)
 (printout ?*rstr-rstd-dbg* "(rule-rel-values LTOP-rstdc Restr-Restricted  "?a2 " "?lbl1 ")"crlf)
)

;Restrictor for LTOP Restrictor-Restricted default value double causative
(defrule LTOP-rstdd
(id-morph_sem	?id	doublecausative)
(MRS_info  id-MRS_concept-LBL-ARG0-ARG1-ARG2-ARG3 ?id1 _ask_v_1 ?lbl ?arg0 $?vars)
=>
 (printout ?*rstr-rstd* "(Restr-Restricted  h0 "?lbl ")" crlf)
 (printout ?*rstr-rstd-dbg* "(rule-rel-values LTOP-rstdc Restr-Restricted  h0 "?lbl ")"crlf)
)

;Restrictor for  double-causative
(defrule LTOP-rstdda
(id-morph_sem	?id	doublecausative)
(MRS_info  id-MRS_concept-LBL-ARG0-ARG1-ARG2-ARG3 ?id _ask_v_1 ?lbl1 ?arg10 ?arg20 ?arg30 ?arg40)
(MRS_info ?rel1  ?id  ?mrsV ?lbl ?arg0 ?arg1 ?arg2 $?var)
(MRS_info  id-MRS_concept-LBL-ARG0-ARG1-ARG2 ?id _make_v_cause ?lbl2 ?arg02 ?arg12 ?arg22)
(test (eq (str-index _v_cause ?mrsV) FALSE))
(test (eq (str-index _ask_v_1 ?mrsV) FALSE))
=>
 (printout ?*rstr-rstd* "(Restr-Restricted  "?arg40 " "?lbl2 ")" crlf)
 (printout ?*rstr-rstd-dbg* "(rule-rel-values LTOP-rstdda Restr-Restricted  "?arg40 " "?lbl2 ")"crlf)
 (printout ?*rstr-rstd* "(Restr-Restricted  "?arg22 " "?lbl ")" crlf)
 (printout ?*rstr-rstd-dbg* "(rule-rel-values LTOP-rstdda_ddd Restr-Restricted  "?arg12 " "?lbl ")"crlf)
)

;Restrictor for LTOP Restrictor-Restricted default value subord
(defrule LTOP-subord
(rel-ids	rpk|rblsk	?id1	?id2)
(MRS_info id-MRS_concept-LBL-ARG0-ARG1-ARG2 ?subord subord|_as_x_subord ?lbl ?arg0 ?arg1 ?arg2)
(MRS_info ?rel1	?id1 ?mrsCon1 ?lbl1 $?var)
(MRS_info ?rel2	?id2 ?mrsCon2 ?lbl2 $?vars)
=>
 (printout ?*rstr-rstd* "(Restr-Restricted  h0  "?lbl ")" crlf)
 (printout ?*rstr-rstd-dbg* "(rule-rel-values LTOP-subord Restr-Restricted  h0 "?lbl ")"crlf)

(printout ?*rstr-rstd* "(Restr-Restricted  "?arg2 " "?lbl2 ")" crlf)
 (printout ?*rstr-rstd-dbg* "(rule-rel-values LTOP-subord Restr-Restricted  "?arg2 " "?lbl2 ")"crlf)

 (printout ?*rstr-rstd* "(Restr-Restricted  "?arg1 " "?lbl1 ")" crlf)
 (printout ?*rstr-rstd-dbg* "(rule-rel-values LTOP-subord Restr-Restricted  "?arg1 " "?lbl1 ")"crlf)
)

;It creates binding for vmod_krvn with subord abstract typed feature
;verified sentence 338 #वह लंगडाकर चलता है.
;Restrictor for LTOP Restrictor-Restricted default value subord
(defrule LTOP-subord-kv
(rel-ids	krvn	?id1	?id2)
(MRS_info id-MRS_concept-LBL-ARG0-ARG1-ARG2 ?subord subord ?lbl ?arg0 ?arg1 ?arg2)
(MRS_info id-MRS_concept-LBL-ARG0-ARG1	?id1 ?mrsCon1 ?lbl1 $?var)
(MRS_info ?rel2	?id2 ?mrsCon2 ?lbl2 $?vars)
=>
 (printout ?*rstr-rstd* "(Restr-Restricted  h0  "?lbl ")" crlf)
 (printout ?*rstr-rstd-dbg* "(rule-rel-values LTOP-subord-kv Restr-Restricted  h0 "?lbl ")"crlf)

(printout ?*rstr-rstd* "(Restr-Restricted  "?arg2 " "?lbl2 ")" crlf)
 (printout ?*rstr-rstd-dbg* "(rule-rel-values LTOP-subord-kv Restr-Restricted  "?arg2 " "?lbl2 ")"crlf)

 (printout ?*rstr-rstd* "(Restr-Restricted  "?arg1 " "?lbl1 ")" crlf)
 (printout ?*rstr-rstd-dbg* "(rule-rel-values LTOP-subord-kv Restr-Restricted  "?arg1 " "?lbl1 ")"crlf)
)


;It creates binding for vmod_krvn with _while_x
; verified sentence 340#भागते हुए शेर को देखो
(defrule LTOP-while-kr
(rel-ids	vmod_krvn	?id1	?id2)
(MRS_info id-MRS_concept-LBL-ARG0-ARG1-ARG2 ?while _while_x ?lbl ?arg0 ?arg1 ?arg2)
(MRS_info id-MRS_concept-LBL-ARG0-ARG1-ARG2 ?id1 ?mrsCon1 ?lbl1 $?var)
(MRS_info ?rel2	?id2 ?mrsCon2 ?lbl2 $?vars)
=>
 (printout ?*rstr-rstd* "(Restr-Restricted  h0  "?lbl ")" crlf)
 (printout ?*rstr-rstd-dbg* "(rule-rel-values LTOP-while Restr-Restricted  h0 "?lbl ")"crlf)

(printout ?*rstr-rstd* "(Restr-Restricted  "?arg2 " "?lbl2 ")" crlf)
 (printout ?*rstr-rstd-dbg* "(rule-rel-values LTOP-while Restr-Restricted  "?arg2 " "?lbl2 ")"crlf)

 (printout ?*rstr-rstd* "(Restr-Restricted  "?arg1 " "?lbl1 ")" crlf)
 (printout ?*rstr-rstd-dbg* "(rule-rel-values LTOP-while Restr-Restricted  "?arg1 " "?lbl1 ")"crlf)
)

;(MRS_info id-MRS_concept-LBL-ARG0-ARG1 20100 _should_v_modal h7 e8 h9)
;(MRS_info id-MRS_concept-LBL-ARG0-ARG1 20000 _sleep_v_1 h10 e11 x2)
;;Restrictor for LTOP Restrictor-Restricted default value
(defrule LTOP-modal-verb
(declare (salience 100))
(not (sent_type	%negative))
;(not (sent_type	%interrogative))
(MRS_info ?rel  ?id ?mrsModal  ?lbl ?arg0 ?arg1 $?vars)
(MRS_info ?rel1  ?id ?mrsV ?lbl1 ?arg01 ?arg11 $?var)
(test (or (neq (str-index _v_modal ?mrsModal) FALSE) (neq (str-index _v_qmodal ?mrsModal) FALSE))) ;_used+to_v_qmodal
(test (eq (str-index _v_qmodal ?mrsV) FALSE))
(test (neq ?lbl ?lbl1)) ;Rama must eat a fruit.
;(not (rel-ids kAryakAraNa ?previouid ?id))
=>
    ;(assert (Restr-Restricted-fact-generated))
    ;(printout ?*rstr-rstd* "(Restr-Restricted h0 " ?lbl ")" crlf)
    ;(printout ?*rstr-rstd-dbg* "(rule-rel-values LTOP-modal-verb  Restr-Restricted h0 "?lbl ")"crlf)

    (printout ?*rstr-rstd* "(Restr-Restricted " ?arg1 " "?lbl1 ")" crlf)
    (printout ?*rstr-rstd-dbg* "(rule-rel-values LTOP-modal-verb  Restr-Restricted " ?arg1 " "?lbl1 ")"crlf)
)

(defrule LTOP-modal-verb_LTOP
(declare (salience 100))
(not (sent_type	%negative))
;(not (sent_type	%interrogative))
(MRS_info ?rel  ?id ?mrsModal  ?lbl ?arg0 ?arg1 $?vars)
(MRS_info ?rel1  ?id ?mrsV ?lbl1 ?arg01 ?arg11 $?var)
(test (or (neq (str-index _v_modal ?mrsModal) FALSE) (neq (str-index _v_qmodal ?mrsModal) FALSE))) ;_used+to_v_qmodal
(test (eq (str-index _v_qmodal ?mrsV) FALSE))
(test (neq ?lbl ?lbl1)) ;Rama must eat a fruit.
(not (rel-ids kAryakAraNa ?previouid ?id))
=>
    (assert (Restr-Restricted-fact-generated))
    (printout ?*rstr-rstd* "(Restr-Restricted h0 " ?lbl ")" crlf)
    (printout ?*rstr-rstd-dbg* "(rule-rel-values LTOP-modal-verb_LTOP  Restr-Restricted h0 "?lbl ")"crlf)

    ;(printout ?*rstr-rstd* "(Restr-Restricted " ?arg1 " "?lbl1 ")" crlf)
    ;(printout ?*rstr-rstd-dbg* "(rule-rel-values LTOP-modal-verb  Restr-Restricted " ?arg1 " "?lbl1 ")"crlf)
)

(defrule LTOP-neg-modal
(declare (salience 100))
(sent_type	%negative)
(MRS_info ?rel  ?id ?mrsModal  ?lbl ?arg0 ?arg1 $?vars)
(MRS_info ?rel1  ?id1 ?mrsV ?lbl1 ?arg01 ?arg11 $?var)
(test (or (neq (str-index _v_modal ?mrsModal) FALSE) (neq (str-index _v_qmodal ?mrsModal) FALSE))) ;_used+to_v_qmodal
(test (neq (str-index _v_ ?mrsV) FALSE))
(test (neq ?id ?id1))
(not (Restr-Restricted-fact-generated))
=>
    (assert (Restr-Restricted-fact-generated))
    (printout ?*rstr-rstd* "(Restr-Restricted h0 " ?lbl ")" crlf)
    (printout ?*rstr-rstd-dbg* "(rule-rel-values LTOP-neg-modal  Restr-Restricted h0 "?lbl ")"crlf)

    (printout ?*rstr-rstd* "(Restr-Restricted " ?arg1 " "?lbl1 ")" crlf)
    (printout ?*rstr-rstd* "(rule-rel-values LTOP-neg-modal  Restr-Restricted " ?arg1 " "?lbl1 ")" crlf)

)

;changing the ARG0 value (i.e. e*) of neg to i300
(defrule neg-arg0-i
(sent_type  %imperative)
(rel-ids neg ?kri  ?negId)
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
(rel-ids neg ?x    ?negId)
?f<-(MRS_info ?rel1 ?negId neg ?lbl ?  ?ARG1)
?f1<-(MRS_info ?rel3 ?m ?verbORprep ?V_lbl  ?V_A0  ?V_A1 $?vars)
(test (or (neq (str-index _v_ ?verbORprep) FALSE) (neq (str-index _p ?verbORprep) FALSE) ) )
(not (rel-ids samuccaya ?id	?x))
(not (rel-ids anyawra ?id	?x))
(not (rel-ids viroXi ?id	?x))
=>
(retract ?f1)
(printout ?*rstr-rstd* "(Restr-Restricted     "?ARG1  "  " ?V_lbl ")"crlf)
(printout ?*rstr-rstd-dbg* "(rule-rel-values neg-rstd Restr-Restricted  "?ARG1"  "?V_lbl")"crlf)
)

;Restrictor-Restricted between ARG1 value neg and LBL value of verb
;Ex. 236: "ayAn ne KAnA nahIM KAyA WA." = Ayan had not eaten food.
;    25: "ladake ne KAnA nahIM KAyA." = The boy did not eat food.       
(defrule neg-rstd_LTOP
(rel-ids neg ?x    ?negId)
?f<-(MRS_info ?rel1 ?negId neg ?lbl ?  ?ARG1)
?f1<-(MRS_info ?rel3 ?m ?verbORprep ?V_lbl  ?V_A0  ?V_A1 $?vars)
(test (or (neq (str-index _v_ ?verbORprep) FALSE) (neq (str-index _p ?verbORprep) FALSE) ) )
(not (rel-ids samuccaya ?id	?x))
(not (rel-ids anyawra ?id	?x))
(not (rel-ids viroXi ?id	?x))
(not (and (id-dis_part	?id	hI_1)(rel-ids	k1	?x	?id)))
=>
(retract ?f1)
(printout ?*rstr-rstd* "(Restr-Restricted  h0 " ?lbl")"crlf)
(printout ?*rstr-rstd-dbg* "(rule-rel-values neg-rstd_LTOP Restr-Restricted  h0 "?lbl")"crlf)
)

; Ex. mEM so nahIM sakawA hUz.
; Ex. I can not sleep. I cannot sleep. I can't sleep.
(defrule neg-modal
(declare (salience 1000))
?f<-(MRS_info ?rel1 ?id ?modal ?lbl ?ARG0  ?ARG1)
?f1<-(MRS_info ?rel2 ?id2 neg ?lbl2 ?ARG0_2 ?ARG1_2 $?vars)
(MRS_info ?rel3 ?id ?v ?lbl3 ?ARG0_3 ?ARG1_3 $?var)
(test (neq (str-index _v_modal ?modal) FALSE))
(test (eq (str-index _v_modal ?v) FALSE)) ;I cannot speak Rusi.
=>
(retract ?f ?f1)
(printout ?*rstr-rstd* "(Restr-Restricted   h0 " ?lbl2 ")" crlf)
(printout ?*rstr-rstd-dbg* "(rule-rel-values neg-modal  Restr-Restricted  h0 "?lbl2")"crlf)

(printout ?*rstr-rstd* "(Restr-Restricted     "?ARG1_2" "?lbl")"crlf)
(printout ?*rstr-rstd-dbg* "(rule-rel-values neg-modal  Restr-Restricted  "?ARG1_2" "?lbl")"crlf)

(printout ?*rstr-rstd* "(Restr-Restricted     "?ARG1" "?lbl3")"crlf)
(printout ?*rstr-rstd-dbg* "(rule-rel-values neg-modal  Restr-Restricted  "?ARG1" "?lbl3")"crlf)
)

;Rule to generate Rester-Restricted values for the verb want when it takes a verb as k2
;Ex. Rama wants to sleep.
(defrule want-k2-rstr
(rel-ids k2   ?kri ?k2)
(MRS_info ?rel ?kri _want_v_1 $?vars ?arg2)
?f1<-(MRS_info ?r ?k2  ?k2v ?l  $?v)
(test (neq (str-index _v_ ?k2v) FALSE))
=>
(retract ?f1)
    (printout ?*rstr-rstd* "(Restr-Restricted " ?arg2 " "?l")" crlf)
    (printout ?*rstr-rstd-dbg* "(rule-rel-values want-k2-rstr  Restr-Restricted " ?arg2 " "?l")"crlf)
)

;Rule for RSTR binding with h0 with lbl of _before_x_h and arg1 and arg2 of before_x_h with the two verb labels. 
;gAyoM ke xuhane se pahale rAma Gara gayA.
(defrule rule_for_x
(rel-ids	rblak|rblpk|rsk	?id1	?id2)
(MRS_info id-MRS_concept-LBL-ARG0-ARG1-ARG2 ?iddd ?MRSCON ?lbl ?arg0 ?arg1 ?arg2)
(MRS_info ?rel1	?id1 ?mrsCon1 ?lbl1 $?var)
(MRS_info ?rel2	?id2 ?mrsCon2 ?lbl2 $?vars)
(test (neq (str-index _x ?MRSCON) FALSE))
(test (eq (str-index pron ?mrsCon1) FALSE))
;(test (or (eq ?MRSCON  _before_x_h)(eq ?MRSCON _when_x_subord) (eq ?MRSCON _while_x)))
=>
 (printout ?*rstr-rstd* "(Restr-Restricted  h0  "?lbl ")" crlf)
 (printout ?*rstr-rstd-dbg* "(rule-rel-values rule_for_x Restr-Restricted  h0 "?lbl ")"crlf)

(printout ?*rstr-rstd* "(Restr-Restricted  "?arg2 " "?lbl2 ")" crlf)
 (printout ?*rstr-rstd-dbg* "(rule-rel-values rule_for_x Restr-Restricted  "?arg2 " "?lbl2 ")"crlf)

 (printout ?*rstr-rstd* "(Restr-Restricted  "?arg1 " "?lbl1 ")" crlf)
 (printout ?*rstr-rstd-dbg* "(rule-rel-values rule_for_x Restr-Restricted  "?arg1 " "?lbl1 ")"crlf)
)

;Rule for not binding h0 with the lbl of the krvn verb. 
(defrule rule_for_x_required
(declare (salience 10000))
(rel-ids kAryakAraNa ?previousid	?id2)
(MRS_info id-MRS_concept-LBL-ARG0-ARG1-ARG2 ?iddd ?MRSCON ?lbl ?arg0 ?arg1 ?arg2)
;(MRS_info ?rel1	?id1 ?mrsCon1 ?lbl1 $?var)
(MRS_info ?rel2	?id2 ?mrsCon2 ?lbl2 $?vars)
(test (neq (str-index _qmodal ?mrsCon2) FALSE))
(test (neq (str-index _x ?MRSCON) FALSE))
=>
(assert (x_modal_notrequired ?id2))
(printout ?*rstr-rstd-dbg* "(rule-rel-values  rule_for_x_required x_modal_notrequired " ?id2 ")"crlf)
)


;Rule for generating qeq binding of ARG1 and ARG2 values of because with LBL of unknown abstract predicate and LBL of the predicate of the sentence. 
;Because, he has to go home. #kyoMki vo Gara jAnA hE.
(defrule kAryakAraNa
(rel-ids kAryakAraNa ?previousid	?verb)
?f<-(MRS_info id-MRS_concept-LBL-ARG0-ARG1-ARG2 ?because _because_x ?lbl ?arg0 ?arg1 ?arg2)
(MRS_info id-MRS_concept-LBL-ARG0-ARG ?unknown unknown ?lbll $?v)
(MRS_info id-MRS_concept-LBL-ARG0-ARG1 ?verb ?mrsverb ?lbbb $?va)
(test (neq (str-index _v_qmodal ?mrsverb) FALSE))
=>
(printout ?*rstr-rstd* "(Restr-Restricted h0 " ?lbl")" crlf)
(printout ?*rstr-rstd-dbg* "(rule-rel-values kAryakAraNa Restr-Restricted h0 "?lbl")"crlf)
(printout ?*rstr-rstd* "(Restr-Restricted "?arg1" " ?lbll")" crlf)
(printout ?*rstr-rstd-dbg* "(rule-rel-values kAryakAraNa Restr-Restricted "?arg1" " ?lbll")"crlf)
(printout ?*rstr-rstd* "(Restr-Restricted "?arg2" " ?lbbb")" crlf)
(printout ?*rstr-rstd-dbg* "(rule-rel-values kAryakAraNa Restr-Restricted "?arg2" " ?lbbb")"crlf)
)

;Rule for binding h0 with label of adjective when there is no verb.
;This rule not fires when predicates are in the construction order. 
;#Rama buxXimAna, motA, xilera, Ora accA hE.
(defrule adjective
(rel-ids	k1s	?id ?adj)
(MRS_info ?rel1  ?adj ?mrs_adj ?l ?arg0 $?v)
(test (neq (str-index _a_ ?mrs_adj) FALSE))
(MRS_info ?rel ?idd ?hin ?lbl ?a0 $?v1)
(not (rel-ids neg	?iddd	?neg))
(test (eq (str-index _v_ ?hin) FALSE))
(not (construction-ids	conj 	$? ?adj $?))
(MRS_info ?rel2 ?impl implicit_conj $?var)
;(test (eq  (+ ?adj 600) ?impl))
=>
(printout ?*rstr-rstd* "(Restr-Restricted h0 "?l")" crlf)
(printout ?*rstr-rstd-dbg* "(rule-rel-values  adjective  Restr-Restricted h0 "?l")"crlf)
)

;Rule for binding h0 with the lbl of the karwa in construction. When there is no verb in the construction and having only two subjective construction.
;#rAma Ora sIwA acCe hEM.
(defrule adjective-conjj
(rel-ids	k1s	?id ?adj)
(MRS_info ?rel1  ?adj ?mrs_adj ?l ?arg0 $?v)
(test (neq (str-index _a_ ?mrs_adj) FALSE))
(MRS_info ?rel ?idd ?hin ?lbl ?a0 $?v1)
(not (rel-ids neg	?iddd	?neg))
(test (eq (str-index _v_ ?hin) FALSE))
(MRS_info ?rel3  ?k1 ?mrsconk1 $?vs)
(construction-ids	conj 	?k1 ?x)
(test (eq  (+ ?k1 10000) ?x))
=>
(printout ?*rstr-rstd* "(Restr-Restricted h0 "?l")" crlf)
(printout ?*rstr-rstd-dbg* "(rule-rel-values  adjective-conjj  Restr-Restricted h0 "?l")"crlf)
)

;Rule for binding lbl of first implicit_conj with the h0 when the construction is having predicates. 
;#Rama buxXimAna, motA, xilera, Ora accA hE.
(defrule implicit-adjective
(rel-ids	k1s	?kri ?adj)
(MRS_info ?rel1  ?adj ?mrs_adj ?l ?arg0 $?v)
(construction-ids	conj	?adj $?var)
(MRS_info ?rel ?id1 implicit_conj ?lbl1 ?arg01 $?vars)
(test (neq (str-index _a_ ?mrs_adj) FALSE))
(test (eq  (+ ?adj 200) ?id1))
=>
(printout ?*rstr-rstd* "(Restr-Restricted h0 "?lbl1")" crlf)
(printout ?*rstr-rstd-dbg* "(rule-rel-values  implicit-adjective  Restr-Restricted h0 "?lbl1")"crlf)
)

;Rule for binding lbl of the unknown with h0 when the sent_type is unknown.
;#kuwwA!
;#billI Ora kuwwA.
(defrule unknown_rstr
(sent_type	)
(MRS_info id-MRS_concept-LBL-ARG0-ARG 0 unknown ?lbl ?arg0 ?arg1)
=>
(printout ?*rstr-rstd* "(Restr-Restricted h0 "?lbl")" crlf)
(printout ?*rstr-rstd-dbg* "(rule-rel-values unknown_rstr Restr-Restricted h0 "?lbl")"crlf)
)

;Rule for binding prpstn_to_prop lbl with ltop ho. 
;How are you?
(defrule how-rstrr
(id-cl	?how	$kim)
(rel-ids	k1s	?kri	?how) 
(sent_type  %interrogative)
(MRS_info id-MRS_concept-LBL-ARG0-ARG1-ARG2 ?ptp prpstn_to_prop ?lptp ?a0ptp ?a1ptp ?a2ptp)
(not (id-morph_sem	?how	?n))
(not (id-anim	?how	yes))
=>
(printout ?*rstr-rstd* "(Restr-Restricted h0 "?lptp")" crlf)
(printout ?*rstr-rstd-dbg* "(rule-rel-values how-rstrr Restr-Restricted h0 "?lptp")"crlf)
)

;Rule for not binding h0 with the lbl of the krvn verb. 
(defrule krvn-notbind
(declare (salience 10000))
(rel-ids	krvn	?kri	?kri_id)
(id-hin_concept-MRS_concept ?kri_id ?hin1 ?mrsCon)
(test (neq (str-index _v_ ?mrsCon) FALSE))
=>
(assert (ltop_bind_notrequired ?kri_id))
(printout ?*rstr-rstd-dbg* "(rule-rel-values  krvn-notbind ltop_bind_notrequired " ?kri_id ")"crlf)
)


;Rule for binding rstr of udef_q with _or_c lbl.
;I like tea or coffee. 
(defrule disjunct-rstr
(declare (salience 10))
(MRS_info id-MRS_concept-LBL-ARG0-L_INDEX-R_INDEX ?id _or_c ?lbl ?arg0 ?first ?second)
?f<-(MRS_info id-MRS_concept-LBL-ARG0-RSTR-BODY ?idd udef_q ?l ?a ?rstr ?body)
(test (eq (+ ?id 10) ?idd))
=>
(retract ?f)
(printout ?*rstr-rstd* "(Restr-Restricted  "?rstr"  "?lbl ")" crlf)
(printout ?*rstr-rstd-dbg* "(rule-rel-values disjunct-rstr Restr-Restricted  "?rstr" "?lbl ")"crlf)
)

;Rule for binding ltop h0 with _or_c lbl when disjuct entries are in predicate position.
;Is Rama good or bad?
(defrule disjunct-rstr-ltop
(construction-ids	disjunct	$?vv ?adj $?vvv)
(MRS_info id-MRS_concept-LBL-ARG0-L_INDEX-R_INDEX-L_HNDL-R_HNDL ?id _or_c ?lbl ?arg0 ?li ?ri ?lhl ?rhl)
(id-hin_concept-MRS_concept ?adj ?hin ?mrscon)
(test (neq (str-index _a_ ?mrscon) FALSE))
=>
(printout ?*rstr-rstd* "(Restr-Restricted  h0  "?lbl ")" crlf)
(printout ?*rstr-rstd-dbg* "(rule-rel-values disjunct-rstr-ltop Restr-Restricted  h0 "?lbl ")"crlf)
)

;Rule for binding LTOP h0 with lbl of _near_p
;The car is near the house.
(defrule near-ltop
(rel-ids	rdl	?near	?k7p)
(MRS_info id-MRS_concept-LBL-ARG0-ARG1-ARG2 ?near _near_p ?l ?a0 ?a1 ?a2)
=>
(printout ?*rstr-rstd* "(Restr-Restricted  h0  "?l ")" crlf)
(printout ?*rstr-rstd-dbg* "(rule-rel-values near-ltop Restr-Restricted  h0 "?l ")"crlf)
)

;Rule for creating binding with LTOP and the label of definite and ARG1 label of definite with word it BI_2.
;#rAma ayegA hI ; The sun also shines.
(defrule emph-definite-verb
?f<-(MRS_info id-MRS_concept-LBL-ARG0-ARG1 ?id ?MRSCON ?lbl ?arg0 ?arg1)
(or (id-dis_part  ?id2  hI_2) (id-dis_part  ?id1  BI_1) (id-dis_part  ?id2  hI_6) (id-dis_part  ?id3  wo_1) (rel-ids	vkvn	?id2	?id))
?f1<-(MRS_info ?rel2 ?id2 ?mrscon ?lbl1 ?arg01 ?arg11 $?v)
(test (neq (str-index _v_ ?mrscon) FALSE))
(test (or (eq ?MRSCON  _definite_a_1)(eq ?MRSCON _also_a_1)  (eq ?MRSCON _only_a_1) (eq ?MRSCON _probable_a_1) (eq ?MRSCON _certain_a_1)))
=>
(retract  ?f ?f1)
(printout ?*rstr-rstd* "(Restr-Restricted h0 " ?lbl")" crlf)
(printout ?*rstr-rstd-dbg* "(rule-rel-values emph-definite-verb Restr-Restricted h0 "?lbl")"crlf)
(printout ?*rstr-rstd* "(Restr-Restricted " ?arg1 " "?lbl1")" crlf)
(printout ?*rstr-rstd-dbg* "(rule-rel-values emph-definite-verb  Restr-Restricted " ?arg1 " "?lbl1")"crlf)
)

;Rule for creating binding with LTOP and the label of definite and ARG1 label of definite with word it hI_6.
;Hari only did not send Riya, Mohana and Sanju his fruits.
(defrule hI_6-definite-noun
?f<-(MRS_info id-MRS_concept-LBL-ARG0-ARG1 ?id ?MRSCON ?lbl ?arg0 ?arg1)
(id-dis_part	?iddd	hI_6)
(and (rel-ids	neg	?kri	?id2)(rel-ids	k1	?kri	?iddd))
?f1<-(MRS_info ?rel2 ?id2 neg ?lbl1 ?arg01 ?arg11 $?v)
(test (or (eq ?MRSCON  _definite_a_1)(eq ?MRSCON _also_a_1)  (eq ?MRSCON _only_a_1) (eq ?MRSCON _probable_a_1) (eq ?MRSCON _certain_a_1)))
=>
(retract  ?f ?f1)
(printout ?*rstr-rstd* "(Restr-Restricted h0 " ?lbl")" crlf)
(printout ?*rstr-rstd-dbg* "(rule-rel-values hI_6-definite-noun Restr-Restricted h0 "?lbl")"crlf)
(printout ?*rstr-rstd* "(Restr-Restricted " ?arg1 " "?lbl1")" crlf)
(printout ?*rstr-rstd-dbg* "(rule-rel-values hI_6-definite-noun  Restr-Restricted " ?arg1 " "?lbl1")"crlf)
)

;Rule for binding ARG3 handle value of ditransitive verb with preposition label. 
;Abramsa put Brauna in the garden.
(defrule verb-preposition
(rel-ids	k7p	?id	?preposition)
?f<-(MRS_info id-MRS_concept-LBL-ARG0-ARG1-ARG2-ARG3 ?id ?verb ?lbl ?arg0 ?arg1 ?arg2 ?arg3)
(MRS_info ?rel2 ?id2 ?mrscon ?lbl1 $?v)
(test (neq (str-index _p ?mrscon) FALSE))
(test (eq (+ ?preposition 1) ?id2)) 
=>
;(retract  ?f ?f1)
(printout ?*rstr-rstd* "(Restr-Restricted "?arg3" " ?lbl1")" crlf)
(printout ?*rstr-rstd-dbg* "(rule-rel-values verb-preposition Restr-Restricted "?arg3" "?lbl1")"crlf)
)

;Generalized rule for creating binding LTOP with the lbl of _and_c, _or_c, _but_c 's and R_HNDL value with the lbl of the verb.
;And he went. Ora vaha gayA. ;Or he went. , But he went.
(defrule samuccaya-LTOP-verb
(or (rel-ids samuccaya ?previousid	?verb) (rel-ids anyawra ?previousid	?verb) (rel-ids viroXi ?previousid	?verb))
?f<-(MRS_info id-MRS_concept-LBL-ARG0-L_INDEX-R_INDEX-L_HNDL-R_HNDL ?and ?MRSCON ?lbl ?arg0 ?lindeh1x ?rindex ?lhndl ?rhndl)
(MRS_info ?rel ?verb ?mrsss ?lblb ?arg00 $?v)
(test (or (eq ?MRSCON  _and_c)(eq ?MRSCON _or_c)(eq ?MRSCON _but_c)))
(not (rel-ids neg ?verb	?neg))
=>
(printout ?*rstr-rstd* "(Restr-Restricted h0 " ?lbl")" crlf)
(printout ?*rstr-rstd-dbg* "(rule-rel-values samuccaya-LTOP-verb Restr-Restricted h0 "?lbl")"crlf)
(printout ?*rstr-rstd* "(Restr-Restricted "?rhndl" " ?lblb")" crlf)
(printout ?*rstr-rstd-dbg* "(rule-rel-values samuccaya-LTOP-verb Restr-Restricted "?rhndl" "?lblb")"crlf)
)

;Generalized rule for creating binding LTOP with the lbl of _and_c, _or_c, _but_c 's  and R_HNDL value with the lbl of the predicative adjective.
;And he is intelligent. #Ora vaha buxXimAna hE. Or he is intelligent. but he is intelligent.
(defrule samuccaya-LTOP-copula
(id-cl	?verb	hE_1)
(or (rel-ids samuccaya ?previousid	?verb) (rel-ids anyawra ?previousid	?verb) (rel-ids viroXi ?previousid	?verb))
(rel-ids	k1s	?verb	?adj)
?f<-(MRS_info id-MRS_concept-LBL-ARG0-L_INDEX-R_INDEX-L_HNDL-R_HNDL ?and ?MRSCON ?lbl ?arg0 ?lindeh1x ?rindex ?lhndl ?rhndl)
(MRS_info ?rel ?adj ?mrsss ?lblb ?arg00 $?v)
(test (or (eq ?MRSCON  _and_c)(eq ?MRSCON _or_c)(eq ?MRSCON _but_c)))
=>
(printout ?*rstr-rstd* "(Restr-Restricted h0 " ?lbl")" crlf)
(printout ?*rstr-rstd-dbg* "(rule-rel-values samuccaya-LTOP-copula Restr-Restricted h0 "?lbl")"crlf)
(printout ?*rstr-rstd* "(Restr-Restricted "?rhndl" " ?lblb")" crlf)
(printout ?*rstr-rstd-dbg* "(rule-rel-values samuccaya-LTOP-copula Restr-Restricted "?rhndl" "?lblb")"crlf)
)

;Generalized rule for Creating qeq binding with h0 with lbl of the _and_c, _or_c, _but_c 's and R_HNDL of _and_c with the lbl of neg and ARG1 value of neg with the verb of the sentence.
;And he didn't finish the work., or and but. 
(defrule samuccaya-LTOP-verb-neg
(or (rel-ids samuccaya ?previousid	?verb) (rel-ids anyawra ?previousid	?verb) (rel-ids viroXi ?previousid	?verb))
(rel-ids neg ?verb	?neg)
?f<-(MRS_info id-MRS_concept-LBL-ARG0-L_INDEX-R_INDEX-L_HNDL-R_HNDL ?and ?MRSCON ?lbl ?arg0 ?lindeh1x ?rindex ?lhndl ?rhndl)
(MRS_info id-MRS_concept-LBL-ARG0-ARG1 ?neg neg ?lbb ?a ?h)
(MRS_info ?rel ?verb ?mrsss ?lblb ?arg00 $?v)
(test (or (eq ?MRSCON  _and_c)(eq ?MRSCON _or_c)(eq ?MRSCON _but_c)))
=>
(printout ?*rstr-rstd* "(Restr-Restricted h0 " ?lbl")" crlf)
(printout ?*rstr-rstd-dbg* "(rule-rel-values samuccaya-LTOP-verb-neg Restr-Restricted h0 "?lbl")"crlf)
(printout ?*rstr-rstd* "(Restr-Restricted "?rhndl" " ?lbb")" crlf)
(printout ?*rstr-rstd-dbg* "(rule-rel-values samuccaya-LTOP-verb-neg Restr-Restricted "?rhndl" "?lbb")"crlf)
(printout ?*rstr-rstd* "(Restr-Restricted "?h" " ?lblb")" crlf)
(printout ?*rstr-rstd-dbg* "(rule-rel-values samuccaya-LTOP-verb-neg Restr-Restricted "?h" "?lblb")"crlf)
)

;Rule for creating binding LTOP h0 value with lbl of the _then_a_1 and arg1 value of _then_a_1 with lbl of the verb.
;;#wo meM jAUMgA. Then I will go.
(defrule AvaSyakwA-pariNAma_samAnakAla-LTOP-verb
(rel-ids AvaSyakwA-pariNAma|samAnakAla ?previousid	?verb)
?f<-(MRS_info id-MRS_concept-LBL-ARG0-ARG1 ?then _then_a_1 ?lbl ?arg0 ?arg11)
(MRS_info ?rel ?verb ?mrsss ?lblb ?arg00 $?v)
=>
(printout ?*rstr-rstd* "(Restr-Restricted h0 " ?lbl")" crlf)
(printout ?*rstr-rstd-dbg* "(rule-rel-values AvaSyakwA-pariNAma_samAnakAla-LTOP-verb Restr-Restricted h0 "?lbl")"crlf)
(printout ?*rstr-rstd* "(Restr-Restricted "?arg11" " ?lblb")" crlf)
(printout ?*rstr-rstd-dbg* "(rule-rel-values AvaSyakwA-pariNAma_samAnakAla-LTOP-verb Restr-Restricted "?arg11" "?lblb")"crlf)
)

;Restrictor for LTOP Restrictor-Restricted default value quantitative pronoun
(defrule LTOP-rstdeic-quantitative
(id-cl	?id	kuCa_1)
(rel-ids	quant	?verb	?id)
(MRS_info id-MRS_concept-LBL-ARG0 ?id2 generic_entity ?lbl1 ?ARG01)
(MRS_info ?rel1 ?id _some_q ?lbl ?ARG0 ?rstr ?body)
=>
(printout ?*rstr-rstd* "(Restr-Restricted  "?rstr " "?lbl1 ")" crlf)
(printout ?*rstr-rstd-dbg* "(rule-rel-values LTOP-rstdeic-quantitative Restr-Restricted  "?rstr " "?lbl1 ")"crlf)
)

;Rule for generating the qeq binding with def_implicit_q rstr with numbered hour lbl. 
;Rama arrived at midday.
(defrule 12_carg_number-rstr
(or (id-cl	?numid	xopahara_2)(id-clocktime	?numid	yes))
(rel-ids	k7t	?kri	?numid)
(MRS_info id-MRS_concept-LBL-ARG0-ARG1-ARG2-CARG ?numid numbered_hour ?lbl ?arg0 ?arg1 ?arg2 ?carg)
(MRS_info id-MRS_concept-LBL-ARG0-RSTR-BODY ?def def_implicit_q ?lbll ?arg00 ?rstr ?body)
=>
(printout ?*rstr-rstd* "(Restr-Restricted  "?rstr " "?lbl ")" crlf)
(printout ?*rstr-rstd-dbg* "(rule-rel-values 12_carg_number-rstr Restr-Restricted   "?rstr " "?lbl ")"crlf)
)

;Rule to create binding with ARG1 of also with the lbl of the predicative adjective. 
(defrule BI_1-also-predadj
(id-cl	?id1	hE_1)
(rel-ids	k1s	?id1	?id2)
?f<-(MRS_info id-MRS_concept-LBL-ARG0-ARG1 ?id _also_a_1 ?lbl ?arg0 ?arg1)
(id-dis_part  ?id1  BI_1)
?f1<-(MRS_info ?rel2 ?id2 ?mrscon ?lbl1 ?arg01 ?arg11 $?v)
(test (neq (str-index _a_ ?mrscon) FALSE))
=>
(retract  ?f ?f1)
;(printout ?*rstr-rstd* "(Restr-Restricted h0 " ?lbl")" crlf)
;(printout ?*rstr-rstd-dbg* "(rule-rel-values BI_1-predadj Restr-Restricted h0 "?lbl")"crlf)
(printout ?*rstr-rstd* "(Restr-Restricted " ?arg1 " "?lbl1")" crlf)
(printout ?*rstr-rstd-dbg* "(rule-rel-values BI_1-also-predadj  Restr-Restricted " ?arg1 " "?lbl1")"crlf)
)

;rule to create binding with demonstratives rstr with the generic_entity lbl when the relations are vyABIcAra and pariNAma. 
;Because of that his parents used to be very upset.
(defrule vyABIcAra_generic_this
(rel-ids vyABIcAra|pariNAma ?previousid	?id)
?f2<-(MRS_info id-MRS_concept-LBL-ARG0 ?gen generic_entity ?lllll ?Arg0000)
(MRS_info id-MRS_concept-LBL-ARG0-RSTR-BODY ?iddd ?qdem ?lbl ?arg0 ?rstr ?body)
(test (neq (str-index "_q_dem" ?qdem) FALSE))
(test (eq  (+ ?iddd 9) ?gen))
=>
(printout ?*rstr-rstd* "(Restr-Restricted " ?rstr " "?lllll")" crlf)
(printout ?*rstr-rstd-dbg* "(rule-rel-values vyABIcAra_generic_this  Restr-Restricted " ?rstr " "?lllll")"crlf)
)

;Restrictor for ARG2 value of the verb with the rt LBL. 
;This attempted to spread knowledge.
(defrule ARG2_LBL_rt
(id-cl	?rt	?hincon1)
(id-cl	?kriya	?hincon2)
(rel-ids	rt	?kriya	?rt)
(MRS_info ?rel ?rt ?verb1 ?lbl $?v)
(MRS_info id-MRS_concept-LBL-ARG0-ARG1-ARG2 ?kriya ?verb2 ?lbbb ?ar00 ?ar11 ?Ar22)
(test (neq (str-index "_v_" ?verb1) FALSE))
(test (neq (str-index "_v_" ?verb2) FALSE))
=>
(printout ?*rstr-rstd* "(Restr-Restricted  "?Ar22 " "?lbl ")" crlf)
(printout ?*rstr-rstd-dbg* "(rule-rel-values ARG2_LBL_rt Restr-Restricted  "?Ar22 " "?lbl ")"crlf)
)



