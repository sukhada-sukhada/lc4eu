;generates output file "mrs_info_with_rstr_values.dat" which contains LTOP , kriyA-TAM and id-MRS-Rel_features


(defglobal ?*rstr-fp* = open-file)
(defglobal ?*rstr-dbug* = debug_fp)

;Compound AP share it's ARG1 value with the head's ARG0 and ARG2 with dependent's ARG0.
;Ex. 307:   usane basa+addA xeKA.
;Ex. 311:   #usane rAma ke kAryAlaya kI AXAraSilA raKI.
(defrule comp
(declare (salience 100))
(cxnlbl-id-values ?nc ?comp mod head $?VAA)
(cxnlbl-id-val_ids ?nc ?comp ?dep ?head $?vaaa)
(MRS_info ?rel1 ?dep ?d ?dl ?da0 $?V)
(MRS_info ?REL2 ?head ?h ?hl ?ha0 $?Var)
?f<-(MRS_info id-MRS_concept-LBL-ARG0-ARG1-ARG2 ?compidd compound ?cl ?ca0 ?ca1 ?ca2)
(test (neq (str-index "nc_"  ?nc) FALSE)) 
=>
(retract ?f)
(printout ?*rstr-fp* "(MRS_info id-MRS_concept-LBL-ARG0-ARG1-ARG2 "?compidd" compound "?hl" "?ca0" "?ha0" "?da0")" crlf)
(printout ?*rstr-dbug* "(rule-rel-values comp id-MRS_concept-LBL-ARG0-ARG1-ARG2 "?compidd" compound "?hl" "?ca0" "?ha0" "?da0"))"crlf)
)


;Rule for the respect word "ji" in Hindi.
;This rule creates binding with the person for whom we are giving respect with word "ji".
; 26 verified sentence #manwrIjI ne kala manxira kA uxGAtana kiyA.
(defrule respect-honorable
(id-speakers_view	?id	respect)
(MRS_info ?rel1 ?id ?mrscon ?lbl1 ?arg0 $?v)
?f<-(MRS_info id-MRS_concept-LBL-ARG0-ARG1 ?id1 _honorable_a_1 ?lbl ?argo2 ?arg01)
(test (eq (+ ?id 20) ?id1)) 
=>
(retract ?f)
(printout ?*rstr-fp* "(MRS_info id-MRS_concept-LBL-ARG0-ARG1 "?id1" _honorable_a_1 "?lbl1" "?argo2" "?arg0")" crlf)
(printout ?*rstr-dbug* "(rule-rel-values respect-honorable id-MRS_concept-LBL-ARG0-ARG1 "?id1" _honorable_a_1 "?lbl1" "?argo2" "?arg0")"crlf)
)
;Rule for krvn, freq. krvn shares its LBL value with the verb, ARG1 value with the ARG0 value of verb.
;I walk slowly. He comes here daily.
(defrule krvn
;(declare (salience 1000))
(rel-ids krvn|freq ?kri ?kri_vi)
(MRS_info ?rel1 ?kri ?mrsconkri ?lbl1 ?arg0  ?arg1 $?var)
?f<-(MRS_info  ?rel2 ?kri_vi ?mrsconkrivi ?lbl2 ?arg0_2 ?arg1_2 $?vars)
(not (modified_krvn ?kri_vi))
(test (eq (str-index _v_ ?mrsconkrivi) FALSE))
=>
(assert (modified_krvn ?kri_vi))
(printout ?*rstr-fp* "(MRS_info  "?rel2 " " ?kri_vi " " ?mrsconkrivi " " ?lbl1 " " ?arg0_2 " " ?arg0 " "(implode$ (create$ $?vars)) ")"crlf)
(printout ?*rstr-dbug* "(rule-rel-values krvn  "?rel2 " " ?kri_vi " " ?mrsconkrivi " " ?lbl1 " " ?arg0_2" "?arg0" "(implode$ (create$ $?vars)) ")"crlf)
)
;Rule for adjective and noun : for (viSeRya-viSeRaNa 	? ?)
;	replace LBL value of viSeRaNa/adv with the LBL value of viSeRya
;	Replace ARG1 value of viSeRaNa/adv with ARG0 value of viSeRya
(defrule viya-viNa
(declare (salience 100))
(rel-ids mod|rvks ?viya ?viNa);verified sentences: 16,309,167,341 respectively.
(MRS_info ?rel1 ?viya ?c ?lbl1 ?arg0_viya  $?var)
?f<-(MRS_info ?rel2 ?viNa ?co ?lbl2 ?arg0_viNa ?arg1_viNa $?vars)
(test (neq (sub-string (- (str-length ?co) 1) (str-length ?co) ?co) "_q"))
(not (modified_viSeRaNa ?viNa))
=>
(retract ?f)
(assert (modified_viSeRaNa ?viNa))
(assert (MRS_info  ?rel2  ?viNa   ?co   ?lbl1   ?arg0_viNa   ?arg0_viya $?vars))
(printout ?*rstr-fp* "(MRS_info  "?rel2 " " ?viNa " " ?co " " ?lbl1 " " ?arg0_viNa " " ?arg0_viya " "(implode$ (create$ $?vars)) ")"crlf)
(printout ?*rstr-dbug* "(rule-rel-values viya-viNa   "?rel2 " " ?viNa " " ?co " " ?lbl1 " " ?arg0_viNa " " ?arg0_viya " "(implode$ (create$ $?vars)) ")"crlf)
)

;Rule for adjective and noun : for (viSeRya-viSeRaNa 	? ?)
;	replace LBL value of viSeRaNa/adv with the LBL value of viSeRya
;	Replace ARG1 value of viSeRaNa/adv with ARG0 value of viSeRya
(defrule viya-viNa-intf
(rel-ids intf ?viya ?viNa);verified sentences: 16,309,167,341 respectively.
(MRS_info ?rel1 ?viya ?c ?lbl1 ?arg0_viya  $?var)
?f<-(MRS_info ?rel2 ?viNa ?co ?lbl2 ?arg0_viNa ?arg1_viNa $?vars)
(test (neq (sub-string (- (str-length ?co) 1) (str-length ?co) ?co) "_q"))
(not (modified_viSeRaNa ?viNa))
=>
(retract ?f)
(assert (modified_viSeRaNa ?viNa))
(assert (MRS_info  ?rel2  ?viNa   ?co   ?lbl1   ?arg0_viNa   ?arg0_viya $?vars))
(printout ?*rstr-fp* "(MRS_info  "?rel2 " " ?viNa " " ?co " " ?lbl1 " " ?arg0_viNa " " ?arg0_viya " "(implode$ (create$ $?vars)) ")"crlf)
(printout ?*rstr-dbug* "(rule-rel-values viya-viNa-intf   "?rel2 " " ?viNa " " ?co " " ?lbl1 " " ?arg0_viNa " " ?arg0_viya " "(implode$ (create$ $?vars)) ")"crlf)
)


;Rule for predicative adjective (samAnAXi) : for (kriyA-k1 ? ?) and  (kriyA-k2 ? ?) is not present
;replace ARG1 of adjective with ARG0 of non-adjective
;ex INPUT: rAma acCA hE. OUTPUT: Rama is good.
(defrule samAnAXi
(rel-ids   k1	?non-adj ?k1) ;#yaha Gara hE.
(rel-ids	k1s	?non-adj ?adj)
?f<-(MRS_info ?rel_name ?adj ?mrsCon ?lbl ?arg0 ?arg1 $?v)
(MRS_info ?rel1 ?k1 ?mrsCon1 ?lbl1 ?nonadjarg_0 $?vars)
(test (neq (str-index _a_ ?mrsCon) FALSE))
(test (neq ?arg1 ?nonadjarg_0))
(not (modified_samAnAXi ?nonadjarg_0))
=>
(retract ?f)
(assert (modified_samAnAXi ?nonadjarg_0))
(assert (MRS_info  ?rel_name ?adj ?mrsCon ?lbl ?arg0 ?nonadjarg_0 $?v))
(printout ?*rstr-dbug* "(rule-rel-values samAnAXi "?rel_name " " ?adj " " ?mrsCon " " ?lbl " " ?nonadjarg_0 " "(implode$ (create$ $?v))")"crlf)
)

;Rule for copulative (samAnAXi) : for binding ARG1 & ARG2 of the stative verb with the entities of copulative(samAnAXi)
;replace ARG1 of verb with ARG0 of 1st samAnAXi & ARG2 of verb with ARG0 of 2nd samAnAXi.
;ex INPUT: rAma dAktara hE. OUTPUT: Rama is a doctor.
(defrule samAnAXi-noun
(id-cl       ?v_id   hE_1|WA_1)
(rel-ids	k1s	?v_id ?k1s)
(rel-ids	k1	?v_id ?k1)
?f<-(MRS_info ?rel_name ?v_id ?mrsCon ?lbl ?arg0 ?arg1 ?arg2 )
(MRS_info ?rel1 ?k1 ?mrsCon1 ?lbl1 ?id1_arg0 $?vars)
(MRS_info ?rel2 ?k1s ?mrsCon2 ?lbl2 ?id2_arg0 $?var)
(test (eq (str-index _q ?mrsCon1) FALSE))
(test (neq ?arg1 ?id1_arg0))
(not (id-cl  ?k-id   ?hiConcept&Aja_1|kala_1|kala_2)) ;to rule out the cases for time adverbs.
(not (modified_samAnAXi ?k1))
(not (rel-ids vyABIcAra ?previousid	?v_id))
=>
(retract ?f)
(assert (modified_samAnAXi ?k1))
(assert (MRS_info  ?rel_name ?v_id ?mrsCon ?lbl ?arg0 ?id1_arg0 ?id2_arg0 ))
(printout ?*rstr-dbug* "(rule-rel-values samAnAXi-noun "?rel_name " " ?v_id " " ?mrsCon " " ?lbl " " ?id1_arg0 " " ?id2_arg0 ")"crlf)
)

;replace ARG1 of existential prep with ARG0 of AXeya & ARG2 of prep with ARG0 of AXAra.
;ex INPUT: ladakA xillI meM hE. OUTPUT: The boy is in Delhi.
(defrule existential
(id-cl   ?v_id  hE_1|WA_1)
(rel-ids	k7p|k7	?v_id ?k7)
(rel-ids	k1	?v_id ?k1)
?f<-(MRS_info ?rel_name ?id ?endsWith_p ?lbl ?arg0 ?arg1 ?arg2 )
(MRS_info ?rel1 ?k1 ?mrsCon1 ?lbl1 ?id1_arg0 $?vars)
(MRS_info ?rel2 ?k7 ?mrsCon2 ?lbl2 ?id2_arg0 $?var)
(test (eq (+ ?k7 1) ?id ))
(test (neq ?arg1 ?id1_arg0))
(not (modified_existential ?arg2))
=>
(retract ?f)
(assert (modified_existential ?id1_arg0))
(assert (MRS_info  ?rel_name ?id ?endsWith_p ?lbl ?arg0 ?id1_arg0 ?id2_arg0 ))
(printout ?*rstr-dbug* "(rule-rel-values existential "?rel_name " " ?id " " ?endsWith_p " " ?lbl " " ?arg0 " " ?id1_arg0 " " ?id2_arg0 ")"crlf)
)

;Rule for (anuBava-anuBAvaka) : for binding ARG1 & ARG2 of the verb with the ARG0 values of anuBAvaka and anuBava.
;replace ARG1 of the verb with ARG0 of k4a/anuBAvaka & ARG2 of verb with ARG0 of k1/anuBava.
;ex INPUT: rAma ko buKAra hE. OUTPUT: rAma has fever.
(defrule anuBava
(declare (salience 500))
(id-cl ?v_id hE_1|WA_1)
(rel-ids   k1    ?v_id  ?id1)
(rel-ids   k4a   ?v_id  ?id2)
?f<-(MRS_info ?rel_name ?v_id ?mrsCon ?lbl ?arg0 ?arg1 ?arg2 )
?f1<-(MRS_info ?rel1 ?id1 ?mrsCon1 ?lbl1 ?id1_arg0 $?vars)
(MRS_info ?rel2 ?id2 ?mrsCon2 ?lbl2 ?id2_arg0 $?var)
(test (eq (str-index _q ?mrsCon1) FALSE))
(test (neq ?arg1 ?id1_arg0))
(not (modified_anuBava ?id2))
=>
(retract ?f )
(assert (modified_anuBava ?id2))
(assert (MRS_info  ?rel_name ?v_id ?mrsCon ?lbl ?arg0 ?id2_arg0 ?id1_arg0 ))
(printout ?*rstr-dbug* "(rule-rel-values anuBava "?rel_name " " ?v_id " " ?mrsCon " " ?lbl " " ?id2_arg0 " " ?id1_arg0 ")"crlf)
)


;Rule for possessor-possessed : for binding ARG1 & ARG2 of the verb with the ARG0 values of possessor and possessed)
;replace ARG1 of the verb with ARG0 of possessor & ARG2 of verb with ARG0 of possessed.
;ex INPUT: rAma ke pAsa kiwAba hE. OUTPUT: rAma has the book.
(defrule possession
(declare (salience 5000))
(id-cl  ?v_id  hE_2)
?f1<-(rel-ids	k1	?v_id	?k1)
(rel-ids  rsm|rhh|rsma     ?k1  ?id2) ;rAma ke xo bete hEM
?f<-(MRS_info ?rel_name ?v_id ?mrsCon ?lbl ?arg0 ?arg1 ?arg2 )
(MRS_info ?rel1 ?k1 ?mrsCon1 ?lbl1 ?id1_arg0 $?vars)
(MRS_info ?rel2 ?id2 ?mrsCon2 ?lbl2 ?id2_arg0 $?var)
(test (eq (str-index _q ?mrsCon1) FALSE))
(test (neq ?arg1 ?id1_arg0))
(not (modified_possessed ?id2))
=>
(retract ?f ?f1)
(assert (modified_possessed ?id2))
(assert (MRS_info  ?rel_name ?v_id ?mrsCon ?lbl ?arg0 ?id2_arg0 ?id1_arg0 ))
(printout ?*rstr-dbug* "(rule-rel-values possession "?rel_name" "?v_id" "?mrsCon" "?lbl" "?arg0" "?id2_arg0" "?id1_arg0")"crlf)
)

;Rule for verb when only karta is present : for (kriyA-k1 ? ?) and  (kriyA-k2 ? ?) is not present
;replace ARG1 of kriyA with ARG0 of karwA
;#rAju ko buKAra hE
(defrule v-k1
(declare (salience 10))
(rel-ids	k1|k4a	?kriyA ?karwA)
?f<-(MRS_info ?rel_name ?kriyA ?mrsCon ?lbl ?arg0 ?arg1 $?v)
(MRS_info ?rel1 ?karwA ?mrsCon1 ?lbl1 ?argwA_0 $?vars)
(test (eq (str-index _q ?mrsCon1) FALSE))
(test (neq ?arg1 ?argwA_0))
(not (modified_k1 ?karwA))
(test (neq (str-index "_v_" ?mrsCon)FALSE))
(test (eq (str-index card ?mrsCon1)FALSE)) ;Three barked.
(not (modified_possessed ?karwA))
(not (verb_bind_notrequired ?kriyA))
=>
(retract ?f)
(assert (modified_k1 ?karwA))
(assert (MRS_info  ?rel_name ?kriyA ?mrsCon ?lbl ?arg0 ?argwA_0 $?v))
;(printout ?*rstr-fp* "(MRS_info  "?rel_name " " ?kriyA " " ?mrsCon " " ?lbl " " ?arg0 " " ?argwA_0 " "(implode$ (create$ $?v))")"crlf)
(printout ?*rstr-dbug* "(rule-rel-values v-k1 "?rel_name " "?kriyA" "?mrsCon" "?lbl" "?arg0" "?argwA_0" "(implode$ (create$ $?v))")"crlf)
)

;Rule for verb when only causative karta is present : for (kriyA-pk1 ? ?) and  (kriyA-k2 ? ?) is not present for causative
;replace ARG1 of the kriyA "_make_v_cause" with ARG0 of karwA
;#SikRikA ne CAwroM se kakRA ko sAPa karAyA.
(defrule v-pk1
(id-morph_sem	?kriya	causative)
(rel-ids	pk1	?kriyA ?karwA)
(MRS_info ?rel1 ?karwA ?mrsCon1 ?lbl1 ?argwA_0 $?vars)
?f<-(MRS_info ?rel3 ?kriyA _make_v_cause ?lbl3 ?A30 ?A31 ?A32)
(not (modified_pk1 ?karwA))
=>
(retract ?f)
(assert (modified_pk1 ?karwA))
(assert (MRS_info  ?rel3  ?kriyA _make_v_cause  ?lbl3 ?A30 ?argwA_0  ?A32))
(printout ?*rstr-dbug* "(rule-rel-values v-pk1 MRS_info "?rel3 " " ?kriyA " _make_v_cause " ?lbl3 " "?A30 " "?argwA_0 " " ?A32")"crlf)
)

;Rule for verb when only prayojaka karta is present : for (kriyA-jk1 ? ?) and  (kriyA-k2 ? ?) is not present
;replace ARG1 of main kriyA with ARG0 of prayojaka karwA
;#SikRikA ne CAwroM se kakRA ko sAPa karAyA.
;Ex. 
(defrule v-jk1
(id-morph_sem	?kriya	causative)
(rel-ids	jk1	?kriyA ?karwA)
(MRS_info ?rel1 ?karwA ?mrsCon1 ?lbl1 ?argwA_0 $?vars)
?f<-(MRS_info ?rel_name ?kriyA ?mrsCon ?lbl ?arg0 ?arg1 ?arg2 $?v)
(test (eq (str-index _q ?mrsCon1) FALSE))
(test (neq (str-index _v_ ?mrsCon) FALSE))
(test (neq ?arg1 ?argwA_0))
(not (modified_jk1 ?karwA))
=>
(retract ?f)
(assert (modified_jk1 ?karwA))
(assert (MRS_info ?rel_name ?kriyA ?mrsCon ?lbl ?arg0 ?argwA_0 ?arg2 $?v))
(printout ?*rstr-dbug* "(rule-rel-values v-jk1 MRS_info "?rel_name " " ?kriyA  " "?mrsCon" " ?lbl " "?arg0 " "?argwA_0 " )"crlf)
)

;Rule for binding ARG1 of ask with ARG0 of karwa.
;genrates binding for double causative
;mAz ne rAma se bacce ko KAnA KilavAyA.
(defrule v-p1k1
(id-morph_sem	?kriyA	doublecausative)
(rel-ids	pk1	?kriyA ?karwA)
(MRS_info ?rel1 ?karwA ?mrsCon1 ?lbl1 ?argwA_0 $?vars)
?f<-(MRS_info ?rel3 ?kriyA _ask_v_1 ?lbl3 ?A30 ?A31 ?A32 ?A33)
(not (modified_p1k1 ?karwA))
=>
(retract ?f)
(assert (modified_p1k1 ?karwA))
(assert (MRS_info  ?rel3  ?kriyA _ask_v_1  ?lbl3 ?A30 ?argwA_0  ?A32 ?A33))
(printout ?*rstr-dbug* "(rule-rel-values v-p1k1 MRS_info "?rel3 " " ?kriyA " _ask_v_1 " ?lbl3 " "?A30 " "?argwA_0 " " ?A32" "A33")"crlf)
)

;mAz ne rAma se bacce ko KAnA KilavAyA.
;Rule to bind ARG1 of make_v_cause with ARG0 of karwa. 
(defrule v-mk1
(id-morph_sem	?kriyA	doublecausative)
(rel-ids	mk1	?kriyA ?karwA)
(MRS_info ?rel1 ?karwA ?mrsCon1 ?lbl1 ?argwA_0 $?vars)
?f1<-(MRS_info ?rel3 ?kriyA _ask_v_1 ?lbl3 ?A30 ?A31 ?A32 ?A33)
?f2<-(MRS_info ?rel2 ?kriyA _make_v_cause ?lbl2 ?A20 ?A21 ?A22)
(not (modified_mk1 ?karwA))
=>
(retract ?f1 ?f2)
(assert (modified_mk1 ?karwA))
(assert (MRS_info  ?rel3  ?kriyA _ask_v_1  ?lbl3 ?A30 ?A31 ?argwA_0 ?A33))
(assert (MRS_info ?rel2 ?kriyA _make_v_cause ?lbl2 ?A20 ?argwA_0 ?A22))
(printout ?*rstr-dbug* "(rule-rel-values v-mk1 MRS_info "?rel3 " " ?kriyA " _ask_v_1 " ?lbl3 " "?A30 " " ?A31" "?argwA_0 " "?A33")"crlf)
(printout ?*rstr-dbug* "(rule-rel-values v-mk1 MRS_info "?rel2 " " ?kriyA " _make_v_cause " ?lbl2 " "?A20 " "?argwA_0 " " ?A22")"crlf)
)

;Rule for converting arg1 of kriya with arg0 of karwa
;mAz ne rAma se bacce ko KAnA KilavAyA.
(defrule v-j1k1
(id-morph_sem	?kriya	doublecausative)
(rel-ids	jk1	?kriyA ?karwA)
?f<-(MRS_info ?rel_name ?kriyA ?mrsCon ?lbl ?arg0 ?arg1 $?v)
(MRS_info ?rel1 ?karwA ?mrsCon1 ?lbl1 ?argwA_0 $?vars)
(test (neq ?arg1 ?argwA_0))
(not (modified_j1k1 ?karwA))
=>
(retract ?f)
(assert (modified_j1k1 ?karwA))
(assert (MRS_info ?rel_name ?kriyA ?mrsCon ?lbl ?arg0 ?argwA_0  $?v))
;(printout ?*rstr-fp* "(MRS_info "?rel_name " " ?kriyA  " "?mrsCon" " ?lbl " "?arg0 " "?argwA_0 ")"crlf)
(printout ?*rstr-dbug* "(rule-rel-values v-j1k1 MRS_info "?rel_name " " ?kriyA  " "?mrsCon" " ?lbl " "?arg0 " "?argwA_0 " )"crlf)
)

;Rule to delete k2 relation of the verb want when it takes a verb as k2
;And replace the ARG1 value of the verb that has occurred as k2 with arg0 value of k1
;Ex. Rama wants to sleep.
(defrule want-k2-deleted
(declare (salience 300))
?f<-(rel-ids k2   ?kri ?k2)
(rel-ids k1   ?kri ?k1)
(MRS_info ?rel ?kri _want_v_1 $?vars)
?f1<-(MRS_info ?r ?k2  ?k2v ?l ?a0 ?a1 $?v)
(MRS_info ?r1 ?k1  ?k1mrs ?k1l ?k1a0 $?k1v)
(test (neq (str-index _v_ ?k2v) FALSE))
=>
(retract ?f ?f1)
(printout ?*rstr-dbug* "(rule-rel-values want-k2-deleted rel-ids k2 "?kri" "?k2")"crlf) 

(printout ?*rstr-fp* "(MRS_info "?r" "?k2" "?k2v" "?l" "?a0" "?k1a0" "(implode$ (create$ $?v))")"crlf) 
(printout ?*rstr-dbug* "(rule-rel-values want-k2-deleted MRS_info "?r" "?k2" "?k2v" "?l" "?a0" "?k1a0" "(implode$ (create$ $?v))")"crlf) 
)


;Rule for verb and its arguments(when both karta and karma are present),Replace ARG1 value of kriyA with ARG0 value of karwA and ARG2 value of kriyA with ARG0 value of karma
(defrule v-k2
(declare (salience 10))
(rel-ids	k2|k1s|rask2      	?kriyA ?karma)
?f<-(MRS_info ?rel_name ?kriyA ?mrsCon ?lbl ?arg0 ?arg1 ?arg2 $?v)
(MRS_info ?rel2 ?karma ?mrsCon2 ?lbl2 ?argma_0 $?vars1)
(test (neq (sub-string (- (str-length ?mrsCon2) 1) (str-length ?mrsCon2) ?mrsCon2) "_q")) ;I asked Rama a question. What do the animals eat? What did Hari fill in the pot?
(test (neq (str-index _v_ ?mrsCon) FALSE))
(test (or (neq (str-index _v_ ?mrsCon) FALSE) (neq (str-index _v_cause ?mrsCon) FALSE))) ;Hari filled the pot, with a water.
(test (eq (str-index make_v_cause ?mrsCon) FALSE)) ;The teacher made the students clean the class.
(test (neq ?arg2 ?argma_0))
(not (modified_k2 ?karma))
;(not (rel-ids rask2 ?kri	?id)) ;#राम खा -खाकर मोटा हो गया ।
=>
(retract ?f)
(assert (modified_k2 ?karma))
(assert (MRS_info  ?rel_name  ?kriyA  ?mrsCon  ?lbl ?arg0 ?arg1 ?argma_0  $?v))
(printout ?*rstr-dbug* "(rule-rel-values v-k2 "?rel_name " " ?kriyA " " ?mrsCon " " ?lbl " "?arg0 " " ?arg1 " " ?argma_0 " "(implode$ (create$ $?v))")"crlf)
)


;Rule for verb and its arguments(when  karta, karma and sampradaan are present),Replace ARG3 value of kriyA with ARG0 value of sampradaan and ARG2 value of kriyA with ARG0 value of karma
(defrule v-k4
(rel-ids	k4|k2g|k2s   	?kriyA ?k4)
?f<-(MRS_info id-MRS_concept-LBL-ARG0-ARG1-ARG2-ARG3 ?kriyA ?mrsCon ?lbl ?arg0 ?arg1 ?arg2 ?arg3 )
(MRS_info ?rel2 ?k4 ?mrsCon2 ?lbl2 ?argk4_0 $?vars1)
(test (eq (str-index _q ?mrsCon2) FALSE))
(test (neq ?arg2 ?argk4_0))
(not (arg3_bind ?arg3))
(not (ask_k4_notbind_required ?kriyA))
;(assert (rel-ids	?rel	?kri	?id))
=>
(retract ?f)
(assert (arg3_bind ?argk4_0 ))
(assert (MRS_info  id-MRS_concept-LBL-ARG0-ARG1-ARG2-ARG3  ?kriyA  ?mrsCon  ?lbl ?arg0 ?arg1 ?arg2 ?argk4_0  ))
(printout ?*rstr-dbug* "(rule-rel-values v-k4 id-MRS_concept-LBL-ARG0-ARG1-ARG2-ARG3  " ?kriyA " " ?mrsCon " " ?lbl " " ?arg0 " " ?arg1 " " ?arg2 " " ?argk4_0 ")"crlf)
)

(defrule ask_k4_notbind
(declare (salience 1000))
(rel-ids	k4	?kriyA 	?k4)
(id-morph_sem	?kriyA	doublecausative)	
(MRS_info id-MRS_concept-LBL-ARG0-ARG1-ARG2-ARG3 ?kriyA _ask_v_1 ?lb ?a0 ?a1 ?a2 ?a3)
;(MRS_info id-MRS_concept-LBL-ARG0-ARG1-ARG2-ARG3 ?kriyA ?verb ?lbb ?a00 ?a11 ?a22 ?a33)
;(test (neq (str-index _ask_v_1 ?MRSCON) FALSE))
=>
(assert (ask_k4_notbind_required ?kriyA))
(printout ?*rstr-dbug* "(rule-rel-values  ask_k4_notbind ask_k4_notbind_required "?kriyA")"crlf)
)

;Rule for preposition for noun : for (kriyA-k*/r* ?1 ?2) and (id-MRS_Rel ?2 k*/r* corresponding prep_rel from dic)
;Replace ARG1 value of prep_rel with ARG0 value of ?1 and ARG2 value of prep_rel with ARG0 value of ?2)
;Ex. Sera_ne_yuxXa_ke_liye_jaMgala_meM_saBA_bulAI
(defrule prep-noun_karak
(declare (salience 10000))
(rel-ids ?relp ?kriyA ?karak)
?f<-(MRS_info ?rel_name ?prep ?endsWith_p ?lbl ?arg0 ?arg1 ?arg2)
(MRS_info ?rel1 ?kriyA ?mrsCon1 ?lbl1 ?argv_0 $?vars)
(MRS_info ?rel2 ?karak ?mrsCon2 ?lbl2 ?argn_0 $?varss)
(test (eq (sub-string 1 1 (str-cat ?prep)) (sub-string 1 1 (str-cat ?karak))))
;(test (eq (sub-string (- (str-length ?endsWith_p) 1) (str-length ?endsWith_p) ?endsWith_p) "_p"))
(test (or (neq (str-index "_p" ?endsWith_p) FALSE) (neq (str-index "_p_temp" ?endsWith_p) FALSE) (neq (str-index "_p_dir" ?endsWith_p) FALSE) (neq (str-index unspec_manner ?endsWith_p) FALSE)))
(test (eq  (+ ?karak 1) ?prep))
(test (or (eq (str-index "_p" ?mrsCon2)FALSE) (eq ?mrsCon2 nominalization) (neq (str-index "_n_" ?mrsCon2)FALSE) ))
(test (eq (str-index "_v_id" ?mrsCon1)FALSE)) ;Anything wrong in the village.
(test (neq (str-index "_v_" ?mrsCon1)FALSE))  ;Bring fruits, from the forest for Riwesa.
(test (eq (str-index "_v_qmodal" ?mrsCon1)FALSE)) ;I have to go.
(not (rel-ids	rask2	?kriyA	?karwA))
(not (id-cl       ?kriyA  raKa_8)) ;Abrams put Browne in the garden.
=>
(retract ?f)
(printout ?*rstr-fp* "(MRS_info  " ?rel_name " " ?prep " " ?endsWith_p " " ?lbl1 " " ?arg0 " " ?argv_0 " " ?argn_0 ")"crlf)
(printout ?*rstr-dbug* "(rule-rel-values prep-noun_karak "?rel_name " " ?prep " " ?endsWith_p " " ?lbl1" " ?arg0 " " ?argv_0 " " ?argn_0 ")"crlf)
)

(defrule prep-noun_non_karak
(declare (salience 10000))
(rel-ids	ru|rn|rt	?high	?low)
?f<-(MRS_info ?rel_name ?prep ?endsWith_p ?lbl ?arg0 ?arg1 ?arg2) 
(MRS_info ?rel1 ?high ?mrscon1 ?lbl1 ?arg01 $?V)
(MRS_info ?rel2 ?low ?mrscon2 ?lbl2 ?arg02 $?v)
(test (or (neq (str-index "_p" ?endsWith_p) FALSE) (neq (str-index "_p_temp" ?endsWith_p) FALSE) (neq (str-index "_p_dir" ?endsWith_p) FALSE)))
(test (eq  (+ ?low 1) ?prep))
=>
(retract ?f)
(printout ?*rstr-fp* "(MRS_info  " ?rel_name " " ?prep " " ?endsWith_p " " ?lbl1 " " ?arg0 " " ?arg01 " " ?arg02 ")"crlf)
(printout ?*rstr-dbug* "(rule-rel-values prep-noun_non_karak "?rel_name " " ?prep " " ?endsWith_p " " ?lbl1 " " ?arg0 " " ?arg01 " " ?arg02 ")"crlf)
)

;Rule for changing lbl of preposition with lbl of verb, arg1 of the preposition with arg0 of verb, arg2 of preposition with arg0 of noun. EXCEPTIONAL CASE FOR PREPOSITION bAxa entry having value. 
;The train came after the sunrise.
(defrule rkl
(rel-ids	rkl	?st	?time)
(rel-ids	k7t	?kriya	?st)
(MRS_info id-MRS_concept-LBL-ARG0 ?time ?mrscc ?lb ?argo)
?f<-(MRS_info id-MRS_concept-LBL-ARG0-ARG1-ARG2 ?st ?mrscon ?l ?a0 ?a1 ?a2)
(MRS_info ?rel ?kriya ?hinkri ?lbll ?arg00 $?v)
(test (neq (str-index "_p"  ?mrscon) FALSE)) 
=>
;(retract ?f)
(printout ?*rstr-fp* "(MRS_info id-MRS_concept-LBL-ARG0-ARG1-ARG2 "?st" "?mrscon" " ?lbll" "?a0" "?arg00" "?argo" )"crlf)
(printout ?*rstr-dbug* "(rule-rel-values rkl id-MRS_concept-LBL-ARG0-ARG1-ARG2 "?st" "?mrscon " " ?lbll" "?a0" "?arg00" "?argo")"crlf)
)

;But their number rises afterwards.
(defrule prep-verb-arg1-time
(rel-ids	k7t	?kriya	?time)
?f<-(MRS_info id-MRS_concept-LBL-ARG0-ARG1 ?time ?preposition  ?lbl ?arg0 ?arg1)
(MRS_info ?rel ?kriya ?verb ?lbl1 ?arg00 $?v)
(test (neq (str-index _p ?preposition) FALSE))
(test (neq (str-index _v_ ?verb) FALSE))
=>
(printout ?*rstr-fp* "(MRS_info id-MRS_concept-LBL-ARG0-ARG1 "?time" "?preposition" " ?lbl1" "?arg0" "?arg00")"crlf)
(printout ?*rstr-dbug* "(rule-rel-values prep-verb-arg1-time id-MRS_concept-LBL-ARG0-ARG1 "?time" "?preposition" " ?lbl1" "?arg0" "?arg00")"crlf)
)

;Rule for creating binding with k2 with "with" preposition when rask2 relation exists. 
;Rama ate banana also with milk.
(defrule rask2-k2-with
(rel-ids	k2	?kriya	?k2)
(rel-ids	rask2	?kriya	?rask2)
(MRS_info ?rel ?k2 ?concept ?lbl ?arg0 $?v)
(MRS_info ?rel3 ?rask2 ?mrscon1 ?lbl3 ?arg000 $?var)
?f<-(MRS_info ?rel1 ?preposition ?mrsconcept ?lbl1 ?arg00 ?arg1 ?arg2)
(test (eq  (+ ?rask2 1) ?preposition))
(test (eq (str-index _p_ ?mrsconcept) FALSE))
=>
(retract ?f)
(printout ?*rstr-fp* "(MRS_info "?rel1" "?preposition" "?mrsconcept" " ?lbl3" "?arg00" "?arg000" "?arg0")"crlf)
(printout ?*rstr-dbug* "(rule-rel-values rask2-k2-with "?rel1" "?preposition" "?mrsconcept" " ?lbl3" "?arg00" "?arg000" "?arg0" )"crlf)
)

;Rule for value sharing between the _according+to_p to the verb and samanadhikaran of the sentence.
;sIwA ke anusAra rAma vIra hE. 'Generalize this rule.
(defrule k7a_according_p
(id-cl	?id	?hinconcept)
(rel-ids	k7a	?kri	?id)
(rel-ids	k1s	?kri	?k1s)
?f<-(MRS_info id-MRS_concept-LBL-ARG0-ARG1-ARG2 ?according _according+to_p ?lbl ?arg0 ?arg1 ?Arg2)
(MRS_info ?rel ?id ?mrscon ?lbl1 ?Arg0 $?v)
(MRS_info ?rell ?k1s ?mrsconcept ?lblll ?arg00 $?var)
=>
(retract ?f)
(printout ?*rstr-fp* "(MRS_info id-MRS_concept-LBL-ARG0-ARG1-ARG2 "?according" _according+to_p "?lblll" "?arg0" "?arg00" "?Arg0")"crlf)
(printout ?*rstr-dbug* "(rule-rel-values k7a_according_p id-MRS_concept-LBL-ARG0-ARG1-ARG2 "?according" _according+to_p "?lblll" "?arg0" "?arg00" "?Arg0")"crlf)
)
;Generalized rule for loc_nonsp which share its value with verb and noun/adjective/anything..
;I am coming home. I am coming there.
(defrule prep-noun_nonsp
(declare (salience 10000))
(rel-ids ?relp ?kriyA ?karak)
?f<-(MRS_info ?rel_name ?prep loc_nonsp ?lbl ?arg0 ?arg1 ?arg2)
(MRS_info ?rel1 ?kriyA ?mrsCon1 ?lbl1 ?argv_0 $?vars)
(MRS_info ?rel2 ?karak ?mrscon2 ?lbl2 ?argn_0 $?varss)
(test (eq  (+ ?karak 1) ?prep)) 
(test (neq (str-index "_n" ?mrscon2)FALSE))
(test (eq (str-index "_a_" ?mrscon2)FALSE))
=>
(retract ?f)
(printout ?*rstr-fp* "(MRS_info  " ?rel_name " " ?prep " loc_nonsp " ?lbl1 " " ?arg0 " " ?argv_0 " " ?argn_0 ")"crlf)
(printout ?*rstr-dbug* "(rule-rel-values prep-noun_nonsp "?rel_name " " ?prep " loc_nonsp " ?lbl1" " ?arg0 " " ?argv_0 " " ?argn_0 ")"crlf)
)

;Rule for '_home_p or _there_a_1, _here_a_1' is with the place_n.
;Also rule for time_n with _today_a_1, _yesterday_a_1, _early_a_1, etc.. 
;Ex- i am coming home ; I am coming tomorrow.
(defrule v-home
(MRS_info id-MRS_concept-LBL-ARG0 ?id place_n|time_n ?lbl2 ?arg02)
?f3<-(MRS_info id-MRS_concept-LBL-ARG0-ARG1 ?id ?home ?lbl3 ?arg03 ?arg13)
(test (or (eq ?home  _there_a_1)
(eq ?home  _home_p)(eq ?home  _here_a_1) (eq ?home _yesterday_a_1) (eq ?home _today_a_1) (eq ?home _tomorrow_a_1)(eq ?home _early_a_1) (eq ?home _now_a_1)(eq ?home _late_p)))
=>
(retract ?f3)
(printout ?*rstr-fp* "(MRS_info id-MRS_concept-LBL-ARG0-ARG1 "?id " " ?home" "?lbl2"  "?arg03" "?arg02 ")"crlf)
(printout ?*rstr-dbug* "(rule-rel-values v-home id-MRS_concept-LBL-ARG0-ARG1 "?id " " ?home" "?lbl2"  "?arg03" "?arg02 ")"crlf)
)

;Replace LBL and ARG1 values of poss with LBL and ARG0 values of RaRTI_viSeRya and ARG2 with ARG0 of RaRTI_viSeRaNa (r6)
;Ex- John's son studies in the school
;Ex. My friend is playing in the garden.
;Ex. The necklace is in the woman's neck. 
(defrule r6
(rel-ids r6|rhh	?id	?id1) ;Because of that his parents used to be very upset.
?f<-(MRS_info id-MRS_concept-LBL-ARG0-ARG1-ARG2 ?idposs poss ?lbl ?arg0 ?arg1 ?arg2)
(MRS_info ?rel ?id ?mrsCon ?lbl6 ?arg00 $?v)  
(MRS_info ?rel1 ?id1 ?mrsCon1 ?lbl7 ?arg8 $?v1) 
(test (eq  (+ ?id 20) ?idposs))  ;Ms. Rajini admitted her son and her daughter in the Kashi's largest school in Banaras.
=>
(retract ?f) 
(printout ?*rstr-fp* "(MRS_info id-MRS_concept-LBL-ARG0-ARG1-ARG2  " ?idposs " poss " ?lbl6 " " ?arg0 " " ?arg00 " " ?arg8 ")"crlf)
(printout ?*rstr-dbug* "(rule-rel-values r6 id-MRS_concept-LBL-ARG0-ARG1-ARG2  " ?idposs " poss " ?lbl6 " " ?arg0 " " ?arg00 " " ?arg8 ")"crlf)
)

;Rule for preposition for pronoun : when (id-pron ? yes) for (kriyA-k*/r* ?1 ?2) and (id-MRS_Rel ?2 k*/r* corresponding prep_rel from dic)
;Replace ARG1 value of prep_rel with ARG0 value of ?1 and ARG2 value of prep_rel with ARG0 value of ?2)
;Ex. mEM_usake_lie_Sahara_se_AyA
(defrule prep-pron
(rel-ids ?relp ?kriyA ?karaka)
?f<-(MRS_info ?rel_name ?prep ?endsWith_p ?lbl ?arg0 ?arg1 ?arg2 $?v)
(MRS_info ?rel1 ?kriyA ?mrsCon1 ?lbl1 ?argv_0 $?vars)
(MRS_info ?rel2 ?karaka pron ?lbl2 ?argpron_0 $?varss)
(test (eq (sub-string (- (str-length ?endsWith_p) 1) (str-length ?endsWith_p) ?endsWith_p) "_p"))
(test (eq (sub-string 1 1 (str-cat ?prep)) (sub-string 1 1 (str-cat ?karaka))))
=>
(retract ?f)
(printout ?*rstr-fp* "(MRS_info  " ?rel_name " " ?prep " " ?endsWith_p " " ?lbl1 " " ?arg0 " " ?argv_0 " " ?argpron_0 ")"crlf)
(printout ?*rstr-dbug* "(rule-rel-values prep-pron  "?rel_name " " ?kriyA " " ?endsWith_p " " ?lbl " " ?arg0 " " ?argv_0 " " ?argpron_0 ")"crlf)
)

;Rule for generating CARG value 'Mon' in days of week and 'Jan' in months of year
(defrule dofw
?f1<-(id-cl	?id	?con)
(or (mofy ?con ?val) (dofw ?con ?val) )
?f<-(MRS_info id-MRS_concept-LBL-ARG0-CARG ?id ?dofw  ?h1 ?x2 ?carg)
(test (or (eq ?dofw mofy) (eq ?dofw dofw)))
=>
(retract ?f ?f1)
(assert (MRS_info  id-MRS_concept-LBL-ARG0-CARG ?id  ?dofw ?h1 ?x2  ?val))
(printout ?*rstr-dbug* "(rule-rel-values dofw id-MRS_concept-LBL-ARG0-CARG "?id"  "?dofw " "?h1" "?x2" " ?val ")"crlf)
)

;Rule for binding proper noun (proper_q) and named ARG0 values. And, replace CARG value with proper name present in the sent. 
;Ex. rAma_jA_rahA_hE.  kyA_rAma_jA_rahA_hE?
(defrule propn
(declare (salience 1000))
(id-cl	?id	?properName)
?f<-(MRS_info id-MRS_concept-LBL-ARG0-CARG ?id ?named ?h1 ?x2 ?carg)
(test (eq ?named named))
(not (modified ?id))
=>
;(retract ?f)
(assert (MRS_info  id-MRS_concept-LBL-ARG0-CARG  ?id  ?named ?h1 ?x2  (sym-cat (upcase (sub-string 1 1 ?properName ))(lowcase (sub-string 2 (str-length ?properName) ?properName )))))
(printout ?*rstr-dbug* "(rule-rel-values propn id-MRS_concept-LBL-ARG0-CARG "?id"  "?named " "?h1" "?x2" " (sym-cat (upcase (sub-string 1 1 ?properName )) (lowcase (sub-string 2 (str-length ?properName) ?properName ))) ")"crlf)
(assert (modified ?id))
)

;Rule for numerical adjectives. Replace CARG value of cardinal number with English number and LBL value of the same fact with LBL of viSeRya, and ARG1 value with the ARG0 value of viSeRya.
;Ex. rAma xo kiwAbaeM paDa rahA hE.
(defrule saMKyA_vi
(declare (salience 1000))
(id-cl ?num ?hnum)
(rel-ids ord|card	?vi     ?num) 
(cl-ls-mrs ?hnum ?enum card|ord)
?f<-(MRS_info  id-MRS_concept-LBL-ARG0-ARG1-CARG ?num ?ord ?lbl ?numARG0 ?ARG1 ?CARG)
(MRS_info ?rel ?vi ?mrscon ?vilbl ?viarg0 $?v)
(test (or (eq ?ord ord) (eq ?ord card)) )
(not (enum_replaced ?num))
=>
(retract ?f)
(assert (enum_replaced ?num))
(if (neq (str-index "_" ?enum) FALSE) then
  (bind ?myEnum (string-to-field (sub-string 0 (- (str-index "_" ?enum )1) ?enum))) ;removing "_digit" from e_concept_label, ex. "ten_2" => "ten"
     (assert (MRS_info  id-MRS_concept-LBL-ARG0-ARG1-CARG ?num ?ord ?vilbl ?numARG0  ?viarg0   ?myEnum ) )
     (printout ?*rstr-dbug* "(rule-rel-values saMKyA_vi id-MRS_concept-LBL-ARG0-ARG1-CARG "?num" " ?ord " "?vilbl" "?numARG0" "?viarg0" "?myEnum")"crlf)
else
   (printout ?*rstr-fp* "(MRS_info  id-MRS_concept-LBL-ARG0-ARG1-CARG "?num" " ?ord " "?vilbl" " ?numARG0 " "?viarg0" " ?enum ")"crlf)
   (printout ?*rstr-dbug* "(rule-rel-values saMKyA_vi id-MRS_concept-LBL-ARG0-ARG1-CARG "?num" " ?ord " "?vilbl" "?numARG0" "?viarg0" "?enum")"crlf)
)
)

;Rule for %imperatives to share the value of pron with the verb. 
(defrule kriImperPronArg
(declare (salience 1000))
(sent_type  %imperative)
?f1<-(MRS_info ?rel1 ?kri ?con ?lbl ?arg0 ?arg1  $?var)
(MRS_info ?rel2 ?kri pron ?lbl1 ?arg01)
(test (neq (str-index "_v_" ?con)FALSE))
(not (already_modified ?kri ARG1  ?arg1))
=>
(retract ?f1)
(assert (already_modified ?kri ARG1  ?arg01))
(assert (MRS_info  ?rel1 ?kri ?con ?lbl ?arg0  ?arg01 $?var))
(printout ?*rstr-dbug* "(rule-rel-values kriImperPronArg " ?rel1 " "?kri" " ?con " "?lbl" " ?arg0 " " ?arg01 " "(implode$ (create$ $?var))")"crlf)
)


;General rule for TAM adding to the verb.
(defrule kri-tam-asser
(kriyA-TAM ?kri ?tam)
(sent_type  %affirmative|%pass_affirmative)
(U_TAM-LS_TAM-Perfective_Aspect-Progressive_Aspect-Tense-Modal ?tam ?e_tam ?perf ?prog ?tense ?typ)
=>
(printout ?*rstr-fp* "(id-SF-TENSE-MOOD-PROG-PERF "?kri " prop " ?tense " indicative " ?prog " " ?perf  ")"crlf)
(printout ?*rstr-dbug* "(rule-rel-values kri-tam-asser id-SF-TENSE-MOOD-PROG-PERF "?kri " prop " ?tense " indicative " ?prog " " ?perf ")"crlf)
)

;rule creates TAM for rpk
;#rAma ne skUla jAkara KAnA KAyA
(defrule rpk
(rel-ids	rpk	?id	?kri)
=>
(printout ?*rstr-fp* "(id-SF-TENSE-MOOD-PROG-PERF "?kri " prop untensed indicative + + )"crlf)
(printout ?*rstr-dbug* "(rule-rel-values rpk id-SF-TENSE-MOOD-PROG-PERF "?kri " prop untensed indicative + + )"crlf)
)


;It creates TAM for rvks
;verified sentence 341 BAgawe hue Sera ko xeKo
(defrule rvks
(rel-ids	rvks|rblsk ?id	?kri)
=>
(printout ?*rstr-fp* "(id-SF-TENSE-MOOD-PROG-PERF "?kri " prop untensed indicative + - )"crlf)
(printout ?*rstr-dbug* "(rule-rel-values rvks id-SF-TENSE-MOOD-PROG-PERF "?kri " prop untensed indicative + - )"crlf)
)
 
;It creates TAM for vmod_krvn
;verified sentence 338 vaha laMgadAkara calawA hE.
;verified sentence 340 BAgawe hue Sera ko xeKo
;#rAma sowe hue KarrAte BarawA hE. 
(defrule krvn-sf
(rel-ids	krvn|rsk	?kri	?kvn)
(id-hin_concept-MRS_concept ?kvn ?hin ?mrscon)
(test (neq (str-index _v_ ?mrscon) FALSE))
=>
(printout ?*rstr-fp* "(id-SF-TENSE-MOOD-PROG-PERF "?kvn " prop untensed indicative + - )"crlf)
(printout ?*rstr-dbug* "(rule-rel-values krvn-sf id-SF-TENSE-MOOD-PROG-PERF "?kvn " prop untensed indicative + - )"crlf)
)

;Rule for creating TAM information for rblak relation verb.  
;gAyoM ke xuhane se pahale rAma Gara gayA.
;;rAma ke vana jAne para xaSaraWa mara gaye.
(defrule rblak
(rel-ids	rblak|rblpk	?kri	?id)
=>
(printout ?*rstr-fp* "(id-SF-TENSE-MOOD-PROG-PERF "?id" prop past indicative - - )"crlf)
(printout ?*rstr-dbug* "(rule-rel-values rblak id-SF-TENSE-MOOD-PROG-PERF "?id" prop past indicative - - )"crlf)
)

;for negation sentence information
;#mEM rUsI nahIM bola sakawA hUz.
(defrule kri-tam-neg
(kriyA-TAM ?kri ?tam)
(sent_type  %negative)
(U_TAM-LS_TAM-Perfective_Aspect-Progressive_Aspect-Tense-Modal ?tam ?e_tam ?perf ?prog ?tense ?)
=>
(printout ?*rstr-fp* "(id-SF-TENSE-MOOD-PROG-PERF "?kri " prop " ?tense " indicative " ?prog " " ?perf ")"crlf)
(printout ?*rstr-dbug* "(rule-rel-values kri-tam-neg id-SF-TENSE-MOOD-PROG-PERF "?kri " prop " ?tense " indicative " ?prog " " ?perf ")"crlf)
)

;Rule for verb - passive sentences . 
;Replace LBL of parg_d with LBL of v and ARG1 of parg_d with ARG0 of verb 
;Ex. rAvana mArA gayA.
(defrule pargd
(declare (salience -200))
?f<-(MRS_info  id-MRS_concept-LBL-ARG0-ARG1-ARG2 ?parg_id parg_d ?lbl ?arg0 ?arg1 ?arg2) 
(MRS_info id-MRS_concept-LBL-ARG0-ARG1-ARG2 ?id ?v ?lblv ?arg0v ?arg1v ?arg2v)
(test (neq (str-index "_v_" ?v)FALSE))
(test (eq (+ ?id 1) ?parg_id))
=>
(retract ?f)
(printout ?*rstr-fp* "(MRS_info  id-MRS_concept-LBL-ARG0-ARG1-ARG2 "?parg_id" parg_d "?lblv" " ?arg0 " " ?arg0v " "?arg2v ")"crlf)
(printout ?*rstr-dbug* "(rule-rel-values pargd id-MRS_concept-LBL-ARG0-ARG1-ARG2 "?parg_id" parg_d " ?lblv " " ?arg0 " " ?arg0v " " ?arg2v ")"crlf)
)

;Rule for pargd when verb has ARG3 value.
;Replace ARG2 value of pargd with ARG3 value of verb
;Ex. The earth is called a planet.
(defrule pargd2
?f<-(MRS_info  id-MRS_concept-LBL-ARG0-ARG1-ARG2 ?parg_d parg_d ?lbl ?arg0 ?arg1 ?arg2) 
(MRS_info ?rel ?id ?v1 ?lblv1 ?arg0v1 ?arg1v1 ?arg2v1 ?arg3v1)
(test (neq (str-index "_v_" ?v1)FALSE))
(test (eq (+ ?id 1) ?parg_d))
=>
(retract ?f)
(printout ?*rstr-fp* "(MRS_info  id-MRS_concept-LBL-ARG0-ARG1-ARG2 "?parg_d" parg_d "?lblv1" " ?arg0 " " ?arg0v1 " "?arg3v1 ")"crlf)
(printout ?*rstr-dbug* "(rule-rel-values pargd2 id-MRS_concept-LBL-ARG0-ARG1-ARG2 "?parg_d" parg_d " ?lblv1 " " ?arg0 " " ?arg0v1 " " ?arg3v1 ")"crlf)
)


;for %imperative sentence information
;#Apa Sahara jAo!
(defrule kri-tam-imper
(kriyA-TAM ?kri ?tam)
(sent_type  %imperative)
(U_TAM-LS_TAM-Perfective_Aspect-Progressive_Aspect-Tense-Modal  ?tam ?e_tam ?perf ?prog ?tense ?)
=>
(printout ?*rstr-fp* "(id-SF-TENSE-MOOD-PROG-PERF "?kri " comm " ?tense " indicative " ?prog " " ?perf ")"crlf)
(printout ?*rstr-dbug* "(rule-rel-values kri-tam-imper id-SF-MOOD-PROG-PERF "?kri " comm " ?tense " indicative " ?prog " " ?perf ")"crlf)
)

;for question sentence information
;#kyA hari ne pAnI se GadZe ko BarA?
(defrule kri-tam-q
(kriyA-TAM ?kri ?e_tam)
(sent_type  %yn_interrogative|%interrogative|%pass_interrogative)
(U_TAM-LS_TAM-Perfective_Aspect-Progressive_Aspect-Tense-Modal  ?tam ?e_tam ?perf ?prog ?tense ?)
=>
(printout ?*rstr-fp* "(id-SF-TENSE-MOOD-PROG-PERF "?kri " ques " ?tense " indicative " ?prog " " ?perf ")"crlf)
(printout ?*rstr-dbug* "(rule-rel-values kri-tam-q id-SF-TENSE-MOOD-PROG-PERF "?kri " ques " ?tense " indicative " ?prog " " ?perf ")"crlf)
)

;Rule for LTOP: The LBL value and ARG0 value of *_v_* becomes the value of LTOP and INDEX if the following words are not there in the sentence: "possibly", "suddenly". "not".If they exist, the LTOP value becomes the LBL value of that word and INDEX value is the ARG0 value of *_v_*. For "not" we get a node "neg" in the MRS
(defrule v-LTOP 
(MRS_info ?rel ?kri_id ?mrsCon ?lbl ?arg0 $?vars)
(rel-ids	main	0	?kri_id)
(not (asserted_LTOP-INDEX-for-modal))
(not (kriyA-TAM ?kri_id nA_cAhawA_hE_1))
(not (rel-ids kriyArWa_kriyA ?kri	?kri_id))
(not (rel-ids	rpk	?id	?kri_id)) ;#rAma ne skUla jAkara KAnA KAyA.
(not (rel-ids	rblak	?id	?kri_id)) ;gAyoM ke xuhane se pahale rAma Gara gayA.
(not (rel-ids	rblpk	?id	?kri_id)) ;;rAma ke vana jAne para xaSaraWa mara gaye.
(not (rblsk_index_notrequired ?id))
(not (id-stative ?id yes))
(not (id-morph_sem ?id causative)) ;#SikRikA ne CAwroM se kakRA ko sAPa karAyA.
(not (id-morph_sem	?id	doublecausative)) ;mAz ne rAma se bacce ko KAnA KilavAyA.
(not(rel-ids vAkya_vn ?id1 ?id2)) 
(not (rel-ids samuccaya ?id	?kri_id))
(not (rel-ids anyawra ?id	?kri_id))
(not (rel-ids viroXi ?id	?kri_id))
(not (rel-ids kAryakAraNa ?id	?kri_id))
;(test (eq (str-index "_v_qmodal" ?mrsCon)FALSE))
=>
(if (or (neq (str-index possible_ ?mrsCon) FALSE) (neq (str-index sudden_ ?mrsCon) FALSE))
then
    (printout ?*rstr-fp* "(LTOP-INDEX h0 "?arg0 ")" crlf)
    (printout ?*rstr-dbug* "(rule-rel-values v-LTOP  LTOP-INDEX h0 "?arg0 ")"crlf)
else
    (if (neq (str-index _v_ ?mrsCon) FALSE)
then
    (printout ?*rstr-fp* "(LTOP-INDEX h0 "?arg0 ")" crlf)
    (printout ?*rstr-dbug* "(rule-rel-values v-LTOP LTOP-INDEX h0 "?arg0 ")"crlf))  
)     
)

;for modal verb 
;nA_hE_1 TAM for Rama has to go to the school.
(defrule tam-modal
(declare (salience 100))
(U_TAM-LS_TAM-Perfective_Aspect-Progressive_Aspect-Tense-Modal  ?tam ?e_tam ?perf ?prog ?tense ?)
(kriyA-TAM ?kri ?tam|nA_hE_1)
?f<-(MRS_info id-MRS_concept-LBL-ARG0-ARG1 ?modalV  ?mrs_modal  ?lbl  ?arg0  ?h)
(sent_type  %affirmative|%interrogative|%yn_interrogative|%negative)
(test (or (neq (str-index _v_modal ?mrs_modal) FALSE) (neq (str-index _v_qmodal ?mrs_modal) FALSE)));_used+to_v_qmodal
(not (rel-ids kAryakAraNa ?previousid	?kri))
=>
(retract ?f)
(assert (asserted_LTOP-INDEX-for-modal))
(printout ?*rstr-fp* "(LTOP-INDEX h0 "?arg0 ")" crlf)
(printout ?*rstr-dbug* "(rule-rel-values tam-modal  LTOP-INDEX h0 "?arg0 ")"crlf)
)

;generates LTOP and INDEX values for causative.
;ex. SikRikA ne CAwroM se kakRA ko sAPa karAyA.
;(MRS_info id-MRS_concept-LBL-ARG0-ARG1-ARG2 40100 _make_v_cause h1 e2 x28 h4)
(defrule make-LTOP
(id-morph_sem	?id	causative)
(MRS_info  id-MRS_concept-LBL-ARG0-ARG1-ARG2 ?id1 _make_v_cause ?lbl ?arg0 $?vars)
=>
    (printout ?*rstr-fp* "(LTOP-INDEX h0 "?arg0 ")" crlf)
    (printout ?*rstr-dbug* "(rule-rel-values causative-LTOP LTOP-INDEX h0 "?arg0 ")"crlf)
)

;generates LTOP and INDEX values for double causative.
(defrule ask-LTOP
(id-morph_sem	?id	doublecausative) 
(MRS_info  id-MRS_concept-LBL-ARG0-ARG1-ARG2-ARG3 ?id _ask_v_1 ?lbl ?arg0 $?vars)
=>
    (printout ?*rstr-fp* "(LTOP-INDEX h0 "?arg0 ")" crlf)
    (printout ?*rstr-dbug* "(rule-rel-values dubcau-LTOP LTOP-INDEX h0 "?arg0 ")"crlf)
)

;generates LTOP and INDEX values for existential verb(s).
;ex. ladakA xilli meM hE.
(defrule Existential-LTOP
(id-cl	 ?v	 hE_1|WA_1)
?f<-(rel-ids k7p|k7 ?v ?id2)
(MRS_info ?rel ?id3 ?endsWith_p ?lbl ?arg0 ?arg1 ?arg2)
(test  (or (eq (sub-string (- (str-length ?endsWith_p) 1) (str-length ?endsWith_p) ?endsWith_p) "_p")        (eq ?endsWith_p "loc_nonsp")))
=>
(retract ?f)
    (printout ?*rstr-fp* "(LTOP-INDEX h0 "?arg0 ")" crlf)
    (printout ?*rstr-dbug* "(rule-rel-values Existential-LTOP LTOP-INDEX h0 "?arg0 ")"crlf)
) 

;replace the ARG1 value of superl with the ARG0 value adjective, and
;replace the LBL value of superl with the LBL value of adjective
(defrule superlative
?f<-(MRS_info id-MRS_concept-LBL-ARG0-ARG1 ?super superl ?l ?a0 ?a1)
(MRS_info id-MRS_concept-LBL-ARG0-ARG1 ?adj  ?adj_concept ?l1 ?a01 ?a11)
(id-morph_sem	?adj	superl)
(rel-ids	mod	?n	?adj)
(MRS_info ?rel ?n ?mrscon ?l2 $?)
=>
(retract ?f)
(printout ?*rstr-fp* "(MRS_info id-MRS_concept-LBL-ARG0-ARG1 "?super" superl "?l2" "?a0" "?a01")"crlf)
(printout ?*rstr-dbug* "(rule-rel-values superlative  id-MRS_concept-LBL-ARG0-ARG1 "?super" superl "?l2" "?a0" "?a01")"crlf)
)

(defrule printFacts
(declare (salience -9000))
?f<-(MRS_info ?rel ?kri ?mrsCon ?lbl $?vars)
(test (eq (str-index unspec_adj ?mrsCon) FALSE))
(test (eq (str-index which_q ?mrsCon) FALSE))
(test (eq (str-index _near_p ?mrsCon) FALSE))

=>
(retract ?f)
(printout ?*rstr-fp* "(MRS_info " ?rel " "?kri " "?mrsCon " "?lbl" " (implode$ (create$ $?vars)) ")" crlf)
(printout ?*rstr-dbug* "(rule-rel-values printFacts " ?rel " "?kri " "?mrsCon " "?lbl" " (implode$ (create$ $?vars)) ")"crlf)
)

;(MRS_info id-MRS_concept-LBL-ARG0-CARG 10000 named h1 x2 n3)
;(MRS_info id-MRS_concept-LBL-ARG0-RSTR-BODY 10010 proper_q h4 x5 h6 h7)
;(MRS_info id-MRS_concept-LBL-ARG0-RSTR-BODY -1010 udef_q h15 x16 h17 h18)
;(MRS_info id-MRS_concept-LBL-ARG0-L_INDEX-R_INDEX -1000 _and_c h19 x20 x21 x22)

;Replacing ARG0 of implicit mrs concepts like _a_q, pronoun_q with the ARG0 value of their head
(defrule mrs-info_q
(declare (salience 1000))
(MRS_info ?rel2 ?head ?mrsCon ?lbl2 ?ARG_0 $?v)
?f<-(MRS_info ?rel1 ?dep ?endsWith_q ?lbl1 ?x $?vars)
(test (neq ?endsWith_q ?mrsCon))
;(test (eq (sub-string 1 1 (implode$ (create$ ?head))) (sub-string 1 1 (implode$ (create$ ?dep)))))
(test (> ?dep ?head))
(test (eq  (+ ?head 10) ?dep)) 
(test (or (neq (str-index "_q" ?endsWith_q)FALSE) (neq (str-index "_qdem" ?endsWith_q)FALSE))) ;The boy is good. That book is beautiful.
(test (neq (sub-string (- (str-length ?mrsCon) 1) (str-length ?mrsCon) ?mrsCon) "_p"))
(test (neq (sub-string (- (str-length ?mrsCon) 6) (str-length ?mrsCon) ?mrsCon) "_p_temp"))
(not (modified_conj ?head))
;(not (which_bind_notrequired ?dep))
(test (eq (str-index "_a_" ?mrsCon)FALSE))
(test (eq (str-index "_v_" ?mrsCon)FALSE)) ;%imperatives
(test (eq (str-index card ?mrsCon)FALSE)) ;Three barked.
=>
(retract ?f)
(printout ?*rstr-fp*   "(MRS_info  "?rel1 " " ?dep " " ?endsWith_q " " ?lbl1 " " ?ARG_0 " " (implode$ (create$ $?vars)) ")"crlf)
(printout ?*rstr-dbug* "(rule-rel-values  mrs-info_q "?rel1 " " ?dep " " ?endsWith_q " " ?lbl1 " "?ARG_0 " " (implode$ (create$ $?vars)) ")"crlf)
)

;Rule to the share the value of head's ARG0 with the dependent's ARG1 
;Each kid is playing. Exceptional Case for Quantifiers with quant relation. 
(defrule rstr-rstd4non-implicit
(rel-ids quant ?head ?dep) 
(MRS_info ?rel2 ?head ?mrsCon ?lbl2 ?ARG_0 $?v)
?f<-(MRS_info ?rel1 ?dep ?endsWith_q ?lbl1 ?x $?vars)
(test (eq (str-index _v_ ?mrsCon) FALSE)) ;Some barked
=>
(retract ?f)
(printout ?*rstr-fp*   "(MRS_info  "?rel1 " " ?dep " " ?endsWith_q " " ?lbl1 " " ?ARG_0 " " (implode$ (create$ $?vars)) ")"crlf)
(printout ?*rstr-dbug* "(rule-rel-values rstr-rstd4non-implicit "?rel1 " " ?dep " " ?endsWith_q " " ?lbl1 " "?ARG_0 " " (implode$ (create$ $?vars)) ")"crlf)
)

;Rule for creating binding with verb and the word _frequent_a_1.
;It creates frequent lbl same as verb lbl and arg1 will be same as arg0 of verb.
;#राम खा -खाकर मोटा हो गया ।
(defrule frequent
;(declare (salience 100))
(rel-ids	rpk ?kriyA ?id)
?f<-(MRS_info id-MRS_concept-LBL-ARG0-ARG1 ?idd _frequent_a_1 ?lbl ?arg0 ?arg1)
(MRS_info ?rell ?id ?mrsCon ?lbl1 ?arg01 ?arg11 $?v)
(test (neq (str-index "_v_" ?mrsCon)FALSE))
(test (eq (+ ?id 2) ?idd))
=>
(retract ?f)
(printout ?*rstr-fp* "(MRS_info id-MRS_concept-LBL-ARG0-ARG1 "?idd" _frequent_a_1 "?lbl1" "?arg0" "?arg01")"crlf)
(printout ?*rstr-dbug* "(rule-rel-values frequent  id-MRS_concept-LBL-ARG0-ARG1 "?idd" _frequent_a_1 "?lbl1" "?arg0" "?arg01")"crlf)
)

;Rule for binding comparitive degree "comp, comp_less, comp_equal" node with the adjective it specifies and the person it compares.
;It replaces lbl of adjective with the lbl of comp, and arg0 of adjective with the arg1 of comp, and arg0 of upamAna with the arg2 of comp. 
;#rAma mohana se jyAxA buxXimAna hE.
(defrule compermore-bind
(or (id-morph_sem	?adjid	compermore) (id-morph_sem	?adjid	comperless) (rel-ids	k1s	?kri	?adjid))
(or (rel-ids ru|rv ?id ?id1) (rel-ids	degree	?adjid	?id1));?id = upameya/rAma, ?id1 = upamAna/mohana
?f<-(MRS_info id-MRS_concept-LBL-ARG0-ARG1-ARG2 ?compid ?MRSCON ?l ?a0 ?a1 ?a2)
(MRS_info ?rel11 ?adjid ?mrs_adj ?lbl ?arg0 $?varr)
(MRS_info ?rel ?id1 ?mrs ?lbll ?arg $?v)
(test (neq (str-index _a_ ?mrs_adj) FALSE))
(test (or (eq ?MRSCON  comp)(eq ?MRSCON comp_less) (eq ?MRSCON comp_equal) (eq ?MRSCON measure)))
=>
(retract ?f)
(printout ?*rstr-fp* "(MRS_info id-MRS_concept-LBL-ARG0-ARG1-ARG2 "?compid" "?MRSCON" "?lbl" "?a0" "?arg0" "?arg" )"crlf)
(printout ?*rstr-dbug* "(rule-rel-values comper-more-bind  id-MRS_concept-LBL-ARG0-ARG1-ARG2 "?compid" "?MRSCON" "?lbl" "?a0" "?arg0" "?arg")"crlf)
)

;Rule for changing L-INDEX and R-INDEX of conj with the ARG0 of the component before _and_c  and the component after _and_c respectively
;Rule for changing arg0 of udef_q with ARG0 of _and_c.
;This rule creates binding for _and_c and will be available for sentences having more coordination words. 
;The ARG0 of _and_c will be available and replace with the previous implicit_conj R-INDEX
;#rAma, hari Ora sIwA acCe hEM.
;Rama buxXimAna, motA, xilera, Ora accA hEM.
;rAma Ora sIwA acCe hEM.
(defrule conj
(declare (salience 100))
(cxnlbl-id-values ?conj ?conjid $?varrrrrr ?op1 ?op2)
(cxnlbl-id-val_ids	?conj	?conjid $?vars ?id1 ?id2)
(test (neq (str-index "conj_" ?conj) FALSE))
?f<-(MRS_info id-MRS_concept-LBL-ARG0-L_INDEX-R_INDEX ?id _and_c ?l ?a0 ?li ?ri)
(MRS_info ?rel1 ?id1 ?name ?lbl ?arg0 $?var)
(MRS_info ?rel2 ?id2 ?name2 ?lbl1 ?arg00 $?varss)
;(test (neq (str-index conj_ ?conj) FALSE))
(not (modified_conj ?id))
;(not (rel-ids	mod	?id1	?id3)) 
=>
(retract ?f)
(assert (modified_conj ?id))
(assert (conj_ARG0 ?id ?a0))
(assert (MRS_info id-MRS_concept-LBL-ARG0-L_INDEX-R_INDEX ?id _and_c ?l ?a0 ?arg0 ?arg00))
(printout ?*rstr-fp*  "(MRS_info id-MRS_concept-LBL-ARG0-L_INDEX-R_INDEX "?id" _and_c "?l" "?a0" "?arg0" "?arg00")"crlf)
(printout ?*rstr-dbug* "(rule-rel-values conj  id-MRS_concept-LBL-ARG0-L_INDEX-R_INDEX "?id" _and_c "?l" "?a0" "?arg0" "?arg00")"crlf)
;(printout ?*rstr-dbug* "(rule-rel-values conj  conj_ARG0 "?id" "?a0")"crlf)
)

;Rule for converting R-INDEX of implicit_conj with ARG0 of _and_c and then ARG0 of immediate implicit_conj with R-INDEX of immidiate next implicit_conj and so on.
;Rule for converting L-INDEX of implicit_conj with  arg0 of previous component it brings (200). This process also continues until the last implicit_conj
;Rule for converting udef_q arg0 with arg0 of implicit_conj
;#rAma, hari Ora sIwA acCe hEM.
;Rama buxXimAna, motA, xilera, Ora accA hEM.

(defrule conj-implicit
(declare (salience 1000))
(cxnlbl-id-values ?conJ ?conjid $?varsssss ?op1 ?op2 $?vaaaaaa)
(cxnlbl-id-val_ids	?conJ	?conjid $?vars ?id1 ?id2 $?va)
?f<-(MRS_info id-MRS_concept-LBL-ARG0-L_INDEX-R_INDEX ?id implicit_conj ?l ?a0 ?li ?ri)
?f3<-(MRS_info ?rel1 ?id1 ?con1 ?l1 ?a01 $?var)
?f2<-(conj_ARG0 ?conj ?Pre_A0)
(not (modified_implicit_conj ?id))
(not (modified_implicit_main ?id1))
;(test (eq  (-  (string-to-field (sub-string 1 1 (str-cat ?conj))) 1)  (string-to-field (sub-string 1 1 (str-cat ?id)))  (string-to-field (sub-string 1 1 (str-cat ?id1)) ) ))
(test (eq  (+ ?id1 200) ?id))
(test (neq (str-index "conj_" ?conJ) FALSE))
=>
(retract ?f2)
(assert (modified_implicit_main ?id1))
(assert (modified_implicit_conj ?id1))
(assert (conj_ARG0 ?id ?a0))
(printout ?*rstr-fp*  "(MRS_info id-MRS_concept-LBL-ARG0-L_INDEX-R_INDEX "?id" implicit_conj "?l" "?a0" "?a01" "?Pre_A0")"crlf)
(printout ?*rstr-dbug* "(rule-rel-values conj-implicit  id-MRS_concept-LBL-ARG0-L_INDEX-R_INDEX "?id" implicit_conj "?l" "?a0" "?a01" "?Pre_A0")"crlf)
)

;generates LTOP and INDEX values for predicative adjective(s).
;ex. rAma acCA hE.   rAma, sIwA, hari and mohana acCe hEM.
(defrule samAnAXi-LTOP
(id-cl       ?v   hE_1|WA_1)
(rel-ids   k1s        ?id  ?id_adj)
(MRS_info ?rel ?id_adj ?mrsCon ?lbl ?arg0 $?vars)
;(not (LTOP_value_geneated_4_construction))
;(not (LTOP_value_geneated_4_disjunct_construction))
(test (neq (str-index _a_ ?mrsCon) FALSE)) 
(not (rel-ids samuccaya ?non	?id))
(not (rel-ids anyawra ?non	?id))
(not (rel-ids viroXi ?non	?id))
=>
    (printout ?*rstr-fp* "(LTOP-INDEX h0 "?arg0 ")" crlf)
    (printout ?*rstr-dbug* "(rule-rel-values samAnAXi-LTOP LTOP-INDEX h0 "?arg0 ")"crlf)
)  

;Rule for binding udef_q, and_c with the modifier and the nouns.
;We met the old men and women.
(defrule conj-mod
(cxnlbl-id-values ?conJ ?conjid $?VAR ?op1 ?op2)
(cxnlbl-id-val_ids	?conJ	?conjid $?vars ?id1 ?id2)
(rel-ids	mod	?id1	?id3)
?f<-(MRS_info id-MRS_concept-LBL-ARG0-L_INDEX-R_INDEX ?id _and_c ?l ?a0 ?li ?ri)
?f2<-(MRS_info ?rel1 ?id3 ?modifier ?lbl ?arg0 ?arg1)
?f3<-(MRS_info id-MRS_concept-LBL-ARG0-ARG1-ARG2 ?id4 ?verb ?lbl3 ?arg03 ?arg13 ?arg23)
(MRS_info ?rel2 ?id1 ?name2 ?lbl1 ?arg00 $?varss)
(MRS_info ?rel3 ?id2 ?name1 ?lbl2 ?arg02 $?varsss)
(test (neq (str-index "conj_" ?conJ) FALSE))
=>
(retract ?f)
(printout ?*rstr-fp*  "(MRS_info id-MRS_concept-LBL-ARG0-L_INDEX-R_INDEX "?id" _and_c "?l" "?a0" "?arg00" "?arg02")"crlf)
(printout ?*rstr-dbug* "(rule-rel-values conj-mod  id-MRS_concept-LBL-ARG0-L_INDEX-R_INDEX "?id" _and_c "?l" "?a0" "?arg00" "?arg02")"crlf)
(printout ?*rstr-fp* "(MRS_info "?rel1" "?id3" "?modifier" "?l" "?arg0" "?a0")"crlf)
(printout ?*rstr-dbug* "(rule-rel-values conj-mod "?rel1" "?id3" "?modifier" "?l" "?arg0" "?a0" )"crlf)
(printout ?*rstr-fp* "(MRS_info id-MRS_concept-LBL-ARG0-ARG1-ARG2 "?id4" "?verb" "?lbl3" "?arg03" "?arg13" "?a0")"crlf)
(printout ?*rstr-dbug* "(rule-rel-values conj-mod id-MRS_concept-LBL-ARG0-ARG1-ARG2 "?id4" "?verb" "?lbl3" "?arg03" "?arg13" "?a0")"crlf)
)

;Rule for binding LTOP_INDEX with arg0 of unknown typed feature.
;#kuwwA!
;#billI Ora kuwwA.
(defrule unknown_LTOP
(sent_type	)
(MRS_info id-MRS_concept-LBL-ARG0-ARG 0 unknown ?lbl ?arg0 ?arg1)
=>
(printout ?*rstr-fp* "(LTOP-INDEX h0 "?arg0 ")" crlf)
(printout ?*rstr-dbug* "(rule-rel-values unknown_LTOP LTOP-INDEX h0 "?arg0 ")"crlf)
)

;Rule to change arg value of unknown with arg0 of the word it brough from. 
;;#kuwwA! for this sentence the arg0 of dog will go for the arg1 of the unknown
;Not applicable for the sentences having more than two words in construction. 
(defrule unknown_bind
(sent_type	)
(MRS_info id-MRS_concept-LBL-ARG0-ARG 0 unknown ?lbl ?arg0 ?arg1)
(MRS_info id-MRS_concept-LBL-ARG0 ?noun ?mrsCon ?lbl1 ?arg01)
(not (cxnlbl-id-values $?var))
=>
(printout ?*rstr-fp* "(MRS_info  id-MRS_concept-LBL-ARG0-ARG  0 unknown "?lbl" " ?arg0 " " ?arg01 ")"crlf)
(printout ?*rstr-dbug* "(rule-rel-values unknown_bind id-MRS_concept-LBL-ARG0-ARG  0 unknown "?lbl" " ?arg0 " " ?arg01 ")"crlf)
)

;Rule for binding ARG0 of conj with ARG of unknown when the construction is in two words.
;;#billI Ora kuwwA. 
(defrule unknown_conj
(declare (salience 2000))
(sent_type	 )
(cxnlbl-id-values ?conJ ?conjid ?op1 ?op2)
(cxnlbl-id-val_ids	?conJ	?conjid ?id1 ?id2)
?f<-(MRS_info id-MRS_concept-LBL-ARG0-ARG 0 unknown ?lbl ?arg0 ?arg1)
(MRS_info id-MRS_concept-LBL-ARG0-L_INDEX-R_INDEX ?conjid _and_c ?lbl1 ?Arg0 $?v)
(test (neq (str-index "conj_" ?conJ) FALSE))
=>
(printout ?*rstr-fp* "(MRS_info  id-MRS_concept-LBL-ARG0-ARG  0 unknown "?lbl" " ?arg0 " " ?Arg0 ")"crlf)
(printout ?*rstr-dbug* "(rule-rel-values unknown_conj id-MRS_concept-LBL-ARG0-ARG  0 unknown "?lbl" " ?arg0 " " ?Arg0 ")"crlf)
)

;Rule for binding LTOP h0 with the lbl of the unsepc_adj. 
; How are you?
(defrule how-k1s-ltop
(rel-ids	k1s	?kri	?how)
(id-cl	?how	$kim)
(sent_type  %interrogative)
(MRS_info ?rel1  ?id1  unspec_adj ?lbl1 ?arg10 ?arg11 $?var)
(not (id-morph_sem	?how	?n))
(not (id-anim	?how	yes))
=>
(printout ?*rstr-fp* "(LTOP-INDEX h0 "?arg10 ")" crlf)
(printout ?*rstr-dbug* "(rule-rel-values how-k1s-ltop LTOP-INDEX h0 "?arg10 ")"crlf)
)

;Rule for binding unsepc_adj, which_q, prpstn_to_prop with property and the pronoun. 
;How are you?

(defrule how-k1s
(declare (salience 1000))
(id-cl	?how	$kim)
(rel-ids	k1s	?kri	?how)
(sent_type  %interrogative)
?f<-(MRS_info id-MRS_concept-LBL-ARG0-ARG1 ?us unspec_adj ?lus ?a0us ?a1us)
?f1<-(MRS_info id-MRS_concept-LBL-ARG0-ARG1-ARG2 ?ptp prpstn_to_prop ?lptp ?a0ptp ?a1ptp ?a2ptp)
?f2<-(MRS_info id-MRS_concept-LBL-ARG0-RSTR-BODY ?wq which_q ?wl ?a0w ?rsw ?bdw)
(MRS_info id-MRS_concept-LBL-ARG0 ?noun pron ?lbl1 ?arg01)
(MRS_info id-MRS_concept-LBL-ARG0 ?p property ?lp ?a0p)
;(test (neq (str-index pron ?mrscon) FALSE))
;(MRS_info id-MRS_concept-LBL-ARG0 10000 pron h1 x2)
(not (id-morph_sem	?how	?n))
(not (id-anim	?how	yes))
=>
(printout ?*rstr-fp* "(MRS_info id-MRS_concept-LBL-ARG0-ARG1 "?us" unspec_adj "?lus" "?a0us" "?arg01")"crlf)
(printout ?*rstr-dbug* "(rule-rel-values how-k1s id-MRS_concept-LBL-ARG0-ARG1 "?us" unspec_adj "?lus" "?a0us" "?arg01")"crlf)

(printout ?*rstr-fp* "(MRS_info id-MRS_concept-LBL-ARG0-RSTR-BODY "?wq" which_q "?wl" "?a0p" "?lp" "?bdw")"crlf)
(printout ?*rstr-dbug* "(rule-rel-values how-k1s id-MRS_concept-LBL-ARG0-RSTR-BODY "?wq" which_q "?wl" "?a0p" "?lp" "?bdw")"crlf)

(printout ?*rstr-fp* "(MRS_info id-MRS_concept-LBL-ARG0-ARG1-ARG2 "?ptp" prpstn_to_prop "?lptp" "?a0ptp" "?lus" "?a0p")"crlf)
(printout ?*rstr-dbug* "(rule-rel-values how-k1s id-MRS_concept-LBL-ARG0-ARG1-ARG2 "?ptp" prpstn_to_prop "?lptp" "?a0ptp" "?lus" "?a0p")"crlf)
)
;Rule for not binding which_q with the head of the word it modifies. 
;How are you?
(defrule $kim-which
(declare (salience 10000))
(id-cl	?how	$kim)
(rel-ids	k1s|degree	?kri	?how)
(MRS_info id-MRS_concept-LBL-ARG0-RSTR-BODY ?wq which_q ?wl ?a0w ?rsw ?bdw)
(not (id-morph_sem	?how	?n)) 
(not (id-anim	?how	yes))
=>
(assert (which_bind_notrequired ?wq))
(printout ?*rstr-dbug* "(rule-rel-values  $kim-which which_bind_notrequired " ?wq ")"crlf)
)

;Rule for binding preposition with k1s. CHECK AGAIN
;Am I the best king in the world?
(defrule prep-noun-k1s
(declare (salience 10000))
(rel-ids ?relp ?kriyA ?karak)
(rel-ids	k1s	?kriyA	?karwA)
?f<-(MRS_info ?rel_name ?prep ?endsWith_p ?lbl ?arg0 ?arg1 $?v)
(MRS_info ?rel1 ?karwA ?mrsCon1 ?lbl1 ?argv_0 $?vars)
(MRS_info ?rel2 ?karak ?mrsCon2 ?lbl2 ?argn_0 $?varss)
(test (eq (sub-string 1 1 (str-cat ?prep)) (sub-string 1 1 (str-cat ?karak))))
(test (eq (sub-string (- (str-length ?endsWith_p) 1) (str-length ?endsWith_p) ?endsWith_p) "_p"))
(test (or (neq (str-index "_n_" ?mrsCon2)FALSE) (eq ?mrsCon2 nominalization) ))
=>
(retract ?f)
(printout ?*rstr-fp* "(MRS_info  " ?rel_name " " ?prep " " ?endsWith_p " " ?lbl1 " " ?arg0 " " ?argv_0 " " ?argn_0 ")"crlf)
(printout ?*rstr-dbug* "(rule-rel-values prep-noun-k1s "?rel_name " " ?prep " " ?endsWith_p " " ?lbl1" " ?arg0 " " ?argv_0 " " ?argn_0 ")"crlf)
)

;Rule for changing ARG0 of udef_q with _or_c.
;Rule for changing _or_c l-index and r-index with arg0 of the first disjunct entry and arg0 of the second disjunct entry repectively.
;I like tea or coffee. 
(defrule disjunct
(declare (salience 1000))
(construction-ids	disjunct	$?vars ?id1 ?id2)
?f<-(MRS_info id-MRS_concept-LBL-ARG0-L_INDEX-R_INDEX ?id _or_c ?l ?a0 ?li ?ri)
(MRS_info ?rel1 ?id1 ?name ?lbl ?arg0 $?var)
(MRS_info ?rel2 ?id2 ?name2 ?lbl1 ?arg00 $?varss)
(not (modified_disjunct ?id))
=>
(retract ?f)
(assert (modified_disjunct ?id))
(assert (MRS_info id-MRS_concept-LBL-ARG0-L_INDEX-R_INDEX ?id _or_c ?l ?a0 ?arg0 ?arg00))
(printout ?*rstr-fp*  "(MRS_info id-MRS_concept-LBL-ARG0-L_INDEX-R_INDEX "?id" _or_c "?l" "?a0" "?arg0" "?arg00")"crlf)
(printout ?*rstr-dbug* "(rule-rel-values disjunct  id-MRS_concept-LBL-ARG0-L_INDEX-R_INDEX "?id" _or_c "?l" "?a0" "?arg0" "?arg00")"crlf)
(printout ?*rstr-dbug* "(rule-rel-values disjunct  disjunct_ARG0 "?id" "?a0")"crlf)
)

;Rule for binding L_HNDL of _or_c with the previous LBL of the word. R_HNDL with the LBl fo the preceeding word.
;Rule for binding L-INDEX of _or_c with the ARG0 of previous word and R-INDEX with the preceding word ARG0 
;It also provides LBL and ARG0 of _and_c for the next rule. 
;Is Rama good or bad?
(defrule disjunct-pred
(declare (salience 1000))
(construction-ids	disjunct	$?vars ?id1 ?id2)
?f<-(MRS_info id-MRS_concept-LBL-ARG0-L_INDEX-R_INDEX-L_HNDL-R_HNDL ?id _or_c ?l ?a0 ?li ?ri ?lh ?rh)
(MRS_info ?rel1 ?id1 ?name ?lbl ?arg0 $?var)
(MRS_info ?rel2 ?id2 ?name2 ?lbl1 ?arg00 $?varss)
(not (modified_disjunct ?id))
=>
(assert (modified_disjunct ?id))
(assert (or_LBL_ARG0 ?id ?l ?a0 ))
(printout ?*rstr-fp*  "(MRS_info id-MRS_concept-LBL-ARG0-L_INDEX-R_INDEX-L_HNDL-R_HNDL "?id" _or_c "?l" "?a0" "?arg0" "?arg00" "?lbl" "?lbl1")"crlf)
(printout ?*rstr-dbug* "(rule-rel-values disjunct-pred  id-MRS_concept-LBL-ARG0-L_INDEX-R_INDEX-L_HNDL-R_HNDL "?id" _or_c "?l" "?a0" "?arg0" "?arg00" "?lbl" "?lbl1")"crlf)
(printout ?*rstr-dbug* "(rule-rel-values disjunct-pred  or_LBL_ARG0 "?id" "?l" "?a0")"crlf)
)


;Rule for creating TAM for adjectives differently in the disjunct relation. 
;Is Rama good or bad?
(defrule disjunct-tam
(construction-ids	disjunct	?id1 ?id2)
(id-hin_concept-MRS_concept ?id1 ?hin ?mrscon)
(id-hin_concept-MRS_concept ?id2 ?hin1 ?mrscon1)
(test (neq (str-index _a_ ?mrscon) FALSE))
(test (neq (str-index _a_ ?mrscon1) FALSE))
=>
(printout ?*rstr-fp* "(id-SF-TENSE-MOOD-PROG-PERF "?id1 " prop pres indicative - - )"crlf)
(printout ?*rstr-dbug* "(rule-rel-values disjunct-tam id-SF-TENSE-MOOD-PROG-PERF "?id1 " prop pres indicative - - )"crlf)
(printout ?*rstr-fp* "(id-SF-TENSE-MOOD-PROG-PERF "?id2 " ques untensed indicative - - )"crlf)
(printout ?*rstr-dbug* "(rule-rel-values disjunct-tam id-SF-TENSE-MOOD-PROG-PERF "?id2 " ques untensed indicative - - )"crlf)
)

;Rule for creating TAM for disjunct _or_c when it has k1s disjunct entries.
;Is Rama good or bad?
(defrule or-tam
(sent_type  %yn_interrogative)
(MRS_info id-MRS_concept-LBL-ARG0-L_INDEX-R_INDEX-L_HNDL-R_HNDL ?or _or_c ?l ?a0 ?li ?ri ?lh ?rh)
(U_TAM-LS_TAM-Perfective_Aspect-Progressive_Aspect-Tense-Modal  ?tam ?e_tam ?perf ?prog ?tense ?)
=>
(printout ?*rstr-fp* "(id-SF-TENSE-MOOD-PROG-PERF "?or " ques pres indicative - - )"crlf)
(printout ?*rstr-dbug* "(rule-rel-values or-tam id-SF-TENSE-MOOD-PROG-PERF "?or" ques pres indicative - - )"crlf)
)

;Rule for binding _near_p with the 
;The car is near the house.
(defrule near-binding
(rel-ids	k1	?verb	?karwa)
(rel-ids	rdl	?near	?k7p)
?f<-(MRS_info id-MRS_concept-LBL-ARG0-ARG1-ARG2 ?near ?MRSCON ?l ?a0 ?a1 ?a2)
(MRS_info ?rellll ?karwa ?mrscon ?ln ?na0 $?var)
(MRS_info ?relll ?k7p ?mrsCon ?lbl ?aa0 $?vv) ;The cart is near the temple.
=>
(printout ?*rstr-fp* "(MRS_info id-MRS_concept-LBL-ARG0-ARG1-ARG2 "?near" "?MRSCON" " ?l" "?a0" "?na0" "?aa0")"crlf)
(printout ?*rstr-dbug* "(rule-rel-values near_binding id-MRS_concept-LBL-ARG0-ARG1-ARG2 "?near" "?MRSCON" " ?l" "?a0" "?na0" "?aa0")"crlf)
)

;Rule for creating TAM for _near_p
;The car is near the house.
(defrule near-tam
(id-cl	?near	pAsa_2)
(MRS_info id-MRS_concept-LBL-ARG0-ARG1-ARG2 ?near _near_p ?l ?a0 ?a1 ?a2)
(U_TAM-LS_TAM-Perfective_Aspect-Progressive_Aspect-Tense-Modal  ?tam ?e_tam ?perf ?prog ?tense ?)
=>
(printout ?*rstr-fp* "(id-SF-TENSE-MOOD-PROG-PERF "?near " prop pres indicative - - )"crlf)
(printout ?*rstr-dbug* "(rule-rel-values near-tam id-SF-TENSE-MOOD-PROG-PERF "?near" prop pres indicative - - )"crlf)
)

;Rule for generating the year number in the CARG value.
;She was born in 1999.
(defrule yoc_carg_number
(id-cl	?numid	?num)
(id-yoc	?numid	yes)
(rel-ids	k7t	?kri	?numid)
?f<-(MRS_info id-MRS_concept-LBL-ARG0-CARG ?numid yofc ?lbl ?arg0 ?carg)
=>
(printout ?*rstr-fp* "(MRS_info id-MRS_concept-LBL-ARG0-CARG "?numid" yofc " ?lbl" "?arg0" "?num")"crlf)
(printout ?*rstr-dbug* "(rule-rel-values yoc_carg_number id-MRS_concept-LBL-ARG0-CARG "?numid" yofc " ?lbl" "?arg0" "?num")"crlf)
)

;Rule for binding ms_n_1 and _mister_n_1 with the compound for the sentence ; Ms. Rajini admitted her son and her daughter in the Kashi's largest school in Banaras. ;Mr. Sanju came.

(defrule _ms_n_1
(declare (salience 1000))
(id-speakers_view  ?id  respect)
(rel-ids ?rel ?idd ?id)
(or (id-female	?id1	yes) (id-male	?id1	yes))
(not(id-cl	?id 	$addressee))
?f1<-(MRS_info id-MRS_concept-LBL-ARG0-ARG1-ARG2 ?comp compound ?l ?a0 ?a1 ?a2)
(MRS_info id-MRS_concept-LBL-ARG0 ?msn ?MRSCON ?lb ?ar0)
(MRS_info id-MRS_concept-LBL-ARG0-CARG ?name named ?lbb ?argg ?v)
(test (or (eq ?MRSCON  _ms_n_1)(eq ?MRSCON _mister_n_1)))
=>
(printout ?*rstr-fp* "(MRS_info id-MRS_concept-LBL-ARG0-ARG1-ARG2 "?comp" compound " ?lbb" "?a0" "?argg" "?ar0" )"crlf)
(printout ?*rstr-dbug* "(rule-rel-values _ms_n_1 id-MRS_concept-LBL-ARG0-ARG1-ARG2 "?comp" compound " ?lbb" "?a0" "?argg" "?ar0" )"crlf)
)


;Rule for changing season CARG value to season name. 
;The snow falls in winter.
(defrule season_name
(declare (salience 1000))
(id-cl	?id	?cl)
(cl-ls-mrs ?cl ?english season)
(id-season	?id	yes)
?f<-(MRS_info id-MRS_concept-LBL-ARG0-CARG ?id season ?l ?a0 ?val)
(not (english_replaced ?id))
=>
(retract ?f)
(assert (english_replaced ?id))
(if (neq (str-index "_" ?english) FALSE) then
  (bind ?myEnglish (string-to-field (sub-string 0 (- (str-index "_" ?english )1) ?english))) ;removing "_digit" from e_concept_label, ex. "winter_2" => "winter"
     (assert (MRS_info  id-MRS_concept-LBL-ARG0-CARG ?id season ?l ?a0 ?myEnglish ) )
     (printout ?*rstr-dbug* "(rule-rel-values season_name id-MRS_concept-LBL-ARG0-CARG "?id" " season " "?l" "?a0" "?myEnglish")"crlf)
else
   (printout ?*rstr-fp* "(MRS_info  id-MRS_concept-LBL-ARG0-CARG "?id" " season " "?l" "?a0" "?english")"crlf)
   (printout ?*rstr-dbug* "(rule-rel-values season_name  id-MRS_concept-LBL-ARG0-CARG "?id" " season " "?l" "?a0" "?english")"crlf)
)
)


;Rule for generating LTOP with INDEX value for a sentence without a verb and having $kim word with relation k5 and animacy in the semantic category. 
;Who is Rama afraid of? 
(defrule k5_anim_$kim_LTOP
(declare (salience 100))
(id-cl ?id $kim)
(rel-ids	k5	?kri	?id)
(sent_type  %interrogative)
(MRS_info ?rell ?kri ?mrscon ?l ?a0 $?v)
(test (eq (str-index _v_ ?mrscon) FALSE))
=>
(printout ?*rstr-fp* "(LTOP-INDEX  h0  "?a0 ")" crlf)
(printout ?*rstr-dbug* "(rule-rel-values k5_anim_$kim_LTOP LTOP-INDEX  h0  "?a0 ")"crlf)
)

;Rule for binding k5+anim+$kim relation concept with kriya and karwa.
;#राम किससे डरता है
(defrule k5_anim_$kim
(id-cl ?id $kim)
(rel-ids	k5	?kri	?id)
(rel-ids	?rel	?kri	?karwa)
(sent_type  %interrogative)
(id-anim	?id	yes)
?f<-(MRS_info ?rel1 ?kri ?mrscc ?lb ?argo ?arg1 ?arg2 $?v1)
(MRS_info ?rel2 ?karwa ?mrscon ?l ?a0 $?v)
(MRS_info ?rel3 ?id ?hinkri ?lbll ?arg00 $?va)
=>
(retract ?f)
(printout ?*rstr-fp* "(MRS_info "?rel1" "?kri" "?mrscc" " ?lb" "?argo" "?a0" "?arg00" "(implode$ (create$ $?v1))")"crlf)
(printout ?*rstr-dbug* "(rule-rel-values k5_anim_$kim "?rel1" "?kri" "?mrscc" " ?lb" "?argo" "?a0" "?arg00" "(implode$ (create$ $?v1))" )"crlf)
)

;Rule for changing ARG2 value of rpk verb with the ARG0 of the head of r6 relation. 
;Having been listening to his word, the lion laughed. ;RECHECK FROM LION STORY
(defrule r6-rpk-arg2
(rel-ids	r6	?noun	?karwa)
(rel-ids	k2	?kriya	?noun)
(rel-ids	rpk	?kriya	?rpk)
?f<-(MRS_info ?rel1 ?rpk ?mrscc ?lb ?argo ?arg1 ?arg2 $?v1)
(MRS_info ?rel2 ?noun ?mrscon ?l ?a0 $?v)
=>
(retract ?f)
(printout ?*rstr-fp* "(MRS_info "?rel1" "?rpk" "?mrscc" " ?lb" "?argo" "?arg1" "?a0" "(implode$ (create$ $?v1))")"crlf)
(printout ?*rstr-dbug* "(rule-rel-values k5_anim_$kim "?rel1" "?rpk" "?mrscc" " ?lb" "?argo" "?arg1" "?a0" "(implode$ (create$ $?v1))" )"crlf)
)

;Rule for binding rbks nonfinite verb with the karwa. 
;The fruit eaten by Rama was sweet.
(defrule karwa-rbks
(rel-ids	rbks	?noun	?nonfinite)
(MRS_info ?rel ?noun ?mrscon ?lbl ?arg0)
?f<-(MRS_info ?rel1 ?nonfinite ?verbconcept ?lbl1 ?arg01 ?arg1 ?arg2 $?v)
=>
(assert (MRS_info ?rel1 ?nonfinite ?verbconcept ?lbl ?arg01 ?arg1 ?arg0))
(printout ?*rstr-dbug* "(rule-rel-values karwa-rbks "?rel1" "?nonfinite" "?verbconcept" " ?lbl" "?arg01" "?arg1" "?arg0" "(implode$ (create$ $?v))" )"crlf)
)

;Rule for generating TAM for rblsk verb
(defrule rblsk
?f<-(rel-ids	rblsk	?id	?kri)
=>
(retract ?f)
(printout ?*rstr-fp* "(id-SF-TENSE-MOOD-PROG-PERF "?kri " prop pres indicative - - )"crlf)
(printout ?*rstr-dbug* "(rule-rel-values rblsk id-SF-TENSE-MOOD-PROG-PERF "?kri " prop pres indicative - - )"crlf)
)

;rule for binding ARG1 and ARG2 of the preposition when "put" verb exists. 
;Abrams put Browne in the garden.
(defrule prep-verb
(rel-ids ?relp ?kriyA ?karak)
?f<-(MRS_info ?rel_name ?prep ?endsWith_p ?lbl ?arg0 ?arg1 $?v)
(MRS_info id-MRS_concept-LBL-ARG0-ARG1-ARG2-ARG3 ?kriyA ?mrsCon1 ?lbl1 ?argv_0 ?a1 ?arg2 ?arg3)
(MRS_info ?rel2 ?karak ?mrsCon2 ?lbl2 ?argn_0 $?varss)
(test (eq (sub-string (- (str-length ?endsWith_p) 1) (str-length ?endsWith_p) ?endsWith_p) "_p"))
=>
(retract ?f)
(printout ?*rstr-fp* "(MRS_info  " ?rel_name " " ?prep " " ?endsWith_p " " ?lbl " " ?arg0 " " ?arg2 " " ?argn_0 ")"crlf)
(printout ?*rstr-dbug* "(rule-rel-values prep-verb "?rel_name " " ?prep " " ?endsWith_p " " ?lbl" " ?arg0 " " ?arg2 " " ?argn_0 ")"crlf)
)

;Rule for creating binding with LBL of card with the generic_Entity lbl and ARG1 of card with ARG0 of generic_Entity and ARG0 of udef_q with ARG0 of generic_Entity and ARG1 of bark with generic_Entity.
;Changing CARG value of card into digit.
;Three barked.
(defrule generic_Entity
(id-cl	?id1	?number)
(id-numex	?id1	yes)
(rel-ids	k1	?kri	?id1)
(numeric ?number ?val)
(not (rel-ids	card	?kri	?id1))
(MRS_info id-MRS_concept-LBL-ARG0 ?id1 generic_entity ?lbll ?arg00)
?f1<-(MRS_info id-MRS_concept-LBL-ARG0-ARG1-CARG ?id1 ?card ?lbl2 ?arg02 ?arg021 ?carg)
=>
(retract ?f1)
(printout ?*rstr-fp* "(MRS_info id-MRS_concept-LBL-ARG0-ARG1-CARG "?id1" "?card" "?lbll" "?arg02" "?arg00" "?val" )"crlf)
(printout ?*rstr-dbug* "(rule-rel-values generic_Entity id-MRS_concept-LBL-ARG0-ARG1-CARG "?id1" "?card" "?lbll" "?arg02" "?arg00" "?val")"crlf)
)

;Rule for binding with the nominalized verb with the nominalization and the udef_q with the nominalization.
;#billi kA pICA karanA purAnA hE. 
(defrule nominalization
(declare (salience 100))
(id-cl	?nominalization	?mrsverb)
(rel-ids	k1	?mainverb	?nominalization)
?f<-(MRS_info id-MRS_concept-LBL-ARG0-ARG1 ?nominalized nominalization ?lbl ?arg0 ?arg1)
(MRS_info id-MRS_concept-LBL-ARG0-ARG1-ARG2 ?nominalization ?mrscon ?lbl1 ?arg01 ?arg011 ?arg02)
=>
(printout ?*rstr-fp* "(MRS_info id-MRS_concept-LBL-ARG0-ARG1 "?nominalized" nominalization "?lbl" "?arg0" "?lbl1")"crlf)
(printout ?*rstr-dbug* "(rule-rel-values nominalization id-MRS_concept-LBL-ARG0-ARG1 "?nominalized" nominalization "?lbl" "?arg0" "?lbl1")"crlf)
)

;Rule for binding with the nominalization with the noun. 
;#billi kA pICA karanA purAnA hE. 
(defrule nominalized
(rel-ids	k1	?mainverb	?nominalization)
(rel-ids	?rel	?nominalization	?noun)
(MRS_info id-MRS_concept-LBL-ARG0-ARG1 ?nominalized nominalization ?lbl ?arg0 ?arg1)
?f<-(MRS_info id-MRS_concept-LBL-ARG0-ARG1-ARG2 ?nominalization ?mrscon ?lbl1 ?arg01 ?arg011 ?arg02)
(MRS_info id-MRS_concept-LBL-ARG0 ?noun ?nounmrs ?lblb ?arg0000)
=>
(retract ?f)
(printout ?*rstr-fp* "(MRS_info id-MRS_concept-LBL-ARG0-ARG1-ARG2 "?nominalization" "?mrscon" "?lbl1" "?arg01" "?arg011" "?arg0000")"crlf)
(printout ?*rstr-dbug* "(rule-rel-values nominalized id-MRS_concept-LBL-ARG0-ARG1-ARG2 "?nominalization" "?mrscon" "?lbl1" "?arg01" "?arg011" "?arg0000")"crlf)
)

;Rule for creating TAM for the nominalized verb.
;#billi kA pICA karanA purAnA hE. 
(defrule nominalization-tam
(declare (salience 100))
(rel-ids	k1	?mainverb	?nominalization)
(rel-ids	?rel	?nominalization	?noun)
(MRS_info id-MRS_concept-LBL-ARG0-ARG1 ?nominalized nominalization ?lbl ?arg0 ?arg1)
?f<-(MRS_info id-MRS_concept-LBL-ARG0-ARG1-ARG2 ?nominalization ?mrscon ?lbl1 ?arg01 ?arg011 ?arg02)
=>
(printout ?*rstr-fp* "(id-SF-TENSE-MOOD-PROG-PERF "?nominalization " prop untensed indicative + - )"crlf)
(printout ?*rstr-dbug* "(rule-rel-values nominalization-tam id-SF-TENSE-MOOD-PROG-PERF "?nominalization " prop untensed indicative + - )"crlf)
)

;Rule for creating the binding with samuccaya _and_c with the verb of the sentence. 
;Rule for changing _and_c R_INDEX with arg0 of the verb and R_HNDL with LBL of verb
;And he is intelligent. #Ora vaha buxXimAna hE.
(defrule samuccaya_and-bind-verb
(or (rel-ids samuccaya ?previousid	?verb) (rel-ids anyawra ?previousid	?verb) (rel-ids viroXi ?previousid	?verb))
?f<-(MRS_info id-MRS_concept-LBL-ARG0-L_INDEX-R_INDEX-L_HNDL-R_HNDL ?and ?MRSCON ?lbl ?arg0 ?lindex ?rindex ?lhndl ?rhndl)
(MRS_info ?rel ?verb ?mrsss ?lblb ?arg00 $?v)
(test (or (eq ?MRSCON  _and_c)(eq ?MRSCON _or_c)(eq ?MRSCON _but_c)))
=>
(printout ?*rstr-fp* "(MRS_info id-MRS_concept-LBL-ARG0-L_INDEX-R_INDEX-L_HNDL-R_HNDL "?and" "?MRSCON" "?lbl" "?arg0" "?lindex" "?arg00" "?lhndl" "?rhndl")"crlf)
(printout ?*rstr-dbug* "(rule-rel-values samuccaya_and-bind-verb id-MRS_concept-LBL-ARG0-L_INDEX-R_INDEX-L_HNDL-R_HNDL "?and" "?MRSCON" "?lbl" "?arg0" "?lindex" "?arg00" "?lhndl" "?rhndl")"crlf)
)

;Rule for creating LTOP value with the _and_c arg0 value when samuccaya relation exists.
;And he is intelligent. #Ora vaha buxXimAna hE.
(defrule samuccaya-LTOP
(or (rel-ids samuccaya ?previousid	?verb) (rel-ids anyawra ?previousid	?verb) (rel-ids viroXi ?previousid	?verb))
?f<-(MRS_info id-MRS_concept-LBL-ARG0-L_INDEX-R_INDEX-L_HNDL-R_HNDL ?and ?MRSCON ?lbl ?arg0 ?lindex ?rindex ?lhndl ?rhndl)
(test (or (eq ?MRSCON  _and_c)(eq ?MRSCON _or_c)(eq ?MRSCON _but_c)))
=>
(printout ?*rstr-fp* "(LTOP-INDEX h0 "?arg0 ")" crlf)
(printout ?*rstr-dbug* "(rule-rel-values samuccaya-LTOP LTOP-INDEX h0 "?arg0 ")"crlf)
)

;Rule for creating binding LTOP with the lbl of _and_c and R_HNDL value with the lbl of the adjective.
;And he is intelligent. #Ora vaha buxXimAna hE.
(defrule samuccaya_and-bind-copula
(id-cl	?verb	hE_1)
(or (rel-ids samuccaya ?previousid	?verb) (rel-ids anyawra ?previousid	?verb) (rel-ids viroXi ?previousid	?verb))
(rel-ids	k1s	?verb	?adj)
?f<-(MRS_info id-MRS_concept-LBL-ARG0-L_INDEX-R_INDEX-L_HNDL-R_HNDL ?and ?MRSCON ?lbl ?arg0 ?lindex ?rindex ?lhndl ?rhndl)
(MRS_info ?rel ?adj ?mrsss ?lblb ?arg00 $?v)
(test (or (eq ?MRSCON  _and_c)(eq ?MRSCON _or_c)(eq ?MRSCON _but_c)))
=>
(printout ?*rstr-fp* "(MRS_info id-MRS_concept-LBL-ARG0-L_INDEX-R_INDEX-L_HNDL-R_HNDL "?and" "?MRSCON" "?lbl" "?arg0" "?lindex" "?arg00" "?lhndl" "?rhndl")"crlf)
(printout ?*rstr-dbug* "(rule-rel-values samuccaya_and-bind-copula id-MRS_concept-LBL-ARG0-L_INDEX-R_INDEX-L_HNDL-R_HNDL "?and" "?MRSCON" "?lbl" "?arg0" "?lindex" "?arg00" "?lhndl" "?rhndl")"crlf)
)

;Rule for generating LTOP and INDEX values when kAryakAraNa relation exists. INDEX value will take the ARG0 of unknown. 
;Because, he has to go home. #kyoMki vo Gara jAnA hE.
(defrule kAryakAraNa-LTOP
(rel-ids kAryakAraNa ?previousid	?verb)
?f<-(MRS_info id-MRS_concept-LBL-ARG0-ARG ?verbb unknown ?id ?arg0 ?arg)
(test (eq  (+ ?verb 1) ?verbb))
=>
(printout ?*rstr-fp* "(LTOP-INDEX h0 "?arg0 ")" crlf)
(printout ?*rstr-dbug* "(rule-rel-values kAryakAraNa-LTOP LTOP-INDEX h0 "?arg0 ")"crlf)
)

;Rule for generating number in CARG value of the date of month (dofm). 
;My birthday is 23 September. 
(defrule dofm_carg_number
(id-cl	?numid	?num)
(id-dom	?numid	yes)
?f<-(MRS_info id-MRS_concept-LBL-ARG0-CARG ?numid dofm ?lbl ?arg0 ?carg)
=>
(printout ?*rstr-fp* "(MRS_info id-MRS_concept-LBL-ARG0-CARG "?numid" dofm " ?lbl" "?arg0" "?num")"crlf)
(printout ?*rstr-dbug* "(rule-rel-values yoc_carg_number id-MRS_concept-LBL-ARG0-CARG "?numid" dofm " ?lbl" "?arg0" "?num")"crlf)
)

(defrule date_of_month_uc
(id-dom	?id1	yes)
(id-moy	?id2	yes)
(rel-ids	r6	?id1	?id2)
?f<-(MRS_info id-MRS_concept-LBL-ARG0-RSTR-BODY ?udef udef_q ?lbl ?arg0 ?rstr ?body)
?f1<-(MRS_info id-MRS_concept-LBL-ARG0-ARG1-ARG2 ?comp compound ?l ?a0 ?a1 ?a2)
(MRS_info id-MRS_concept-LBL-ARG0-CARG ?id1 dofm ?lbl1 ?arg01 ?carg1)
(MRS_info id-MRS_concept-LBL-ARG0-CARG ?id2 mofy ?lbl2 ?arg02 ?carg2)
(test (eq  (+ ?id1 10) ?udef))
(test (eq  (+ ?id1 2) ?comp))
=>
(retract ?f )
(printout ?*rstr-fp* "(MRS_info id-MRS_concept-LBL-ARG0-RSTR-BODY "?udef" udef_q " ?lbl" "?arg01" "?rstr" "?body" )"crlf)
(printout ?*rstr-dbug* "(rule-rel-values date_of_month_uc id-MRS_concept-LBL-ARG0-RSTR-BODY "?udef" udef_q " ?lbl" "?arg01" "?rstr" "?body" )"crlf)
(printout ?*rstr-fp* "(MRS_info id-MRS_concept-LBL-ARG0-ARG1-ARG2 "?comp" compound " ?lbl1" "?a0" "?arg01" "?arg02" )"crlf)
(printout ?*rstr-dbug* "(rule-rel-values date_of_month_uc id-MRS_concept-LBL-ARG0-ARG1-ARG2 "?comp" compound " ?lbl1" "?a0" "?arg01" "?arg02" )"crlf)
)

(defrule clock_time_carg
(id-cl	?ct	 ?num)
(id-clocktime	?ct	yes)
(rel-ids	k7t	?kri	?ct)
(test (neq (str-index "+baje" ?num) FALSE))
?f<-(MRS_info id-MRS_concept-LBL-ARG0-CARG ?numid minute ?lbl ?arg0 ?carg)
(test (eq  (+ ?ct 1) ?numid))
=>
(printout ?*rstr-fp* "(MRS_info id-MRS_concept-LBL-ARG0-CARG "?numid" minute " ?lbl" "?arg0" "?num")"crlf)
(printout ?*rstr-dbug* "(rule-rel-values clock_time_carg id-MRS_concept-LBL-ARG0-CARG "?numid" minute " ?lbl" "?arg0" "?num")"crlf)
)

;Rule for creating the binding with comp, generic_entity, much-many_a, udef_q, card, and verb. 
;More than 300 people will come tomorrow.
(defrule quant_more_bind
(id-cl	?id	?num)
(id-numex	?id	yes)
(or (rel-ids	quantmore	?modifier	?id) (rel-ids	quantless	?modifier	?id))
?f<-(MRS_info id-MRS_concept-LBL-ARG0-ARG1 ?much ?MRSCON ?lbl ?arg0 ?arg1)
(MRS_info id-MRS_concept-LBL-ARG0 ?id generic_entity ?lbl1 ?arg01)
?f2<-(MRS_info id-MRS_concept-LBL-ARG0-ARG1-ARG2 ?comp comp ?l ?a0 ?a1 ?a2)
?f4<-(MRS_info id-MRS_concept-LBL-ARG0-ARG1-CARG ?iD card ?lbllll ?arg0000 ?arg1111 ?value)
?f5<-(MRS_info id-MRS_concept-LBL-ARG0-ARG1 ?verb ?verbmrs ?b ?aooo ?a111)
(MRS_info ?rel ?modifier ?modifermrs ?lob ?ao0 $?vvvvvv)
(test (or (eq ?MRSCON  much-many_a)(eq ?MRSCON little-few_a)))
=> 
(retract ?f ?f2 ?f4 ?f5)
(printout ?*rstr-fp* "(MRS_info id-MRS_concept-LBL-ARG0-ARG1 "?much" "?MRSCON" "?lbl1" "?arg0" "?arg01")"crlf)
(printout ?*rstr-dbug* "(rule-rel-values quant_more_bind id-MRS_concept-LBL-ARG0-ARG1 ?much "?MRSCON" "?lbl1" "?arg0" "?arg01")"crlf)
(printout ?*rstr-fp* "(MRS_info id-MRS_concept-LBL-ARG0-ARG1-ARG2 "?comp" comp "?lbl1" "?a0" "?arg0" "?ao0")"crlf)
(printout ?*rstr-dbug* "(rule-rel-values quant_more_bind id-MRS_concept-LBL-ARG0-ARG1-ARG2 "?comp" comp "?lbl1" "?a0" "?arg0" "?ao0")"crlf)
(printout ?*rstr-fp* "(MRS_info id-MRS_concept-LBL-ARG0-ARG1-CARG "?iD" card "?lob" "?arg0000" "?ao0" "?num")"crlf)
(printout ?*rstr-dbug* "(rule-rel-values quant_more_bind id-MRS_concept-LBL-ARG0-ARG1-CARG "?iD" card "?lob" "?arg0000" "?ao0" "?num")"crlf)
(assert (MRS_info id-MRS_concept-LBL-ARG0-ARG1 ?verb ?verbmrs ?b ?aooo ?arg01))
(printout ?*rstr-dbug* "(rule-rel-values quant_more_bind id-MRS_concept-LBL-ARG0-ARG1 "?verb" "?verbmrs" "?b" "?aooo" "?arg01")"crlf)
)

;My country
(defrule unknown_LTOP_%TITLE
(id-cl	?id	?hinconcept)
(rel-ids	main	0	?id)
(sent_type	%TITLE)
(MRS_info id-MRS_concept-LBL-ARG0-ARG 0 unknown ?lbl ?arg0 ?arg1)
=>
(printout ?*rstr-fp* "(LTOP-INDEX h0 "?arg0 ")" crlf)
(printout ?*rstr-dbug* "(rule-rel-values unknown_LTOP_%TITLE LTOP-INDEX h0 "?arg0 ")"crlf)
)

;Fruits and vegetables found in India.
(defrule unknown_LTOP_heading
(id-cl	?id	?hinconcept)
(rel-ids	main	0	?id)
(sent_type	heading)
(MRS_info id-MRS_concept-LBL-ARG0-ARG 0 unknown ?lbl ?arg0 ?arg1)
=>
(printout ?*rstr-fp* "(LTOP-INDEX h0 "?arg0 ")" crlf)
(printout ?*rstr-dbug* "(rule-rel-values unknown_LTOP_heading LTOP-INDEX h0 "?arg0 ")"crlf)
)

;My country
(defrule unknown_LTOP_value_sharing
(id-cl	?id	?hinconcept)
(rel-ids	main	0	?id)
(sent_type	%TITLE)
(MRS_info id-MRS_concept-LBL-ARG0-ARG 0 unknown ?lbl ?arg0 ?arg1)
(MRS_info ?rel ?id ?mrsCon ?lbl1 ?arg01 $?v)
=>
(printout ?*rstr-fp* "(MRS_info  id-MRS_concept-LBL-ARG0-ARG  0 unknown "?lbl" " ?arg0 " " ?arg01 ")"crlf)
(printout ?*rstr-dbug* "(rule-rel-values unknown_LTOP_value_sharing id-MRS_concept-LBL-ARG0-ARG  0 unknown "?lbl" " ?arg0 " " ?arg01 ")"crlf)
)


;Rule for generating the 12 number in the CARG value for midday, noon, twelve time hours. 
;Rama arrived at midday.
(defrule 12_carg_number
(id-cl	?numid	xopahara_2)
(rel-ids	k7t	?kri	?numid)
?f<-(MRS_info id-MRS_concept-LBL-ARG0-ARG1-ARG2-CARG ?numid numbered_hour ?lbl ?arg0 ?arg1 ?arg2 ?carg)
=>
(printout ?*rstr-fp* "(MRS_info id-MRS_concept-LBL-ARG0-ARG1-ARG2-CARG "?numid" numbered_hour "?lbl" "?arg0" "?arg1" "?arg2" 12)"crlf)
(printout ?*rstr-dbug* "(rule-rel-values 12_carg_number id-MRS_concept-LBL-ARG0-ARG1-ARG2-CARG "?numid" numbered_hour "?lbl" "?arg0" "?arg1" "?arg2" 12)"crlf)
)

;Rule for generating the 12 number in the CARG value for midday, noon, twelve time hours. 
;Rama arrived at midday.
(defrule carg_number
(id-cl	?numid	?hinconcept)
(rel-ids	k7t	?kri	?numid)
?f<-(MRS_info id-MRS_concept-LBL-ARG0-CARG ?minut minute ?lbb ?arg00 ?arg111)
(MRS_info id-MRS_concept-LBL-ARG0-ARG1-ARG2-CARG ?numid numbered_hour ?lbl ?arg0 ?arg1 ?arg2 ?carg)
(test (neq (str-index "+baje" ?hinconcept) FALSE))
=>
(printout ?*rstr-fp* "(MRS_info id-MRS_concept-LBL-ARG0-CARG "?minut" minute "?lbl" "?arg00" "?arg1" 00)"crlf)
(printout ?*rstr-dbug* "(rule-rel-values carg_number id-MRS_concept-LBL-ARG0-CARG "?minut" minute "?lbl" "?arg00" "?arg1" 00)"crlf)
)

;Rule to generate the number in english and value sharing of cardinal with the modified (noun). 
;Four boys used to live in a village.
(defrule viya-viNa-cardinals
(declare (salience 100))
(id-cl	?viNa	?hinconcept)
(id-numex	?viNa	yes)
(rel-ids card ?viya ?viNa)
(MRS_info ?rel1 ?viya ?c ?lbl1 ?arg0_viya  $?var)
?f<-(MRS_info id-MRS_concept-LBL-ARG0-ARG1-CARG ?card card ?lbl2 ?arg0_viNa ?arg1_viNa ?carg)
=>
(retract ?f)
(printout ?*rstr-fp* "(MRS_info id-MRS_concept-LBL-ARG0-ARG1-CARG "?card" card "?lbl1" "?arg0_viNa" "?arg0_viya" "?hinconcept")"crlf)
(printout ?*rstr-dbug* "(rule-rel-values viya-viNa-carg id-MRS_concept-LBL-ARG0-ARG1-CARG "?card" card "?lbl1" "?arg0_viNa" "?arg0_viya" "?hinconcept")"crlf)
)

;They were not only obedient.
(defrule hI_1_not_only
?f<-(MRS_info id-MRS_concept-LBL-ARG0-ARG1 ?id _only_x_deg ?lbl ?a0 ?a1)
(id-dis_part  ?id1  hI_1)
(MRS_info ?rel ?id1 ?mrscon ?l ?arg0 $?v)
(test (eq (+ ?id1 1000) ?id))
=>
(retract ?f)
(printout ?*rstr-fp* "(MRS_info id-MRS_concept-LBL-ARG0-ARG1 "?id" _only_x_deg "?l" "?a0" " ?arg0")"crlf)
(printout ?*rstr-dbug* "(rule-rel-values hI_1_not_only MRS_info id-MRS_concept-LBL-ARG0-ARG1 "?id" _only_x_deg "?l"  "?a0" " ?arg0")"crlf)
)

;Rule for creating LTOP value with the _but_c arg0 value when samuccaya and BI_1 relation exists.
;#बल्कि वे बहुत समझदार भी थे
(defrule samuccaya_BI_but-LTOP
(rel-ids samuccaya ?previousid	?verb)
(id-dis_part	?verb	BI_1)
?f<-(MRS_info id-MRS_concept-LBL-ARG0-L_INDEX-R_INDEX-L_HNDL-R_HNDL ?but _but_c ?lbl ?arg0 ?lindex ?rindex ?lhndl ?rhndl)
=>
(printout ?*rstr-fp* "(LTOP-INDEX h0 "?arg0 ")" crlf)
(printout ?*rstr-dbug* "(rule-rel-values samuccaya_BI_but-LTOP LTOP-INDEX h0 "?arg0 ")"crlf)
)

;Rule for creating binding LTOP with the lbl of _but_c and R_HNDL value with the lbl of the adjective.
;#बल्कि वे बहुत समझदार भी थे
(defrule samuccaya_BI_but-bind-copula
(id-cl	?verb	hE_1)
(rel-ids samuccaya ?previousid	?verb)
(id-dis_part	?verb	BI_1)
(rel-ids	k1s	?verb	?adj)
?f<-(MRS_info id-MRS_concept-LBL-ARG0-L_INDEX-R_INDEX-L_HNDL-R_HNDL ?and _but_c ?lbl ?arg0 ?lindex ?rindex ?lhndl ?rhndl)
(MRS_info ?rel ?adj ?mrsss ?lblb ?arg00 $?v)
;(test (eq  (+ ?verb 1000) ?and))
=>
(printout ?*rstr-fp* "(MRS_info id-MRS_concept-LBL-ARG0-L_INDEX-R_INDEX-L_HNDL-R_HNDL "?and" _but_c "?lbl" "?arg0" "?lindex" "?arg00" "?lhndl" "?rhndl")"crlf)
(printout ?*rstr-dbug* "(rule-rel-values samuccaya_BI_but-bind-copula id-MRS_concept-LBL-ARG0-L_INDEX-R_INDEX-L_HNDL-R_HNDL "?and" _but_c "?lbl" "?arg0" "?lindex" "?arg00" "?lhndl" "?rhndl")"crlf)
)

;Rule to create value sharing between the _despite_p, focus_d, and the verb of the sentence.
;;#इसके बावजूद  वे बहुत घनिष्ठ मित्र थे
(defrule vyABIcAra_despite_focus
(rel-ids vyABIcAra ?previousid	?id)
?f<-(MRS_info id-MRS_concept-LBL-ARG0-ARG1-ARG2 ?gen _despite_p ?l ?a0 ?a1 ?a2)
?f1<-(MRS_info id-MRS_concept-LBL-ARG0-ARG1-ARG2 ?iD focus_d ?ll ?ar0 ?ar1 ?ar2)
?f2<-(MRS_info id-MRS_concept-LBL-ARG0 ?gen generic_entity ?lllll ?Arg0000)
(MRS_info id-MRS_concept-LBL-ARG0-ARG1-ARG2 ?id ?verb ?lll ?a00 ?a11 ?a22)
(MRS_info id-MRS_concept-LBL-ARG0-RSTR-BODY ?iddd ?qdem ?lbl ?arg0 $?var)
(test (neq (str-index "_q_dem" ?qdem) FALSE))
(test (neq (str-index "_v_" ?verb) FALSE))
(test (eq  (+ ?iddd 9) ?gen))
=>
(retract ?f ?f1 ?f2)
(printout ?*rstr-fp* "(MRS_info id-MRS_concept-LBL-ARG0-ARG1-ARG2 "?gen" _despite_p "?lll" "?a0" "?a00" "?arg0")"crlf)
(printout ?*rstr-dbug* "(rule-rel-values vyABIcAra_despite_focus id-MRS_concept-LBL-ARG0-ARG1-ARG2 "?gen" _despite_p "?lll" "?a0" "?a00" "?arg0")"crlf)

(printout ?*rstr-fp* "(MRS_info id-MRS_concept-LBL-ARG0 "?gen" generic_entity "?lllll" "?arg0")"crlf)
(printout ?*rstr-dbug* "(rule-rel-values vyABIcAra_despite_focus id-MRS_concept-LBL-ARG0 "?gen" generic_entity "?lllll" "?arg0")"crlf)

(printout ?*rstr-fp* "(MRS_info id-MRS_concept-LBL-ARG0-ARG1-ARG2 "?iD" focus_d "?lll" "?ar0" "?a00" "?a0")"crlf)
(printout ?*rstr-dbug* "(rule-rel-values vyABIcAra_despite_focus id-MRS_concept-LBL-ARG0-ARG1-ARG2 "?iD" focus_d "?lll" "?ar0" "?a00" "?a0")"crlf)
)

;Rule to create value sharing between focus_d and _because+of_p with the verb and the demonstrative.
;Because of that his parents used to be very upset.
(defrule pariNAma_focus
;(declare (salience 1000))
(rel-ids pariNAma ?previousid	?id)
(rel-ids	k1s	?id ?verbid)
?f<-(MRS_info id-MRS_concept-LBL-ARG0-ARG1-ARG2 ?gen _because+of_p ?l ?a0 ?a1 ?a2)
?f1<-(MRS_info id-MRS_concept-LBL-ARG0-ARG1-ARG2 ?iD focus_d ?ll ?ar0 ?ar1 ?ar2)
?f2<-(MRS_info id-MRS_concept-LBL-ARG0 ?gen generic_entity ?lllll ?Arg0000)
(MRS_info ?relll ?verbid ?verb ?lll ?a00 ?a11 $?vvv)
(MRS_info id-MRS_concept-LBL-ARG0-RSTR-BODY ?iddd ?qdem ?lbl ?arg0 $?var)
(test (neq (str-index "_q_dem" ?qdem) FALSE))
;(test (neq (str-index "_v_" ?verb) FALSE))
(test (eq  (+ ?iddd 9) ?gen))
=>
(retract ?f ?f1 ?f2)
(printout ?*rstr-fp* "(MRS_info id-MRS_concept-LBL-ARG0-ARG1-ARG2 "?gen" _because+of_p "?lll" "?a0" "?a00" "?arg0")"crlf)
(printout ?*rstr-dbug* "(rule-rel-values pariNAma_focus id-MRS_concept-LBL-ARG0-ARG1-ARG2 "?gen" _because+of_p "?lll" "?a0" "?a00" "?arg0")"crlf)

(printout ?*rstr-fp* "(MRS_info id-MRS_concept-LBL-ARG0 "?gen" generic_entity "?lllll" "?arg0")"crlf)
(printout ?*rstr-dbug* "(rule-rel-values pariNAma_focus id-MRS_concept-LBL-ARG0 "?gen" generic_entity "?lllll" "?arg0")"crlf)

(printout ?*rstr-fp* "(MRS_info id-MRS_concept-LBL-ARG0-ARG1-ARG2 "?iD" focus_d "?lll" "?ar0" "?a00" "?a0")"crlf)
(printout ?*rstr-dbug* "(rule-rel-values pariNAma_focus id-MRS_concept-LBL-ARG0-ARG1-ARG2 "?iD" focus_d "?lll" "?ar0" "?a00" "?a0")"crlf)
)


;Rule to create value sharing between the predicative adjective and the possessive pronoun "rhh"
;;Because of that his parents used to be very upset.
;MRS_info id-MRS_concept-LBL-ARG0-ARG1 40000 _upset_a_1 h31 e32 x33)
(defrule pariNAma_pred_adjective
(rel-ids pariNAma ?previousid	?id)
(rel-ids	k1	?id	?k1id)
?f<-(MRS_info id-MRS_concept-LBL-ARG0-ARG1 ?id ?adj ?lbl ?arg0 ?arg1)
(MRS_info ?rel ?k1id ?noun ?l ?a $?v)
(test (neq (str-index "_a_" ?adj) FALSE))
(test (neq (str-index "_n_" ?noun) FALSE))
=>
(retract ?f)
(printout ?*rstr-fp* "(MRS_info id-MRS_concept-LBL-ARG0-ARG1 "?id" "?adj" "?lbl" "?arg0" "?a")"crlf)
(printout ?*rstr-dbug* "(rule-rel-values pariNAma_pred_adjective id-MRS_concept-LBL-ARG0-ARG1 "?id" "?adj" "?lbl" "?arg0" "?a")"crlf)
)

;(MRS_info id-MRS_concept-LBL-ARG0-ARG1 50040 _only_x_deg h44 e45 u46)
;(MRS_info id-MRS_concept-LBL-ARG0-RSTR-BODY 50010 def_explicit_q h5 x6 h7 h8)


;Rule to change the LBL value of _only_x_deg with the def_explicit_q LBL.
;Rama and Siwa did not talk with only their brother, in the temple.
(defrule only_x_deg_explicit
(declare (salience 1001))
(id-dis_part	?id	hI_1)
(MRS_info id-MRS_concept-LBL-ARG0-RSTR-BODY ?quant def_explicit_q  ?lbl ?arg0 ?rstr ?body)
?f<-(MRS_info id-MRS_concept-LBL-ARG0-ARG1 ?deg _only_x_deg ?l ?a0 ?a1)
(test (eq  (+ ?id 10) ?quant))
(test (eq  (+ ?id 40) ?deg))
=>
(retract ?f)
(printout ?*rstr-fp* "(MRS_info id-MRS_concept-LBL-ARG0-ARG1 "?deg" _only_x_deg "?lbl" "?a0" "?a1")"crlf)
(printout ?*rstr-dbug* "(rule-rel-values only_x_deg_explicit id-MRS_concept-LBL-ARG0-ARG1 "?deg" _only_x_deg "?lbl" "?a0" "?a1")"crlf)
)

(defrule nc_final_binding
(declare (salience 10000))
(id-cl	 ?compounid	 ?nc_concept)
?f<-(rel-ids	 ?rel	 ?kri	 ?compounid)
(cxn_rel-ids	 head	 ?compounid	 ?headid)
(test (neq (str-index "nc_"  ?nc_concept) FALSE)) 
=>
(retract ?f)
(assert (rel-ids ?rel ?kri ?headid))
(printout ?*rstr-dbug* "(rule-rel-values nc_final_binding rel-ids	"?rel"	"?kri"	"?headid") "crlf)
)

(defrule conj-bind-final_implicit
(declare (salience 10000))
(id-cl	 ?conjid	 [conj_1])
(cxn_rel-ids	 op1	 ?conjid	 ?op1)
(cxnlbl-id-values [conj_1] ?conjid op1 $?var)
(cxnlbl-id-val_ids [conj_1] ?conjid ?op1 $?va)
?f1<-(rel-ids	 ?rel	?kri	 ?conjid)
(MRS_info ?conj_rel ?imp_con implicit_conj ?lbll ?arg00 $?vaar)  
(test (eq  (+ ?op1 200) ?imp_con))
=>
(retract ?f1)
(assert (rel-ids	?rel	?kri	?imp_con))
(printout ?*rstr-dbug* "(rule-rel-values conj-bind-final_implicit rel-ids	"?rel"	"?kri"	"?imp_con") "crlf)
)

