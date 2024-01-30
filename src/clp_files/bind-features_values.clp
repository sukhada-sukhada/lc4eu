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
(declare (salience 100))
(rel_name-ids mod|intf|card|rvks ?viya ?viNa);verified sentences: 16,309,167,341 respectively.
(MRS_info ?rel1 ?viya ?c ?lbl1 ?arg0_viya  $?var)
?f<-(MRS_info ?rel2 ?viNa ?co ?lbl2 ?arg0_viNa ?arg1_viNa $?vars)
;(test (eq (str-index _q ?co) FALSE))  ;prawyeka baccA Kela rahe hEM. saBI bacce Kela rahe hEM. kuCa bacce koI Kela Kela sakawe hEM. 
(test (neq (sub-string (- (str-length ?co) 1) (str-length ?co) ?co) "_q"))
(not (modified_viSeRaNa ?viNa))
(not (construction-ids	conj	$?vars ?viya ?id2))
=>
(retract ?f)
(assert (modified_viSeRaNa ?viNa))
(assert (MRS_info  ?rel2  ?viNa   ?co   ?lbl1   ?arg0_viNa   ?arg0_viya $?vars))
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
(defrule krvnn
(rrrel_name-ids krvn ?kri ?kri_vi)
(MRS_info ?rel1 ?kri ?mrsconkri ?lbl1 ?arg0  ?arg1 $?var)
?f<-(MRS_info  ?rel2 ?kri_vi ?mrsconkrivi ?lbl2 ?arg0_2 ?arg1_2 $?vars)
=>
(retract ?f)
(printout ?*rstr-fp* "(MRS_info  "?rel2 " " ?kri_vi " " ?mrsconkrivi " " ?lbl1 " " ?arg0_2 " " ?arg0 " "(implode$ (create$ $?vars)) ")"crlf)
(printout ?*rstr-dbug* "(rule-rel-values krvnn  "?rel2 " " ?kri_vi " " ?mrsconkrivi " " ?lbl1 " " ?arg0_2" "?arg0" "(implode$ (create$ $?vars)) ")"crlf)
)

(defrule krvn
(declare (salience 1000))
(rel_name-ids krvn|freq ?kri ?kri_vi) ;#aXyApaka aBI Aye hEM. ;#vaha rojZa yaha AwA hE.
(MRS_info ?rel1 ?kri ?mrsconkri ?lbl1 ?arg0  ?arg1 $?var)
?f<-(MRS_info  ?rel2 ?kri_vi ?mrsconkrivi ?lbl2 ?arg0_2 ?arg1_2 $?vars)
(not (modified_krvn ?kri_vi))
(test (eq (str-index _v_ ?mrsconkrivi) FALSE))
=>
;(retract ?f)
(assert (modified_krvn ?kri_vi))
(printout ?*rstr-fp* "(MRS_info  "?rel2 " " ?kri_vi " " ?mrsconkrivi " " ?lbl1 " " ?arg0_2 " " ?arg0 " "(implode$ (create$ $?vars)) ")"crlf)
;(assert (MRS_info  ?rel2 ?kri_vi  ?mrsconkrivi  ?lbl1 ?arg0_2 ?arg0 $?vars) )
(printout ?*rstr-dbug* "(rule-rel-values krvn  "?rel2 " " ?kri_vi " " ?mrsconkrivi " " ?lbl1 " " ?arg0_2" "?arg0" "(implode$ (create$ $?vars)) ")"crlf)
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
(not (construction-ids	disjunct	$?vv ?adj $?vvv))
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
(rel_name-ids  rsm|rhh|rsma     ?k1  ?id2) ;rAma ke xo bete hEM
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
(id-doublecausative	?kriya	yes)
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
(id-doublecausative	?kriya	yes)
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
(id-doublecausative	?kriya	yes)
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
(declare (salience 10))
(rel_name-ids	k2|k1s       	?kriyA ?karma)
?f<-(MRS_info ?rel_name ?kriyA ?mrsCon ?lbl ?arg0 ?arg1 ?arg2 $?v)
(MRS_info ?rel2 ?karma ?mrsCon2 ?lbl2 ?argma_0 $?vars1)
(test (neq (sub-string (- (str-length ?mrsCon2) 1) (str-length ?mrsCon2) ?mrsCon2) "_q")) ;I asked Rama a question. What do the animals eat? What did Hari fill in the pot?
(test (neq (str-index _v_ ?mrsCon) FALSE))
(test (neq ?arg2 ?argma_0))
(not (modified_k2 ?karma))
(not (rel_name-ids rask2 ?kri	?id)) ;#राम खा -खाकर मोटा हो गया ।
(not (construction-ids	conj	$?vars ?karma $?varss))
(not (construction-ids	disjunct	$?vars ?karma $?varss))
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
(declare (salience 10000))
(rel_name-ids ?relp ?kriyA ?karak)
?f<-(MRS_info ?rel_name ?prep ?endsWith_p ?lbl ?arg0 ?arg1 $?v)
(MRS_info ?rel1 ?kriyA ?mrsCon1 ?lbl1 ?argv_0 $?vars)
(MRS_info ?rel2 ?karak ?mrsCon2 ?lbl2 ?argn_0 $?varss)
(test (eq (sub-string 1 1 (str-cat ?prep)) (sub-string 1 1 (str-cat ?karak))))
(test (eq (sub-string (- (str-length ?endsWith_p) 1) (str-length ?endsWith_p) ?endsWith_p) "_p"))
;(test (neq (str-index "_n_" ?mrsCon2)FALSE))
(test (or (neq (str-index "_n_" ?mrsCon2)FALSE) (eq ?mrsCon2 nominalization) ))
(not (rel_name-ids	k1s	?kriyA	?karwA))
(not (rel_name-ids	rask2	?kriyA	?karwA))
(not (id-concept_label       ?kriyA  raKa_8)) ;Abrams put Browne in the garden.
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
(eq ?home  _home_p)(eq ?home  _here_a_1)))
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
?f3<-(MRS_info id-MRS_concept-LBL-ARG0-ARG1 ?id ?proxdis ?lbl3 ?arg03 ?arg13)
(rel_name-ids	AXAra-AXeya	?adhar  ?adhey)
(MRS_info id-MRS_concept-LBL-ARG0 ?adhey ?mrs ?l ?a0)
(not (modified loc_nonsp))
;(MRS_info id-MRS_concept-LBL-ARG0-ARG1 ?id1 ?v ?lbl4 ?arg04 ?arg14)
;(test (neq (str-index "_v_" ?v)FALSE))
(test (or (eq ?proxdis  _there_a_1)
(eq ?proxdis  _here_a_1)))
=>
(retract ?f ?f1 ?f2 ?f3)
(assert (modified loc_nonsp))
(assert (MRS_info id-MRS_concept-LBL-ARG0-ARG1-ARG2 ?id loc_nonsp  ?lbl ?arg0 ?a0  ?arg02))
;(printout ?*rstr-fp* "(MRS_info id-MRS_concept-LBL-ARG0-ARG1-ARG2 "?id " loc_nonsp " ?lbl " " ?arg0" " ?a0 " " ?arg02 ")"crlf)
(printout ?*rstr-dbug* "(rule-rel-values v-there  id-MRS_concept-LBL-ARG0-ARG1-ARG2 "?id" loc_nonsp "?lbl" "?arg0" "?a0" "?arg02")"crlf)

(printout ?*rstr-fp* "(MRS_info id-MRS_concept-LBL-ARG0  "?id" place_n "?lbl3" "?arg02 ")"crlf)
(printout ?*rstr-dbug* "(rule-rel-values v-there  id-MRS_concept-LBL-ARG0  "?id" place_n "?lbl3" "?arg02 ")"crlf)

(printout ?*rstr-fp* "(MRS_info id-MRS_concept-LBL-ARG0-ARG1 "?id " "?proxdis" "?lbl3"  "?arg03" "?arg02 ")"crlf)
(printout ?*rstr-dbug* "(rule-rel-values v-there  id-MRS_concept-LBL-ARG0-ARG1 "?id " "?proxdis" "?lbl3"  "?arg03" "?arg02 ")"crlf)

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
(test (or (eq ?named named) (eq ?named dofw) (eq ?named mofy) (eq ?named yoc))) ;
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
(test (eq  (+ ?id 1) ?idposs))  ;Ms. Rajini admitted her son and her daughter in the Kashi's largest school in Banaras.
;(not (construction-ids	conj	?id $?v))
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
(or (mofy ?con ?val) (dofw ?con ?val) )
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
(cl-cEn-MRSc ?hnum ?enum card|ord)
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

;Rule for converting card CARG value n into the english number. It works when card is coming in k2 position. 
;The cat chased one. 
(defrule saMKyA_kri
(declare (salience 1000))
(id-concept_label ?num ?hnum)
(rel_name-ids k2	?vi     ?num)
(cl-cEn-MRSc ?hnum ?enum card)
?f<-(MRS_info  id-MRS_concept-LBL-ARG0-ARG1-CARG ?num card ?lbl ?numARG0 ?ARG1 ?CARG)
;(MRS_info ?rel ?vi ?mrscon ?vilbl ?viarg0 $?v)
;(test (or (eq ?ord ord) (eq ?ord card)) )
(not (enum_replaced ?num))
=>
(retract ?f)
(assert (enum_replaced ?num))
(if (neq (str-index "_" ?enum) FALSE) then
  (bind ?myEnum (string-to-field (sub-string 0 (- (str-index "_" ?enum )1) ?enum))) ;removing "_digit" from e_concept_label, ex. "ten_2" => "ten"
     (assert (MRS_info  id-MRS_concept-LBL-ARG0-ARG1-CARG ?num card ?lbl ?numARG0  ?ARG1   ?myEnum ) )
     ;(printout ?*rstr-fp* "(MRS_info  id-MRS_concept-LBL-ARG0-ARG1-CARG "?num" card "?lbl" "?numARG0" "?ARG1" "?myEnum")"crlf)
     (printout ?*rstr-dbug* "(rule-rel-values saMKyA_vi id-MRS_concept-LBL-ARG0-ARG1-CARG "?num" card "?lbl" "?numARG0" "?ARG1" "?myEnum")"crlf)
else
   (printout ?*rstr-fp* "(MRS_info  id-MRS_concept-LBL-ARG0-ARG1-CARG "?num" card "?lbl" " ?numARG0 " "?ARG1" " ?enum ")"crlf)
   (printout ?*rstr-dbug* "(rule-rel-values saMKyA_kri id-MRS_concept-LBL-ARG0-ARG1-CARG "?num" card "?lbl" "?numARG0" "?ARG1" "?enum")"crlf)
)
)


;Rule for numerical adjectives. Replace 
;CARG value of ordinal number with English number and LBL value of the same fact with LBL of viSeRya and ARG1 value with ARG0 value of viSeRya.
;Ex. rAma pahalI kiwAba paDa rahA hE.
(defrule kramavAcI_vi
(id-concept_label ?num ?hnum)
(rel_name-ids card   ?vi     ?num)
(cl-cEn-MRSc ?hnum ?enum ord)
?f<-(MRS_info  id-MRS_concept-LBL-ARG0-ARG1-CARG ?num ord ?lbl ?numARG0 ?ARG1 ?CARG)
(MRS_info ?rel ?vi ?mrscon ?vilbl ?viarg0 $?v)
=>
(retract ?f)
(printout ?*rstr-fp* "(MRS_info  id-MRS_concept-LBL-ARG0-ARG1-CARG "?num" ord "?vilbl" " ?numARG0 " "?viarg0" " ?enum ")"crlf)
(printout ?*rstr-dbug* "(rule-rel-values kramavAcI_vi id-MRS_concept-LBL-ARG0-ARG1-CARG "?num" ord "?vilbl" "?numARG0" "?viarg0" "?enum")"crlf)
)



;Rule for sentence and tam info: (if (kriyA-TAM), value of id = value of kriyA from the facts kriyA-TAM, SF from sentence_type and the rest from tam_mapping.csv)
;for asssertive sentence information
(defrule kri-tam-asser
(kriyA-TAM ?kri ?tam)
(sentence_type  affirmative|pass-affirmative)
(H_TAM-E_TAM-Perfective_Aspect-Progressive_Aspect-Tense-Type ?tam ?e_tam ?perf ?prog ?tense ?typ)
(not (rel_name-ids kAryakAraNa ?previousid	?kri))
=>
(printout ?*rstr-fp* "(id-SF-TENSE-MOOD-PROG-PERF "?kri " prop " ?tense " indicative " ?prog " " ?perf  ")"crlf)
(printout ?*rstr-dbug* "(rule-rel-values kri-tam-asser id-SF-TENSE-MOOD-PROG-PERF "?kri " prop " ?tense " indicative " ?prog " " ?perf ")"crlf)
)

;(id-hin_concept-MRS_concept 50000 KA_1 _eat_v_1)
;(id-hin_concept-MRS_concept 30000 jA_1 _go_v_1)
;(rel_name-ids	rpk	50000	30000)
;rule creates TAM for rpk
;#rAma ne skUla jAkara KAnA KAyA
(defrule rpk
(rel_name-ids	rpk	?id	?kri)
;(id-hin_concept-MRS_concept ?kri ?hin ?mrscon)
;(test (neq (str-index _v_ ?mrscon) FALSE))
=>
(printout ?*rstr-fp* "(id-SF-TENSE-MOOD-PROG-PERF "?kri " prop untensed indicative + + )"crlf)
(printout ?*rstr-dbug* "(rule-rel-values rpk id-SF-TENSE-MOOD-PROG-PERF "?kri " prop untensed indicative + + )"crlf)
)


;It creates TAM for rvks
;verified sentence 341 BAgawe hue Sera ko xeKo
(defrule rvks
(rel_name-ids	rvks|rblsk ?id	?kri)
=>
(printout ?*rstr-fp* "(id-SF-TENSE-MOOD-PROG-PERF "?kri " prop untensed indicative + - )"crlf)
(printout ?*rstr-dbug* "(rule-rel-values rvks id-SF-TENSE-MOOD-PROG-PERF "?kri " prop untensed indicative + - )"crlf)
)
 
;It creates TAM for vmod_krvn
;verified sentence 338 vaha laMgadAkara calawA hE.
;verified sentence 340 BAgawe hue Sera ko xeKo
(defrule krvn-sf
(rel_name-ids	krvn	?kri	?kvn)
;(MRSc-FVs ?mrscon ?lbl ?l ?arg0 ?a0 ARG1: ?a1)
(id-hin_concept-MRS_concept ?kvn ?hin ?mrscon)
(test (neq (str-index _v_ ?mrscon) FALSE))
=>
(printout ?*rstr-fp* "(id-SF-TENSE-MOOD-PROG-PERF "?kvn " prop untensed indicative + - )"crlf)
(printout ?*rstr-dbug* "(rule-rel-values krvn-sf id-SF-TENSE-MOOD-PROG-PERF "?kvn " prop untensed indicative + - )"crlf)
)

;It creates TAM for rsk
;verified sentence 339 #rAma sowe hue KarrAte BarawA hE. 
(defrule rsk
(rel_name-ids	rsk	?id	?kri)
=>
(printout ?*rstr-fp* "(id-SF-TENSE-MOOD-PROG-PERF "?kri " prop untensed indicative + - )"crlf)
(printout ?*rstr-dbug* "(rule-rel-values rsk id-SF-TENSE-MOOD-PROG-PERF "?kri " prop untensed indicative + - )"crlf)
)

;genrate tense value for rpk in get_v_state
(defrule rpk2
(rel_name-ids	rpk	?id	?kri)
(id-stative	?id	yes)
=>
(printout ?*rstr-fp* "(id-SF-TENSE-MOOD-PROG-PERF "?id" prop untensed indicative - - )"crlf)
(printout ?*rstr-dbug* "(rule-rel-values rpk2 id-SF-TENSE-MOOD-PROG-PERF "?id" prop untensed indicative - - )"crlf)
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
(printout ?*rstr-dbug* "(rule-rel-values kri-tam-neg id-SF-TENSE-MOOD-PROG-PERF "?kri " prop " ?tense " indicative " ?prog " " ?perf ")"crlf)
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
(declare (salience 1000))
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
(not (construction-ids	disjunct	?id1 ?id2))
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
(not (rel_name-ids	rpk	?id	?kri_id)) ;#rAma ne skUla jAkara KAnA KAyA.
(not (rel_name-ids	rblak	?id	?kri_id)) ;gAyoM ke xuhane se pahale rAma Gara gayA.
(not (rel_name-ids	rblpk	?id	?kri_id)) ;;rAma ke vana jAne para xaSaraWa mara gaye.
(not (rblsk_index_notrequired ?id))
(not (id-stative ?id yes))
(not (id-causative ?id yes)) ;#SikRikA ne CAwroM se kakRA ko sAPa karAyA.
(not (id-doublecausative	?id	yes)) ;mAz ne rAma se bacce ko KAnA KilavAyA.
(not(rel_name-ids vAkya_vn ?id1 ?id2)) 
(not (rel_name-ids samuccaya ?id	?kri_id))
(not (rel_name-ids anyawra ?id	?kri_id))
(not (rel_name-ids viroXi ?id	?kri_id))
(not (rel_name-ids kAryakAraNa ?id	?kri_id))
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
(H_TAM-E_TAM-Perfective_Aspect-Progressive_Aspect-Tense-Type  ?tam ?e_tam ?perf ?prog ?tense modal)
(kriyA-TAM ?kri ?tam|nA_hE_1)
(MRS_info id-MRS_concept-LBL-ARG0-ARG1 ?modalV  ?mrs_modal  ?lbl  ?arg0  ?h)
(sentence_type  affirmative|interrogative|yn_interrogative|negative)
(test (or (neq (str-index _v_modal ?mrs_modal) FALSE) (neq (str-index _v_qmodal ?mrs_modal) FALSE)));_used+to_v_qmodal
(not (rel_name-ids kAryakAraNa ?previousid	?kri))
=>
(assert (asserted_LTOP-INDEX-for-modal))
(printout ?*rstr-fp* "(LTOP-INDEX h0 "?arg0 ")" crlf)
(printout ?*rstr-dbug* "(rule-rel-values tam-modal  LTOP-INDEX h0 "?arg0 ")"crlf)
)

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
(id-doublecausative	?id	yes) 
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
?f<-(MRS_info ?rel ?kri ?mrsCon ?lbl $?vars)
(test (eq (str-index unspec_adj ?mrsCon) FALSE))
(test (eq (str-index which_q ?mrsCon) FALSE))
(test (eq (str-index _near_p ?mrsCon) FALSE))

=>
(retract ?f)
(printout ?*rstr-fp* "(MRS_info " ?rel " "?kri " "?mrsCon " "?lbl" " (implode$ (create$ $?vars)) ")" crlf)
(printout ?*rstr-dbug* "(rule-rel-values printFacts " ?rel " "?kri " "?mrsCon " "?lbl" " (implode$ (create$ $?vars)) ")"crlf)
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
(id-concept_label	?id1	wyax)
(or (id-proximal	?id1	yes) (id-distal	?id1	yes))
(MRS_info ?rel ?id1 ?mrscon ?lbl ?ARG0 ?rstr ?body)
?f1<-(MRS_info ?rel1 ?id2 ?mrsCon ?lbl1 ?ARG01 ?ARG1 $?var)
?f2<-(MRS_info ?rel2 ?id3 generic_entity ?lbl2 ?ARG02)
(test (eq  (+ ?id1 10) ?id3))
(not (modified ?ARG02))
(test (or (neq (str-index _this_q_dem ?mrscon) FALSE)
          (neq (str-index _that_q_dem ?mrscon) FALSE)))
(test (neq (str-index _v_ ?mrsCon) FALSE))
=>
(retract ?f1 ?f2)
(assert (modified ?ARG02))

(assert (MRS_info ?rel1 ?id2 ?mrsCon ?lbl1 ?ARG01 ?ARG0 $?var))
(printout ?*rstr-dbug* "(rule-rel-values generic_entity " ?rel1 " "?id2" "?mrsCon" " ?lbl1 " " ?ARG01" " ?ARG0" "(implode$ (create$ $?var)) ")"crlf)

(assert (MRS_info ?rel2 ?id3 generic_entity ?lbl2 ?ARG0))
(printout ?*rstr-dbug* "(rule-rel-values generic_entity " ?rel2 " "?id3" generic_entity " ?lbl2 " " ?ARG0")"crlf)
)

;Rule for generic_entity
(defrule generic_entity-k2
(id-concept_label	?id1	wyax)
(or (id-proximal	?id1	yes) (id-distal	?id1	yes))
(MRS_info ?rel ?id1 ?mrscon ?lbl ?ARG0 ?rstr ?body)
?f1<-(MRS_info ?rel1 ?id2 ?mrsCon ?lbl1 ?ARG01 ?ARG1 $?var)
?f2<-(MRS_info ?rel2 ?id3 generic_entity ?lbl2 ?ARG02)
(test (eq  (+ ?id1 10) ?id3))
(not (modified ?ARG02))
(test (or (neq (str-index _this_q_dem ?mrscon) FALSE)
          (neq (str-index _that_q_dem ?mrscon) FALSE)))
(test (neq (str-index _v_ ?mrsCon) FALSE))
=>
(retract ?f1 ?f2)
(assert (modified ?ARG02))

(assert (MRS_info ?rel1 ?id2 ?mrsCon ?lbl1 ?ARG01 ?ARG1 $?var))
(printout ?*rstr-dbug* "(rule-rel-values generic_entity-k2 " ?rel1 " "?id2" "?mrsCon" " ?lbl1 " " ?ARG01" " ?ARG1" "(implode$ (create$ $?var)) ")"crlf)

(assert (MRS_info ?rel2 ?id3 generic_entity ?lbl2 ?ARG0))
(printout ?*rstr-dbug* "(rule-rel-values generic_entity-k2 " ?rel2 " "?id3" generic_entity " ?lbl2 " " ?ARG0")"crlf)
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
(not (modified_conj ?head))
(not (which_bind_notrequired ?dep))
;(not (id-concept_label	?head	eka_1))
=>
(retract ?f)
(printout ?*rstr-fp*   "(MRS_info  "?rel1 " " ?dep " " ?endsWith_q " " ?lbl1 " " ?ARG_0 " " (implode$ (create$ $?vars)) ")"crlf)
(printout ?*rstr-dbug* "(rule-rel-values  mrs-info_q "?rel1 " " ?dep " " ?endsWith_q " " ?lbl1 " "?ARG_0 " " (implode$ (create$ $?vars)) ")"crlf)
)


(defrule rstr-rstd4non-implicit
(rel_name-ids dem|quant ?head ?dep) 
;(rel_name-ids ord|dem|quant ?head ?dep) ;Rama ate the second apple.
(MRS_info ?rel2 ?head ?mrsCon ?lbl2 ?ARG_0 $?v)
?f<-(MRS_info ?rel1 ?dep ?endsWith_q ?lbl1 ?x $?vars)
(test (eq (str-index _v_ ?mrsCon) FALSE)) ;Some barked
=>
(retract ?f)
(printout ?*rstr-fp*   "(MRS_info  "?rel1 " " ?dep " " ?endsWith_q " " ?lbl1 " " ?ARG_0 " " (implode$ (create$ $?vars)) ")"crlf)
(printout ?*rstr-dbug* "(rule-rel-values rstr-rstd4non-implicit "?rel1 " " ?dep " " ?endsWith_q " " ?lbl1 " "?ARG_0 " " (implode$ (create$ $?vars)) ")"crlf)
)

;#sUrya camakawA BI hE.
(defrule BI_1-also-nonverb
?f<-(MRS_info id-MRS_concept-LBL-ARG0-ARG1 ?id _also_a_1 ?lbl ?a0 ?a1)
(id-BI_1  ?id1  yes)
(MRS_info ?rel ?id1 ?mrscon ?l $?v)
(test (eq (+ ?id1 1000) ?id))
(not (rel_name-ids	rask2	?kriya	?id1))
=>
;(retract  ?f)
;(bind ?arg1 (str-cat "e" (sub-string 2 (str-length ?a1) ?a1)))
(printout ?*rstr-fp* "(MRS_info id-MRS_concept-LBL-ARG0-ARG1 "?id" _also_a_1 "?l" "?a0" " ?a1")"crlf)
(printout ?*rstr-dbug* "(rule-rel-values BI_1-also-nonverb MRS_info id-MRS_concept-LBL-ARG0-ARG1 "?id" _also_a_1 "?l"  "?a0" " ?a1")"crlf)
)
;#sUrya camakawA BI hE.
(defrule BI_1-also-nonverb
?f<-(MRS_info id-MRS_concept-LBL-ARG0-ARG1 ?id _also_a_1 ?lbl ?a0 ?a1)
(iiiiiid-BI_1  ?id1  yes)
(MRS_info ?rel ?id1 ?mrscon ?l $?v)
(test (eq (+ ?id1 1000) ?id))
(not (rel_name-ids	rask2	?kriya	?id1))
=>
;(retract  ?f)
(bind ?arg1 (str-cat "e" (sub-string 2 (str-length ?a1) ?a1)))
(printout ?*rstr-fp* "(MRS_info id-MRS_concept-LBL-ARG0-ARG1 "?id" _also_a_1 "?l" "?a0" " ?arg1")"crlf)
(printout ?*rstr-dbug* "(rule-rel-values BI_1-also-nonverb MRS_info id-MRS_concept-LBL-ARG0-ARG1 "?id" _also_a_1 "?l"  "?a0" " ?arg1")"crlf)
)
;Rule for creating binding with verb and the word _frequent_a_1.
;It creates frequent lbl same as verb lbl and arg1 will be same as arg0 of verb.
;#राम खा -खाकर मोटा हो गया ।
(defrule frequent
;(MRS_info id-MRS_concept -5000  _frequent_a_1)
(rel_name-ids	rpk ?id ?kriyA)
?f<-(MRS_info id-MRS_concept-LBL-ARG0-ARG1 -5000 _frequent_a_1 ?lbl ?arg0 ?arg1)
(MRS_info id-MRS_concept-LBL-ARG0-ARG1-ARG2 ?kriyA ?mrsCon ?lbl1 ?arg01 ?arg11 $?v)
(test (neq (str-index "_v_" ?mrsCon)FALSE))
=>
(retract ?f)
(printout ?*rstr-fp* "(MRS_info id-MRS_concept-LBL-ARG0-ARG1 -5000 _frequent_a_1 "?lbl1" "?arg0" "?arg01")"crlf)
(printout ?*rstr-dbug* "(rule-rel-values frequent  id-MRS_concept-LBL-ARG0-ARG1 -5000 _frequent_a_1 "?lbl1" "?arg0" "?arg01")"crlf)
)

;Rule for binding comparitive degree "comp" node with the adjective it specifies and the person it compares.
;It replaces lbl of adjective with the lbl of comp, and arg0 of adjective with the arg1 of comp, and arg0 of upamAna with the arg2 of comp. 
;#rAma mohana se jyAxA buxXimAna hE.
(defrule compermore-bind
(id-degree	?adjid	compermore)
(rel_name-ids ru|rv ?id ?id1)          ;?id = upameya/rAma, ?id1 = upamAna/mohana
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
(defrule comperless-bind
(id-degree	?adjid	comperless)
(rel_name-ids rv|ru ?id ?id1)
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
(rel_name-ids	k1	?kri	?id)
(rel_name-ids	k1s	?kri	?adjid) ;#गुलाब जैसे फूल पानी में नहीं उगते हैं।
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

;Rule for changing L-INDEX and R-INDEX of conj with the ARG0 of the component before _and_c  and the component after _and_c respectively
;Rule for changing arg0 of udef_q with ARG0 of _and_c.
;This rule creates binding for _and_c and will be available for sentences having more coordination words. 
;The ARG0 of _and_c will be available and replace with the previous implicit_conj R-INDEX
;#rAma, hari Ora sIwA acCe hEM.
;Rama buxXimAna, motA, xilera, Ora accA hEM.
;rAma Ora sIwA acCe hEM.
(defrule conj
(declare (salience 1000))
(construction-ids	conj	$?vars ?id1 ?id2)
?f<-(MRS_info id-MRS_concept-LBL-ARG0-L_INDEX-R_INDEX ?id _and_c ?l ?a0 ?li ?ri)
?f1<-(MRS_info id-MRS_concept-LBL-ARG0-RSTR-BODY ?idd udef_q ?lbll ?argg ?rstr ?body)
(MRS_info ?rel1 ?id1 ?name ?lbl ?arg0 $?var)
(MRS_info ?rel2 ?id2 ?name2 ?lbl1 ?arg00 $?varss)
(test (eq  (- ?id 490) ?idd)) 
(not (modified_conj ?id))
(not (rel_name-ids	mod	?id1	?id3)) 
=>
(retract ?f ?f1)
(assert (modified_conj ?id))
(assert (conj_ARG0 ?id ?a0))
;(assert (MRS_info id-MRS_concept-LBL-ARG0-L_INDEX-R_INDEX ?id _and_c ?l ?a0 ?arg0 ?arg00))
(printout ?*rstr-fp*  "(MRS_info id-MRS_concept-LBL-ARG0-L_INDEX-R_INDEX "?id" _and_c "?l" "?a0" "?arg0" "?arg00")"crlf)
(printout ?*rstr-dbug* "(rule-rel-values conj  id-MRS_concept-LBL-ARG0-L_INDEX-R_INDEX "?id" _and_c "?l" "?a0" "?arg0" "?arg00")"crlf)
(printout ?*rstr-dbug* "(rule-rel-values conj  conj_ARG0 "?id" "?a0")"crlf)
(printout ?*rstr-fp* "(MRS_info id-MRS_concept-LBL-ARG0-RSTR-BODY "?idd" udef_q "?lbll" "?a0" "?rstr" "?body")"crlf)
(printout ?*rstr-dbug* "(rule-rel-values conj  id-MRS_concept-LBL-ARG0-RSTR-BODY "?idd" udef_q "?lbll" "?a0" "?rstr" "?body")"crlf)
)

;Rule for converting R-INDEX of implicit_conj with ARG0 of _and_c and then ARG0 of immediate implicit_conj with R-INDEX of immidiate next implicit_conj and so on.
;Rule for converting L-INDEX of implicit_conj with  arg0 of previous component it brings (-600). This process also continues until the last implicit_conj
;Rule for converting udef_q arg0 with arg0 of implicit_conj
;#rAma, hari Ora sIwA acCe hEM.
;Rama buxXimAna, motA, xilera, Ora accA hEM.

(defrule conj-implicit
(declare (salience 1000))
(construction-ids	conj	$?vars ?id1 ?id2 $?va)
?f<-(MRS_info id-MRS_concept-LBL-ARG0-L_INDEX-R_INDEX ?id implicit_conj ?l ?a0 ?li ?ri)
?f1<-(MRS_info id-MRS_concept-LBL-ARG0-RSTR-BODY ?idd udef_q ?lbll ?argg ?rstr ?body)
?f3<-(MRS_info ?rel1 ?id1 ?con1 ?l1 ?a01 $?var)
?f2<-(conj_ARG0 ?conj ?Pre_A0)
(not (modified_implicit_conj ?id))
(not (modified_implicit_main ?id1))
(test (eq  (-  (string-to-field (sub-string 1 1 (str-cat ?conj))) 1)  (string-to-field (sub-string 1 1 (str-cat ?id)))  (string-to-field (sub-string 1 1 (str-cat ?id1)) ) ))
=>
(retract ?f ?f1 ?f2)
(assert (modified_implicit_main ?id1))
(assert (modified_implicit_conj ?id1))
(assert (conj_ARG0 ?id ?a0))
(printout ?*rstr-fp*  "(MRS_info id-MRS_concept-LBL-ARG0-L_INDEX-R_INDEX "?id" implicit_conj "?l" "?a0" "?a01" "?Pre_A0")"crlf)
(printout ?*rstr-dbug* "(rule-rel-values conj-implicit  id-MRS_concept-LBL-ARG0-L_INDEX-R_INDEX "?id" conj-implicit "?l" "?a0" "?a01" "?Pre_A0")"crlf)
(printout ?*rstr-fp* "(MRS_info id-MRS_concept-LBL-ARG0-RSTR-BODY "?idd" udef_q "?lbll" "?a0" "?rstr" "?body")"crlf)
(printout ?*rstr-dbug* "(rule-rel-values conj-implicit  id-MRS_concept-LBL-ARG0-RSTR-BODY "?idd" udef_q "?lbll" "?a0" "?rstr" "?body")"crlf)
)


;generates LTOP and INDEX values for predicative adjective(s).
;ex. rAma acCA hE.   rAma, sIwA, hari and mohana acCe hEM.
(defrule samAnAXi-LTOP
(id-concept_label       ?v   hE_1|WA_1)
(rel_name-ids   k1s        ?id  ?id_adj)
(MRS_info ?rel ?id_adj ?mrsCon ?lbl ?arg0 $?vars)
(not (LTOP_value_geneated_4_construction))
(not (LTOP_value_geneated_4_disjunct_construction))
(test (neq (str-index _a_ ?mrsCon) FALSE)) 
(not (rel_name-ids samuccaya ?non	?id))
(not (rel_name-ids anyawra ?non	?id))
(not (rel_name-ids viroXi ?non	?id))
=>
    (printout ?*rstr-fp* "(LTOP-INDEX h0 "?arg0 ")" crlf)
    (printout ?*rstr-dbug* "(rule-rel-values samAnAXi-LTOP LTOP-INDEX h0 "?arg0 ")"crlf)
)  

;Generates binding with the LTOP-INDEX with implicit arg0 when there is predicative construction with more than two words. 
;#Rama buxXimAna, motA, xilera, Ora accA hE.
(defrule samAnAXi-LTOP-conj-pred
(declare (salience 1000))
(id-concept_label       ?v   hE_1|WA_1)
(rel_name-ids   k1s        ?v  ?k1s)
(construction-ids	conj  ?k1s $?k1ses)
(MRS_info ?rel ?k1sImplicit implicit_conj ?lbl ?arg0 $?vars)
(MRS_info ?rel1 ?k1s ?mrsCon $?var)
(test (eq  (+ ?k1s 600) ?k1sImplicit))
(test (neq (str-index _a_ ?mrsCon) FALSE))
;(not (modified_implicit_main ?id1))
=>

(assert (LTOP_value_geneated_4_construction))
    (printout ?*rstr-fp* "(LTOP-INDEX h0 "?arg0 ")" crlf)
    (printout ?*rstr-dbug* "(rule-rel-values samAnAXi-LTOP-conj-pred LTOP-INDEX h0 "?arg0 ")"crlf)
)  


;Rule to change ARG1 of adjective with ARG0 of _and_c when the construction is in predicate position.
;rAma Ora sIwA acCe hEM.
;When the construction is having only two words. 
(defrule conjk1s
(construction-ids	conj	?id1 ?id2)
(rel_name-ids	k1s	?non-adj ?adj)
?f<-(MRS_info id-MRS_concept-LBL-ARG0-ARG1-ARG2 ?adj ?mrsCon ?lbl ?arg0 ?arg1 ?arg2)
(MRS_info id-MRS_concept-LBL-ARG0-L_INDEX-R_INDEX ?iddd _and_c ?lbll ?arg00 ?l ?r)
(test (neq (str-index _a_ ?mrsCon) FALSE))
(test (neq ?arg1 ?arg00))
(not (modified_conjk1s ?arg00))
=>
(retract ?f)
(assert (modified_conjk1s ?arg00))
(assert (MRS_info id-MRS_concept-LBL-ARG0-ARG1-ARG2 ?adj ?mrsCon ?lbl ?arg0 ?arg00 ?arg2))
;(printout ?*rstr-fp* "(MRS_info id-MRS_concept-LBL-ARG0-ARG1-ARG2 "?adj" "?mrsCon" "?lbl" "?arg0" "?arg00" "?arg2")"crlf)
(printout ?*rstr-dbug* "(rule-rel-values conjk1s id-MRS_concept-LBL-ARG0-ARG1-ARG2 "?adj" "?mrsCon" "?lbl" "?arg0" "?arg00" "?arg2")"crlf)
)


;Rule for converting predicatvie word ARG1 with the first implicit_conj ARG0 value. 
;#rAma, hari Ora sIwA acCe hEM.
(defrule implicit-conj-bind-final
(declare (salience 1000))
(rel_name-ids	k1	?kri	?id1)
(construction-ids	conj	?id1 $?var)
?f<-(MRS_info ?rel ?adjid ?mrsCon ?lbl ?arg0 ?arg1 $?v)
(MRS_info id-MRS_concept-LBL-ARG0-L_INDEX-R_INDEX ?id implicit_conj ?lbll ?arg00 ?l ?r)
(test (eq  (+ ?id1 600) ?id))
=>
(printout ?*rstr-fp* "(MRS_info "?rel" "?adjid" "?mrsCon" "?lbl" "?arg0" "?arg00" "(implode$ (create$ $?v)) ")"crlf)
(printout ?*rstr-dbug* "(rule-rel-values implicit-conj-bind-final "?rel" "?adjid" "?mrsCon" "?lbl" "?arg0" "?arg00" "(implode$ (create$ $?v)) ")"crlf)
)

;Rule for binding ARG1 of the predicative word with ARG0 of _and_c  when construction is in subjective position with two entries. 
(defrule conj-bind-final-two
(declare (salience 1000))
(rel_name-ids	k1	?kri	?id1)
(construction-ids	conj	?id1 ?id2)
?f<-(MRS_info ?rel ?adjid ?mrsCon ?lbl ?arg0 ?arg1 $?v)
(MRS_info id-MRS_concept-LBL-ARG0-L_INDEX-R_INDEX ?id _and_c ?lbll ?arg00 ?l ?r)
(test (eq  (+ ?id1 500) ?id))
=>
(printout ?*rstr-fp* "(MRS_info "?rel" "?adjid" "?mrsCon" "?lbl" "?arg0" "?arg00" "(implode$ (create$ $?v)) ")"crlf)
(printout ?*rstr-dbug* "(rule-rel-values conj-bind-final-two "?rel" "?adjid" "?mrsCon" "?lbl" "?arg0" "?arg00" "(implode$ (create$ $?v)) ")"crlf)
)

;Rule for binding LTOP_INDEX with arg0 of unknown typed feature.
;#kuwwA!
;#billI Ora kuwwA.
(defrule unknown_LTOP
(sentence_type	)
(MRS_info id-MRS_concept-LBL-ARG0-ARG 0 unknown ?lbl ?arg0 ?arg1)
=>
(printout ?*rstr-fp* "(LTOP-INDEX h0 "?arg0 ")" crlf)
(printout ?*rstr-dbug* "(rule-rel-values unknown_LTOP LTOP-INDEX h0 "?arg0 ")"crlf)
)

;Rule to change arg value of unknown with arg0 of the word it brough from. 
;;#kuwwA! for this sentence the arg0 of dog will go for the arg1 of the unknown
;Not applicable for the sentences having more than two words in construction. 
(defrule unknown_bind
(sentence_type	)
(MRS_info id-MRS_concept-LBL-ARG0-ARG 0 unknown ?lbl ?arg0 ?arg1)
(MRS_info id-MRS_concept-LBL-ARG0 ?noun ?mrsCon ?lbl1 ?arg01)
(not (construction-ids	conj	?id1 ?id2))
=>
(printout ?*rstr-fp* "(MRS_info  id-MRS_concept-LBL-ARG0-ARG  0 unknown "?lbl" " ?arg0 " " ?arg01 ")"crlf)
(printout ?*rstr-dbug* "(rule-rel-values unknown_bind id-MRS_concept-LBL-ARG0-ARG  0 unknown "?lbl" " ?arg0 " " ?arg01 ")"crlf)
)

;Rule for binding ARG0 of conj with ARG of unknown when the construction is in two words.
;;#billI Ora kuwwA. 
(defrule unknown_conj
(declare (salience 2000))
(sentence_type	)
(construction-ids	conj	?id1 ?id2)
(MRS_info id-MRS_concept-LBL-ARG0-ARG 0 unknown ?lbl ?arg0 ?arg1)
(MRS_info id-MRS_concept-LBL-ARG0-L_INDEX-R_INDEX ?conjid _and_c ?lbl1 ?Arg0 $?v)
(test (eq  (+ ?id1 500) ?conjid))
=>
(printout ?*rstr-fp* "(MRS_info  id-MRS_concept-LBL-ARG0-ARG  0 unknown "?lbl" " ?arg0 " " ?Arg0 ")"crlf)
(printout ?*rstr-dbug* "(rule-rel-values unknown_conj id-MRS_concept-LBL-ARG0-ARG  0 unknown "?lbl" " ?arg0 " " ?Arg0 ")"crlf)
)

;Rule for binding L_HNDL of _and_c with the previous LBL of the word. R_HNDL with the LBl fo the preceeding word.
;Rule for binding L-INDEX of _and_c with the ARG0 of previous word and R-INDEX with the preceding word ARG0 
;It also provides LBL and ARG0 of _and_c for the next rule. 
;#Rama buxXimAna, motA, xilera, Ora accA hE.
(defrule conj-pred
(declare (salience 1000))
(construction-ids	conj	$?vars ?id1 ?id2)
?f<-(MRS_info id-MRS_concept-LBL-ARG0-L_INDEX-R_INDEX-L_HNDL-R_HNDL ?id _and_c ?l ?a0 ?li ?ri ?lh ?rh)
(MRS_info ?rel1 ?id1 ?name ?lbl ?arg0 $?var)
(MRS_info ?rel2 ?id2 ?name2 ?lbl1 ?arg00 $?varss)
(not (modified_conj ?id))
=>
(retract ?f)
(assert (modified_conj ?id))
(assert (conj_LBL_ARG0 ?id ?l ?a0 ))
(printout ?*rstr-fp*  "(MRS_info id-MRS_concept-LBL-ARG0-L_INDEX-R_INDEX-L_HNDL-R_HNDL "?id" _and_c "?l" "?a0" "?arg0" "?arg00" "?lbl" "?lbl1")"crlf)
(printout ?*rstr-dbug* "(rule-rel-values conj-pred  id-MRS_concept-LBL-ARG0-L_INDEX-R_INDEX-L_HNDL-R_HNDL "?id" _and_c "?l" "?a0" "?arg0" "?arg00" "?lbl" "?lbl1")"crlf)
(printout ?*rstr-dbug* "(rule-rel-values conj-pred  conj_LBL_ARG0 "?id" "?l" "?a0")"crlf)
)

;Rule for binding implicit_conj just before the _and_c with R-INDEX with the arg0 of the _and_c and LBL of _and_c with the R_HNDL of implicit_conj.
;Then binding starts for this implicit_conj L_INDEX with the ARG0 of the preceeding word and L_HNDL with the LBL of the same word.
;This process continues until the last implicit_conj binds. 
;#Rama buxXimAna, motA, xilera, Ora accA hE. 
(defrule conj-implicit-pred
(declare (salience 1000))
(construction-ids	conj	$?vars ?id1 ?id2 $?va)
?f<-(MRS_info id-MRS_concept-LBL-ARG0-L_INDEX-R_INDEX-L_HNDL-R_HNDL ?id implicit_conj ?l ?a0 ?li ?ri ?lh ?rh)
?f3<-(MRS_info ?rel1 ?id1 ?con1 ?l1 ?a01 $?var)
?f2<-(conj_LBL_ARG0 ?conj ?Pre_lbl ?Pre_A0)
(not (modified_implicit_conj ?id))
(not (modified_implicit_main ?id1))
(test (eq  (-  (string-to-field (sub-string 1 1 (str-cat ?conj))) 1)  (string-to-field (sub-string 1 1 (str-cat ?id)))  (string-to-field (sub-string 1 1 (str-cat ?id1)) ) ))
=>
(retract ?f ?f2)
(assert (modified_implicit_main ?id1))
(assert (modified_implicit_conj ?id1))
(assert (conj_LBL_ARG0 ?id ?l ?a0))
(printout ?*rstr-fp*  "(MRS_info id-MRS_concept-LBL-ARG0-L_INDEX-R_INDEX-L_HNDL-R_HNDL "?id" implicit_conj "?l" "?a0" "?a01" "?Pre_A0" "?l1" "?Pre_lbl" )"crlf)
(printout ?*rstr-dbug* "(rule-rel-values conj-implicit-pred  id-MRS_concept-LBL-ARG0-L_INDEX-R_INDEX-L_HNDL-R_HNDL "?id" implicit_conj "?l" "?a0" "?a01" "?Pre_A0" "?Pre_lbl")"crlf)
)

;Rule for binding ARG1 of the predicative position with the ARG0 of the subject position.
;#rAma, hari Ora sIwA acCe hEM.
(defrule samAnAXi-construction
(rel_name-ids   k1	?non-adj ?k1)
(rel_name-ids	k1s	?non-adj ?adj)
(construction-ids	conj	 $? ?adj  $?)
?f<-(MRS_info ?rel_name ?adj ?mrsCon ?lbl ?arg0 ?arg1 $?v)
(MRS_info ?rel1 ?k1 ?mrsCon1 ?lbl1 ?nonadjarg_0 $?vars)
(test (neq (str-index _a_ ?mrsCon) FALSE))
(test (neq ?arg1 ?nonadjarg_0))
(not (modified_samAnAXi ?nonadjarg_0 ?adj) )
=>
;(retract ?f)
(assert (modified_samAnAXi ?nonadjarg_0 ?adj))
(assert (MRS_info  ?rel_name ?adj ?mrsCon ?lbl ?arg0 ?nonadjarg_0 $?v))
(printout ?*rstr-dbug* "(rule-rel-values samAnAXi-construction "?rel_name " " ?adj " " ?mrsCon " " ?lbl " " ?nonadjarg_0 " "(implode$ (create$ $?v))")"crlf)
)

;Rule for binding arg0 of the _which_q with the arg0 of the word it modifies. 
;;#kOna sA kuwwA BOMkA?
(defrule which-mod
(id-concept_label	?which	kim)
(rel_name-ids	mod	?k1	?which)
(sentence_type  interrogative)
?f<-(MRS_info id-MRS_concept-LBL-ARG0-RSTR-BODY ?which _which_q ?lbl ?arg0 ?rstr ?body)
(MRS_info id-MRS_concept-LBL-ARG0 ?k1 ?mrscon ?lbl1 ?arg01 $?v)
=>
(printout ?*rstr-fp* "(MRS_info  id-MRS_concept-LBL-ARG0-RSTR-BODY "?which" _which_q "?lbl" "?arg01" " ?rstr " " ?body ")"crlf)
(printout ?*rstr-dbug* "(rule-rel-values which-mod id-MRS_concept-LBL-ARG0-RSTR-BODY "?which" _which_q "?lbl" " ?arg01 " " ?rstr " "?body")"crlf)
)


;Rule for binding def_implicit_q, which_q, poss with the values of person and noun concept.
;It changes ARG0 of def_implicit_q with the arg0 of word it modifies, changing arg0 of which_q with the arg0 of the person, and changing lbl of poss with the word it modifies and arg1 with arg0 of the same word and arg2 with the person arg0. 
;#kiska kuwwA BOMkA? 
(defrule whose-r6
(declare (salience 1000))
(id-concept_label	?whose	kim)
(rel_name-ids	r6	?noun	?whose)
(sentence_type  interrogative)
?f<-(MRS_info id-MRS_concept-LBL-ARG0-RSTR-BODY ?id def_implicit_q ?ld ?ad ?rd ?bd)
?f1<-(MRS_info id-MRS_concept-LBL-ARG0-RSTR-BODY ?id which_q ?lbl ?arg0 ?rstr ?body)
?f2<-(MRS_info id-MRS_concept-LBL-ARG0-ARG1-ARG2 ?poss poss ?lpo ?aopo ?a1po ?a2po)
(MRS_info id-MRS_concept-LBL-ARG0 ?per person ?lp ?pa)
(MRS_info id-MRS_concept-LBL-ARG0 ?noun ?mrscon ?lbl1 ?arg01 $?v)
=>
(retract ?f)
(printout ?*rstr-fp* "(MRS_info  id-MRS_concept-LBL-ARG0-RSTR-BODY "?id" def_implicit_q "?ld" "?arg01" "?rd" "?bd")"crlf)
(printout ?*rstr-dbug* "(rule-rel-values whose-r6 id-MRS_concept-LBL-ARG0-RSTR-BODY "?id" def_implicit_q "?ld" "?arg01" "?rd" "?bd")"crlf)

(printout ?*rstr-fp* "(MRS_info  id-MRS_concept-LBL-ARG0-RSTR_BODY "?id" which_q "?lbl" "?pa" "?rstr" "?body")"crlf)
(printout ?*rstr-dbug* "(rule-rel-values whose-r6 id-MRS_concept-LBL-ARG0-RSTR_BODY "?id" which_q "?lbl" "?pa" "?rstr" "?body")"crlf)

(printout ?*rstr-fp* "(MRS_info  id-MRS_concept-LBL-ARG0-ARG1-ARG2 "?poss" poss "?lbl1" "?aopo" "?arg01" "?pa")"crlf)
(printout ?*rstr-dbug* "(rule-rel-values whose-r6 id-MRS_concept-LBL-ARG0-ARG1-ARG2 "?poss" poss "?lbl1" "?aopo" "?arg01" "?pa")"crlf)
)

;Rule for binding LTOP h0 with the lbl of the unsepc_adj. 
; How are you?
(defrule how-k1s-ltop
(rel_name-ids	k1s	?kri	?how)
(id-concept_label	?how	kim)
(sentence_type  interrogative)
(MRS_info ?rel1  ?id1  unspec_adj ?lbl1 ?arg10 ?arg11 $?var)
(not (id-num	?how	?n))
(not (id-anim	?how	yes))
=>
(printout ?*rstr-fp* "(LTOP-INDEX h0 "?arg10 ")" crlf)
(printout ?*rstr-dbug* "(rule-rel-values how-k1s-ltop LTOP-INDEX h0 "?arg10 ")"crlf)
)

;Rule for binding unsepc_adj, which_q, prpstn_to_prop with property and the pronoun. 
;How are you?

(defrule how-k1s
(declare (salience 1000))
(id-concept_label	?how	kim)
(rel_name-ids	k1s	?kri	?how)
(sentence_type  interrogative)
?f<-(MRS_info id-MRS_concept-LBL-ARG0-ARG1 ?us unspec_adj ?lus ?a0us ?a1us)
?f1<-(MRS_info id-MRS_concept-LBL-ARG0-ARG1-ARG2 ?ptp prpstn_to_prop ?lptp ?a0ptp ?a1ptp ?a2ptp)
?f2<-(MRS_info id-MRS_concept-LBL-ARG0-RSTR-BODY ?wq which_q ?wl ?a0w ?rsw ?bdw)
(MRS_info id-MRS_concept-LBL-ARG0 ?noun pron ?lbl1 ?arg01)
(MRS_info id-MRS_concept-LBL-ARG0 ?p property ?lp ?a0p)
;(test (neq (str-index pron ?mrscon) FALSE))
;(MRS_info id-MRS_concept-LBL-ARG0 10000 pron h1 x2)
(not (id-num	?how	?n))
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
(defrule kim-which
(declare (salience 10000))
(id-concept_label	?how	kim)
(rel_name-ids	k1s|degree	?kri	?how)
(MRS_info id-MRS_concept-LBL-ARG0-RSTR-BODY ?wq which_q ?wl ?a0w ?rsw ?bdw)
(not (id-num	?how	?n)) 
(not (id-anim	?how	yes))
=>
(assert (which_bind_notrequired ?wq))
(printout ?*rstr-dbug* "(rule-rel-values  kim-which which_bind_notrequired " ?wq ")"crlf)
)

;Rule for binding measure and which_q with the abstr_deg and kri of the sentence.
;How happy was Abramas?
(defrule how-adj
(rel_name-ids	degree	?kri	?how)
(id-concept_label	?how	kim)
(sentence_type  interrogative)
?f<-(MRS_info id-MRS_concept-LBL-ARG0-ARG1-ARG2 ?m measure ?ml ?ma0 ?ma1 ?ma2)
?f1<-(MRS_info id-MRS_concept-LBL-ARG0-RSTR-BODY ?w which_q ?wl ?wa0 ?wr ?wb)
(MRS_info id-MRS_concept-LBL-ARG0 ?a abstr_deg ?al ?aa0)
(MRS_info id-MRS_concept-LBL-ARG0-ARG1-ARG2 ?kri _happy_a_with ?hl ?ha0 ?ha1 ?ha2)
=>
(printout ?*rstr-fp* "(MRS_info id-MRS_concept-LBL-ARG0-ARG1-ARG2 "?m" measure "?hl" "?ma0" "?ha0" "?aa0")"crlf)
(printout ?*rstr-dbug* "(rule-rel-values how-adj id-MRS_concept-LBL-ARG0-ARG1-ARG2 "?m" measure "?hl" "?ma0" "?ha0" "?aa0")"crlf)
(printout ?*rstr-fp* "(MRS_info id-MRS_concept-LBL-ARG0-RSTR-BODY "?w" which_q "?wl" "?aa0" "?wr" "?wb")"crlf)
(printout ?*rstr-dbug* "(rule-rel-values how-adj id-MRS_concept-LBL-ARG0-RSTR-BODY "?w" which_q "?wl" "?aa0" "?wr" "?wb")"crlf)
)

;Rule for binding arg1 and lbl with the kriya.
;#राम खा -खाकर मर गया ।
(defrule rpk-noun
(rel_name-ids	rpk ?noun ?id)
(rel_name-ids	k1	?kriyA	?noun)
?f<-(MRS_info id-MRS_concept-LBL-ARG0-ARG1 ?id ?engcon ?lbl ?arg0 ?arg1)
(MRS_info id-MRS_concept-LBL-ARG0-ARG1-ARG2 ?kriyA ?mrsCon ?lbl1 ?arg01 ?arg11 $?v)
(test (neq (str-index "_v_" ?mrsCon)FALSE))
=>
(retract ?f)
(printout ?*rstr-fp* "(MRS_info id-MRS_concept-LBL-ARG0-ARG1 "?id" "?engcon" "?lbl1" "?arg0" "?arg01")"crlf)
(printout ?*rstr-dbug* "(rule-rel-values rpk-noun  id-MRS_concept-LBL-ARG0-ARG1 "?id" "?engcon" "?lbl1" "?arg0" "?arg01")"crlf)
)

;Rule for changing unspec_manner lbl, arg1, and arg2. Lbl and arg0 of kriya will be it's lbl and arg1. arg2 will be the arg0 of manner. 
;How did you complete the work?
(defrule how-verb
(rel_name-ids	krvn	?kri	?how)
(id-concept_label	?how	kim)
(sentence_type  interrogative)
?f<-(MRS_info id-MRS_concept-LBL-ARG0-ARG1-ARG2 ?m unspec_manner ?ml ?ma0 ?ma1 ?ma2)
(MRS_info id-MRS_concept-LBL-ARG0 ?w manner ?wl ?wa0)
(MRS_info ?rel ?kri ?mrscon ?hl ?ha0 ?ha1 ?ha2 $?v)
(test (neq (str-index "_v_" ?mrscon)FALSE))
=>
(retract ?f)
(printout ?*rstr-fp* "(MRS_info id-MRS_concept-LBL-ARG0-ARG1-ARG2 "?m" unspec_manner "?hl" "?ma0" "?ha0" "?wa0")"crlf)
(printout ?*rstr-dbug* "(rule-rel-values how-verb id-MRS_concept-LBL-ARG0-ARG1-ARG2 "?m" unspec_manner "?hl" "?ma0" "?ha0" "?wa0")"crlf)
)

;Rule for changing arg1 of the rblsk kriya with the arg0 of karwa.
;Rama being gone to the forest, Sita follows.
(defrule rblsk
(rel_name-ids	rblsk	?kri	?rblsk)
(rel_name-ids	k1	?rblsk	?k1)
?f<-(MRS_info id-MRS_concept-LBL-ARG0-ARG1 ?rblsk ?mrscon ?ml ?ma0 ?ma1)
(MRS_info ?rel ?k1 ?mrsc ?lbl ?arg0 $?v)
=>
(retract ?f)
(printout ?*rstr-fp* "(MRS_info id-MRS_concept-LBL-ARG0-ARG1 "?rblsk" "?mrscon" "?ml" "?ma0" "?arg0")"crlf)
(printout ?*rstr-dbug* "(rule-rel-values rblsk id-MRS_concept-LBL-ARG0-ARG1 "?rblsk" "?mrscon" "?ml" "?ma0" "?arg0")"crlf)
)


;Rule for not binding ARG0 value of the verb with the Index value 
;Rama being gone to the forest, Sita follows.
;(defrule rblsk-index
;(declare (salience 10000))
;(rel_name-ids	rblsk	?kri	?rblsk)
;(MRS_info id-MRS_concept-LBL-ARG0-ARG1 ?kri ?mrscon ?ml ?ma0 ?ma1)
;=>
;(assert (rblsk_index_notrequired ?kri))
;(printout ?*rstr-dbug* "(rule-rel-values  rblsk-index rblsk_index_notrequired " ?kri ")"crlf)
;)


;(defrule rblsk-index
;(declare (salience 10000))
;(rrrrrrel_name-ids	rblsk	?kri	?rblsk)
;(MRS_info id-MRS_concept-LBL-ARG0-ARG1 ?kri ?mrscon ?ml ?ma0 ?ma1)
;=>
;(printout ?*rstr-fp* "(LTOP-INDEX h0 "?arg0 ")" crlf)
;(printout ?*rstr-dbug* "(rule-rel-values rblsk-index  LTOP-INDEX h0 "?arg0 ")"crlf)
;)

;Rule for binding udef_q, and_c with the modifier and the nouns.
;We met the old men and women.
(defrule conj-mod
(construction-ids	conj	$?vars ?id1 ?id2)
(rel_name-ids	mod	?id1	?id3)
?f<-(MRS_info id-MRS_concept-LBL-ARG0-L_INDEX-R_INDEX ?id _and_c ?l ?a0 ?li ?ri)
?f1<-(MRS_info id-MRS_concept-LBL-ARG0-RSTR-BODY ?idd udef_q ?lbll ?argg ?rstr ?body)
?f2<-(MRS_info ?rel1 ?id3 ?modifier ?lbl ?arg0 ?arg1)
?f3<-(MRS_info id-MRS_concept-LBL-ARG0-ARG1-ARG2 ?id4 ?verb ?lbl3 ?arg03 ?arg13 ?arg23)
(MRS_info ?rel2 ?id1 ?name2 ?lbl1 ?arg00 $?varss)
(MRS_info ?rel3 ?id2 ?name1 ?lbl2 ?arg02 $?varsss)
;(not (modified_conj ?id))
=>
(retract ?f ?f1)
(printout ?*rstr-fp*  "(MRS_info id-MRS_concept-LBL-ARG0-L_INDEX-R_INDEX "?id" _and_c "?l" "?a0" "?arg00" "?arg02")"crlf)
(printout ?*rstr-dbug* "(rule-rel-values conj-mod  id-MRS_concept-LBL-ARG0-L_INDEX-R_INDEX "?id" _and_c "?l" "?a0" "?arg00" "?arg02")"crlf)
;(printout ?*rstr-dbug* "(rule-rel-values conj-mod  conj_ARG0 "?id" "?a0")"crlf)
(printout ?*rstr-fp* "(MRS_info id-MRS_concept-LBL-ARG0-RSTR-BODY "?idd" udef_q "?lbll" "?arg00" "?rstr" "?body")"crlf)
(printout ?*rstr-dbug* "(rule-rel-values conj-mod  id-MRS_concept-LBL-ARG0-RSTR-BODY "?idd" udef_q "?lbll" "?arg00" "?rstr" "?body")"crlf)
(printout ?*rstr-fp* "(MRS_info "?rel1" "?id3" "?modifier" "?l" "?arg0" "?a0")"crlf)
(printout ?*rstr-dbug* "(rule-rel-values conj-mod "?rel1" "?id3" "?modifier" "?l" "?arg0" "?a0" )"crlf)
(printout ?*rstr-fp* "(MRS_info id-MRS_concept-LBL-ARG0-ARG1-ARG2 "?id4" "?verb" "?lbl3" "?arg03" "?arg13" "?a0")"crlf)
(printout ?*rstr-dbug* "(rule-rel-values conj-mod id-MRS_concept-LBL-ARG0-ARG1-ARG2 "?id4" "?verb" "?lbl3" "?arg03" "?arg13" "?a0")"crlf)
)

;Rule for changing lbl of intf and arg1 with lbl and arg0 of the modifier.
;You are a very good king.
(defrule intf_mod
(rel_name-ids intf ?viya ?viNa)
(MRS_info ?rel1 ?viya ?c ?lbl1 ?arg0_viya  $?var)
?f<-(MRS_info ?rel2 ?viNa ?co ?lbl2 ?arg0_viNa ?arg1_viNa $?vars)
(test (neq (sub-string (- (str-length ?co) 1) (str-length ?co) ?co) "_q"))
(not (construction-ids	conj	$?vars ?viya ?id2))
=>
(assert (MRS_info  ?rel2  ?viNa   ?co   ?lbl1   ?arg0_viNa   ?arg0_viya $?vars))
(printout ?*rstr-fp* "(MRS_info  "?rel2 " " ?viNa " " ?co " " ?lbl1 " " ?arg0_viNa " " ?arg0_viya " "(implode$ (create$ $?vars)) ")"crlf)
(printout ?*rstr-dbug* "(rule-rel-values intf_mod   "?rel2 " " ?viNa " " ?co " " ?lbl1 " " ?arg0_viNa " " ?arg0_viya " "(implode$ (create$ $?vars)) ")"crlf)
)

;Rule for binding arg0 of _the_q with the arg0 of the _and_c
;We met the old men and women.
(defrule def_conj
(declare (salience 100))
(construction-ids	conj	$?vars ?id1 ?id2)
(rel_name-ids	mod	?id1	?id3)
(id-def	?id1	yes)
?f<-(MRS_info id-MRS_concept-LBL-ARG0-RSTR-BODY ?id4 _the_q ?lt ?a0t ?rt ?rb)
(MRS_info id-MRS_concept-LBL-ARG0-L_INDEX-R_INDEX ?id5 _and_c ?la ?aa0 ?ali ?ari)
(test (eq (+ ?id1 10) ?id4)) 
(test (eq (+ ?id1 500) ?id5)) 
=>
(retract ?f)
(printout ?*rstr-fp* "(MRS_info id-MRS_concept-LBL-ARG0-RSTR-BODY "?id4" _the_q "?lt" "?aa0" "?rt" "?rb")"crlf)
(printout ?*rstr-dbug* "(rule-rel-values def_conj id-MRS_concept-LBL-ARG0-RSTR-BODY "?id4" _the_q "?lt" "?aa0" "?rt" "?rb")"crlf)
)

;Rule for binding arg0 of recip_pro with pronoun_q.
;We love each other.
(defrule reciprocal
(id-concept_label	?recip	eka+xUsarA)
(rel_name-ids	k2	?kri	?recip)
?f<-(MRS_info id-MRS_concept-LBL-ARG0-RSTR-BODY ?recip pronoun_q ?lp ?pa0 ?rp ?bp)
?f1<-(MRS_info id-MRS_concept-LBL-ARG0-ARG1-ARG2 ?kri ?verb ?lv ?av ?a1v ?a2v)
(MRS_info id-MRS_concept-LBL-ARG0 ?recippro recip_pro  ?lr ?a0r)
(test (eq (+ ?recip 1000) ?recippro)) 
=>
(retract ?f ?f1)
(assert (MRS_info id-MRS_concept-LBL-ARG0-ARG1-ARG2 ?kri ?verb ?lv ?av ?a1v ?a0r))
(printout ?*rstr-fp* "(MRS_info id-MRS_concept-LBL-ARG0-RSTR-BODY "?recip" pronoun_q "?lp" "?a0r" "?rp" "?bp")"crlf)
(printout ?*rstr-dbug* "(rule-rel-values reciprocal id-MRS_concept-LBL-ARG0-RSTR-BODY "?recip" pronoun_q "?lp" "?a0r" "?rp" "?bp")"crlf)
(printout ?*rstr-fp* "(MRS_info id-MRS_concept-LBL-ARG0-ARG1-ARG2 "?kri" "?verb" "?lv" "?av" "?a1v" "?a0r")"crlf)
(printout ?*rstr-dbug* "(rule-rel-values reciprocal id-MRS_concept-LBL-ARG0-ARG1-ARG2 "?kri" "?verb" "?lv" "?av" "?a1v" "?a0r")"crlf)
)


;Rule for binding preposition with k1s.
;Am I the best king in the world?
(defrule prep-noun-k1s
(declare (salience 10000))
(rel_name-ids ?relp ?kriyA ?karak)
(rel_name-ids	k1s	?kriyA	?karwA)
?f<-(MRS_info ?rel_name ?prep ?endsWith_p ?lbl ?arg0 ?arg1 $?v)
(MRS_info ?rel1 ?karwA ?mrsCon1 ?lbl1 ?argv_0 $?vars)
(MRS_info ?rel2 ?karak ?mrsCon2 ?lbl2 ?argn_0 $?varss)
(test (eq (sub-string 1 1 (str-cat ?prep)) (sub-string 1 1 (str-cat ?karak))))
(test (eq (sub-string (- (str-length ?endsWith_p) 1) (str-length ?endsWith_p) ?endsWith_p) "_p"))
;(test (neq (str-index "_n_" ?mrsCon2)FALSE))
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
?f1<-(MRS_info id-MRS_concept-LBL-ARG0-RSTR-BODY ?idd udef_q ?lbll ?argg ?rstr ?body)
(MRS_info ?rel1 ?id1 ?name ?lbl ?arg0 $?var)
(MRS_info ?rel2 ?id2 ?name2 ?lbl1 ?arg00 $?varss)
(not (modified_disjunct ?id))
(test (eq  (+ ?id1 510) ?idd))
=>
(retract ?f ?f1)
(assert (modified_disjunct ?id))
(assert (MRS_info id-MRS_concept-LBL-ARG0-L_INDEX-R_INDEX ?id _or_c ?l ?a0 ?arg0 ?arg00))
(printout ?*rstr-fp*  "(MRS_info id-MRS_concept-LBL-ARG0-L_INDEX-R_INDEX "?id" _or_c "?l" "?a0" "?arg0" "?arg00")"crlf)
(printout ?*rstr-dbug* "(rule-rel-values disjunct  id-MRS_concept-LBL-ARG0-L_INDEX-R_INDEX "?id" _or_c "?l" "?a0" "?arg0" "?arg00")"crlf)
(printout ?*rstr-dbug* "(rule-rel-values disjunct  disjunct_ARG0 "?id" "?a0")"crlf)
(printout ?*rstr-fp* "(MRS_info id-MRS_concept-LBL-ARG0-RSTR-BODY "?idd" udef_q "?lbll" "?a0" "?rstr" "?body")"crlf)
(printout ?*rstr-dbug* "(rule-rel-values disjunct  id-MRS_concept-LBL-ARG0-RSTR-BODY "?idd" udef_q "?lbll" "?a0" "?rstr" "?body")"crlf)
)

;Rule for binding _or_c arg0 value with the arg2 value of the verb when it has k2 relation.
;I like tea or coffee. 
(defrule disjunct-bind-ARG2
(declare (salience 100))
(rel_name-ids	k2	?kri	?id1)
(construction-ids	disjunct	?id1 ?id2)
?f<-(MRS_info ?rel ?verb ?mrsCon ?lbl ?arg0 ?arg1 ?arg2 $?v)
(MRS_info id-MRS_concept-LBL-ARG0-L_INDEX-R_INDEX ?id _or_c ?lbll ?arg00 ?l ?r)
(test (eq  (+ ?id1 500) ?id))
(test (neq (str-index _v_ ?mrsCon) FALSE))
=>
(printout ?*rstr-fp* "(MRS_info "?rel" "?verb" "?mrsCon" "?lbl" "?arg0" "?arg1" "?arg00" "(implode$ (create$ $?v)) ")"crlf)
(printout ?*rstr-dbug* "(rule-rel-values disjunct-bind-ARG2 "?rel" "?verb" "?mrsCon" "?lbl" "?arg0" "?arg1" "?arg00" "(implode$ (create$ $?v)) ")"crlf)
)

;Rule for no binding arg0 with the ltop h0 when it has k1s relation. 
;Rule for binding arg0 of _or_c with the ltop h0 when it is disjunct relation.
;I like tea or coffee.
(defrule samAnAXi-LTOP-disjunct-pred
(declare (salience 1000))
(id-concept_label       ?v   hE_1|WA_1)
(rel_name-ids   k1s        ?v  ?k1s)
(construction-ids	disjunct  ?k1s $?k1ses)
(MRS_info ?rel ?k1sor _or_c ?lbl ?arg0 $?vars)
(MRS_info ?rel1 ?k1s ?mrsCon $?var)
(test (eq  (+ ?k1s 500) ?k1sor))
(test (neq (str-index _a_ ?mrsCon) FALSE))
=>
(assert (LTOP_value_geneated_4_disjunct_construction))
    (printout ?*rstr-fp* "(LTOP-INDEX h0 "?arg0 ")" crlf)
    (printout ?*rstr-dbug* "(rule-rel-values samAnAXi-LTOP-disjunct-pred LTOP-INDEX h0 "?arg0 ")"crlf)
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
;(retract ?f)
(assert (modified_disjunct ?id))
(assert (or_LBL_ARG0 ?id ?l ?a0 ))
(printout ?*rstr-fp*  "(MRS_info id-MRS_concept-LBL-ARG0-L_INDEX-R_INDEX-L_HNDL-R_HNDL "?id" _or_c "?l" "?a0" "?arg0" "?arg00" "?lbl" "?lbl1")"crlf)
(printout ?*rstr-dbug* "(rule-rel-values disjunct-pred  id-MRS_concept-LBL-ARG0-L_INDEX-R_INDEX-L_HNDL-R_HNDL "?id" _or_c "?l" "?a0" "?arg0" "?arg00" "?lbl" "?lbl1")"crlf)
(printout ?*rstr-dbug* "(rule-rel-values disjunct-pred  or_LBL_ARG0 "?id" "?l" "?a0")"crlf)
)

;Rule for binding arg1 of the disjunct entries with the arg0 of the karwa.
;#rAma acCA hE yA burA?
(defrule samAnAXi-disjunct
(declare (salience 1000))
(rel_name-ids   k1	?non-adj ?k1) 
(rel_name-ids	k1s	?non-adj ?adj)
(construction-ids	disjunct	$?vv ?adj $?vvv)
?f<-(MRS_info ?rel_name ?adj ?mrsCon ?lbl ?arg0 ?arg1 $?v)
(MRS_info ?rel1 ?k1 ?mrsCon1 ?lbl1 ?nonadjarg_0 $?vars)
(test (neq (str-index _a_ ?mrsCon) FALSE))
(test (neq ?arg1 ?nonadjarg_0))
(not (modified_samAnAXi ?nonadjarg_0))
=>
(retract ?f)
;(assert (modified_samAnAXi ?nonadjarg_0))
(assert (MRS_info  ?rel_name ?adj ?mrsCon ?lbl ?arg0 ?nonadjarg_0 $?v))
(printout ?*rstr-dbug* "(rule-rel-values samAnAXi-disjunct "?rel_name " " ?adj " " ?mrsCon " " ?lbl " " ?nonadjarg_0 ""(implode$ (create$ $?v))")"crlf)
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
(sentence_type  yn_interrogative)
(MRS_info id-MRS_concept-LBL-ARG0-L_INDEX-R_INDEX-L_HNDL-R_HNDL ?or _or_c ?l ?a0 ?li ?ri ?lh ?rh)
(H_TAM-E_TAM-Perfective_Aspect-Progressive_Aspect-Tense-Type  ?tam ?e_tam ?perf ?prog ?tense ?)
=>
(printout ?*rstr-fp* "(id-SF-TENSE-MOOD-PROG-PERF "?or " ques pres indicative - - )"crlf)
(printout ?*rstr-dbug* "(rule-rel-values or-tam id-SF-TENSE-MOOD-PROG-PERF "?or" ques pres indicative - - )"crlf)
)

;Rule for binding _near_p with the 
;The car is near the house.
(defrule near-binding
(rel_name-ids	k1	?verb	?karwa)
(rel_name-ids	rdl	?near	?k7p)
(rel_name-ids	k7p	?verb	?near)
?f<-(MRS_info id-MRS_concept-LBL-ARG0-ARG1-ARG2 ?near _near_p ?l ?a0 ?a1 ?a2)
(MRS_info id-MRS_concept-LBL-ARG0 ?karwa ?mrscon ?ln ?na0)
(MRS_info ?relll ?k7p ?mrsCon ?lbl ?aa0 $?vv) ;The cart is near the temple.
=>
(printout ?*rstr-fp* "(MRS_info id-MRS_concept-LBL-ARG0-ARG1-ARG2 "?near" _near_p " ?l" "?a0" "?na0" "?aa0")"crlf)
(printout ?*rstr-dbug* "(rule-rel-values near_binding id-MRS_concept-LBL-ARG0-ARG1-ARG2 "?near" _near_p " ?l" "?a0" "?na0" "?aa0")"crlf)
)

;Rule for creating TAM for _near_p
;The car is near the house.
(defrule near-tam
(id-concept_label	?near	pAsa_2)
(MRS_info id-MRS_concept-LBL-ARG0-ARG1-ARG2 ?near _near_p ?l ?a0 ?a1 ?a2)
(H_TAM-E_TAM-Perfective_Aspect-Progressive_Aspect-Tense-Type  ?tam ?e_tam ?perf ?prog ?tense ?)
=>
(printout ?*rstr-fp* "(id-SF-TENSE-MOOD-PROG-PERF "?near " prop pres indicative - - )"crlf)
(printout ?*rstr-dbug* "(rule-rel-values near-tam id-SF-TENSE-MOOD-PROG-PERF "?near" prop pres indicative - - )"crlf)
)


;Rule for binding _from_p_dir with kriya and place_n. The label of _from_p_dir will be as kriya lbl, arg1 of this will be place_n arg0.
;Where did Rama come from?
(defrule _from_p_dir
(id-concept_label ?id kim)
(rel_name-ids	?relll	?kri	?id)
(sentence_type  interrogative)
?f<-(MRS_info id-MRS_concept-LBL-ARG0-ARG1-ARG2 ?from ?prep ?l ?a0 ?a1 ?a2)
(MRS_info ?rel ?kri ?mrscon ?ln ?aoo ?a11 $?v)
(MRS_info id-MRS_concept-LBL-ARG0 ?id ?head ?lbl ?aa0)
(test (neq (str-index _v_ ?mrscon) FALSE))
(test (neq (str-index _p_ ?prep) FALSE))
=>
(retract ?f)
(printout ?*rstr-fp* "(MRS_info id-MRS_concept-LBL-ARG0-ARG1-ARG2 "?from" "?prep" " ?ln" "?a0" "?aoo" "?aa0")"crlf)
(printout ?*rstr-dbug* "(rule-rel-values _from_p_dir id-MRS_concept-LBL-ARG0-ARG1-ARG2 "?from" "?prep" " ?ln" "?a0" "?aa0" "?aa0")"crlf)
)

;Rule for creating binding with the predicate when the conjoined words are in the predicate position.
;Rama ate an apple and grapes.
(defrule conj-bind-final-two-pred
;(declare (salience 10000))
(rel_name-ids	k2	?verbid	?id1)
(construction-ids	conj	?id1 ?id2)
?f<-(MRS_info ?rel ?verbid ?mrsCon ?lbl ?arg0 ?arg1 ?arg2 $?v)
?f1<-(conj_ARG0 ?conj ?Pre_A0)
(test (eq  (+ ?id1 500) ?conj))
(test (neq (str-index _v_ ?mrsCon) FALSE))
=>
(printout ?*rstr-fp* "(MRS_info "?rel" "?verbid" "?mrsCon" "?lbl" "?arg0" "?arg1" "?Pre_A0" "(implode$ (create$ $?v)) ")"crlf)
(printout ?*rstr-dbug* "(rule-rel-values conj-bind-final-two-pred "?rel" "?verbid" "?mrsCon" "?lbl" "?arg0" "?arg0" "?Pre_A0"	 "(implode$ (create$ $?v)) ")"crlf)
)

;Rule for generating the year number in the CARG value.
;She was born in 1999.
(defrule yoc_carg_number
(id-concept_label	?numid	?num)
(id-yoc	?numid	yes)
(rel_name-ids	k7t	?kri	?numid)
?f<-(MRS_info id-MRS_concept-LBL-ARG0-CARG ?numid yofc ?lbl ?arg0 ?carg)
=>
(printout ?*rstr-fp* "(MRS_info id-MRS_concept-LBL-ARG0-CARG "?numid" yofc " ?lbl" "?arg0" "?num")"crlf)
(printout ?*rstr-dbug* "(rule-rel-values yoc_carg_number id-MRS_concept-LBL-ARG0-CARG "?numid" yofc " ?lbl" "?arg0" "?num")"crlf)
)

;Rule for creating the binding with yoc, in_p_temp, and verb. 
;LBL of preposition with verb, arg2 of preposition with kriya arg0, arg1 of preposition with arg0 of verb.
;I will come in 1999. Rama has to wake up in the morning. 
(defrule in_p_temp_verb
(rel_name-ids	k7t	?kriya	?numid)
(MRS_info ?rellll ?numid ?hinconceptt ?lbl ?argo $?v)
?f<-(MRS_info id-MRS_concept-LBL-ARG0-ARG1-ARG2 ?prep ?mrscon ?l ?a0 ?a1 ?a2)
(MRS_info ?rel ?kriya ?hinkri ?lbll ?arg00 ?arg11 $?vv)
(test (neq (str-index "_p_temp"  ?mrscon) FALSE)) 
=>
(retract ?f)
(printout ?*rstr-fp* "(MRS_info id-MRS_concept-LBL-ARG0-ARG1-ARG2 "?prep" "?mrscon" " ?lbll" "?a0" "?arg00" "?argo" )"crlf)
(printout ?*rstr-dbug* "(rule-rel-values in_p_temp_Verb id-MRS_concept-LBL-ARG0-ARG1-ARG2 "?prep" "?mrscon " " ?lbll" "?a0" "?arg00" "?argo")"crlf)
)


;Rule for changing lbl of preposition with lbl of verb, arg1 of the preposition with arg0 of verb, arg2 of preposition with arg0 of noun. 
;The train came after the sunrise.
(defrule rkl
(rel_name-ids	rkl	?st	?time)
(rel_name-ids	k7t	?kriya	?st)
(MRS_info id-MRS_concept-LBL-ARG0 ?time ?mrscc ?lb ?argo)
?f<-(MRS_info id-MRS_concept-LBL-ARG0-ARG1-ARG2 ?st ?mrscon ?l ?a0 ?a1 ?a2)
(MRS_info ?rel ?kriya ?hinkri ?lbll ?arg00 $?v)
(test (neq (str-index "_p"  ?mrscon) FALSE)) 
=>
;(retract ?f)
(printout ?*rstr-fp* "(MRS_info id-MRS_concept-LBL-ARG0-ARG1-ARG2 "?st" "?mrscon" " ?lbll" "?a0" "?arg00" "?argo" )"crlf)
(printout ?*rstr-dbug* "(rule-rel-values rkl id-MRS_concept-LBL-ARG0-ARG1-ARG2 "?st" "?mrscon " " ?lbll" "?a0" "?arg00" "?argo")"crlf)
)

;Rule for creating the binding with preposition _for_p with the verb lbl and arg0. 
;Why does Rama eat food?
(defrule kim_why
(id-concept_label	?kim	kim)
(rel_name-ids	rh	?kri	?kim)
(sentence_type  interrogative)
?f1<-(MRS_info ?rel1 ?prep ?mrsconn ?lblll ?arg00 ?arg11 ?arg22)
(MRS_info ?rel ?kri ?mrscon ?l ?a0 ?a1 ?a2 $?v)
(MRS_info id-MRS_concept-LBL-ARG0 ?kim reason ?lbl1 ?arg01)
(test (neq (str-index "_p"  ?mrsconn) FALSE)) 
(test (neq (str-index "_v_"  ?mrscon) FALSE)) 
=>
(retract ?f1)
(printout ?*rstr-fp* "(MRS_info "?rel1" "?prep" "?mrsconn" "?l" "?arg00" " ?a0 " " ?arg01 ")"crlf)
(printout ?*rstr-dbug* "(rule-rel-values kim_why "?rel1" "?prep" "?mrsconn" "?l" "?arg00" " ?a0 " " ?arg01 ")"crlf)
)

;Rule for binding ms_n_1 with the udef_q and compound for the sentence ; Ms. Rajini admitted her son and her daughter in the Kashi's largest school in Banaras.

(defrule _ms_n_1
(declare (salience 1000))
(id-respect  ?id  yes)
(rel_name-ids ?rel ?idd ?id)
(id-female	?id1	yes)
(not(id-concept_label	?id 	addressee))
?f<-(MRS_info id-MRS_concept-LBL-ARG0-RSTR-BODY ?udef udef_q ?lbl ?arg0 ?rstr ?body)
?f1<-(MRS_info id-MRS_concept-LBL-ARG0-ARG1-ARG2 ?comp compound ?l ?a0 ?a1 ?a2)
(MRS_info id-MRS_concept-LBL-ARG0 ?msn _ms_n_1 ?lb ?ar0)
(MRS_info id-MRS_concept-LBL-ARG0-CARG ?name named ?lbb ?argg ?v)
(test (eq  (+ ?name 10) ?udef))
(test (eq  (+ ?name 2) ?comp))
(test (eq  (+ ?name 5) ?msn))
=>
(retract ?f )
(printout ?*rstr-fp* "(MRS_info id-MRS_concept-LBL-ARG0-RSTR-BODY "?udef" udef_q " ?lbl" "?ar0" "?rstr" "?body" )"crlf)
(printout ?*rstr-dbug* "(rule-rel-values _ms_n_1 id-MRS_concept-LBL-ARG0-RSTR-BODY "?udef" udef_q " ?lbl" "?ar0" "?rstr" "?body" )"crlf)
(printout ?*rstr-fp* "(MRS_info id-MRS_concept-LBL-ARG0-ARG1-ARG2 "?comp" compound " ?lbb" "?a0" "?argg" "?ar0" )"crlf)
(printout ?*rstr-dbug* "(rule-rel-values _ms_n_1 id-MRS_concept-LBL-ARG0-ARG1-ARG2 "?comp" compound " ?lbb" "?a0" "?argg" "?ar0" )"crlf)
)

;Rule for creating binding with the timed entity and location preposition along with noun. 
(defrule prep-time
(rel_name-ids	k7t	?kriya	?timeentity)
(rel_name-ids	k7p	?kriya	?noun)
?f<-(MRS_info id-MRS_concept-LBL-ARG0-ARG1-ARG2 ?prep ?preposition ?lbl ?arg0 ?arg1 ?arg2)
(MRS_info id-MRS_concept-LBL-ARG0 ?noun ?mrscon ?lb ?arg)
(MRS_info id-MRS_concept-LBL-ARG0-CARG ?timeentity ?time ?lbll ?arg00 ?carg)
(test (eq  (+ ?timeentity 1) ?prep))
(test (neq (str-index "_p"  ?preposition) FALSE))
=>
(retract ?f)
(printout ?*rstr-fp* "(MRS_info id-MRS_concept-LBL-ARG0-ARG1-ARG2 "?prep" "?preposition" "?lb" "?arg0" "?arg" "?arg00")"crlf)
(printout ?*rstr-dbug* "(rule-rel-values prep-time id-MRS_concept-LBL-ARG0-ARG1-ARG2 "?prep" "?preposition" "?lb" "?arg0" "?arg" "?arg00")"crlf)
)	


;Rule for creating binding for when conjunction is in k2 position. The ARG2 of verb will replace with the ARG0 of _and_c. 
(defrule conjk2
(declare (salience 10000))
(construction-ids	conj	?id1 ?id2)
(rel_name-ids	k2	?verb	?id1)
?f<-(MRS_info ?rel ?verb ?mrscon ?lbl ?arg0 ?arg1 ?arg2 $?v)
(MRS_info id-MRS_concept-LBL-ARG0-L_INDEX-R_INDEX ?iddd _and_c ?lbll ?arg00 ?l ?r)
(test (neq (str-index _v_ ?mrscon) FALSE))
(test (neq ?arg2 ?arg00))
=>
(retract ?f)
(assert (MRS_info ?rel ?verb ?mrscon ?lbl ?arg0 ?arg1 ?arg00 ) )
(printout ?*rstr-dbug* "(rule-rel-values conjk2 "?rel" "?verb" "?mrscon" "?lbl" "?arg0" "?arg1" "?arg00" "(implode$ (create$ $?v)) " )"crlf)
)


;Rule for binding _mister_n_1 with the udef_q and compound for the sentence ;Mr. Sanju came. 
(defrule _mister_n_1
(declare (salience 1000))
(id-respect  ?id  yes)
(rel_name-ids ?rel ?idd ?id)
(id-male	?id1	yes)
(not(id-concept_label	?id 	addressee))
?f<-(MRS_info id-MRS_concept-LBL-ARG0-RSTR-BODY ?udef udef_q ?lbl ?arg0 ?rstr ?body)
?f1<-(MRS_info id-MRS_concept-LBL-ARG0-ARG1-ARG2 ?comp compound ?l ?a0 ?a1 ?a2)
(MRS_info id-MRS_concept-LBL-ARG0 ?msn _mister_n_1 ?lb ?ar0)
(MRS_info id-MRS_concept-LBL-ARG0-CARG ?name named ?lbb ?argg ?v)
(test (eq  (+ ?name 10) ?udef))
(test (eq  (+ ?name 2) ?comp))
(test (eq  (+ ?name 5) ?msn))
=>
(retract ?f )
(printout ?*rstr-fp* "(MRS_info id-MRS_concept-LBL-ARG0-RSTR-BODY "?udef" udef_q " ?lbl" "?ar0" "?rstr" "?body" )"crlf)
(printout ?*rstr-dbug* "(rule-rel-values _mister_n_1 id-MRS_concept-LBL-ARG0-RSTR-BODY "?udef" udef_q " ?lbl" "?ar0" "?rstr" "?body" )"crlf)
(printout ?*rstr-fp* "(MRS_info id-MRS_concept-LBL-ARG0-ARG1-ARG2 "?comp" compound " ?lbb" "?a0" "?argg" "?ar0" )"crlf)
(printout ?*rstr-dbug* "(rule-rel-values _mister_n_1 id-MRS_concept-LBL-ARG0-ARG1-ARG2 "?comp" compound " ?lbb" "?a0" "?argg" "?ar0" )"crlf)
)


;Creating of binding with udef_q and season abstract predicate. 
;The snow falls in winter.
(defrule season_udef_q
(id-concept_label	?id	?cl)
(id-season	?id	yes)
?f1<-(MRS_info id-MRS_concept-LBL-ARG0-RSTR-BODY ?udef udef_q ?lbl ?arg0 ?rstr ?body)
?f<-(MRS_info id-MRS_concept-LBL-ARG0-CARG ?id season ?l ?a0 ?num)
(test (eq  (+ ?id 10) ?udef))
=>
(retract ?f1)
(printout ?*rstr-fp* "(MRS_info id-MRS_concept-LBL-ARG0-RSTR-BODY "?udef" udef_q " ?lbl" "?a0" "?rstr" "?body" )"crlf)
(printout ?*rstr-dbug* "(rule-rel-values season_udef_q id-MRS_concept-LBL-ARG0-RSTR-BODY "?udef" udef_q " ?lbl" "?a0" "?rstr" "?body" )"crlf)
)

;Rule for changing season CARG value to season name. 
;The snow falls in winter.
(defrule season_name
(declare (salience 1000))
(id-concept_label	?id	?cl)
(cl-cEn-MRSc ?cl ?english season)
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

;Rule for generating LTOP with INDEX value for a sentence without a verb and having kim word with relation k5 and animacy in the semantic category. 
;Who is Rama afraid of? 
(defrule k5_anim_kim_LTOP
(declare (salience 100))
(id-concept_label ?id kim)
(rel_name-ids	k5	?kri	?id)
(sentence_type  interrogative)
(MRS_info ?rell ?kri ?mrscon ?l ?a0 $?v)
(test (eq (str-index _v_ ?mrscon) FALSE))
=>
(printout ?*rstr-fp* "(LTOP-INDEX  h0  "?a0 ")" crlf)
(printout ?*rstr-dbug* "(rule-rel-values k5_anim_kim_LTOP LTOP-INDEX  h0  "?a0 ")"crlf)
)

;Rule for binding k5+anim+kim relation concept with kriya and karwa.
;#राम किससे डरता है
(defrule k5_anim_kim
(id-concept_label ?id kim)
(rel_name-ids	k5	?kri	?id)
(rel_name-ids	?rel	?kri	?karwa)
(sentence_type  interrogative)
(id-anim	?id	yes)
?f<-(MRS_info ?rel1 ?kri ?mrscc ?lb ?argo ?arg1 ?arg2 $?v1)
(MRS_info ?rel2 ?karwa ?mrscon ?l ?a0 $?v)
(MRS_info ?rel3 ?id ?hinkri ?lbll ?arg00 $?va)
=>
(retract ?f)
(printout ?*rstr-fp* "(MRS_info "?rel1" "?kri" "?mrscc" " ?lb" "?argo" "?a0" "?arg00" "(implode$ (create$ $?v1))")"crlf)
(printout ?*rstr-dbug* "(rule-rel-values k5_anim_kim "?rel1" "?kri" "?mrscc" " ?lb" "?argo" "?a0" "?arg00" "(implode$ (create$ $?v1))" )"crlf)
)

;Rule for changing ARG2 value of rpk verb with the ARG0 of the head of r6 relation. 
;Having been listening to his word, the lion laughed.
(defrule r6-rpk-arg2
(rel_name-ids	r6	?noun	?karwa)
(rel_name-ids	k2	?kriya	?noun)
(rel_name-ids	rpk	?kriya	?rpk)
?f<-(MRS_info ?rel1 ?rpk ?mrscc ?lb ?argo ?arg1 ?arg2 $?v1)
(MRS_info ?rel2 ?noun ?mrscon ?l ?a0 $?v)
=>
(retract ?f)
(printout ?*rstr-fp* "(MRS_info "?rel1" "?rpk" "?mrscc" " ?lb" "?argo" "?arg1" "?a0" "(implode$ (create$ $?v1))")"crlf)
(printout ?*rstr-dbug* "(rule-rel-values k5_anim_kim "?rel1" "?rpk" "?mrscc" " ?lb" "?argo" "?arg1" "?a0" "(implode$ (create$ $?v1))" )"crlf)
)


;Rule for binding rbks nonfinite verb with the karwa. 
;The fruit eaten by Rama was sweet.
(defrule karwa-rbks
(rel_name-ids	rbks	?noun	?nonfinite)
(MRS_info ?rel ?noun ?mrscon ?lbl ?arg0)
?f<-(MRS_info ?rel1 ?nonfinite ?verbconcept ?lbl1 ?arg01 ?arg1 ?arg2 $?v)
=>
(assert (MRS_info ?rel1 ?nonfinite ?verbconcept ?lbl ?arg01 ?arg1 ?arg0))
(printout ?*rstr-dbug* "(rule-rel-values karwa-rbks "?rel1" "?nonfinite" "?verbconcept" " ?lbl" "?arg01" "?arg1" "?arg0" "(implode$ (create$ $?v))" )"crlf)
)

;Rule for creating binding with kriya ARG2 value with ARG0 of rask2 relation. 
;Rama ate banana also with milk.
(defrule rask2
(declare (salience 100))
(rel_name-ids	rask2	?kriya	?rask2)
(MRS_info ?rel ?rask2 ?concept ?lbl ?arg0 $?v)
?f<-(MRS_info ?rel1 ?kriya ?mrsconcept ?lbl1 ?arg00 ?arg1 ?arg2 $?va)
=>
(assert (MRS_info ?rel1 ?kriya ?mrsconcept  ?lbl1 ?arg00 ?arg1 ?arg0))
(printout ?*rstr-dbug* "(rule-rel-values rask2 "?rel1" "?kriya" "?mrsconcept" " ?lbl1" "?arg00" "?arg1" "?arg0" "(implode$ (create$ $?va))" )"crlf)
)

(defrule prep-noun-dir
(declare (salience 10000))
(rel_name-ids ?relp ?kriyA ?karak)
?f<-(MRS_info ?rel_name ?prep ?endsWith_p ?lbl ?arg0 ?arg1 $?v)
(MRS_info ?rel1 ?kriyA ?mrsCon1 ?lbl1 ?argv_0 $?vars)
(MRS_info ?rel2 ?karak ?mrsCon2 ?lbl2 ?argn_0 $?varss)
(test (neq (str-index "_p_dir" ?endsWith_p)FALSE))
=>
(retract ?f)
(printout ?*rstr-fp* "(MRS_info  " ?rel_name " " ?prep " " ?endsWith_p " " ?lbl1 " " ?arg0 " " ?argv_0 " " ?argn_0 ")"crlf)
(printout ?*rstr-dbug* "(rule-rel-values prep-noun-dir "?rel_name " " ?prep " " ?endsWith_p " " ?lbl1" " ?arg0 " " ?argv_0 " " ?argn_0 ")"crlf)
)

;Rule for generating TAM for rblsk verb
(defrule rblsk
?f<-(rel_name-ids	rblsk	?id	?kri)
=>
(retract ?f)
(printout ?*rstr-fp* "(id-SF-TENSE-MOOD-PROG-PERF "?kri " prop pres indicative - - )"crlf)
(printout ?*rstr-dbug* "(rule-rel-values rpk id-SF-TENSE-MOOD-PROG-PERF "?kri " prop pres indicative - - )"crlf)
)

;rule for binding ARG1 and ARG2 of the preposition when "put" verb exists. 
;Abrams put Browne in the garden.
(defrule prep-verb
(rel_name-ids ?relp ?kriyA ?karak)
?f<-(MRS_info ?rel_name ?prep ?endsWith_p ?lbl ?arg0 ?arg1 $?v)
(MRS_info id-MRS_concept-LBL-ARG0-ARG1-ARG2-ARG3 ?kriyA ?mrsCon1 ?lbl1 ?argv_0 ?a1 ?arg2 ?arg3)
(MRS_info ?rel2 ?karak ?mrsCon2 ?lbl2 ?argn_0 $?varss)
(test (eq (sub-string 1 1 (str-cat ?prep)) (sub-string 1 1 (str-cat ?karak))))
(test (eq (sub-string (- (str-length ?endsWith_p) 1) (str-length ?endsWith_p) ?endsWith_p) "_p"))
(test (or (neq (str-index "_n_" ?mrsCon2)FALSE) (eq ?mrsCon2 nominalization) ))
(id-concept_label       ?kriyA  raKa_8)
=>
(retract ?f)
(printout ?*rstr-fp* "(MRS_info  " ?rel_name " " ?prep " " ?endsWith_p " " ?lbl " " ?arg0 " " ?arg2 " " ?argn_0 ")"crlf)
(printout ?*rstr-dbug* "(rule-rel-values prep-verb "?rel_name " " ?prep " " ?endsWith_p " " ?lbl" " ?arg0 " " ?arg2 " " ?argn_0 ")"crlf)
)

;Rule for creating binding with k2 with "with" preposition when rask2 relation exists. 
;Rama ate banana also with milk.
(defrule rask2-k2-with
;(declare (salience 100))
(rel_name-ids	k2	?kriya	?k2)
(rel_name-ids	rask2	?kriya	?rask2)
(MRS_info ?rel ?k2 ?concept ?lbl ?arg0 $?v)
(MRS_info ?rel3 ?rask2 ?mrscon1 ?lbl3 ?arg000 $?var)
?f<-(MRS_info ?rel1 ?preposition ?mrsconcept ?lbl1 ?arg00 ?arg1 ?arg2)
(test (eq  (+ ?rask2 1) ?preposition))
(test (eq (str-index _p_ ?mrsconcept) FALSE))
=>
(retract ?f)
;(assert (which_bind_notrequired_rask2 ?preposition))
(printout ?*rstr-fp* "(MRS_info "?rel1" "?preposition" "?mrsconcept" " ?lbl3" "?arg00" "?arg000" "?arg0")"crlf)
;(assert (MRS_info ?rel1 ?preposition ?mrsconcept ?lbl3 ?arg00 ?arg000 ?arg0))
(printout ?*rstr-dbug* "(rule-rel-values rask2-k2-with "?rel1" "?preposition" "?mrsconcept" " ?lbl3" "?arg00" "?arg000" "?arg0" )"crlf)
)

(defrule rask2-prep-also
(declare (salience 10))
(rel_name-ids	rask2	?kriya	?rask2)
(id-BI_1	?rask2	yes)
?f<-(MRS_info ?rel ?rask22 _also_a_1 ?lbll ?arg000 ?arg11)
(MRS_info ?rel1 ?preposition ?mrsconcept ?lbl1 ?arg00 ?arg1 ?arg2)
(MRS_info ?relllll ?rask2 ?concept ?lbl ?arg0 $?v)
(test (eq  (+ ?rask2 1) ?preposition))
(test (eq  (+ ?rask2 1000) ?rask22))
(test (eq (str-index _p_ ?mrsconcept) FALSE))
=>
(retract ?f)
(printout ?*rstr-fp* "(MRS_info "?rel" "?rask22" _also_a_1 " ?lbl" "?arg000" "?arg00")"crlf)
(printout ?*rstr-dbug* "(rule-rel-values rask2-prep-also "?rel" "?rask22" _also_a_1 " ?lbl" "?arg000" "?arg00" )"crlf)
)

;Rule for creating binding with LBL of card with the generic_Entity lbl and ARG1 of card with ARG0 of generic_Entity and ARG0 of udef_q with ARG0 of generic_Entity and ARG1 of bark with generic_Entity.
;Changing CARG value of card into digit.
;Three barked.
(defrule generic_Entity
(declare (salience 1000))
(id-concept_label	?id1	?number)
(id-numex	?id1	yes)
(rel_name-ids	k1	?kri	?id1)
(numeric ?number ?val)
(not (rel_name-ids	card	?kri	?id1))
?f<-(MRS_info id-MRS_concept-LBL-ARG0-RSTR-BODY ?id udef_q ?lbl ?arg0 ?rstr ?body)
(MRS_info id-MRS_concept-LBL-ARG0 ?id1 generic_entity ?lbll ?arg00)
?f1<-(MRS_info id-MRS_concept-LBL-ARG0-ARG1-CARG ?id1 ?card ?lbl2 ?arg02 ?arg021 ?carg)
(test (eq  (+ ?id1 10) ?id))
=>
(retract ?f ?f1)
(printout ?*rstr-fp* "(MRS_info id-MRS_concept-LBL-ARG0-RSTR-BODY "?id" udef_q "?lbl" "?arg00" "?rstr" "?body" )"crlf)
(printout ?*rstr-dbug* "(rule-rel-values generic_Entity id-MRS_concept-LBL-ARG0-RSTR-BODY "?id" udef_q "?lbl" "?arg00" "?rstr" "?body")"crlf)
(printout ?*rstr-fp* "(MRS_info id-MRS_concept-LBL-ARG0-ARG1-CARG "?id1" "?card" "?lbll" "?arg02" "?arg00" "?val" )"crlf)
(printout ?*rstr-dbug* "(rule-rel-values generic_Entity id-MRS_concept-LBL-ARG0-ARG1-CARG "?id1" "?card" "?lbll" "?arg02" "?arg00" "?val")"crlf)
)

;Rule for binding with the nominalized verb with the nominalization and the udef_q with the nominalization.
;#billi kA pICA karanA purAnA hE. 
(defrule nominalization
(declare (salience 100))
(id-concept_label	?nominalization	?mrsverb)
(rel_name-ids	k1	?mainverb	?nominalization)
?f<-(MRS_info id-MRS_concept-LBL-ARG0-ARG1 ?nominalized nominalization ?lbl ?arg0 ?arg1)
(MRS_info id-MRS_concept-LBL-ARG0-ARG1-ARG2 ?nominalization ?mrscon ?lbl1 ?arg01 ?arg011 ?arg02)
?f1<-(MRS_info id-MRS_concept-LBL-ARG0-RSTR-BODY ?udef udef_q ?lblll ?arg000 ?rstr ?body)
=>
(retract ?f1)
(printout ?*rstr-fp* "(MRS_info id-MRS_concept-LBL-ARG0-ARG1 "?nominalized" nominalization "?lbl" "?arg0" "?lbl1")"crlf)
(printout ?*rstr-dbug* "(rule-rel-values nominalization id-MRS_concept-LBL-ARG0-ARG1 "?nominalized" nominalization "?lbl" "?arg0" "?lbl1")"crlf)
(printout ?*rstr-fp* "(MRS_info id-MRS_concept-LBL-ARG0-RSTR-BODY "?udef" udef_q "?lblll" "?arg0" "?rstr" "?body")"crlf)
(printout ?*rstr-dbug* "(rule-rel-values nominalization id-MRS_concept-LBL-ARG0-RSTR-BODY "?udef" udef_q "?lblll" "?arg0" "?rstr" "?body")"crlf)
)

;Rule for binding with the nominalization with the noun. 
;#billi kA pICA karanA purAnA hE. 
(defrule nominalized
(rel_name-ids	k1	?mainverb	?nominalization)
(rel_name-ids	?rel	?nominalization	?noun)
(MRS_info id-MRS_concept-LBL-ARG0-ARG1 ?nominalized nominalization ?lbl ?arg0 ?arg1)
?f<-(MRS_info id-MRS_concept-LBL-ARG0-ARG1-ARG2 ?nominalization ?mrscon ?lbl1 ?arg01 ?arg011 ?arg02)
(MRS_info id-MRS_concept-LBL-ARG0 ?noun ?nounmrs ?lblb ?arg0000)
=>
(retract ?f)
(printout ?*rstr-fp* "(MRS_info id-MRS_concept-LBL-ARG0-ARG1-ARG2 "?nominalization" "?mrscon" "?lbl1" "?arg01" "?arg011" "?arg0000")"crlf)
(printout ?*rstr-dbug* "(rule-rel-values nominalized id-MRS_concept-LBL-ARG0-ARG1-ARG2 "?nominalization" "?mrscon" "?lbl1" "?arg01" "?arg011" "?arg0000")"crlf)
)

;#billI kA pICA karanA purAnA hE. 
(defrule nominalized-adjective
(rel_name-ids	k1	?mainverb	?nominalization)
(rel_name-ids	k1s	?mainverb	?adjective)
(MRS_info id-MRS_concept-LBL-ARG0-ARG1 ?nominalized nominalization ?lbl ?arg0 ?arg1)
?f<-(MRS_info id-MRS_concept-LBL-ARG0-ARG1 ?adjective ?adj ?lblb ?arg0000 ?arg111)
(test (neq (str-index _a_ ?adj) FALSE))
=>
(retract ?f)
(printout ?*rstr-fp* "(MRS_info id-MRS_concept-LBL-ARG0-ARG1 "?adjective" "?adj" "?lblb" "?arg0000" "?arg0")"crlf)
(printout ?*rstr-dbug* "(rule-rel-values nominalized-adjective id-MRS_concept-LBL-ARG0-ARG1 "?adjective" "?adj" "?lblb" "?arg0000" "?arg0")"crlf)
)

;Rule for creating TAM for the nominalized verb.
;#billi kA pICA karanA purAnA hE. 
(defrule nominalization-tam
(declare (salience 100))
(rel_name-ids	k1	?mainverb	?nominalization)
(rel_name-ids	?rel	?nominalization	?noun)
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
(rel_name-ids samuccaya ?previousid	?verb)
?f<-(MRS_info id-MRS_concept-LBL-ARG0-L_INDEX-R_INDEX-L_HNDL-R_HNDL ?and _and_c ?lbl ?arg0 ?lindex ?rindex ?lhndl ?rhndl)
(MRS_info ?rel ?verb ?mrsss ?lblb ?arg00 $?v)
(test (eq  (+ ?verb 1000) ?and))
=>
(printout ?*rstr-fp* "(MRS_info id-MRS_concept-LBL-ARG0-L_INDEX-R_INDEX-L_HNDL-R_HNDL "?and" _and_c "?lbl" "?arg0" "?lindex" "?arg00" "?lhndl" "?rhndl")"crlf)
(printout ?*rstr-dbug* "(rule-rel-values samuccaya_and-bind-verb id-MRS_concept-LBL-ARG0-L_INDEX-R_INDEX-L_HNDL-R_HNDL "?and" _and_c "?lbl" "?arg0" "?lindex" "?arg00" "?lhndl" "?rhndl")"crlf)
)

;Rule for creating LTOP value with the _and_c arg0 value when samuccaya relation exists.
;And he is intelligent. #Ora vaha buxXimAna hE.
(defrule samuccaya-LTOP
(rel_name-ids samuccaya ?previousid	?verb)
?f<-(MRS_info id-MRS_concept-LBL-ARG0-L_INDEX-R_INDEX-L_HNDL-R_HNDL ?and _and_c ?lbl ?arg0 ?lindex ?rindex ?lhndl ?rhndl)
=>
(printout ?*rstr-fp* "(LTOP-INDEX h0 "?arg0 ")" crlf)
(printout ?*rstr-dbug* "(rule-rel-values samuccaya-LTOP LTOP-INDEX h0 "?arg0 ")"crlf)
)

;Rule for creating binding LTOP with the lbl of _and_c and R_HNDL value with the lbl of the adjective.
;And he is intelligent. #Ora vaha buxXimAna hE.
(defrule samuccaya_and-bind-copula
(id-concept_label	?verb	hE_1)
(rel_name-ids samuccaya ?previousid	?verb)
(rel_name-ids	k1s	?verb	?adj)
?f<-(MRS_info id-MRS_concept-LBL-ARG0-L_INDEX-R_INDEX-L_HNDL-R_HNDL ?and _and_c ?lbl ?arg0 ?lindex ?rindex ?lhndl ?rhndl)
(MRS_info ?rel ?adj ?mrsss ?lblb ?arg00 $?v)
(test (eq  (+ ?verb 1000) ?and))
=>
(printout ?*rstr-fp* "(MRS_info id-MRS_concept-LBL-ARG0-L_INDEX-R_INDEX-L_HNDL-R_HNDL "?and" _and_c "?lbl" "?arg0" "?lindex" "?arg00" "?lhndl" "?rhndl")"crlf)
(printout ?*rstr-dbug* "(rule-rel-values samuccaya_and-bind-copula id-MRS_concept-LBL-ARG0-L_INDEX-R_INDEX-L_HNDL-R_HNDL "?and" _and_c "?lbl" "?arg0" "?lindex" "?arg00" "?lhndl" "?rhndl")"crlf)
)

;Rule for creating the binding with anyawra _or_c with the verb of the sentence.
;Rule for changing _or_c R_INDEX with arg0 of the verb and R_HNDL with LBL of verb 
;Or he is intelligent. #yA vaha buxXimAna hE.
(defrule anyawra_or-bind-verb
(rel_name-ids anyawra ?previousid	?verb)
?f<-(MRS_info id-MRS_concept-LBL-ARG0-L_INDEX-R_INDEX-L_HNDL-R_HNDL ?or _or_c ?lbl ?arg0 ?lindex ?rindex ?lhndl ?rhndl)
(MRS_info ?rel ?verb ?mrsss ?lblb ?arg00 $?v)
(test (eq  (+ ?verb 1000) ?or))
=>
(printout ?*rstr-fp* "(MRS_info id-MRS_concept-LBL-ARG0-L_INDEX-R_INDEX-L_HNDL-R_HNDL "?or" _or_c "?lbl" "?arg0" "?lindex" "?arg00" "?lhndl" "?rhndl")"crlf)
(printout ?*rstr-dbug* "(rule-rel-values anyawra_or-bind-verb id-MRS_concept-LBL-ARG0-L_INDEX-R_INDEX-L_HNDL-R_HNDL "?or" _or_c "?lbl" "?arg0" "?lindex" "?arg00" "?lhndl" "?rhndl")"crlf)
)

;Rule for creating LTOP value with the _or_c arg0 value when anyawra relation exists.
;or He is intelligent. #yA vaha buxXimAna hE.
(defrule anyawra-LTOP
(rel_name-ids anyawra ?previousid	?verb)
?f<-(MRS_info id-MRS_concept-LBL-ARG0-L_INDEX-R_INDEX-L_HNDL-R_HNDL ?or _or_c ?lbl ?arg0 ?lindex ?rindex ?lhndl ?rhndl)
=>
(printout ?*rstr-fp* "(LTOP-INDEX h0 "?arg0 ")" crlf)
(printout ?*rstr-dbug* "(rule-rel-values anyawra-LTOP LTOP-INDEX h0 "?arg0 ")"crlf)
)

;Rule for creating binding LTOP with the lbl of _and_c and R_HNDL value with the lbl of the adjective.
;or He is intelligent. #yA vaha buxXimAna hE.
(defrule or_and-bind-copula
(id-concept_label	?verb	hE_1)
(rel_name-ids anyawra ?previousid	?verb)
(rel_name-ids	k1s	?verb	?adj)
?f<-(MRS_info id-MRS_concept-LBL-ARG0-L_INDEX-R_INDEX-L_HNDL-R_HNDL ?and _or_c ?lbl ?arg0 ?lindex ?rindex ?lhndl ?rhndl)
(MRS_info ?rel ?adj ?mrsss ?lblb ?arg00 $?v)
(test (eq  (+ ?verb 1000) ?and))
=>
(printout ?*rstr-fp* "(MRS_info id-MRS_concept-LBL-ARG0-L_INDEX-R_INDEX-L_HNDL-R_HNDL "?and" _or_c "?lbl" "?arg0" "?lindex" "?arg00" "?lhndl" "?rhndl")"crlf)
(printout ?*rstr-dbug* "(rule-rel-values or_and-bind-copula id-MRS_concept-LBL-ARG0-L_INDEX-R_INDEX-L_HNDL-R_HNDL "?and" _and_c "?lbl" "?arg0" "?lindex" "?arg00" "?lhndl" "?rhndl")"crlf)
)

;Rule for changing _but_c R_INDEX with arg0 of the verb and R_HNDL with LBL of verb
;Rule for creating the binding with viroXi _but_c with the verb of the sentence. 
;But he is intelligent. #kinwu vaha buxXimAna hE.
(defrule viroXi_but-bind-verb
(rel_name-ids viroXi ?previousid	?verb)
?f<-(MRS_info id-MRS_concept-LBL-ARG0-L_INDEX-R_INDEX-L_HNDL-R_HNDL ?but _but_c ?lbl ?arg0 ?lindex ?rindex ?lhndl ?rhndl)
(MRS_info ?rel ?verb ?mrsss ?lblb ?arg00 $?v)
(test (eq  (+ ?verb 1000) ?but))
=>
(printout ?*rstr-fp* "(MRS_info id-MRS_concept-LBL-ARG0-L_INDEX-R_INDEX-L_HNDL-R_HNDL "?but" _but_c "?lbl" "?arg0" "?lindex" "?arg00" "?lhndl" "?rhndl")"crlf)
(printout ?*rstr-dbug* "(rule-rel-values viroXi_but-bind-verb id-MRS_concept-LBL-ARG0-L_INDEX-R_INDEX-L_HNDL-R_HNDL "?but" _but_c "?lbl" "?arg0" "?lindex" "?arg00" "?lhndl" "?rhndl")"crlf)
)

;Rule for creating LTOP value with the _but_c arg0 value when viroXi relation exists.
;But he is intelligent. #kinwu vaha buxXimAna hE.
(defrule viroXi-LTOP
(rel_name-ids viroXi ?previousid	?verb)
?f<-(MRS_info id-MRS_concept-LBL-ARG0-L_INDEX-R_INDEX-L_HNDL-R_HNDL ?but _but_c ?lbl ?arg0 ?lindex ?rindex ?lhndl ?rhndl)
=>
(printout ?*rstr-fp* "(LTOP-INDEX h0 "?arg0 ")" crlf)
(printout ?*rstr-dbug* "(rule-rel-values viroXi-LTOP LTOP-INDEX h0 "?arg0 ")"crlf)
)


;Rule for creating binding LTOP with the lbl of _and_c and R_HNDL value with the lbl of the adjective.
;But he is intelligent. #kinwu vaha buxXimAna hE.
(defrule but_and-bind-copula
(id-concept_label	?verb	hE_1)
(rel_name-ids viroXi ?previousid	?verb)
(rel_name-ids	k1s	?verb	?adj)
?f<-(MRS_info id-MRS_concept-LBL-ARG0-L_INDEX-R_INDEX-L_HNDL-R_HNDL ?and _but_c ?lbl ?arg0 ?lindex ?rindex ?lhndl ?rhndl)
(MRS_info ?rel ?adj ?mrsss ?lblb ?arg00 $?v)
(test (eq  (+ ?verb 1000) ?and))
=>
(printout ?*rstr-fp* "(MRS_info id-MRS_concept-LBL-ARG0-L_INDEX-R_INDEX-L_HNDL-R_HNDL "?and" _but_c "?lbl" "?arg0" "?lindex" "?arg00" "?lhndl" "?rhndl")"crlf)
(printout ?*rstr-dbug* "(rule-rel-values but_and-bind-copula id-MRS_concept-LBL-ARG0-L_INDEX-R_INDEX-L_HNDL-R_HNDL "?and" _but_c "?lbl" "?arg0" "?lindex" "?arg00" "?lhndl" "?rhndl")"crlf)
)


;Rule for generating LTOP and INDEX values when kAryakAraNa relation exists. INDEX value will take the ARG0 of unknown. 
;Because, he has to go home. #kyoMki vo Gara jAnA hE.
(defrule kAryakAraNa-LTOP
(rel_name-ids kAryakAraNa ?previousid	?verb)
?f<-(MRS_info id-MRS_concept-LBL-ARG0-ARG ?verbb unknown ?id ?arg0 ?arg)
(test (eq  (+ ?verb 1) ?verbb))
=>
(printout ?*rstr-fp* "(LTOP-INDEX h0 "?arg0 ")" crlf)
(printout ?*rstr-dbug* "(rule-rel-values kAryakAraNa-LTOP LTOP-INDEX h0 "?arg0 ")"crlf)
)

;Rule for generating TAM for kAryakAraNa relation with the main verb. 
;Because he has to go home. kyoMki vo Gara jAnA hE.
(defrule kAryakAraNa-TAM
(rel_name-ids kAryakAraNa ?previousid	?verb)
(id-hin_concept-MRS_concept ?verb ?hin ?mrscon)
(test (neq (str-index _v_ ?mrscon) FALSE))
=>
(printout ?*rstr-fp* "(id-SF-TENSE-MOOD-PROG-PERF "?verb " prop-or-ques untensed indicative - - )"crlf)
(printout ?*rstr-dbug* "(rule-rel-values kAryakAraNa-TAM id-SF-TENSE-MOOD-PROG-PERF "?verb " prop-or-ques untensed indicative - - )"crlf)
)

;Rule for generating TAM for kAryakAraNa relation with the modal verb. 
;Because he has to go home. kyoMki vo Gara jAnA hE.
(defrule kAryakAraNa-TAM-modal
(rel_name-ids kAryakAraNa ?previousid	?verb)
(MRS_info id-MRS_concept-LBL-ARG0-ARG1 ?modal ?mrscon ?lbl ?arg0 ?arg1)
(test (neq (str-index _v_qmodal ?mrscon) FALSE))
(test (eq  (+ ?verb 100) ?modal))
=>
(printout ?*rstr-fp* "(id-SF-TENSE-MOOD-PROG-PERF "?modal " prop pres indicative - - )"crlf)
(printout ?*rstr-dbug* "(rule-rel-values kAryakAraNa-TAM-modal id-SF-TENSE-MOOD-PROG-PERF "?modal " prop pres indicative - - )"crlf)
)


;Rule for generating number in CARG value of the date of month (dofm). 
;My birthday is 23 September. 
(defrule dofm_carg_number
(id-concept_label	?numid	?num)
(id-dom	?numid	yes)
?f<-(MRS_info id-MRS_concept-LBL-ARG0-CARG ?numid dofm ?lbl ?arg0 ?carg)
=>
(printout ?*rstr-fp* "(MRS_info id-MRS_concept-LBL-ARG0-CARG "?numid" dofm " ?lbl" "?arg0" "?num")"crlf)
(printout ?*rstr-dbug* "(rule-rel-values yoc_carg_number id-MRS_concept-LBL-ARG0-CARG "?numid" dofm " ?lbl" "?arg0" "?num")"crlf)
)

(defrule date_of_month_uc
(id-dom	?id1	yes)
(id-moy	?id2	yes)
(rel_name-ids	r6	?id1	?id2)
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
(id-concept_label	?ct	 ?num)
(id-clocktime	?ct	yes)
(rel_name-ids	k7t	?kri	?ct)
(test (neq (str-index "+baje" ?num) FALSE))
?f<-(MRS_info id-MRS_concept-LBL-ARG0-CARG ?numid minute ?lbl ?arg0 ?carg)
(test (eq  (+ ?ct 1) ?numid))
=>
(printout ?*rstr-fp* "(MRS_info id-MRS_concept-LBL-ARG0-CARG "?numid" minute " ?lbl" "?arg0" "?num")"crlf)
(printout ?*rstr-dbug* "(rule-rel-values clock_time_carg id-MRS_concept-LBL-ARG0-CARG "?numid" minute " ?lbl" "?arg0" "?num")"crlf)
)

(defrule prep-verb-arg1-time
(rel_name-ids	k7t	?kriya	?time)
?f<-(MRS_info id-MRS_concept-LBL-ARG0-ARG1 ?time ?preposition  ?lbl ?arg0 ?arg1)
(MRS_info ?rel ?kriya ?verb ?lbl1 ?arg00 $?v)
(test (neq (str-index _p ?preposition) FALSE))
(test (neq (str-index _v_ ?verb) FALSE))
=>
(printout ?*rstr-fp* "(MRS_info id-MRS_concept-LBL-ARG0-ARG1 "?time" "?preposition" " ?lbl1" "?arg0" "?arg00")"crlf)
(printout ?*rstr-dbug* "(rule-rel-values prep-verb-arg1-time id-MRS_concept-LBL-ARG0-ARG1 "?time" "?preposition" " ?lbl1" "?arg0" "?arg00")"crlf)
)

;Rule for generic_entity when the adjective is in predicate position.
;This is very huge.
(defrule generic_entity-pred
(id-concept_label	?id1	wyax)
(or (id-proximal	?id1	yes) (id-distal	?id1	yes))
(MRS_info ?rel ?id1 ?mrscon ?lbl ?ARG0 ?rstr ?body)
?f1<-(MRS_info ?rel1 ?id2 ?MRSCON ?lbl1 ?ARG01 ?ARG1)
?f2<-(MRS_info ?rel2 ?id3 generic_entity ?lbl2 ?ARG02)
(test (eq  (+ ?id1 10) ?id3))
(test (or (neq (str-index _this_q_dem ?mrscon) FALSE)
          (neq (str-index _that_q_dem ?mrscon) FALSE)))
(test (neq (str-index _a_ ?MRSCON) FALSE))
=>
(retract ?f1 ?f2)
(printout ?*rstr-fp* "(MRS_info " ?rel1 " "?id2" "?MRSCON" " ?lbl1 " " ?ARG01" " ?ARG0")"crlf)
(printout ?*rstr-dbug* "(rule-rel-values generic_entity-pred " ?rel1 " "?id2" "?MRSCON" " ?lbl1 " " ?ARG01" " ?ARG0" )"crlf)

(assert (MRS_info ?rel2 ?id3 generic_entity ?lbl2 ?ARG0))
(printout ?*rstr-dbug* "(rule-rel-values generic_entity-pred " ?rel2 " "?id3" generic_entity " ?lbl2 " " ?ARG0")"crlf)
)

;Rule for generic_entity
;Some barked.
(defrule generic_entity-quantitative
(id-concept_label	?id1	kuCa_1)
(rel_name-ids	quant	?id2	?quant)
(MRS_info ?rel ?id1 ?mrscon ?lbl ?ARG0 ?rstr ?body)
?f1<-(MRS_info ?rel1 ?id2 ?mrsCon ?lbl1 ?ARG01 ?ARG1 $?var)
?f2<-(MRS_info ?rel2 ?id3 generic_entity ?lbl2 ?ARG02)
(test (eq  (+ ?id1 10) ?id3))
(not (modified ?ARG02))
(test (neq (str-index _some_q ?mrscon) FALSE))
(test (neq (str-index _v_ ?mrsCon) FALSE))
=>
(retract ?f1 ?f2)
(assert (modified ?ARG02))

(assert (MRS_info ?rel1 ?id2 ?mrsCon ?lbl1 ?ARG01 ?ARG0 $?var))
(printout ?*rstr-dbug* "(rule-rel-values generic_entity-quantitative " ?rel1 " "?id2" "?mrsCon" " ?lbl1 " " ?ARG01" " ?ARG0" "(implode$ (create$ $?var)) ")"crlf)

(assert (MRS_info ?rel2 ?id3 generic_entity ?lbl2 ?ARG0))
(printout ?*rstr-dbug* "(rule-rel-values generic_entity-quantitative " ?rel2 " "?id3" generic_entity " ?lbl2 " " ?ARG0")"crlf)
)

;Rule for creating the binding with comp, generic_entity, much-many_a, udef_q, card, and verb. 
;More than 300 people will come tomorrow.
(defrule quant_more_bind
(id-concept_label	?id	?num)
(id-numex	?id	yes)
(rel_name-ids	quantmore	?modifier	?id)
?f<-(MRS_info id-MRS_concept-LBL-ARG0-ARG1 ?much much-many_a ?lbl ?arg0 ?arg1)
?f1<-(MRS_info id-MRS_concept-LBL-ARG0 ?id generic_entity ?lbl1 ?arg01)
?f2<-(MRS_info id-MRS_concept-LBL-ARG0-ARG1-ARG2 ?comp comp ?l ?a0 ?a1 ?a2)
?f3<-(MRS_info id-MRS_concept-LBL-ARG0-RSTR-BODY ?udefq udef_q ?ll ?a00 ?rstr ?body)
?f4<-(MRS_info id-MRS_concept-LBL-ARG0-ARG1-CARG ?id card ?lbllll ?arg0000 ?arg1111 ?value)
?f5<-(MRS_info id-MRS_concept-LBL-ARG0-ARG1 ?verb ?verbmrs ?b ?aooo ?a111)
(MRS_info id-MRS_concept-LBL-ARG0-ARG1 ?modifier ?modifermrs ?lob ?ao0 ?a11i)
=> 
(retract ?f ?f1 ?f2 ?f3 ?f4 ?f5)
(printout ?*rstr-fp* "(MRS_info id-MRS_concept-LBL-ARG0-ARG1 "?much" much-many_a "?l" "?arg0" "?arg01")"crlf)
(printout ?*rstr-dbug* "(rule-rel-values quant_more_bind id-MRS_concept-LBL-ARG0-ARG1 ?much much-many_a "?l" "?arg0" "?arg01")"crlf)
(printout ?*rstr-fp* "(MRS_info id-MRS_concept-LBL-ARG0 "?id" generic_entity "?l" "?arg01")"crlf)
(printout ?*rstr-dbug* "(rule-rel-values quant_more_bind id-MRS_concept-LBL-ARG0 "?id" generic_entity "?l" "?arg01")"crlf)
(printout ?*rstr-fp* "(MRS_info id-MRS_concept-LBL-ARG0-ARG1-ARG2 "?comp" comp "?l" "?a0" "?arg0" "?ao0")"crlf)
(printout ?*rstr-dbug* "(rule-rel-values quant_more_bind id-MRS_concept-LBL-ARG0-ARG1-ARG2 "?comp" comp "?l" "?a0" "?arg0" "?ao0")"crlf)
(printout ?*rstr-fp* "(MRS_info id-MRS_concept-LBL-ARG0-RSTR-BODY "?udefq" udef_q "?ll" "?arg01" "?rstr" "?body")"crlf)
(printout ?*rstr-dbug* "(rule-rel-values quant_more_bind id-MRS_concept-LBL-ARG0-RSTR-BODY "?udefq" udef_q "?ll" "?arg01" "?rstr" "?body")"crlf)
(printout ?*rstr-fp* "(MRS_info id-MRS_concept-LBL-ARG0-ARG1-CARG "?id" card "?lob" "?arg0000" "?ao0" "?num")"crlf)
(printout ?*rstr-dbug* "(rule-rel-values quant_more_bind id-MRS_concept-LBL-ARG0-ARG1-CARG "?id" card "?lob" "?arg0000" "?ao0" "?num")"crlf)
(assert (MRS_info id-MRS_concept-LBL-ARG0-ARG1 ?verb ?verbmrs ?b ?aooo ?arg01))
(printout ?*rstr-dbug* "(rule-rel-values quant_more_bind id-MRS_concept-LBL-ARG0-ARG1 "?verb" "?verbmrs" "?b" "?aooo" "?arg01")"crlf)
)

;Rule for creating the binding with comp, generic_entity, much-many_a, udef_q, card, and verb. 
;Less than 300 people will come tomorrow.
(defrule quant_less_bind
(id-concept_label	?id	?num)
(id-numex	?id	yes)
(rel_name-ids	quantless	?modifier	?id)
?f<-(MRS_info id-MRS_concept-LBL-ARG0-ARG1 ?less little-few_a ?lbl ?arg0 ?arg1)
?f1<-(MRS_info id-MRS_concept-LBL-ARG0 ?id generic_entity ?lbl1 ?arg01)
?f2<-(MRS_info id-MRS_concept-LBL-ARG0-ARG1-ARG2 ?comp comp ?l ?a0 ?a1 ?a2)
?f3<-(MRS_info id-MRS_concept-LBL-ARG0-RSTR-BODY ?udefq udef_q ?ll ?a00 ?rstr ?body)
?f4<-(MRS_info id-MRS_concept-LBL-ARG0-ARG1-CARG ?id card ?lbllll ?arg0000 ?arg1111 ?value)
?f5<-(MRS_info id-MRS_concept-LBL-ARG0-ARG1 ?verb ?verbmrs ?b ?aooo ?a111)
(MRS_info id-MRS_concept-LBL-ARG0-ARG1 ?modifier ?modifermrs ?lob ?ao0 ?a11i)
=> 
(retract ?f ?f1 ?f2 ?f3 ?f4 ?f5)
(printout ?*rstr-fp* "(MRS_info id-MRS_concept-LBL-ARG0-ARG1 "?less" little-few_a "?l" "?arg0" "?arg01")"crlf)
(printout ?*rstr-dbug* "(rule-rel-values quant_less_bind id-MRS_concept-LBL-ARG0-ARG1 "?less" little-few_a "?l" "?arg0" "?arg01")"crlf)
(printout ?*rstr-fp* "(MRS_info id-MRS_concept-LBL-ARG0 "?id" generic_entity "?l" "?arg01")"crlf)
(printout ?*rstr-dbug* "(rule-rel-values quant_less_bind id-MRS_concept-LBL-ARG0 "?id" generic_entity "?l" "?arg01")"crlf)
(printout ?*rstr-fp* "(MRS_info id-MRS_concept-LBL-ARG0-ARG1-ARG2 "?comp" comp "?l" "?a0" "?arg0" "?ao0")"crlf)
(printout ?*rstr-dbug* "(rule-rel-values quant_less_bind id-MRS_concept-LBL-ARG0-ARG1-ARG2 "?comp" comp "?l" "?a0" "?arg0" "?ao0")"crlf)
(printout ?*rstr-fp* "(MRS_info id-MRS_concept-LBL-ARG0-RSTR-BODY "?udefq" udef_q "?ll" "?arg01" "?rstr" "?body")"crlf)
(printout ?*rstr-dbug* "(rule-rel-values quant_less_bind id-MRS_concept-LBL-ARG0-RSTR-BODY "?udefq" udef_q "?ll" "?arg01" "?rstr" "?body")"crlf)
(printout ?*rstr-fp* "(MRS_info id-MRS_concept-LBL-ARG0-ARG1-CARG "?id" card "?lob" "?arg0000" "?ao0" "?num")"crlf)
(printout ?*rstr-dbug* "(rule-rel-values quant_less_bind id-MRS_concept-LBL-ARG0-ARG1-CARG "?id" card "?lob" "?arg0000" "?ao0" "?num")"crlf)
(assert (MRS_info id-MRS_concept-LBL-ARG0-ARG1 ?verb ?verbmrs ?b ?aooo ?arg01))
(printout ?*rstr-dbug* "(rule-rel-values quant_less_bind id-MRS_concept-LBL-ARG0-ARG1 "?verb" "?verbmrs" "?b" "?aooo" "?arg01")"crlf)
)

;Rule for value sharing between the _according+to_p to the verb and samanadhikaran of the sentence.
;sIwA ke anusAra rAma vIra hE.
(defrule k7a_according_p
(id-concept_label	?id	?hinconcept)
(rel_name-ids	k7a	?kri	?id)
(rel_name-ids	k1s	?kri	?k1s)
?f<-(MRS_info id-MRS_concept-LBL-ARG0-ARG1-ARG2 ?according _according+to_p ?lbl ?arg0 ?arg1 ?Arg2)
(MRS_info ?rel ?id ?mrscon ?lbl1 ?Arg0 $?v)
(MRS_info ?rell ?k1s ?mrsconcept ?lblll ?arg00 $?var)
=>
(retract ?f)
(printout ?*rstr-fp* "(MRS_info id-MRS_concept-LBL-ARG0-ARG1-ARG2 "?according" _according+to_p "?lblll" "?arg0" "?arg00" "?Arg0")"crlf)
(printout ?*rstr-dbug* "(rule-rel-values k7a_according_p id-MRS_concept-LBL-ARG0-ARG1-ARG2 "?according" _according+to_p "?lblll" "?arg0" "?arg00" "?Arg0")"crlf)
)

;My country
(defrule unknown_LTOP_TITLE
(id-concept_label	?id	?hinconcept)
(rel_name-ids	main	0	?id)
(sentence_type	TITLE)
(MRS_info id-MRS_concept-LBL-ARG0-ARG 0 unknown ?lbl ?arg0 ?arg1)
=>
(printout ?*rstr-fp* "(LTOP-INDEX h0 "?arg0 ")" crlf)
(printout ?*rstr-dbug* "(rule-rel-values unknown_LTOP_TITLE LTOP-INDEX h0 "?arg0 ")"crlf)
)

;Fruits and vegetables found in India.
(defrule unknown_LTOP_heading
(id-concept_label	?id	?hinconcept)
(rel_name-ids	main	0	?id)
(sentence_type	heading)
(MRS_info id-MRS_concept-LBL-ARG0-ARG 0 unknown ?lbl ?arg0 ?arg1)
=>
(printout ?*rstr-fp* "(LTOP-INDEX h0 "?arg0 ")" crlf)
(printout ?*rstr-dbug* "(rule-rel-values unknown_LTOP_heading LTOP-INDEX h0 "?arg0 ")"crlf)
)

;My country
(defrule unknown_LTOP_value_sharing
(id-concept_label	?id	?hinconcept)
(rel_name-ids	main	0	?id)
(sentence_type	TITLE)
(MRS_info id-MRS_concept-LBL-ARG0-ARG 0 unknown ?lbl ?arg0 ?arg1)
(MRS_info ?rel ?id ?mrsCon ?lbl1 ?arg01 $?v)
=>
(printout ?*rstr-fp* "(MRS_info  id-MRS_concept-LBL-ARG0-ARG  0 unknown "?lbl" " ?arg0 " " ?arg01 ")"crlf)
(printout ?*rstr-dbug* "(rule-rel-values unknown_LTOP_value_sharing id-MRS_concept-LBL-ARG0-ARG  0 unknown "?lbl" " ?arg0 " " ?arg01 ")"crlf)
)

;Fruits and vegetables found in India.
(defrule unknown_LTOP_value_sharing-heading
(construction-ids	conj	?id ?id1)
(id-concept_label	?id1	?hinconcept)
(rel_name-ids	main	0	?id)
(sentence_type	heading)
(MRS_info id-MRS_concept-LBL-ARG0-ARG 0 unknown ?lbl ?arg0 ?arg1)
(MRS_info ?rel ?conj ?mrsCon ?lbl1 ?arg01 $?v)
(test (eq  (+ ?id 500) ?conj))
=>
(printout ?*rstr-fp* "(MRS_info  id-MRS_concept-LBL-ARG0-ARG  0 unknown "?lbl" " ?arg0 " " ?arg01 ")"crlf)
(printout ?*rstr-dbug* "(rule-rel-values unknown_LTOP_value_sharing-heading id-MRS_concept-LBL-ARG0-ARG  0 unknown "?lbl" " ?arg0 " " ?arg01 ")"crlf)
)



