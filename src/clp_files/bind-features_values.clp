;generates output file "mrs_info_with_rstr_values.dat" which contains LTOP , kriyA-TAM and id-MRS-Rel_features


(defglobal ?*rstr-fp* = open-file)
(defglobal ?*rstr-dbug* = debug_fp)



;for compounds 
;Ex. 307:   usane basa+addA xeKA.
;Ex. 311:   #usane rAma ke kAryAlaya kI AXAraSilA raKI.
(defrule comp
(declare (salience 100))
(id-hin_concept-MRS_concept ?head ?hc ?mrsConComp)
(MRS_info id-MRS_concept-LBL-ARG0 ?dep ?d ?dl ?da0)
(MRS_info id-MRS_concept-LBL-ARG0 ?head ?h ?hl ?ha0)
?f1<-(MRS_info id-MRS_concept-LBL-ARG0-RSTR-BODY ?udf udef_q ?ul ?ua0 ?rstr ?body)
?f2<-(MRS_info id-MRS_concept-LBL-ARG0-RSTR-BODY ?adq ?atheq ?ql ?qa0 ?qstr ?qody)
?f<-(MRS_info id-MRS_concept-LBL-ARG0-ARG1-ARG2 ?comp compound ?cl ?ca0 ?ca1 ?ca2)
(not (compound_mapped ?comp))
(test (neq (str-index "+"  ?mrsConComp) FALSE)) 
(test (eq (+ ?head 10) ?adq))
(test (or (neq (str-index _the_q ?atheq) FALSE)
          (neq (str-index _a_q ?atheq) FALSE)))
=>
(retract ?f ?f1 ?f2)
(assert (compound_mapped ?comp))
(printout ?*rstr-fp* "(MRS_info id-MRS_concept-LBL-ARG0-ARG1-ARG2 "?comp" compound "?hl" "?ca0" "?ha0" "?da0")" crlf)
(printout ?*rstr-dbug* "(rule-rel-values comp id-MRS_concept-LBL-ARG0-ARG1-ARG2 "?comp" compound "?hl" "?ca0" "?ha0" "?da0"))"crlf)

(printout ?*rstr-fp* "(MRS_info id-MRS_concept-LBL-ARG0-RSTR-BODY "?udf" udef_q "?ul" "?da0" "?rstr" "?body")" crlf)
(printout ?*rstr-dbug* "(rule-rel-values comp id-MRS_concept-LBL-ARG0-RSTR-BODY "?udf" udef_q "?ul" "?da0" "?rstr" "?body")" crlf)

(printout ?*rstr-fp* "(MRS_info id-MRS_concept-LBL-ARG0-RSTR-BODY "?adq" "?atheq" "?ql" "?ha0" "?qstr" "?qody")" crlf)
(printout ?*rstr-dbug* "(rule-rel-values comp id-MRS_concept-LBL-ARG0-RSTR-BODY  "?adq" "?atheq" "?ql" "?ha0" "?qstr" "?qody")" crlf)
)

;Rule for the respect word "ji" in Hindi.
;This rule creates binding with the person for whom we are giving respect with word "ji".
; 26 verified sentence #manwrIjI ne kala manxira kA uxGAtana kiyA.
(defrule respect-honorable
(declare (salience 1000))
(id-respect	?id	yes)
(MRS_info ?rel1 ?id ?mrscon ?lbl1 ?arg0 $?v)
?f<-(MRS_info id-MRS_concept-LBL-ARG0-ARG1 ?id1 _honorable_a_1 ?lbl ?argo2 ?arg01)
(test (eq (+ ?id 1000) ?id1)) 
=>
(retract ?f)
(printout ?*rstr-fp* "(MRS_info id-MRS_concept-LBL-ARG0-ARG1 "?id1" _honorable_a_1 "?lbl1" "?argo2" "?arg0")" crlf)
(printout ?*rstr-dbug* "(rule-rel-values respect-honorable id-MRS_concept-LBL-ARG0-ARG1 "?id1" _honorable_a_1 "?lbl1" "?argo2" "?arg0")"crlf)
)


;Rule for adjective and noun : for (viSeRya-viSeRaNa 	? ?)
;	replace LBL value of viSeRaNa/adv with the LBL value of viSeRya
;	Replace ARG1 value of viSeRaNa/adv with ARG0 value of viSeRya
(defrule viya-viNa
(rel_name-ids mod|intf|card|vmod_vks ?viya ?viNa);verified sentences: 16,309,167,341 respectively.
(MRS_info ?rel1 ?viya ?c ?lbl1 ?arg0_viya  $?var)
(MRS_info ?rel2 ?viNa ?co ?lbl2 ?arg0_viNa ?arg1_viNa $?vars)
;(test (eq (str-index _q ?co) FALSE))  ;prawyeka baccA Kela rahe hEM. saBI bacce Kela rahe hEM. kuCa bacce koI Kela Kela sakawe hEM. 
(test (neq (sub-string (- (str-length ?co) 1) (str-length ?co) ?co) "_q"))
(not (modified_viSeRaNa ?viNa))
=>
(assert (modified_viSeRaNa ?viNa))
(printout ?*rstr-fp* "(MRS_info  "?rel2 " " ?viNa " " ?co " " ?lbl1 " " ?arg0_viNa " " ?arg0_viya " "(implode$ (create$ $?vars)) ")"crlf)
(printout ?*rstr-dbug* "(rule-rel-values viya-viNa   "?rel2 " " ?viNa " " ?co " " ?lbl1 " " ?arg0_viNa " " ?arg0_viya " "(implode$ (create$ $?vars)) ")"crlf)
)

;Rule for binding/replacing ARG0 value of demonstrative_pronoun with ARG0 value of viSeRya
;Ex. rAma yaha kAma  kara sakawA. Rama can do this work.
(defrule dem
(rel_name-ids dem|quant ?viya ?viNa) ; 142,129 respectively. 
(MRS_info ?rel1 ?viya ?c ?lbl1 ?arg0_viya  $?var)
?f<-(MRS_info ?rel2 ?viNa ?co ?lbl2 ?arg0_viNa ?arg1_viNa $?vars)
(test (neq (sub-string (- (str-length ?co) 1) (str-length ?co) ?co) "_q")) 
=>
(retract ?f)
(printout ?*rstr-fp* "(MRS_info  "?rel2" "?viNa" "?co" "?lbl2" "?arg0_viya" "?arg1_viNa" "(implode$ (create$ $?vars)) ")"crlf)
(printout ?*rstr-dbug* "(rule-rel-values dem   "?rel2 " " ?viNa " " ?co " " ?lbl2 " " ?arg0_viya " " ?arg1_viNa " "(implode$ (create$ $?vars)) ")"crlf)
)

;Replace LBL values of kriyA_viSeRaNa with the LBL value of kriyA, and Replace ARG1 values of kriyA_viSeRaNa with the ARG0 value of kriyA. Ex. "I walk slowly." 
(defrule kr_vnn
(rrrel_name-ids kr_vn ?kri ?kri_vi)
(MRS_info ?rel1 ?kri ?mrsconkri ?lbl1 ?arg0  ?arg1 $?var)
?f<-(MRS_info  ?rel2 ?kri_vi ?mrsconkrivi ?lbl2 ?arg0_2 ?arg1_2 $?vars)
=>
(retract ?f)
(printout ?*rstr-fp* "(MRS_info  "?rel2 " " ?kri_vi " " ?mrsconkrivi " " ?lbl1 " " ?arg0_2 " " ?arg0 " "(implode$ (create$ $?vars)) ")"crlf)
(printout ?*rstr-dbug* "(rule-rel-values kriyA-kriyA_viSeRaNa  "?rel2 " " ?kri_vi " " ?mrsconkrivi " " ?lbl1 " " ?arg0_2" "?arg0" "(implode$ (create$ $?vars)) ")"crlf)
)

(defrule kr_vn
(declare (salience 1000))
(rel_name-ids kr_vn ?kri ?kri_vi) ;#aXyApaka aBI Aye hEM.
(MRS_info ?rel1 ?kri ?mrsconkri ?lbl1 ?arg0  ?arg1 $?var)
?f<-(MRS_info  ?rel2 ?kri_vi ?mrsconkrivi ?lbl2 ?arg0_2 ?arg1_2 $?vars)
(not (modified_kr_vn ?kri_vi))
=>
(retract ?f)
(assert (modified_kr_vn ?kri_vi))
(printout ?*rstr-fp* "(MRS_info  "?rel2 " " ?kri_vi " " ?mrsconkrivi " " ?lbl1 " " ?arg0_2 " " ?arg0 " "(implode$ (create$ $?vars)) ")"crlf)
;(assert (MRS_info  ?rel2 ?kri_vi  ?mrsconkrivi  ?lbl1 ?arg0_2 ?arg0 $?vars) )
(printout ?*rstr-dbug* "(rule-rel-values kr_vn  "?rel2 " " ?kri_vi " " ?mrsconkrivi " " ?lbl1 " " ?arg0_2" "?arg0" "(implode$ (create$ $?vars)) ")"crlf)
)

;Rule for predicative adjective (samAnAXi) : for (kriyA-k1 ? ?) and  (kriyA-k2 ? ?) is not present
;replace ARG1 of adjective with ARG0 of non-adjective
;ex INPUT: rAma acCA hE. OUTPUT: Rama is good.
(defrule samAnAXi
(rel_name-ids   k1	?non-adj ?k1) ;#yaha Gara hE.
(rel_name-ids	k1s	?non-adj ?adj)
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
(id-concept_label       ?v_id   hE_1|WA_1)
(rel_name-ids	k1s	?v_id ?k1s)
(rel_name-ids	k1	?v_id ?k1)
?f<-(MRS_info ?rel_name ?v_id ?mrsCon ?lbl ?arg0 ?arg1 ?arg2 )
(MRS_info ?rel1 ?k1 ?mrsCon1 ?lbl1 ?id1_arg0 $?vars)
(MRS_info ?rel2 ?k1s ?mrsCon2 ?lbl2 ?id2_arg0 $?var)
(test (eq (str-index _q ?mrsCon1) FALSE))
(test (neq ?arg1 ?id1_arg0))
(not (id-concept_label  ?k-id   ?hiConcept&Aja_1|kala_1|kala_2)) ;to rule out the cases for time adverbs.
(not (modified_samAnAXi ?k1))
=>
(retract ?f)
(assert (modified_samAnAXi ?k1))
(assert (MRS_info  ?rel_name ?v_id ?mrsCon ?lbl ?arg0 ?id1_arg0 ?id2_arg0 ))
(printout ?*rstr-dbug* "(rule-rel-values samAnAXi-noun "?rel_name " " ?v_id " " ?mrsCon " " ?lbl " " ?id1_arg0 " " ?id2_arg0 ")"crlf)
)

;replace ARG1 of existential prep with ARG0 of AXeya & ARG2 of prep with ARG0 of AXAra.
;ex INPUT: ladakA xillI meM hE. OUTPUT: The boy is in Delhi.
(defrule existential
(id-concept_label   ?v_id  hE_1|WA_1)
(rel_name-ids	k7p|k7	?v_id ?k7)
(rel_name-ids	k1	?v_id ?k1)
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
(id-concept_label ?v_id hE_1|WA_1)
(rel_name-ids   k1    ?v_id  ?id1)
(rel_name-ids   k4a   ?v_id  ?id2)
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
;(rel_name-ids	possessor	30000	10000)
;(rel_name-ids	k1	40000	30000)
(defrule possession
(declare (salience 5000))
(id-concept_label  ?v_id  hE_2)
?f1<-(rel_name-ids	k1	?v_id	?k1)
(rel_name-ids  possessor|janaka     ?k1  ?id2) ;rAma ke xo bete hEM
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
;(declare (salience 10))
(rel_name-ids	k1|k4a	?kriyA ?karwA)
?f<-(MRS_info ?rel_name ?kriyA ?mrsCon ?lbl ?arg0 ?arg1 $?v)
(MRS_info ?rel1 ?karwA ?mrsCon1 ?lbl1 ?argwA_0 $?vars)
(test (eq (str-index _q ?mrsCon1) FALSE))
(test (neq ?arg1 ?argwA_0))
(not (modified_k1 ?karwA))
(test (neq (str-index "_v_" ?mrsCon)FALSE))
(not (modified_possessed ?karwA))
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
(id-causative	?kriya	yes)
(rel_name-ids	pk1	?kriyA ?karwA)
(MRS_info ?rel_name ?kriyA ?mrsCon ?lbl ?arg0 ?arg1 $?v)
(MRS_info ?rel1 ?karwA ?mrsCon1 ?lbl1 ?argwA_0 $?vars)
?f<-(MRS_info ?rel3 ?make_v_id _make_v_cause ?lbl3 ?A30 ?A31 ?A32)
(test (neq ?arg1 ?argwA_0))
(test (eq ?make_v_id (+ ?kriyA 100)))
(not (modified_pk1 ?karwA))
=>
(retract ?f)
(assert (modified_pk1 ?karwA))
(assert (MRS_info  ?rel3  ?make_v_id _make_v_cause  ?lbl3 ?A30 ?argwA_0  ?A32))
;(printout ?*rstr-fp* "(MRS_info "?rel3 " " ?make_v_id " _make_v_cause " ?lbl3 " "?A30 " "?argwA_0 " " ?A32")"crlf)
(printout ?*rstr-dbug* "(rule-rel-values v-pk1 MRS_info "?rel3 " " ?make_v_id " _make_v_cause " ?lbl3 " "?A30 " "?argwA_0 " " ?A32")"crlf)
)

;Rule for verb when only prayojaka karta is present : for (kriyA-jk1 ? ?) and  (kriyA-k2 ? ?) is not present
;replace ARG1 of main kriyA with ARG0 of prayojaka karwA
;#SikRikA ne CAwroM se kakRA ko sAPa karAyA.
;Ex. 
(defrule v-jk1
(id-causative	?kriya	yes)
(rel_name-ids	jk1	?kriyA ?karwA)
(MRS_info ?rel1 ?karwA ?mrsCon1 ?lbl1 ?argwA_0 $?vars)
(MRS_info ?rel3 ?make_v_id _make_v_cause ?lbl3 ?A30 ?A31 ?A32)
?f<-(MRS_info ?rel_name ?kriyA ?mrsCon ?lbl ?arg0 ?arg1 ?arg2 $?v)
(test (eq (str-index _q ?mrsCon1) FALSE))
(test (neq ?arg1 ?argwA_0))
(test (eq ?make_v_id (+ ?kriyA 100)))
(not (modified_jk1 ?karwA))
=>
(retract ?f)
(assert (modified_jk1 ?karwA))
(assert (MRS_info ?rel_name ?kriyA ?mrsCon ?lbl ?arg0 ?argwA_0 ?arg2 $?v))
;(printout ?*rstr-fp* "(MRS_info "?rel_name " " ?kriyA  " "?mrsCon" " ?lbl " "?arg0 " "?argwA_0 ")"crlf)
(printout ?*rstr-dbug* "(rule-rel-values v-jk1 MRS_info "?rel_name " " ?kriyA  " "?mrsCon" " ?lbl " "?arg0 " "?argwA_0 " )"crlf)
)

;Rule for binding ARG1 of ask with ARG0 of karwa.
;genrates binding for double causative
;mAz ne rAma se bacce ko KAnA KilavAyA.
(defrule v-p1k1
(id-double_causative	?kriya	yes)
(rel_name-ids	pk1	?kriyA ?karwA)
(MRS_info ?rel_name ?kriyA ?mrsCon ?lbl ?arg0 ?arg1 $?v)
(MRS_info ?rel1 ?karwA ?mrsCon1 ?lbl1 ?argwA_0 $?vars)
?f<-(MRS_info ?rel3 ?ask_id1 _ask_v_1 ?lbl3 ?A30 ?A31 ?A32 ?A33)
(test (neq ?arg1 ?argwA_0))
(test (eq ?ask_id1 (+ ?kriyA 200)))
(not (modified_p1k1 ?karwA))
=>
(retract ?f)
(assert (modified_p1k1 ?karwA))
(assert (MRS_info  ?rel3  ?ask_id1 _ask_v_1  ?lbl3 ?A30 ?argwA_0  ?A32 ?A33))
;(printout ?*rstr-fp* "(MRS_info "?rel3 " " ?ask_id1 " _ask_v_1" ?lbl3 " "?A30 " "?argwA_0 " " ?A32" "A33")"crlf)
(printout ?*rstr-dbug* "(rule-rel-values v-p1k1 MRS_info "?rel3 " " ?ask_id1 " _ask_v_1 " ?lbl3 " "?A30 " "?argwA_0 " " ?A32" "A33")"crlf)
)

;mAz ne rAma se bacce ko KAnA KilavAyA.
;Rule to bind ARG1 of make_v_cause with ARG0 of karwa. 
(defrule v-mk1
(id-double_causative	?kriya	yes)
(rel_name-ids	mk1	?kriyA ?karwA)
(MRS_info ?rel_name ?kriyA ?mrsCon ?lbl ?arg0 ?arg1 $?v)
(MRS_info ?rel1 ?karwA ?mrsCon1 ?lbl1 ?argwA_0 $?vars)
?f1<-(MRS_info ?rel3 ?ask_id1 _ask_v_1 ?lbl3 ?A30 ?A31 ?A32 ?A33)
?f2<-(MRS_info ?rel2 ?make_v_id _make_v_cause ?lbl2 ?A20 ?A21 ?A22)
(test (neq ?arg1 ?argwA_0))
(test (eq ?ask_id1 (+ ?kriyA 200)))
(test (eq ?make_v_id (+ ?kriyA 100)))
(not (modified_mk1 ?karwA))
=>
(retract ?f1 ?f2)
(assert (modified_mk1 ?karwA))
(assert (MRS_info  ?rel3  ?ask_id1 _ask_v_1  ?lbl3 ?A30 ?A31 ?argwA_0 ?A33))
(assert (MRS_info ?rel2 ?make_v_id _make_v_cause ?lbl2 ?A20 ?argwA_0 ?A22))
(printout ?*rstr-dbug* "(rule-rel-values v-mk1 MRS_info "?rel3 " " ?ask_id1 " _ask_v_1 " ?lbl3 " "?A30 " " ?A31" "?argwA_0 " "?A33")"crlf)
(printout ?*rstr-dbug* "(rule-rel-values v-mk1 MRS_info "?rel2 " " ?make_v_id " _make_v_cause " ?lbl2 " "?A20 " "?argwA_0 " " ?A22")"crlf)
)

;Rule for converting arg1 of kriya with arg0 of karwa
;mAz ne rAma se bacce ko KAnA KilavAyA.
(defrule v-j1k1
(id-double_causative	?kriya	yes)
(rel_name-ids	jk1	?kriyA ?karwA)
?f<-(MRS_info ?rel_name ?kriyA ?mrsCon ?lbl ?arg0 ?arg1 $?v)
(MRS_info ?rel1 ?karwA ?mrsCon1 ?lbl1 ?argwA_0 $?vars)
(MRS_info ?rel2 ?make_v_id _make_v_cause ?lbl2 ?A20 ?A21 ?A22)
(test (neq ?arg1 ?argwA_0))
(test (eq ?make_v_id (+ ?kriyA 100)))
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
?f<-(rel_name-ids k2   ?kri ?k2)
(rel_name-ids k1   ?kri ?k1)
(MRS_info ?rel ?kri _want_v_1 $?vars)
?f1<-(MRS_info ?r ?k2  ?k2v ?l ?a0 ?a1 $?v)
(MRS_info ?r1 ?k1  ?k1mrs ?k1l ?k1a0 $?k1v)
(test (neq (str-index _v_ ?k2v) FALSE))
=>
(retract ?f ?f1)
(printout ?*rstr-dbug* "(rule-rel-values want-k2-deleted rel_name-ids k2 "?kri" "?k2")"crlf) 

(printout ?*rstr-fp* "(MRS_info "?r" "?k2" "?k2v" "?l" "?a0" "?k1a0" "(implode$ (create$ $?v))")"crlf) 
(printout ?*rstr-dbug* "(rule-rel-values want-k2-deleted MRS_info "?r" "?k2" "?k2v" "?l" "?a0" "?k1a0" "(implode$ (create$ $?v))")"crlf) 
)


;Rule for verb and its arguments(when both karta and karma are present),Replace ARG1 value of kriyA with ARG0 value of karwA and ARG2 value of kriyA with ARG0 value of karma
(defrule v-k2
(rel_name-ids	k2|k1s       	?kriyA ?karma)
?f<-(MRS_info ?rel_name ?kriyA ?mrsCon ?lbl ?arg0 ?arg1 ?arg2 $?v)
(MRS_info ?rel2 ?karma ?mrsCon2 ?lbl2 ?argma_0 $?vars1)
(test (neq (sub-string (- (str-length ?mrsCon2) 1) (str-length ?mrsCon2) ?mrsCon2) "_q")) ;I asked Rama a question. What do the animals eat? What did Hari fill in the pot?
(test (neq (str-index _v_ ?mrsCon) FALSE))
(test (neq ?arg2 ?argma_0))
(not (modified_k2 ?karma))
(not (rel_name-ids vmod_pka ?kri	?id)) ;#राम खा -खाकर मोटा हो गया ।
=>
(retract ?f)
(assert (modified_k2 ?karma))
(assert (MRS_info  ?rel_name  ?kriyA  ?mrsCon  ?lbl ?arg0 ?arg1 ?argma_0  $?v))
(printout ?*rstr-dbug* "(rule-rel-values v-k2 "?rel_name " " ?kriyA " " ?mrsCon " " ?lbl " "?arg0 " " ?arg1 " " ?argma_0 " "(implode$ (create$ $?v))")"crlf)
)

;Rule to bind every_q with kriya by converting arg2 of kriya with arg0 of every_q
;rAma sabako skUla bulAwA hE.
(defrule v-k2_every
(rel_name-ids    k2         ?kriyA ?every_q)
?f<-(MRS_info ?rel_name ?kriyA ?mrsCon ?lbl ?arg0 ?arg1 ?arg2 $?v)
(MRS_info ?rel2 ?every_q every_q  ?lbl2 ?argma_0 $?v1)
;(MRS_info ?rel3 ?per person  ?l ?a0)
(test (neq (str-index _v_ ?mrsCon) FALSE))
(test (neq ?arg2 ?argma_0))
(not (modified_k2 ?every_q))
=>
(retract ?f)
(assert (modified_k2 ?every_q))
(assert (MRS_info  ?rel_name  ?kriyA  ?mrsCon  ?lbl ?arg0 ?arg1 ?argma_0 $?v))
(printout ?*rstr-dbug* "(rule-rel-values v-k2_every "?rel_name " " ?kriyA " " ?mrsCon " " ?lbl " "?arg0 " " ?arg1 " " ?argma_0 " "(implode$ (create$ $?v))")"crlf)
)


;genrates binding for get_v_state
(defrule v-stative
(id-stative	?kriyA	yes)
(not (sentence_type  pass-affirmative))
(MRS_info ?rel_name ?kriyA ?mrsCon ?lbl ?arg0 ?arg1 ?arg2 $?v)
?f<-(MRS_info ?rel3 ?get_v_id ?getVState ?lbl3 ?getA0 ?getA1 ?A2)
(test (eq ?get_v_id (+ ?kriyA 100)))
(not (modified_Arg1 ?getA1))
(not (id-causative ?id yes)) ;SikRikA ne CAwroM se kakRA ko sAPa karAyA.
=>
(retract ?f)
(assert (modified_Arg1 ?getA1))
(assert (MRS_info  ?rel3  ?get_v_id ?getVState  ?lbl3 ?getA0 ?arg1  ?A2))
(printout ?*rstr-dbug* "(rule-rel-values stative "?rel3 " " ?get_v_id " " ?getVState " " ?lbl3 " "?getA0 " "?arg1 " " ?A2")"crlf)
)

;genrates binding for get_v_state passive sentence
(defrule v-stativepa
(id-stative	?kriyA	yes)
(sentence_type  pass-affirmative)
(MRS_info ?rel_name ?kriyA ?mrsCon ?lbl ?arg0 ?arg1 ?arg2 $?v)
?f<-(MRS_info ?rel3 ?get_v_id ?getVState ?lbl3 ?getA0 ?getA1 ?A2)
(test (eq ?get_v_id (+ ?kriyA 100)))
(not (modified_Arg1 ?getA1))
(not (id-causative ?id yes)) ;SikRikA ne CAwroM se kakRA ko sAPa karAyA.
=>
(retract ?f)
(assert (modified_Arg1 ?getA1))
(assert (MRS_info  ?rel3  ?get_v_id ?getVState  ?lbl3 ?getA0 ?arg2  ?A2))
(printout ?*rstr-dbug* "(rule-rel-values stativepa "?rel3 " " ?get_v_id " " ?getVState " " ?lbl3 " "?getA0 " "?arg2 " " ?A2")"crlf)
)

(defrule v-in
(rel_name-ids	k7t	?id1	?id2)
(MRS_info id-MRS_concept-LBL-ARG0-ARG1 ?id2 ?dnn ?lbl2 ?arg10 ?arg11)
(MRS_info id-MRS_concept-LBL-ARG0-ARG1-ARG2 ?id1 ?v ?lbl1 ?arg0 ?arg1 ?arg2)
(MRS_info id-MRS_concept-LBL-ARG0-ARG1 ?id4 _can_v_modal ?lbl3 ?arg20 ?arg21)
?f3<-(MRS_info id-MRS_concept-LBL-ARG0-ARG1-ARG2 ?id3 _at_p_temp ?lbl4 ?arg30 ?arg31 ?arg32)
(test (eq ?id1 (- ?id4 100)))
(test (eq ?id2 (- ?id3 1)))
(not (modified_at ?id3))
=>
(retract ?f3)
(assert (modified_at ?id3))
(assert (MRS_info id-MRS_concept-LBL-ARG0-ARG1-ARG2 ?id3 _at_p_temp ?lbl1 ?arg30 ?arg0 ?arg10))
(printout ?*rstr-dbug* "(rule-rel-values v-in MRS_info id-MRS_concept-LBL-ARG0-ARG1-ARG2 "?id3" _at_p_temp "?lbl1" "?arg30" "?arg0" "?arg10")"crlf)
)

(defrule v-day
(rel_name-ids	k7t	?id1	?id2)
(MRS_info id-MRS_concept-LBL-ARG0 ?id2 ?dnn ?lbl2 ?arg10 )
(MRS_info id-MRS_concept-LBL-ARG0-ARG1-ARG2 ?id1 ?v ?lbl1 ?arg0 ?arg1 ?arg2)
?f2<-(MRS_info id-MRS_concept-LBL-ARG0-RSTR-BODY ?id2 def_implicit_q ?lbl3 ?arg20 ?arg21 ?arg22)
?f3<-(MRS_info id-MRS_concept-LBL-ARG0-ARG1-ARG2 ?id3 _at_p_temp ?lbl4 ?arg30 ?arg31 ?arg32)
(test (eq ?id2 (- ?id3 1)))
(not (modified_at ?id3))
=>
(retract ?f2 ?f3)
(assert (modified_at ?id3))
;(assert (MRS_info id-MRS_concept-LBL-ARG0-RSTR-BODY ?id2 def_implicit_q ?lbl3 ?arg10 ?arg21 ?arg22))
(printout ?*rstr-fp* "(MRS_info id-MRS_concept-LBL-ARG0-RSTR-BODY "?id2" def_implicit_q "?lbl3" "?arg10" "?arg21" "?arg22")"crlf)
(printout ?*rstr-dbug* "(rule-rel-values v-day MRS_info id-MRS_concept-LBL-ARG0-RSTR-BODY "?id2" def_implicit_q "?lbl3" "?arg10" "?arg21" "?arg22")"crlf)

;(assert (MRS_info id-MRS_concept-LBL-ARG0-ARG1-ARG2 ?id3 _at_p_temp ?lbl1 ?arg30 ?arg0 ?arg10))
(printout ?*rstr-fp* "(MRS_info id-MRS_concept-LBL-ARG0-ARG1-ARG2 "?id3" _at_p_temp "?lbl1" "?arg30" "?arg0" "?arg10")"crlf)
(printout ?*rstr-dbug* "(rule-rel-values v-day MRS_info id-MRS_concept-LBL-ARG0-ARG1-ARG2 "?id3" _at_p_temp "?lbl1" "?arg30" "?arg0" "?arg10")"crlf)
)


;Rule for verb and its arguments(when  karta, karma and sampradaan are present),Replace ARG3 value of kriyA with ARG0 value of sampradaan and ARG2 value of kriyA with ARG0 value of karma
(defrule v-k4
(rel_name-ids	k4|k2g|k2s   	?kriyA ?k4)
?f<-(MRS_info id-MRS_concept-LBL-ARG0-ARG1-ARG2-ARG3 ?kriyA ?mrsCon ?lbl ?arg0 ?arg1 ?arg2 ?arg3 )
(MRS_info ?rel2 ?k4 ?mrsCon2 ?lbl2 ?argk4_0 $?vars1)
(test (eq (str-index _q ?mrsCon2) FALSE))
(test (neq ?arg2 ?argk4_0))
(not (arg3_bind ?arg3))
=>
(retract ?f)
(assert (arg3_bind ?argk4_0 ))
(assert (MRS_info  id-MRS_concept-LBL-ARG0-ARG1-ARG2-ARG3  ?kriyA  ?mrsCon  ?lbl ?arg0 ?arg1 ?arg2 ?argk4_0  ))
(printout ?*rstr-dbug* "(rule-rel-values v-k4 id-MRS_concept-LBL-ARG0-ARG1-ARG2-ARG3  " ?kriyA " " ?mrsCon " " ?lbl " " ?arg0 " " ?arg1 " " ?arg2 " " ?argk4_0 ")"crlf)
)

;Rule for preposition for noun : for (kriyA-k*/r* ?1 ?2) and (id-MRS_Rel ?2 k*/r* corresponding prep_rel from dic)
;Replace ARG1 value of prep_rel with ARG0 value of ?1 and ARG2 value of prep_rel with ARG0 value of ?2)
;Ex. Sera_ne_yuxXa_ke_liye_jaMgala_meM_saBA_bulAI
(defrule prep-noun
(rel_name-ids ?relp ?kriyA ?karak)
?f<-(MRS_info ?rel_name ?prep ?endsWith_p ?lbl ?arg0 ?arg1 $?v)
(MRS_info ?rel1 ?kriyA ?mrsCon1 ?lbl1 ?argv_0 $?vars)
(MRS_info ?rel2 ?karak ?mrsCon2 ?lbl2 ?argn_0 $?varss)
(test (eq (sub-string 1 1 (str-cat ?prep)) (sub-string 1 1 (str-cat ?karak))))
(test (eq (sub-string (- (str-length ?endsWith_p) 1) (str-length ?endsWith_p) ?endsWith_p) "_p"))
;(test (neq (str-index "_n_" ?mrsCon2)FALSE))
(test (or (neq (str-index "_n_" ?mrsCon2)FALSE) (eq ?mrsCon2 nominalization) ))
=>
(retract ?f)
(printout ?*rstr-fp* "(MRS_info  " ?rel_name " " ?prep " " ?endsWith_p " " ?lbl1 " " ?arg0 " " ?argv_0 " " ?argn_0 ")"crlf)
(printout ?*rstr-dbug* "(rule-rel-values prep-noun "?rel_name " " ?prep " " ?endsWith_p " " ?lbl1" " ?arg0 " " ?argv_0 " " ?argn_0 ")"crlf)
)

;written by sakshi yadav (NIT-Raipur)
;date-27.05.19
;Rule for verb and when word 'home' is present:
;Replace LBL of loc_nonsp with LBL of verb and  ARG1 of loc_nonsp with ARG0 of verb and LBL of place_n with LBL of home_p and ARG0 of place_n ,ARG2 of home_p,ARG0 of de_implicit_q with ARG2 of loc_nonsp.
;Ex- i am coming home
(defrule v-home
?f<-(MRS_info id-MRS_concept-LBL-ARG0-ARG1-ARG2 ?id loc_nonsp ?lbl ?arg0 ?arg1 ?arg2)
?f1<-(MRS_info id-MRS_concept-LBL-ARG0-RSTR-BODY ?id def_implicit_q ?lbl1 ?arg01 ?rstr ?body)
?f2<-(MRS_info id-MRS_concept-LBL-ARG0 ?id place_n ?lbl2 ?arg02)
?f3<-(MRS_info id-MRS_concept-LBL-ARG0-ARG1 ?id ?home ?lbl3 ?arg03 ?arg13)
(MRS_info id-MRS_concept-LBL-ARG0-ARG1 ?id1 ?v ?lbl4 ?arg04 ?arg14)
(test (neq (str-index "_v_" ?v)FALSE))
(test (or (eq ?home  _there_a_1)
(eq ?home  _home_p)))
=>
(retract ?f ?f1 ?f2 ?f3)
(printout ?*rstr-fp* "(MRS_info id-MRS_concept-LBL-ARG0-ARG1-ARG2 "?id " loc_nonsp " ?lbl4 " " ?arg0" " ?arg04 " " ?arg2 ")"crlf)
(printout ?*rstr-dbug* "(rule-rel-values v-home id-MRS_concept-LBL-ARG0-ARG1-ARG2 "?id " loc_nonsp " ?lbl4 " " ?arg0 " " ?arg04 " " ?arg2 ")"crlf)

(printout ?*rstr-fp* "(MRS_info id-MRS_concept-LBL-ARG0  "?id" place_n "?lbl3" "?arg2 ")"crlf)
(printout ?*rstr-dbug* "(rule-rel-values v-home id-MRS_concept-LBL-ARG0  "?id" place_n "?lbl3" "?arg2 ")"crlf)

(printout ?*rstr-fp* "(MRS_info id-MRS_concept-LBL-ARG0-ARG1 "?id " " ?home" "?lbl3"  "?arg03" "?arg2 ")"crlf)
(printout ?*rstr-dbug* "(rule-rel-values v-home id-MRS_concept-LBL-ARG0-ARG1 "?id " " ?home" "?lbl3"  "?arg03" "?arg2 ")"crlf)

(printout ?*rstr-fp* "(MRS_info id-MRS_concept-LBL-ARG0-RSTR-BODY "?id" def_implicit_q "?lbl1" "?arg2" "?rstr" "?body ")"crlf)
(printout ?*rstr-dbug* "(rule-rel-values v-home id-MRS_concept-LBL-ARG0-RSTR-BODY "?id" def_implicit_q "?lbl1" "?arg2" "?rstr" "?body ")"crlf)
)

;#mEM vahAz A rahA hUz.
(defrule v-there
?f<-(MRS_info id-MRS_concept-LBL-ARG0-ARG1-ARG2 ?id loc_nonsp ?lbl ?arg0 ?arg1 ?arg2)
?f1<-(MRS_info id-MRS_concept-LBL-ARG0-RSTR-BODY ?id def_implicit_q ?lbl1 ?arg01 ?rstr ?body)
?f2<-(MRS_info id-MRS_concept-LBL-ARG0 ?id place_n ?lbl2 ?arg02)
?f3<-(MRS_info id-MRS_concept-LBL-ARG0-ARG1 ?id _there_a_1 ?lbl3 ?arg03 ?arg13)
(rel_name-ids	AXAra-AXeya	?adhar  ?adhey)
(MRS_info id-MRS_concept-LBL-ARG0 ?adhey ?mrs ?l ?a0)
(not (modified loc_nonsp))
;(MRS_info id-MRS_concept-LBL-ARG0-ARG1 ?id1 ?v ?lbl4 ?arg04 ?arg14)
;(test (neq (str-index "_v_" ?v)FALSE))
=>
(retract ?f ?f1 ?f2 ?f3)
(assert (modified loc_nonsp))
(assert (MRS_info id-MRS_concept-LBL-ARG0-ARG1-ARG2 ?id loc_nonsp  ?lbl ?arg0 ?a0  ?arg02))
;(printout ?*rstr-fp* "(MRS_info id-MRS_concept-LBL-ARG0-ARG1-ARG2 "?id " loc_nonsp " ?lbl " " ?arg0" " ?a0 " " ?arg02 ")"crlf)
(printout ?*rstr-dbug* "(rule-rel-values v-there  id-MRS_concept-LBL-ARG0-ARG1-ARG2 "?id" loc_nonsp "?lbl" "?arg0" "?a0" "?arg02")"crlf)

(printout ?*rstr-fp* "(MRS_info id-MRS_concept-LBL-ARG0  "?id" place_n "?lbl3" "?arg02 ")"crlf)
(printout ?*rstr-dbug* "(rule-rel-values v-there  id-MRS_concept-LBL-ARG0  "?id" place_n "?lbl3" "?arg02 ")"crlf)

(printout ?*rstr-fp* "(MRS_info id-MRS_concept-LBL-ARG0-ARG1 "?id " _there_a_1 "?lbl3"  "?arg03" "?arg02 ")"crlf)
(printout ?*rstr-dbug* "(rule-rel-values v-there  id-MRS_concept-LBL-ARG0-ARG1 "?id " _there_a_1 "?lbl3"  "?arg03" "?arg02 ")"crlf)

(printout ?*rstr-fp* "(MRS_info id-MRS_concept-LBL-ARG0-RSTR-BODY "?id" def_implicit_q "?lbl1" "?arg02" "?rstr" "?body ")"crlf)
(printout ?*rstr-dbug* "(rule-rel-values v-there id-MRS_concept-LBL-ARG0-RSTR-BODY "?id" def_implicit_q "?lbl1" "?arg02" "?rstr" "?body ")"crlf)
)

;written by sakshi yadav (NIT-Raipur) date-27.05.19
;Rule for verb and word yesterday,today,tomorrow is present :
;Replace LBL of loc_nonsp with LBL of verb and  ARG1 of loc_nonsp with ARG0 of verb and LBL of place_n with LBL of home_p and ARG1 of mrs_time  ,ARG0 of time_n home_p,ARG0 of de_implicit_q with ARG2 of loc_nonsp
;Ex- i came yesterday, i will come tomorrow, i come today. I will play a game today.
(defrule v-time
?f<-(MRS_info id-MRS_concept-LBL-ARG0-ARG1-ARG2 ?id loc_nonsp ?lbl ?arg0 ?arg1 ?arg2)
?f1<-(MRS_info id-MRS_concept-LBL-ARG0-RSTR-BODY ?id def_implicit_q ?lbl1 ?arg01 ?rstr ?body)
?f2<-(MRS_info id-MRS_concept-LBL-ARG0 ?id time_n ?lbl2 ?arg02)
?f3<-(MRS_info id-MRS_concept-LBL-ARG0-ARG1 ?id ?mrs_time ?lbl3 ?arg03 ?arg13)
(MRS_info ?rel ?id1 ?v ?lbl4 ?arg04 $?vars); It will rain tomorrow. kala varRA hogI.
(rel_name-ids   ?relname        ?id1  ?id)
(test (neq (str-index "_v_" ?v)FALSE))
(test (or (eq ?mrs_time _yesterday_a_1) (eq ?mrs_time _today_a_1) (eq ?mrs_time _tomorrow_a_1)(eq ?mrs_time _early_a_1) (eq ?mrs_time _now_a_1)(eq ?mrs_time _late_p)))
=>
(retract ?f ?f1 ?f2 ?f3)
(printout ?*rstr-fp* "(MRS_info id-MRS_concept-LBL-ARG0-ARG1-ARG2 "?id " loc_nonsp " ?lbl4 " " ?arg0" " ?arg04 " " ?arg2 ")"crlf)
(printout ?*rstr-dbug* "(rule-rel-values v-time id-MRS_concept-LBL-ARG0-ARG1-ARG2 "?id " loc_nonsp " ?lbl4 " " ?arg0 " " ?arg04 " " ?arg2 ")"crlf)

(printout ?*rstr-fp* "(MRS_info id-MRS_concept-LBL-ARG0  "?id" time_n "?lbl3" "?arg2 ")"crlf)
(printout ?*rstr-dbug* "(rule-rel-values v-time id-MRS_concept-LBL-ARG0  "?id" time_n "?lbl3" "?arg2 ")"crlf)

(printout ?*rstr-fp* "(MRS_info id-MRS_concept-LBL-ARG0-ARG1 "?id " " ?mrs_time " "?lbl3"  "?arg03" "?arg2 ")"crlf)
(printout ?*rstr-dbug* "(rule-rel-values v-time id-MRS_concept-LBL-ARG0-ARG1 "?id " " ?mrs_time " "?lbl3"  "?arg03" "?arg2 ")"crlf)

(printout ?*rstr-fp* "(MRS_info id-MRS_concept-LBL-ARG0-RSTR-BODY "?id" def_implicit_q "?lbl1" "?arg2" "?rstr" "?body ")"crlf)
(printout ?*rstr-dbug* "(rule-rel-values v-time id-MRS_concept-LBL-ARG0-RSTR-BODY "?id" def_implicit_q "?lbl1" "?arg2" "?rstr" "?body ")"crlf)
)

;Rule for time adverb (today, tomorrow, yesterday) with samanadhi relation
;Replace LBL of _today_a_1 with LBL of time_n and  ARG1 of _today_a_1 with ARG0 of time.
;Replace ARG0 of def_implicit_q with ARG0 of time_n
;Replace ARG1 of verb with ARG0 of time_n and ARG2 of verb with ARG0 of the other samAnAXi relation
;ex INPUT: Aja somavAra hE. OUTPUT: Today is Monday.
;ex INPUT: Aja skUla meM merA pahalA xina hE. OUTPUT: Today is my first day at the school.

(defrule time-samAnAXi
(id-concept_label       ?v_id   state_copula|hE_1|WA_1)
(rel_name-ids   samAnAXi        ?s-id1  ?s-id2)
(id-concept_label  ?k-id   ?hiConcept&Aja_1|kala_1|kala_2)
?f<-(MRS_info ?rel_name ?v_id ?mrsCon ?lbl ?arg0 ?arg1 ?arg2 )
(MRS_info id-MRS_concept-LBL-ARG0-RSTR-BODY ?id def_implicit_q ?lbl1 ?arg01 ?rstr ?body)
(MRS_info id-MRS_concept-LBL-ARG0 ?id time_n ?lbl2 ?arg02)
(MRS_info id-MRS_concept-LBL-ARG0-ARG1 ?id ?mrs_time ?lbl3 ?arg03 ?arg13)
(MRS_info id-MRS_concept-LBL-ARG0-ARG1 ?rel1 ?s-id2 ?mrsCon2 ?s-id2_lbl ?s-id2_arg0 $?vars)
(test (neq (str-index "_v_" ?v_id)FALSE))
(test (eq (str-index _q ?id) FALSE))
(test (neq ?arg1 ?arg02))
(not (modified_samAnAXi ?s-id1))
(test (or (eq ?mrs_time _yesterday_a_1) (eq ?mrs_time _today_a_1) (eq ?mrs_time _tomorrow_a_1)))
=>
(assert (modified_samAnAXi ?s-id1))
(assert (MRS_info  ?rel_name ?v_id ?mrsCon ?lbl ?arg0 ?arg02 ?s-id2_arg0 ))
(printout ?*rstr-dbug* "(rule-rel-values time-samAnAXi "?rel_name " " ?v_id " " ?mrsCon " " ?lbl " " ?arg0 " " ?s-id2_arg0 ")"crlf)

(printout ?*rstr-fp* "(MRS_info id-MRS_concept-LBL-ARG0  "?id" time_n "?lbl3" "?arg02 ")"crlf)
(printout ?*rstr-dbug* "(rule-rel-values time-samAnAXi id-MRS_concept-LBL-ARG0  "?id" time_n "?lbl3" "?arg02 ")"crlf)

(printout ?*rstr-fp* "(MRS_info id-MRS_concept-LBL-ARG0-ARG1 "?id " " ?mrs_time " "?lbl3"  "?arg03" "?arg02 ")"crlf)
(printout ?*rstr-dbug* "(rule-rel-values time-samAnAXi id-MRS_concept-LBL-ARG0-ARG1 "?id " " ?mrs_time " "?lbl3"  "?arg03" "?arg02 ")"crlf)

(printout ?*rstr-fp* "(MRS_info id-MRS_concept-LBL-ARG0-RSTR-BODY "?id" def_implicit_q "?lbl1" "?arg02" "?rstr" "?body ")"crlf)
(printout ?*rstr-dbug* "(rule-rel-values time-samAnAXi id-MRS_concept-LBL-ARG0-RSTR-BODY "?id" def_implicit_q "?lbl1" "?arg02" "?rstr" "?body ")"crlf)
)



;Rule for preposition for proper_noun : for (kriyA-k*/r* ?1 ?2) and (id-MRS_Rel ?2 k*/r* corresponding prep_rel from dic)
;Ex. mEM_John_ke_liye_Sahara_se_AyA
;Ex. baccA_somavAra_ko_Pala__KA-wA_hE
;Ex. baccA_janavarI_meM_Pala__KA-wA_hE
(defrule prep-propn
(rel_name-ids ?relp ?kri ?id)
?f1<-(MRS_info ?rel_name ?prep ?endsWith_p ?lbl ?arg0 ?arg1 ?arg2)
(MRS_info ?rel1 ?id ?named ?l  ?namedarg0 $?v)
(MRS_info ?rel2 ?kri ?mrsCon2 ?vlbl ?varg0 $?varss)
(test (or (eq (sub-string (- (str-length ?endsWith_p) 1) (str-length ?endsWith_p) ?endsWith_p) "_p") (neq (str-index "_p_" ?endsWith_p)FALSE)) )
(test (neq (str-index "_v_" ?mrsCon2)FALSE))
(test (eq (sub-string 1 1 (str-cat ?prep)) (sub-string 1 1 (str-cat ?id))))
(test (or (eq ?named named) (eq ?named dofw) (eq ?named mofy))) ;
=>
(retract ?f1)
(printout ?*rstr-fp* "(MRS_info  " ?rel_name " " ?prep " " ?endsWith_p " " ?vlbl " " ?arg0 " " ?varg0 " " ?namedarg0 ")"crlf)
(printout ?*rstr-dbug* "(rule-rel-values prep-propn "?rel_name " " ?prep " " ?endsWith_p " " ?vlbl " " ?arg0 " " ?varg0 " " ?namedarg0 ")"crlf)
)


;Replace LBL and ARG1 values of poss with LBL and ARG0 values of RaRTI_viSeRya and ARG2 with ARG0 of RaRTI_viSeRaNa (r6)
;Replace ARG0 values of def_explicit_q with the ARG0 value of RaRTI_viSeRya
;Ex- John's son studies in the school
;Ex. My friend is playing in the garden.
;Ex. The necklace is in the woman's neck. 
(defrule r6
(rel_name-ids r6	?id	?id1)
?f<-(MRS_info id-MRS_concept-LBL-ARG0-ARG1-ARG2 ?idposs poss ?lbl ?arg0 ?arg1 ?arg2)
?f1<-(MRS_info id-MRS_concept-LBL-ARG0-RSTR-BODY ?id_q def_explicit_q ?lbl1 ?arg01 ?rstr ?body)
(MRS_info ?rel                             ?id ?mrsCon ?lbl6 ?arg00 $?v)  
(MRS_info ?rel1                             ?id1 ?mrsCon1 ?lbl7 ?arg8 $?v1)  
=>
(retract ?f ?f1) 
(printout ?*rstr-fp* "(MRS_info id-MRS_concept-LBL-ARG0-ARG1-ARG2  " ?idposs " poss " ?lbl6 " " ?arg0 " " ?arg00 " " ?arg8 ")"crlf)
(printout ?*rstr-dbug* "(rule-rel-values r6 id-MRS_concept-LBL-ARG0-ARG1-ARG2  " ?idposs " poss " ?lbl6 " " ?arg0 " " ?arg00 " " ?arg8 ")"crlf)

(printout ?*rstr-fp* "(MRS_info id-MRS_concept-LBL-ARG0-RSTR-BODY  " ?id_q " def_explicit_q " ?lbl1 " " ?arg00 " " ?rstr " " ?body ")"crlf)
(printout ?*rstr-dbug* "(rule-rel-values r6  id-MRS_concept-LBL-ARG0-RSTR-BODY  " ?id_q " def_explicit_q " ?lbl1 " " ?arg00 " " ?rstr" " ?body ")"crlf)
)

(defrule adhar-adheya
(rel_name-ids	AXAra-AXeya	?adhar  ?adheya)
(MRS_info id-MRS_concept-LBL-ARG0 ?adheya ?mrs ?l ?a0)
(MRS_info id-MRS_concept-LBL-ARG0-RSTR-BODY ?id_q def_explicit_q ?lbl1 ?arg01 ?rstr1 ?body1)
?f<-(MRS_info id-MRS_concept-LBL-ARG0-ARG1-ARG2 ?adhar loc_nonsp ?lbl ?arg0 ?a1 ?a2)
?f1<-(MRS_info id-MRS_concept-LBL-ARG0-RSTR-BODY ?adhar def_implicit_q ?lbl2 ?a02 ?rstr ?body)
(MRS_info ?rel                             ?adheya ?mrsCon ?lbl6 ?arg00 $?v)
?f2<-(MRS_info id-MRS_concept-LBL-ARG0-ARG1 ?adhar _there_a_1 ?lbl7 ?a07 ?a17)
?f3<-(MRS_info id-MRS_concept-LBL-ARG0 ?adhar place_n ?lbl8 ?a08)
=>
(retract ?f ?f1 ?f2 ?f3)
(assert (MRS_info id-MRS_concept-LBL-ARG0-ARG1-ARG2  ?adhar  loc_nonsp  ?lbl ?arg0 ?arg00 ?a17))
(printout ?*rstr-dbug* "(rule-rel-values adhar-adheya id-MRS_concept-LBL-ARG0-ARG1-ARG2  "?adhar" loc_nonsp "?lbl" "?arg0" "?arg00" "?a17")"crlf)

(printout ?*rstr-fp* "(MRS_info id-MRS_concept-LBL-ARG0-RSTR-BODY  " ?adhar" def_implicit_q "?lbl2 " " ?a17 " " ?rstr " " ?body ")"crlf)
(printout ?*rstr-dbug* "(rule-rel-values adhar-adheya id-MRS_concept-LBL-ARG0-RSTR-BODY  "?adhar" def_implicit_q "?lbl2" "?a17" "?rstr" "?body")"crlf)

(printout ?*rstr-fp* "(MRS_info id-MRS_concept-LBL-ARG0-ARG1 " ?adhar " _there_a_1 " ?lbl7" "?a07" "?a17")"crlf)
(printout ?*rstr-dbug* "(rule-rel-values adhar-adheya id-MRS_concept-LBL-ARG0-ARG1  " ?adhar" _there_a_1 " ?lbl7 " " ?a07 " " ?a17")"crlf)

(printout ?*rstr-fp* "(MRS_info id-MRS_concept-LBL-ARG0 " ?adhar " place_n "?lbl7" "?a17")"crlf)
(printout ?*rstr-dbug* "(rule-rel-values adhar-adheya id-MRS_concept-LBL-ARG0 "?adhar" place_n " ?lbl7 " " ?a17 ")"crlf)
)


;Rule for preposition for pronoun : when (id-pron ? yes) for (kriyA-k*/r* ?1 ?2) and (id-MRS_Rel ?2 k*/r* corresponding prep_rel from dic)
;Replace ARG1 value of prep_rel with ARG0 value of ?1 and ARG2 value of prep_rel with ARG0 value of ?2)
;Ex. mEM_usake_lie_Sahara_se_AyA
(defrule prep-pron
(rel_name-ids ?relp ?kriyA ?karaka)
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


;Rule for interrogative sent 'where'
;#Apa kahAz rahawe hEM?
(defrule ques-where
(declare (salience 100))
(rel_name-ids	?r	?id1	?id2)
(MRS_info ?rel1 ?id1 ?kri ?kl ?ka0 $?vars)
(MRS_info ?rel ?id2 place_n ?pl ?pa0)
?f<- (MRS_info ?rel2 ?id loc_nonsp ?ll ?la0 ?la1 ?la2)
?f1<-(MRS_info ?rel_name ?id which_q ?wl ?wa0 $?v)
(test (neq (str-index "_v_" ?kri)FALSE))
=>
(retract ?f ?f1)
(printout ?*rstr-fp* "(MRS_info  " ?rel2 " "?id " loc_nonsp " ?kl " " ?la0 " " ?ka0" "?pa0")"crlf)
(printout ?*rstr-dbug* "(rule-rel-values ques-where  " ?rel2 " "?id " loc_nonsp " ?kl " " ?la0 " " ?ka0 " " ?pa0 ")"crlf)

(printout ?*rstr-fp* "(MRS_info  " ?rel_name " "?id " which_q " ?wl " " ?pa0 " " (implode$ (create$ $?v)) ")"crlf)
(printout ?*rstr-dbug* "(rule-rel-values ques-where  " ?rel_name " "?id " which_q " ?wl " " ?pa0 " " (implode$ (create$ $?v))")"crlf)
)



;Rule for interrogative sent 'when'
;#vaha kaba jA rahA hE?
(defrule ques-when
(MRS_info ?rel ?id time_n ?tlbl ?targ0)
(MRS_info ?rel1 ?id1 ?mrsCon1 ?glbl ?garg0 $?vars)
?f<- (MRS_info ?rel2 ?id2 loc_nonsp ?lbl ?arg0 ?arg1 ?arg2)
?f1<-(MRS_info ?rel_name ?id3 which_q ?whlbl ?wharg0 $?v)
=>
(retract ?f ?f1)
(printout ?*rstr-fp* "(MRS_info  " ?rel2 " "?id2 " " loc_nonsp " " ?glbl " " ?arg0 " " ?garg0 " " ?targ0 ")"crlf)
(printout ?*rstr-dbug* "(rule-rel-values ques-when  " ?rel2 " "?id2 " " loc_nonsp " " ?glbl " " ?arg0 " " ?garg0 " " ?targ0 ")"crlf)

(printout ?*rstr-fp* "(MRS_info  " ?rel_name " "?id3 " " which_q " " ?whlbl " " ?targ0 " "(implode$ (create$ $?v))")"crlf)
(printout ?*rstr-dbug* "(rule-rel-values ques-when  " ?rel_name " "?id3 " " which_q " " ?whlbl " " ?targ0 " "(implode$ (create$ $?v))")"crlf)
)


;Rule for binding proper noun (proper_q) and named ARG0 values. And, replace CARG value with proper name present in the sent. 
;Ex. rAma_jA_rahA_hE.  kyA_rAma_jA_rahA_hE?
(defrule propn
(declare (salience 1000))
(id-concept_label	?id	?properName)
?f<-(MRS_info id-MRS_concept-LBL-ARG0-CARG ?id ?named ?h1 ?x2 ?carg)
(test (eq ?named named) )
(not (modified ?id))
=>
(retract ?f)
(assert (MRS_info  id-MRS_concept-LBL-ARG0-CARG  ?id  ?named ?h1 ?x2  (sym-cat (upcase (sub-string 1 1 ?properName ))(lowcase (sub-string 2 (str-length ?properName) ?properName )))))
(printout ?*rstr-dbug* "(rule-rel-values propn id-MRS_concept-LBL-ARG0-CARG "?id"  "?named " "?h1" "?x2" " (sym-cat (upcase (sub-string 1 1 ?properName )) (lowcase (sub-string 2 (str-length ?properName) ?properName ))) ")"crlf)
(assert (modified ?id))
)

;Rule for generating CARG value 'Mon' in days of week and 'Jan' in months of year
(defrule dofw
?f1<-(id-concept_label	?id	?con)
(or (mofy ?con ?val) (dofw ?con ?val))
?f<-(MRS_info id-MRS_concept-LBL-ARG0-CARG ?id ?dofw  ?h1 ?x2 ?carg)
(test (or (eq ?dofw mofy) (eq ?dofw dofw)))
=>
(retract ?f ?f1)
(assert (MRS_info  id-MRS_concept-LBL-ARG0-CARG ?id  ?dofw ?h1 ?x2  ?val))
(printout ?*rstr-dbug* "(rule-rel-values dofw id-MRS_concept-LBL-ARG0-CARG "?id"  "?dofw " "?h1" "?x2" " ?val ")"crlf)
)


;Rule for numerical adjectives. Replace CARG value of cardinal number with English number and LBL value of the same fact with LBL of viSeRya, and ARG1 value with the ARG0 value of viSeRya.
;Ex. rAma xo kiwAbaeM paDa rahA hE.
(defrule saMKyA_vi
(declare (salience 1000))
(id-concept_label ?num ?hnum)
(rel_name-ids ord|card	?vi     ?num)
(concept_label-concept_in_Eng-MRS_concept ?hnum ?enum card|ord)
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
     ;(printout ?*rstr-fp* "(MRS_info  id-MRS_concept-LBL-ARG0-ARG1-CARG "?num" " ?ord " "?vilbl" "?numARG0" "?viarg0" "?myEnum")"crlf)
     (printout ?*rstr-dbug* "(rule-rel-values saMKyA_vi id-MRS_concept-LBL-ARG0-ARG1-CARG "?num" " ?ord " "?vilbl" "?numARG0" "?viarg0" "?myEnum")"crlf)
else
   (printout ?*rstr-fp* "(MRS_info  id-MRS_concept-LBL-ARG0-ARG1-CARG "?num" " ?ord " "?vilbl" " ?numARG0 " "?viarg0" " ?enum ")"crlf)
   (printout ?*rstr-dbug* "(rule-rel-values saMKyA_vi id-MRS_concept-LBL-ARG0-ARG1-CARG "?num" " ?ord " "?vilbl" "?numARG0" "?viarg0" "?enum")"crlf)
)
)

;Rule for numerical adjectives. Replace 
;CARG value of ordinal number with English number and LBL value of the same fact with LBL of viSeRya and ARG1 value with ARG0 value of viSeRya.
;Ex. rAma pahalI kiwAba paDa rahA hE.
(defrule kramavAcI_vi
(id-concept_label ?num ?hnum)
(rel_name-ids card   ?vi     ?num)
(concept_label-concept_in_Eng-MRS_concept ?hnum ?enum ord)
?f<-(MRS_info  id-MRS_concept-LBL-ARG0-ARG1-CARG ?num ord ?lbl ?numARG0 ?ARG1 ?CARG)
(MRS_info ?rel ?vi ?mrscon ?vilbl ?viarg0 $?v)
=>
(retract ?f)
(printout ?*rstr-fp* "(MRS_info  id-MRS_concept-LBL-ARG0-ARG1-CARG "?num" ord "?vilbl" " ?numARG0 " "?viarg0" " ?enum ")"crlf)
(printout ?*rstr-dbug* "(rule-rel-values kramavAcI_vi id-MRS_concept-LBL-ARG0-ARG1-CARG "?num" ord "?vilbl" "?numARG0" "?viarg0" "?enum")"crlf)
)

;Rule for demonstrative adjectives.
;Replace CARG value of cardinal number with English number and LBL value of the same fact with LBL of viSeRya, and ARG1 value with the ARG0 value of viSeRya.
;Ex. rAma xo kiwAbaeM paDa rahA hE.
;(defrule demonstrative
;(rel_name-ids viSeRya-dem	?vi     ?dem)
;(concept_label-concept_in_Eng-MRS_concept ?hdem ?edem this_q_dem)
;(MRS_info  id-MRS_concept-LBL-ARG0-ARG1-CARG ?num card ?lbl ?numARG0 ?ARG1 ?CARG)
;(MRS_info id-MRS_concept-LBL-ARG0-RSTR-BODY ?dem _this_q_dem ?lbl ?demARG0 ?RSTR ?BODY)
;(MRS_info ?rel ?vi ?mrscon ?vilbl ?viarg0 $?v)
;=>
;(printout ?*rstr-fp* "(MRS_info id-MRS_concept-LBL-ARG0-RSTR-BODY _this_q_dem "?lbl" "?viarg0" "?RSTR" "?BODY")"crlf)
;(printout ?*rstr-dbug* "(rule-rel-values demonstrative id-MRS_concept-LBL-ARG0-RSTR-BODY _this_q_dem "?lbl" "?viarg0" "?RSTR" "?BODY")"crlf)
;)


;Rule for sentence and tam info: (if (kriyA-TAM), value of id = value of kriyA from the facts kriyA-TAM, SF from sentence_type and the rest from tam_mapping.csv)
;for asssertive sentence information
(defrule kri-tam-asser
(kriyA-TAM ?kri ?tam)
(sentence_type  affirmative|pass-affirmative)
(H_TAM-E_TAM-Perfective_Aspect-Progressive_Aspect-Tense-Type ?tam ?e_tam ?perf ?prog ?tense ?typ)
=>
(printout ?*rstr-fp* "(id-SF-TENSE-MOOD-PROG-PERF "?kri " prop " ?tense " indicative " ?prog " " ?perf  ")"crlf)
(printout ?*rstr-dbug* "(rule-rel-values kri-tam-asser id-SF-TENSE-MOOD-PROG-PERF "?kri " prop " ?tense " indicative " ?prog " " ?perf ")"crlf)
)

;rule creates TAM for vmod_pk and vmod_pka
;#rAma ne skUla jAkara KAnA KAyA
(defrule vmod_pk_pka
(rel_name-ids	vmod_pk|vmod_pka	?id	?kri)
=>
(printout ?*rstr-fp* "(id-SF-TENSE-MOOD-PROG-PERF "?kri " prop untensed indicative + + )"crlf)
(printout ?*rstr-dbug* "(rule-rel-values vmod_pk_pka id-SF-TENSE-MOOD-PROG-PERF "?kri " prop untensed indicative + + )"crlf)
)

;It creates TAM for vmod_vks
;verified sentence 341 BAgawe hue Sera ko xeKo
(defrule vmod_vks
(rel_name-ids	vmod_vks ?id	?kri)
=>
(printout ?*rstr-fp* "(id-SF-TENSE-MOOD-PROG-PERF "?kri " prop untensed indicative + - )"crlf)
(printout ?*rstr-dbug* "(rule-rel-values vmod_vks id-SF-TENSE-MOOD-PROG-PERF "?kri " prop untensed indicative + - )"crlf)
)

;It creates TAM for vmod_kr_vn
;verified sentence 338 vaha laMgadAkara calawA hE.
;verified sentence 340 BAgawe hue Sera ko xeKo
(defrule vmod_kr_vn
(rel_name-ids	vmod_kr_vn	?kri	?kvn)
=>
(printout ?*rstr-fp* "(id-SF-TENSE-MOOD-PROG-PERF "?kvn " prop untensed indicative + - )"crlf)
(printout ?*rstr-dbug* "(rule-rel-values vmod_kr_vn id-SF-TENSE-MOOD-PROG-PERF "?kvn " prop untensed indicative + - )"crlf)
)

;It creates TAM for vmod_sk
;verified sentence 339 #rAma sowe hue KarrAte BarawA hE. 
(defrule vmod_sk
(rel_name-ids	vmod_sk	?id	?kri)
=>
(printout ?*rstr-fp* "(id-SF-TENSE-MOOD-PROG-PERF "?kri " prop untensed indicative + - )"crlf)
(printout ?*rstr-dbug* "(rule-rel-values vmod_sk id-SF-TENSE-MOOD-PROG-PERF "?kri " prop untensed indicative + - )"crlf)
)



;genrate tense value for vmod_pk in get_v_state
(defrule vmod_pk2
(rel_name-ids	vmod_pk	?id	?kri)
(id-stative	?id	yes)
=>
(printout ?*rstr-fp* "(id-SF-TENSE-MOOD-PROG-PERF "?id" prop untensed indicative - - )"crlf)
(printout ?*rstr-dbug* "(rule-rel-values vmod_pk2 id-SF-TENSE-MOOD-PROG-PERF "?id" prop untensed indicative - - )"crlf)
)

(defrule vmod_atb
(rel_name-ids	vmod_atb	?kri	?id)
=>
(printout ?*rstr-fp* "(id-SF-TENSE-MOOD-PROG-PERF "?id " prop untensed indicative - - )"crlf)
(printout ?*rstr-dbug* "(rule-rel-values vmod_atb id-SF-TENSE-MOOD-PROG-PERF "?id " prop untensed indicative - - )"crlf)
)

;Rule for creating TAM information for rblak relation verb.  ;gAyoM ke xuhane se pahale rAma Gara gayA.
(defrule rblak
(rel_name-ids	rblak	?kri	?id)
=>
(printout ?*rstr-fp* "(id-SF-TENSE-MOOD-PROG-PERF "?id" prop past indicative - - )"crlf)
(printout ?*rstr-dbug* "(rule-rel-values rblak id-SF-TENSE-MOOD-PROG-PERF "?id" prop past indicative - - )"crlf)
)

;Rule for creating TAM information for rblpk relation verb. ;rAma ke vana jAne para xaSaraWa mara gaye.
(defrule rblpk
(rel_name-ids	rblpk	?kri	?id)
=>
(printout ?*rstr-fp* "(id-SF-TENSE-MOOD-PROG-PERF "?id" prop past indicative - - )"crlf)
(printout ?*rstr-dbug* "(rule-rel-values rblpk id-SF-TENSE-MOOD-PROG-PERF "?id" prop past indicative - - )"crlf)
)


;for negation sentence information
;#mEM rUsI nahIM bola sakawA hUz.
(defrule kri-tam-neg
(kriyA-TAM ?kri ?tam)
(sentence_type  negative)
(H_TAM-E_TAM-Perfective_Aspect-Progressive_Aspect-Tense-Type ?tam ?e_tam ?perf ?prog ?tense ?)
=>
(printout ?*rstr-fp* "(id-SF-TENSE-MOOD-PROG-PERF "?kri " prop " ?tense " indicative " ?prog " " ?perf ")"crlf)
(printout ?*rstr-dbug* "(rule-rel-values kri-tam-asser id-SF-TENSE-MOOD-PROG-PERF "?kri " prop " ?tense " indicative " ?prog " " ?perf ")"crlf)
)

;Modified by Sukhada on 24/04/2020 for 'Ravana was killed by Rama'.
; written by sakshi yadav (NIT-Raipur) Date - 10.06.19
;Rule for verb - passive sentences . 
;Replace LBL of parg_d with LBL of v and ARG1 of parg_d with ARG0 of verb 
;Ex. rAvana mArA gayA.
(defrule pargd
(declare (salience -200))
?f<-(MRS_info  id-MRS_concept-LBL-ARG0-ARG1-ARG2 ?id parg_d ?lbl ?arg0 ?arg1 ?arg2) 
(MRS_info ?rel ?id ?v ?lblv ?arg0v ?arg1v ?arg2v)
(test (neq (str-index "_v_" ?v)FALSE))
=>
(retract ?f)
(printout ?*rstr-fp* "(MRS_info  id-MRS_concept-LBL-ARG0-ARG1-ARG2 "?id" parg_d "?lblv" " ?arg0 " " ?arg0v " "?arg2v ")"crlf)
(printout ?*rstr-dbug* "(rule-rel-values pargd id-MRS_concept-LBL-ARG0-ARG1-ARG2 "?id" parg_d " ?lblv " " ?arg0 " " ?arg0v " " ?arg2v ")"crlf)
)

;Rule for pargd when verb has ARG3 value.
;Replace ARG2 value of pargd with ARG3 value of verb
;Ex. The earth is called a planet.
(defrule pargd2
?f<-(MRS_info  id-MRS_concept-LBL-ARG0-ARG1-ARG2 ?id parg_d ?lbl ?arg0 ?arg1 ?arg2) 
(MRS_info ?rel ?id1 ?v1 ?lblv1 ?arg0v1 ?arg1v1 ?arg2v1 ?arg3v1)
(test (neq (str-index "_v_" ?v1)FALSE))
=>
(retract ?f)
(printout ?*rstr-fp* "(MRS_info  id-MRS_concept-LBL-ARG0-ARG1-ARG2 "?id1" parg_d "?lblv1" " ?arg0 " " ?arg0v1 " "?arg3v1 ")"crlf)
(printout ?*rstr-dbug* "(rule-rel-values pargd2 id-MRS_concept-LBL-ARG0-ARG1-ARG2 "?id1" parg_d " ?lblv1 " " ?arg0 " " ?arg0v1 " " ?arg3v1 ")"crlf)
)


;for imperative sentence information
;#Apa Sahara jAo!
(defrule kri-tam-imper
(kriyA-TAM ?kri ?tam)
(sentence_type  imperative)
(H_TAM-E_TAM-Perfective_Aspect-Progressive_Aspect-Tense-Type  ?tam ?e_tam ?perf ?prog ?tense ?)
=>
(printout ?*rstr-fp* "(id-SF-TENSE-MOOD-PROG-PERF "?kri " comm " ?tense " indicative " ?prog " " ?perf ")"crlf)
(printout ?*rstr-dbug* "(rule-rel-values kri-tam-imper id-SF-MOOD-PROG-PERF "?kri " comm " ?tense " indicative " ?prog " " ?perf ")"crlf)
)

; Bind feature values for imperative sentence. Replace ARG0 value of pron and pronoun_q with the ARG1 value of verb
(defrule kriImperPronArg
(sentence_type  imperative)
?f1<-(MRS_info ?rel1 ?kri ?con ?lbl ?arg0 ?arg1  $?var)
?f<-(MRS_info ?rel2 ?pron pron ?lbl1 ?arg01  $?vars)
?f2<-(MRS_info ?rel3 ?pron pronoun_q ?l ?a0  $?v)
(test (neq (str-index "_v_" ?con)FALSE))
(not (already_modified ?kri ARG1  ?arg1))
=>
(retract ?f1 ?f ?f2)
(assert (already_modified ?kri ARG1  ?arg01))

(assert (MRS_info  ?rel1 ?kri ?con ?lbl ?arg0  ?arg01 $?var))
(printout ?*rstr-dbug* "(rule-rel-values kriImperPronArg " ?rel1 " "?kri" " ?con " "?lbl" " ?arg0 " " ?arg01 " "(implode$ (create$ $?var))")"crlf)

(printout ?*rstr-fp* "(MRS_info "?rel3" "?pron" pronoun_q "?l" "?arg01" "(implode$ (create$ $?v))")"crlf)
(printout ?*rstr-dbug* "(rule-rel-values kriImperPronArg " ?rel3" "?pron" pronoun_q "?l" "?arg01" "(implode$ (create$ $?v))")"crlf)
)

;for the TAM nA_cAhawA_hE_1
;rAma sonA cAhawA hE.
;Rama wants to sleep.
(defrule nA_cAhawA_hE
(kriyA-TAM ?kri nA_cAhawA_hE_1)
(MRS_info ?rel ?kri  ?mrscon $?var ?arg1)
?f1<-(MRS_info ?rel-1 ?kri-1  $?vars ?arg1-1 ?arg-2)
(test (eq (+ ?kri 100) ?kri-1))
(test (neq (str-index "_v_" ?mrscon) FALSE))
(not (already_modified ?kri-1 ARG1))
=>
(retract ?f1)
(assert (already_modified ?kri-1 ARG1 ))
(assert (MRS_info  ?rel-1 ?kri-1 $?vars ?arg1 ?arg-2))
(printout ?*rstr-dbug* "(rule-rel-values nA_cAhawA_hE " ?rel-1 " "?kri-1" " (implode$ (create$ $?vars)) " " ?arg1 " " ?arg-2 ")"crlf)
)


;for question sentence information
;#kyA hari ne pAnI se GadZe ko BarA?
(defrule kri-tam-q
(kriyA-TAM ?kri ?tam)
(sentence_type  yn_interrogative|interrogative|pass-interrogative)
(H_TAM-E_TAM-Perfective_Aspect-Progressive_Aspect-Tense-Type  ?tam ?e_tam ?perf ?prog ?tense ?)
=>
(printout ?*rstr-fp* "(id-SF-TENSE-MOOD-PROG-PERF "?kri " ques " ?tense " indicative " ?prog " " ?perf ")"crlf)
(printout ?*rstr-dbug* "(rule-rel-values kri-tam-q id-SF-TENSE-MOOD-PROG-PERF "?kri " ques " ?tense " indicative " ?prog " " ?perf ")"crlf)
)

;generates LTOP and INDEX values for vAkya_vn.
;Ex. sUrya camakawA BI hE. 
(defrule vAkya_vn-LTOP
(rel_name-ids	vAkya_vn   ?id1 ?id2)
(MRS_info ?rel1  ?id1  ?mrsV ?lbl1 ?arg10 ?arg11 $?var)
=>
(printout ?*rstr-fp* "(LTOP-INDEX h0 "?arg10 ")" crlf)
(printout ?*rstr-dbug* "(rule-rel-values vAkya_vn-LTOP LTOP-INDEX h0 "?arg10 ")"crlf)
)
;Rule for LTOP: The LBL value and ARG0 value of *_v_* becomes the value of LTOP and INDEX if the following words are not there in the sentence: "possibly", "suddenly". "not".If they exist, the LTOP value becomes the LBL value of that word and INDEX value is the ARG0 value of *_v_*. For "not" we get a node "neg" in the MRS
(defrule v-LTOP 
(MRS_info ?rel ?kri_id ?mrsCon ?lbl ?arg0 $?vars)
(rel_name-ids	main	0	?kri_id)
(not (asserted_LTOP-INDEX-for-modal))
(not (kriyA-TAM ?kri_id nA_cAhawA_hE_1))
(not (rel_name-ids kriyArWa_kriyA ?kri	?kri_id))
(not (rel_name-ids	vmod_pk	?id	?kri_id)) ;#rAma ne skUla jAkara KAnA KAyA.
(not (rel_name-ids	vmod_pka	?id	?kri_id)) ;rAma KA -KAkara motA ho gayA .
(not (rel_name-ids	vmod_atb	?id	?kri_id))
(not (rel_name-ids	rblak	?id	?kri_id)) ;gAyoM ke xuhane se pahale rAma Gara gayA.
(not (rel_name-ids	rblpk	?id	?kri_id)) ;;rAma ke vana jAne para xaSaraWa mara gaye.
(not (id-stative ?id yes))
(not (id-causative ?id yes)) ;#SikRikA ne CAwroM se kakRA ko sAPa karAyA.
(not (id-double_causative	?id	yes)) ;mAz ne rAma se bacce ko KAnA KilavAyA.
(not(rel_name-ids vAkya_vn ?id1 ?id2)) 
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
(defrule tam-modal
(declare (salience 100))
(H_TAM-E_TAM-Perfective_Aspect-Progressive_Aspect-Tense-Type  ?tam ?e_tam ?perf ?prog ?tense modal)
(kriyA-TAM ?kri ?tam)
(MRS_info id-MRS_concept-LBL-ARG0-ARG1 ?modalV  ?mrs_modal  ?lbl  ?arg0  ?h)
(sentence_type  affirmative|interrogative|yn_interrogative|negative)
(test (or (neq (str-index _v_modal ?mrs_modal) FALSE) (neq (str-index _v_qmodal ?mrs_modal) FALSE)));_used+to_v_qmodal
=>
(assert (asserted_LTOP-INDEX-for-modal))
(printout ?*rstr-fp* "(LTOP-INDEX h0 "?arg0 ")" crlf)
(printout ?*rstr-dbug* "(rule-rel-values tam-modal  LTOP-INDEX h0 "?arg0 ")"crlf)
)

;(defrule tam-wish
;(kriyA-TAM ?kri_id nA_cAhawA_hE_1) 
;(MRS_info ?rel ?mod  _want_v_1 ?l ?arg0 ?a1 ?a2)
;(sentence_type  affirmative|interrogative|negative)
;(test (eq ?mod (+ ?kri_id 100)))
;=>
;(assert (asserted_LTOP-INDEX-for-modal))
;(printout ?*rstr-fp* "(LTOP-INDEX h0 "?arg0 ")" crlf)
;(printout ?*rstr-dbug* "(rule-rel-values tam-wish  LTOP-INDEX h0 "?arg0 ")"crlf)
;)

;generates LTOP and INDEX values for causative.
;ex. SikRikA ne CAwroM se kakRA ko sAPa karAyA.
;(MRS_info id-MRS_concept-LBL-ARG0-ARG1-ARG2 40100 _make_v_cause h1 e2 x28 h4)
(defrule make-LTOP
(id-causative	?id	yes)
(MRS_info  id-MRS_concept-LBL-ARG0-ARG1-ARG2 ?id1 _make_v_cause ?lbl ?arg0 $?vars)
(test (eq  (+ ?id 100) ?id1))
=>
    (printout ?*rstr-fp* "(LTOP-INDEX h0 "?arg0 ")" crlf)
    (printout ?*rstr-dbug* "(rule-rel-values causative-LTOP LTOP-INDEX h0 "?arg0 ")"crlf)
)

;generates LTOP and INDEX values for double causative.
(defrule ask-LTOP
(id-double_causative	?id	yes) 
(MRS_info  id-MRS_concept-LBL-ARG0-ARG1-ARG2-ARG3 ?id1 _ask_v_1 ?lbl ?arg0 $?vars)
(test (eq  (+ ?id 200) ?id1))
=>
    (printout ?*rstr-fp* "(LTOP-INDEX h0 "?arg0 ")" crlf)
    (printout ?*rstr-dbug* "(rule-rel-values dubcau-LTOP LTOP-INDEX h0 "?arg0 ")"crlf)
)

;generates LTOP and INDEX values for get_cause.
(defrule get-LTOP
(id-stative	?id	yes)
(MRS_info  id-MRS_concept-LBL-ARG0-ARG1-ARG2 ?id1 _get_v_state ?lbl ?arg0 $?vars)
(test (eq  (+ ?id 100) ?id1))
=>
    (printout ?*rstr-fp* "(LTOP-INDEX h0 "?arg0 ")" crlf)
    (printout ?*rstr-dbug* "(rule-rel-values get-LTOP LTOP-INDEX h0 "?arg0 ")"crlf)
)

;generates LTOP and INDEX values for predicative adjective(s).
;ex. rAma acCA hE.
(defrule samAnAXi-LTOP
(id-concept_label       ?v   hE_1|WA_1)
(rel_name-ids   k1s        ?id  ?id_adj)
(MRS_info ?rel ?id_adj ?mrsCon ?lbl ?arg0 $?vars)
(test (neq (str-index _a_ ?mrsCon) FALSE)) 
=>
    (printout ?*rstr-fp* "(LTOP-INDEX h0 "?arg0 ")" crlf)
    (printout ?*rstr-dbug* "(rule-rel-values samAnAXi-LTOP LTOP-INDEX h0 "?arg0 ")"crlf)
)  

;generates LTOP and INDEX values for existential verb(s).
;ex. ladakA xilli meM hE.
(defrule Existential-LTOP
(id-concept_label       ?v   hE_1|WA_1)
?f<-(rel_name-ids   k7p|k7        ?v  ?id2)
(MRS_info ?rel ?id3 ?endsWith_p ?lbl ?arg0 ?arg1 ?arg2)
(test  (or (eq (sub-string (- (str-length ?endsWith_p) 1) (str-length ?endsWith_p) ?endsWith_p) "_p")        (eq ?endsWith_p "loc_nonsp")))
=>
(retract ?f)
    (printout ?*rstr-fp* "(LTOP-INDEX h0 "?arg0 ")" crlf)
    (printout ?*rstr-dbug* "(rule-rel-values Existential-LTOP LTOP-INDEX h0 "?arg0 ")"crlf)
) 
 
(defrule there-LTOP
(id-concept_label       ?id   state_existential|hE_1|WA_1)
?f<-(rel_name-ids   AXAra-AXeya        ?id1  ?id2)
(MRS_info id-MRS_concept-LBL-ARG0-ARG1-ARG2 ?id1 loc_nonsp  ?lbl ?arg0 $?args)
=>
(printout ?*rstr-fp* "(LTOP-INDEX h0 "?arg0 ")" crlf)
(printout ?*rstr-dbug* "(rule-rel-values there-LTOP LTOP-INDEX h0 "?arg0 ")"crlf)
) 


;replace the ARG1 value of superl with the ARG0 value adjective, and
;replace the LBL value of superl with the LBL value of adjective
(defrule superlative
?f<-(MRS_info id-MRS_concept-LBL-ARG0-ARG1 ?super superl ?l ?a0 ?a1)
(MRS_info id-MRS_concept-LBL-ARG0-ARG1 ?adj  ?adj_concept ?l1 ?a01 ?a11)
(id-degree	?adj	superl)
(rel_name-ids	mod	?n	?adj)
(MRS_info ?rel ?n ?mrscon ?l2 $?)
=>
(retract ?f)
(printout ?*rstr-fp* "(MRS_info id-MRS_concept-LBL-ARG0-ARG1 "?super" superl "?l2" "?a0" "?a01")"crlf)
(printout ?*rstr-dbug* "(rule-rel-values superlative  id-MRS_concept-LBL-ARG0-ARG1 "?super" superl "?l2" "?a0" "?a01")"crlf)
)

(defrule printFacts
(declare (salience -9000))
?f<-(MRS_info ?rel ?kri ?mrsCon $?vars)
=>
(retract ?f)
(printout ?*rstr-fp* "(MRS_info " ?rel " "?kri " "?mrsCon " " (implode$ (create$ $?vars)) ")" crlf)
(printout ?*rstr-dbug* "(rule-rel-values printFacts " ?rel " "?kri " "?mrsCon " " (implode$ (create$ $?vars)) ")"crlf)
)

(defrule samAnAXi-deic
(id-concept_label       ?v_id   state_copula|hE_1|WA_1)
(rel_name-ids	samAnAXi|k1s	?id1 ?id2)
(rel_name-ids deic ?id2	?id1)
?f<-(MRS_info ?rel_name ?v_id ?mrsCon ?lbl ?arg0 ?arg1 ?arg2 )
(MRS_info ?rel1 ?id1 ?mrsCon1 ?lbl1 ?id1_arg0 $?vars)
(MRS_info ?rel2 ?id2 ?mrsCon2 ?lbl2 ?id2_arg0 $?var)
(not (modified_samAnAXide ?id2))
=>
(retract ?f)
(assert (modified_samAnAXide ?id2))
(assert (MRS_info  ?rel_name ?v_id ?mrsCon ?lbl ?arg0 ?arg1 ?id2_arg0 ))
(printout ?*rstr-dbug* "(rule-rel-values samAnAXi-deic "?rel_name " " ?v_id " " ?mrsCon " " ?lbl " " ?arg1 " " ?id2_arg0 ")"crlf)
)


;Rule for generic_entity
(defrule generic_entity
(rel_name-ids deic ?id    ?id1) ;#yaha Gara hE.
(MRS_info ?rel ?id1 _this_q_dem ?lbl ?ARG0 ?rstr ?body)
?f1<-(MRS_info ?rel1 ?id2 _be_v_id ?lbl1 ?ARG01 ?ARG1 ?ARG2)
?f2<-(MRS_info ?rel2 ?id3 generic_entity ?lbl2 ?ARG02)
(test (eq  (+ ?id1 10) ?id3))
(not (modified ?ARG02))
=>
(retract ?f1 ?f2)
(assert (modified ?ARG02))

(assert (MRS_info ?rel1 ?id2 _be_v_id ?lbl1 ?ARG01 ?ARG0 ?ARG2))
(printout ?*rstr-dbug* "(rule-rel-values _be_v_id " ?rel1 " "?id2" _be_v_id " ?lbl1 " " ?ARG01" " ?ARG0" " ?ARG2")"crlf)

(assert (MRS_info ?rel2 ?id3 generic_entity ?lbl2 ?ARG0))
(printout ?*rstr-dbug* "(rule-rel-values generic_entity " ?rel2 " "?id3" generic_entity " ?lbl2 " " ?ARG0")"crlf)
)

;Rule for demonstrative adj
(defrule dem_adj
(rel_name-ids deic ?id1    ?id3) ;#yaha Gara hE.
(rel_name-ids	dem	?id1	?id3)
(id-guNavAcI	?id2	yes)
(MRS_info ?rel ?id2 ?mrs ?lbl ?arg0 ?arg1 $?va)
?f1<-(MRS_info ?rel1 ?id1 ?mrs_1 ?lbl1 ?ARG01 $?var)
?f2<-(MRS_info ?rel2 ?id3 ?mrs_2 ?lbl2 ?ARG11 $?vars)
(not (modified_adj ?arg0))
=>
(retract ?f1 ?f2)
(assert (modified_adj ?arg0))

(assert (MRS_info ?rel1 ?id1 ?mrs_1 ?lbl1 ?arg1 $?var))
(printout ?*rstr-dbug* "(rule-rel-values dem_adj " ?rel1 " "?id1" " mrs_1" " ?lbl1 " " ?arg1" "(implode$ (create$ $?var)) ")"crlf)

(assert (MRS_info ?rel2 ?id3 ?mrs_2 ?lbl2 ?arg1 $?vars))
(printout ?*rstr-dbug* "(rule-rel-values dem_adj2 " ?rel2 " "?id3" " mrs_2" " ?lbl2 " " ?arg1" "(implode$ (create$ $?vars)) ")"crlf)
)

;Replacing ARG0 of implicit mrs concepts like _a_q, pronoun_q with the ARG0 value of their head
(defrule mrs-info_q
(MRS_info ?rel2 ?head ?mrsCon ?lbl2 ?ARG_0 $?v)
?f<-(MRS_info ?rel1 ?dep ?endsWith_q ?lbl1 ?x $?vars)
(test (neq ?endsWith_q ?mrsCon))
(test (eq (sub-string 1 1 (implode$ (create$ ?head))) (sub-string 1 1 (implode$ (create$ ?dep)))))
(test (> ?dep ?head))
(test (eq (sub-string (- (str-length ?endsWith_q) 1) (str-length ?endsWith_q) ?endsWith_q) "_q"))
(test (neq (sub-string (- (str-length ?mrsCon) 1) (str-length ?mrsCon) ?mrsCon) "_p"))
(test (neq (sub-string (- (str-length ?mrsCon) 6) (str-length ?mrsCon) ?mrsCon) "_p_temp"))
=>
(retract ?f)
(printout ?*rstr-fp*   "(MRS_info  "?rel1 " " ?dep " " ?endsWith_q " " ?lbl1 " " ?ARG_0 " " (implode$ (create$ $?vars)) ")"crlf)
(printout ?*rstr-dbug* "(rule-rel-values  mrs-info_q "?rel1 " " ?dep " " ?endsWith_q " " ?lbl1 " "?ARG_0 " " (implode$ (create$ $?vars)) ")"crlf)
)


(defrule rstr-rstd4non-implicit
(rel_name-ids ord|dem|quant ?head ?dep)
(MRS_info ?rel2 ?head ?mrsCon ?lbl2 ?ARG_0 $?v)
?f<-(MRS_info ?rel1 ?dep ?endsWith_q ?lbl1 ?x $?vars)
=>
(retract ?f)
(printout ?*rstr-fp*   "(MRS_info  "?rel1 " " ?dep " " ?endsWith_q " " ?lbl1 " " ?ARG_0 " " (implode$ (create$ $?vars)) ")"crlf)
(printout ?*rstr-dbug* "(rule-rel-values rstr-rstd4non-implicit "?rel1 " " ?dep " " ?endsWith_q " " ?lbl1 " "?ARG_0 " " (implode$ (create$ $?vars)) ")"crlf)
)

;#sUrya camakawA BI hE.
(defrule emph-also-nonverb
?f<-(MRS_info id-MRS_concept-LBL-ARG0-ARG1 ?id _also_a_1 ?lbl ?a0 ?a1)
(id-emph  ?id1  yes)
(MRS_info ?rel ?id1 ?mrscon ?l $?v)
(test (eq (str-index _v_ ?mrscon) FALSE))
(test (eq (+ ?id1 1000) ?id))
=>
(retract  ?f)
(bind ?arg1 (str-cat "e" (sub-string 2 (str-length ?a1) ?a1)))
(printout ?*rstr-fp* "(MRS_info id-MRS_concept-LBL-ARG0-ARG1 "?id" _also_a_1 "?l" "?a0" " ?arg1")"crlf)
(printout ?*rstr-dbug* "(rule-rel-values emph-also-nonverb MRS_info id-MRS_concept-LBL-ARG0-ARG1 "?id" _also_a_1 "?l"  "?a0" " ?arg1")"crlf)
)
;Rule for creating binding with verb and the word _frequent_a_1.
;It creates frequent lbl same as verb lbl and arg1 will be same as arg0 of verb.
;#राम खा -खाकर मोटा हो गया ।
(defrule frequent
;(MRS_info id-MRS_concept -5000  _frequent_a_1)
(rel_name-ids	vmod_pka ?id ?kriyA)
?f<-(MRS_info id-MRS_concept-LBL-ARG0-ARG1 -5000 _frequent_a_1 ?lbl ?arg0 ?arg1)
(MRS_info id-MRS_concept-LBL-ARG0-ARG1-ARG2 ?kriyA ?mrsCon ?lbl1 ?arg01 ?arg11 $?v)
(test (neq (str-index "_v_" ?mrsCon)FALSE))
=>
(retract ?f)
(printout ?*rstr-fp* "(MRS_info id-MRS_concept-LBL-ARG0-ARG1 -5000 _frequent_a_1 "?lbl1" "?arg0" "?arg01")"crlf)
(printout ?*rstr-dbug* "(rule-rel-values frequent  id-MRS_concept-LBL-ARG0-ARG1 -5000 _frequent_a_1 "?lbl1" "?arg0" "?arg01")"crlf)
)

(defrule vmod_atb_bind
(rel_name-ids	vmod_atb ?ids ?idatb)
?f<-(MRS_info id-MRS_concept-LBL-ARG0-ARG1 ?idatb ?mrscon ?lbl ?arg0 ?arg1)
(MRS_info id-MRS_concept-LBL-ARG0-ARG1-ARG2 ?kriyA ?mrsCon ?lbl1 ?arg01 ?arg11 $?v)
(test (neq (str-index "_v_" ?mrsCon)FALSE))
=>
(retract ?f)
(printout ?*rstr-fp* "(MRS_info id-MRS_concept-LBL-ARG0-ARG1 "?idatb" "?mrscon" "?lbl1" "?arg0" "?arg01")"crlf)
(printout ?*rstr-dbug* "(rule-rel-values frequent  id-MRS_concept-LBL-ARG0-ARG1 "?idatb" "?mrscon" "?lbl1" "?arg0" "?arg01")"crlf)
)

;Rule for binding comparitive degree "comp" node with the adjective it specifies and the person it compares.
;It replaces lbl of adjective with the lbl of comp, and arg0 of adjective with the arg1 of comp, and arg0 of upamAna with the arg2 of comp. 
;#rAma mohana se jyAxA buxXimAna hE.
(defrule comper_more-bind
(id-degree	?adjid	comper_more)
(rel_name-ids ru ?id ?id1)          ;?id = upameya/rAma, ?id1 = upamAna/mohana
?f<-(MRS_info id-MRS_concept-LBL-ARG0-ARG1-ARG2 ?compid comp ?l ?a0 ?a1 ?a2)
(MRS_info id-MRS_concept-LBL-ARG0-ARG1 ?adjid ?mrs_adj ?lbl ?arg0 ?arg1)
(MRS_info ?rel ?id1 ?mrs ?lbll ?arg ?name)
(test (neq (str-index _a_ ?mrs_adj) FALSE))
=>
(retract ?f)
(printout ?*rstr-fp* "(MRS_info id-MRS_concept-LBL-ARG0-ARG1-ARG2 "?compid" comp "?lbl" "?a0" "?arg0" "?arg" )"crlf)
(printout ?*rstr-dbug* "(rule-rel-values comper-more-bind  id-MRS_concept-LBL-ARG0-ARG1-ARG2 "?compid" comp "?lbl" "?a0" "?arg0" "?arg")"crlf)
)

;Rule for binding comparitive degree "comp_less" node with the adjective it specifies and the person it compares.
;It converts lbl of adjective as its lbl and arg0 of adjective will be its arg1 and arg2 will the arg0 of the person.
;#rAma mohana se kama buxXimAna hE .
(defrule comper_less-bind
(id-degree	?adjid	comper_less)
(rel_name-ids ru ?id ?id1)
?f<-(MRS_info id-MRS_concept-LBL-ARG0-ARG1-ARG2 ?compid comp_less ?l ?a0 ?a1 ?a2)
(MRS_info id-MRS_concept-LBL-ARG0-ARG1 ?adjid ?mrs_adj ?lbl ?arg0 ?arg1)
(MRS_info ?rel ?id1 ?mrs ?lbll ?arg ?name)
(test (neq (str-index _a_ ?mrs_adj) FALSE))
=>
(retract ?f)
(printout ?*rstr-fp* "(MRS_info id-MRS_concept-LBL-ARG0-ARG1-ARG2 "?compid" comp_less "?lbl" "?a0" "?arg0" "?arg" )"crlf)
(printout ?*rstr-dbug* "(rule-rel-values comper-less-bind  id-MRS_concept-LBL-ARG0-ARG1-ARG2 "?compid" comp_less "?lbl" "?a0" "?arg0" "?arg")"crlf)
)

;Rule for changing the LBL of comp_equal with the adjective it modifies and changing arg1 of comp_equal with arg0 of the adjective and ARG2 of comp_equal will be same as the arg0 of the person it refers. 
;rAXA mIrA jEsI sunxara hE.
(defrule comper_equal-bind
(rel_name-ids ru ?id ?id1)          ;?id = upameya/rAma, ?id1 = upamAna/mohana
?f<-(MRS_info id-MRS_concept-LBL-ARG0-ARG1-ARG2 ?compid comp_equal ?l ?a0 ?a1 ?a2)
(MRS_info id-MRS_concept-LBL-ARG0-ARG1 ?adjid ?mrs_adj ?lbl ?arg0 ?arg1)
(MRS_info ?rel ?id1 ?mrs ?lbll ?arg ?name)
(test (neq (str-index _a_ ?mrs_adj) FALSE))
=>
(retract ?f)
(printout ?*rstr-fp* "(MRS_info id-MRS_concept-LBL-ARG0-ARG1-ARG2 "?compid" comp_equal "?lbl" "?a0" "?arg0" "?arg" )"crlf)
(printout ?*rstr-dbug* "(rule-rel-values comper_equal-bind  id-MRS_concept-LBL-ARG0-ARG1-ARG2 "?compid" com_equal "?lbl" "?a0" "?arg0" "?arg")"crlf)
)

;Changing the lbl value of pargd with the blak verb and arg1 and arg2 will changed as blak verb.
;gAyoM ke xuhane se pahale rAma Gara gayA.
(defrule pargd-r-blak
(declare (salience -400))
(rel_name-ids	rblak	?kri	?blak)
?f<-(MRS_info  id-MRS_concept-LBL-ARG0-ARG1-ARG2 ?id parg_d ?lbl ?arg0 ?arg1 ?arg2)
(MRS_info id-MRS_concept-LBL-ARG0-ARG1-ARG2 ?blak ?mrscon ?lbl1 ?arg00 ?arg11 ?arg22)
(test (neq (str-index "_v_" ?mrscon)FALSE))
=>
(retract ?f)
(printout ?*rstr-fp* "(MRS_info  id-MRS_concept-LBL-ARG0-ARG1-ARG2 "?id" parg_d "?lbl1" " ?arg0 " " ?arg00 " "?arg22 ")"crlf)
(printout ?*rstr-dbug* "(rule-rel-values pargd-r-blak id-MRS_concept-LBL-ARG0-ARG1-ARG2 "?id" parg_d "?lbl1" " ?arg0 " " ?arg00 " "?arg22 ")"crlf)
)

;Rule for changing L-INDEX of ccof with the first list component word ARG0 and R-INDEX with the second list component word ARG0.
;Rule for changing arg0 of udef_q with ARG0 of _and_c.
;rAma Ora sIwA acCe hEM.
(defrule ccof
(rel_name-ids	ccof	?ccofid	?first)
(rel_name-ids	ccof	?ccofid	?second)
?f<-(MRS_info id-MRS_concept-LBL-ARG0-L_INDEX-R_INDEX ?id _and_c ?l ?a0 ?li ?ri)
?f1<-(MRS_info id-MRS_concept-LBL-ARG0-RSTR-BODY ?idd udef_q ?lbll ?argg ?rstr ?body)
(MRS_info id-MRS_concept-LBL-ARG0-CARG ?first ?name ?lbl ?arg0 ?namee)
(MRS_info id-MRS_concept-LBL-ARG0-CARG ?second ?name2 ?lbl1 ?arg00 ?namee2)
(not (modified_ccof ?a0))
=>
(retract ?f ?f1)
(assert (modified_ccof ?a0))
(assert (MRS_info id-MRS_concept-LBL-ARG0-L_INDEX-R_INDEX ?id _and_c ?l ?a0 ?arg0 ?arg00))
(printout ?*rstr-dbug* "(rule-rel-values ccof  id-MRS_concept-LBL-ARG0-L_INDEX-R_INDEX "?id" _and_c "?l" "?a0" "?arg0" "?arg00")"crlf)
(printout ?*rstr-fp* "(MRS_info id-MRS_concept-LBL-ARG0-RSTR-BODY "?idd" udef_q "?lbll" "?a0" "?rstr" "?body")"crlf)
(printout ?*rstr-dbug* "(rule-rel-values ccof  id-MRS_concept-LBL-ARG0-RSTR-BODY "?idd" udef_q "?lbll" "?a0" "?rstr" "?body")"crlf)
)

;Rule to change ARG1 of adjective with ARG0 of _and_c
;rAma Ora sIwA acCe hEM.
(defrule ccofk1s
(rel_name-ids	ccof	?ccofid	?id)
(rel_name-ids	k1s	?non-adj ?adj)
?f<-(MRS_info id-MRS_concept-LBL-ARG0-ARG1-ARG2 ?adj ?mrsCon ?lbl ?arg0 ?arg1 ?arg2)
(MRS_info id-MRS_concept-LBL-ARG0-L_INDEX-R_INDEX ?iddd _and_c ?lbll ?arg00 ?l ?r)
(test (neq (str-index _a_ ?mrsCon) FALSE))
(test (neq ?arg1 ?arg00))
(not (modified_ccofk1s ?arg00))
=>
(retract ?f)
(assert (modified_ccofk1s ?arg00))
(assert (MRS_info id-MRS_concept-LBL-ARG0-ARG1-ARG2 ?adj ?mrsCon ?lbl ?arg0 ?arg00 ?arg2))
;(printout ?*rstr-fp* "(MRS_info id-MRS_concept-LBL-ARG0-ARG1-ARG2 "?adj" "?mrsCon" "?lbl" "?arg0" "?arg00" "?arg2")"crlf)
(printout ?*rstr-dbug* "(rule-rel-values ccofk1s id-MRS_concept-LBL-ARG0-ARG1-ARG2 "?adj" "?mrsCon" "?lbl" "?arg0" "?arg00" "?arg2")"crlf)
)

