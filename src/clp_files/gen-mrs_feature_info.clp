;generates output file "initial-mrs_info.dat" which contains id,MRS concept and their respective relation features.


(defglobal ?*mrs-fp* = mrs-file)
(defglobal ?*mrs-dbug* = mrs-dbug)
(defglobal ?*count* = 1)




;rule for deleting be_v_id for k1s
;Rama is good.
;(id-concept_label	30000	hE_1)
;(rel_name-ids	k1s	30000	20000)
;(id-hin_concept-MRS_concept 30000 hE_1 _be_v_id)
;(id-hin_concept-MRS_concept 20000 acCA_1 _good_a_at-for-of)
(defrule rm_be_v_id
(declare (salience 10000))
?f<-(id-concept_label	?kri	hE_1)
(rel_name-ids	k1s	?kri	?k1s)
?f1<-(id-hin_concept-MRS_concept ?kri  hE_1   _be_v_id)
(id-hin_concept-MRS_concept ?k1s ?hinCon ?adj)
(test (neq (str-index _a_ ?adj) FALSE) )
=>
(retract ?f ?f1)
(printout ?*mrs-dbug* "(rule-rel-values   rm_be_v_id id-MRS_concept " ?kri " hE_1)"crlf)
)



;rule for deleting be_v_id for k7p
;Rama is in Delhi.
;(id-concept_label	20000	xillI)
;(id-concept_label	40000	 hE_1)
;(rel_name-ids	k1	40000	10000)
;(rel_name-ids	k7p	40000	20000)
(defrule rm_be_v_id-k7p
(declare (salience 10000))
?f<-(id-concept_label	?kri	hE_1)
(rel_name-ids	k7p	?kri	?k1s)
?f1<-(id-hin_concept-MRS_concept ?kri  hE_1   _be_v_id)
=>
(retract ?f ?f1)
(printout ?*mrs-dbug* "(rule-rel-values   rm_be_v_id-k7p id-MRS_concept " ?kri " hE_1)"crlf)
)



;(rel_name-ids viSeRya-viSeRaNa	20000	21000)
;(id-concept_label	21000	WodZA_3)
;(id-hin_concept-MRS_concept 21000 WodZA_3 _some_q) 
;(MRS_info id-MRS_concept 20010 _a_q)
;Rules to delete _a_q etc for concepts that already have some quantifiers like _some_q, _all_q, _every_q etc as viSeRana
;prawyeka baccA Kela rahe hEM. hara baccA Kela rahe hEM. saBI bacce Kela rahe hEM. prawyeka pedZa lambA hE.	
;Each kid is playing.          Every kid is playing.     All kids are playing.     Each tree is tall.
(defrule rm-qcon4quantifier
(declare (salience 10000))
(rel_name-ids mod	?vi 	?vina)
(id-hin_concept-MRS_concept ?vina ?qntfr ?vinaq) 
?f<-(MRS_info id-MRS_concept ?q_id  ?aq)
(test (eq (+ 10 ?vi) ?q_id))
(test (neq (str-index _q ?vinaq) FALSE))
(test (neq (str-index _q ?aq) FALSE))
=>
(retract ?f)
(printout ?*mrs-dbug* "(rule-rel-values   rm-qcon4quantifier  id-MRS_concept "?q_id" "?aq")"crlf)
)

;Rule to change the ARG2 value x* to h* of the verb want when it takes a verb as k2
;Ex. Rama wants to sleep.
(defrule want-k2-v
(declare (salience 300))
?f<-(MRS_info ?rel ?kri _want_v_1 ?l ?a0 ?a1 ?a2)
(rel_name-ids k2   ?kri	?k2)
(MRS_info ?r ?k2  ?k2v $?v)
(test (neq (str-index _v_ ?k2v) FALSE))
=>
(retract ?f)
(bind ?arg2 (str-cat "h" (sub-string 2 (str-length ?a2) ?a2)))  
(printout ?*mrs-fp* "(MRS_info "?rel" "?kri" _want_v_1 "?l" "?a0" "?a1" "?arg2")"crlf)
(printout ?*mrs-dbug* "(rule-rel-values want-k2-v "?rel" "?kri" _want_v_1 "?l" "?a0" "?a1" "?arg2")"crlf)
)


;Rule to change the ARG1 value x* of the passive verbs when k1 is not present for the verb to i*
;Ex. (MRS_info id-MRS_concept-LBL-ARG0-ARG1-ARG2 30000 _kill_v_1 h19 e20 x21 x22)
;changes to
;    (MRS_info id-MRS_concept-LBL-ARG0-ARG1-ARG2 30000 _kill_v_1 h19 e20 i21 x22)
;Ex. Ravana was killed.
(defrule passive-v-k1
(declare (salience 200))
?f1<-(sentence_type     pass-affirmative)
?f<-(MRS_info ?rel ?kri ?mrscon ?lbl ?arg0 ?arg1 ?arg2 $?var)
(not (rel_name-ids k1   ?kri    ?k1))
=>
(retract ?f1 ?f)
(bind ?a1 (str-cat "u" (sub-string 2 (str-length ?arg1) ?arg1)))
;(assert (MRS_info   ?kri ?arg1  (explode$ ?a1) ))
(printout ?*mrs-fp* "(MRS_info "?rel" "?kri" "?mrscon" "?lbl" "?arg0" "?a1" "?arg2" "(implode$ (create$ $?var))")"crlf)
(printout ?*mrs-dbug* "(rule-rel-values passive-v-k1 MRS_info "?rel" "?kri" "?mrscon" "?lbl" "?arg0" "?a1" "?arg2" "(implode$ (create$ $?var))")"crlf)
)

;Rule for converting arg2 value (x*) of transtive verb when k2 is absent to u*
;Ex. #usane nahIM KAyA.  
;     He did not eat.
(defrule active-k2-absent
(declare (salience 200))
?f1<-(sentence_type    affirmative|negative|interrogative|yn_interrogative)
?f<-(MRS_info id-MRS_concept-LBL-ARG0-ARG1-ARG2 ?kri ?mrscon ?lbl ?arg0 ?arg1 ?arg2)
(not (rel_name-ids k2   ?kri    ?k2))
(test (eq (str-index _have_v_1 ?mrscon) FALSE))
=>
(retract ?f1 ?f)
(bind ?a2 (str-cat "u" (sub-string 2 (str-length ?arg2) ?arg2)))
(printout ?*mrs-fp* "(MRS_info id-MRS_concept-LBL-ARG0-ARG1-ARG2 "?kri" "?mrscon" "?lbl" "?arg0" "?arg1" "?a2")"crlf)
(printout ?*mrs-dbug* "(rule-rel-values active-k2-absent MRS_info id-MRS_concept-LBL-ARG0-ARG1-ARG2 "?kri" "?mrscon" "?lbl" "?arg0" "?arg1" "?a2")"crlf)
)


;Rule for converting arg1 value (x*) of transtive verb when k1 is absent to u*
;Ex. rAma ne skUla jAkara KAnA KAyA.
;   Having gone to the school Rama ate food.
(defrule k1-absent
(declare (salience 200))
?f1<-(sentence_type    affirmative|negative|interrogative|yn_interrogative)
?f<-(MRS_info ?rel ?kri ?mrscon ?lbl ?arg0 ?arg1 $?v)
(not (rel_name-ids k1   ?kri    ?k1))
(test (neq (str-index _v_ ?mrscon) FALSE))
=>
(retract ?f1 ?f)
(bind ?a1 (str-cat "u" (sub-string 2 (str-length ?arg1) ?arg1)))
(printout ?*mrs-fp* "(MRS_info "?rel" "?kri" "?mrscon" "?lbl" "?arg0" "?a1" "(implode$ (create$ $?v))")"crlf)
(printout ?*mrs-dbug* "(rule-rel-values k1-absent "?rel" "?kri" "?mrscon" "?lbl" "?arg0" "?a1" "(implode$ (create$ $?v))")"crlf)
)

;Rule converts arg1 and arg2 of vmod_pka kriya into u*
;#राम खा -खाकर मोटा हो गया ।
(defrule vmod_pka
(declare (salience 500))
?f<-(MRS_info ?rel ?kri ?mrscon ?lbl ?arg0 ?arg1 ?arg2)
(rel_name-ids vmod_pka  ?id    ?kri)
(test (neq (str-index _v_ ?mrscon) FALSE))
=>
(retract ?f)
(bind ?a1 (str-cat "u" (sub-string 2 (str-length ?arg1) ?arg1)))
(bind ?a2 (str-cat "u" (sub-string 2 (str-length ?arg2) ?arg2)))
(printout ?*mrs-fp* "(MRS_info "?rel" "?kri" "?mrscon" "?lbl" "?arg0" "?a1" "?a2")"crlf)
(printout ?*mrs-dbug* "(rule-rel-values vmod_pka "?rel" "?kri" "?mrscon" "?lbl" "?arg0" "?a1" "?a2")"crlf)
)

;This rule converts kridant arg1 x* to u* when k1 is absent for any type of sentence.
; verified sentence 340 #भागते हुए शेर को देखो
(defrule k1-absent-4-vmod
(declare (salience 200))
;?f1<-(sentence_type    affirmative|negative|interrogative|yn_interrogative)
?f<-(MRS_info ?rel ?kridant ?mrscon ?lbl ?arg0 ?arg1 $?v)
(rel_name-ids ?vmod   ?main    ?kridant)
(not (rel_name-ids k1   ?kridant    ?k1))
(test (neq (str-index _v_ ?mrscon) FALSE))
(test (neq (str-index vmod_ ?vmod) FALSE))
=>
(retract ?f)
(bind ?a1 (str-cat "u" (sub-string 2 (str-length ?arg1) ?arg1)))
(printout ?*mrs-fp* "(MRS_info "?rel" "?kridant" "?mrscon" "?lbl" "?arg0" "?a1" "(implode$ (create$ $?v))")"crlf)
(printout ?*mrs-dbug* "(rule-rel-values k1-absent-4-vmod "?rel" "?kridant" "?mrscon" "?lbl" "?arg0" "?a1" "(implode$ (create$ $?v))")"crlf)
)

;Changing the ARG0 value (e*) to i* for imperative(-nagetive) sentences.
;(MRS_concept-label-feature_values neg LBL: h* ARG0: e* ARG1: h*)
;Ex. 320 Sahara mawa jAo!  =  Don't go to the city.
(defrule imper-neg
(declare (salience 2200))
(sentence_type	imperative)
(rel_name-ids neg	?kri	?negid)
?f<-(MRS_concept-label-feature_values neg LBL: h* ARG0: e* ARG1: h*)
=>
(retract ?f)
(printout ?*mrs-fp* "(MRS_info id-MRS_concept-LBL-ARG0-ARG1 "?negid" neg  h1 i2 h3)"crlf)
(printout ?*mrs-dbug* "(rule-rel-values imper-neg MRS_info id-MRS_concept-LBL-ARG0-ARG1 "?negid" neg  h1 i2 h3)"crlf)
(bind ?*count* (+ ?*count* 3))
)

(defrule speak_k2
(declare (salience 5000))
(id-hin_concept-MRS_concept ?id ?hinlbl _speak_v_to)
?f<-(MRS_info id-MRS_concept-LBL-ARG0-ARG1-ARG2 ?id _speak_v_to ?lbl ?arg0 ?arg1 ?arg2)
(not (rel_name-ids k2 ?id ?k2))
=>
(retract ?f)
(printout ?*mrs-fp* "(MRS_info id-MRS_concept-LBL-ARG0-ARG1 "?id" _speak_v_to "?lbl" "?arg0" "?arg1")"crlf)
(printout ?*mrs-dbug*  "(rule-rel-values speak_k2 MRS_info id-MRS_concept-LBL-ARG0-ARG1 "?id" _speak_v_to "?lbl" "?arg0" "?arg1")"crlf)
)



;Rule for generating initial mrs info for concepts in file "id-concept_label-mrs_concept.dat"
(defrule mrs-info
(id-hin_concept-MRS_concept ?id  ?conLbl  ?mrsCon)
(MRS_concept-label-feature_values ?mrsCon $?vars)
=>
	(bind ?val (length$ (create$ $?vars)))
	(bind ?rel (create$ ))
	(bind ?v (create$ ))
	(loop-for-count (?i 1 ?val)
		(if (eq (oddp ?i) TRUE) then
			(bind ?rel_name (string-to-field (sub-string 1 (- (str-length (nth$ ?i $?vars)) 1) (nth$ ?i $?vars))))
			(bind ?rel (create$ ?rel ?rel_name))
		else
			(bind ?v1 (string-to-field (str-cat (sub-string 1 1 (nth$ ?i $?vars)) ?*count*)))
			(bind ?*count* (+ ?*count* 1))
			(bind ?v (create$ ?v ?v1))
		)
	)
        (bind ?l (length$ $?rel) )
        (bind ?str "")
	(loop-for-count (?i 1 ?l )
        	(bind ?str (str-cat ?str (nth$ ?i $?rel) "-")) 
	)
	(bind ?f (sub-string 1 (- (str-length ?str)1) ?str))
	(bind ?f1 (explode$ (str-cat "id-MRS_concept-"  ?f)))

        (assert (MRS_info  ?f1  ?id ?mrsCon  ?v))
        ;(printout ?*mrs-fp* "(MRS_info "(implode$ (create$ ?f1))" "?id " "?mrsCon" "(implode$ (create$ ?v))")"crlf)
        (printout ?*mrs-dbug* "(rule-rel-values mrs-info MRS_info "(implode$ (create$ ?f1))" "?id " "?mrsCon" "(implode$ (create$ ?v))")"crlf)
)

;Generate initial MRS info for concepts in "mrs_info.dat"
(defrule mrs-info-other
?f<-(MRS_info id-MRS_concept ?id  ?mrsCon )
(MRS_concept-label-feature_values ?mrsCon $?vars)
=>
(retract ?f )
	(bind ?val (length$ (create$ $?vars)))
	(bind ?rel (create$ ))
	(bind ?v (create$ ))
	(loop-for-count (?i 1 ?val)
		(if (eq (oddp ?i) TRUE) then
			(bind ?rel_name (string-to-field (sub-string 1 (- (str-length (nth$ ?i $?vars)) 1) (nth$ ?i $?vars))))
			(bind ?rel (create$ ?rel ?rel_name))
		else
			(bind ?v1 (string-to-field (str-cat (sub-string 1 1 (nth$ ?i $?vars)) ?*count*)))
			(bind ?*count* (+ ?*count* 1))
			(bind ?v (create$ ?v ?v1))
		)
	)
        (bind ?l (length$ $?rel) )
        (bind ?str "")
	(loop-for-count (?i 1 ?l )
        	(bind ?str (str-cat ?str (nth$ ?i $?rel) "-")) 
	)
	(bind ?f (sub-string 1 (- (str-length ?str)1) ?str))
	(bind ?f1 (explode$ (str-cat "id-MRS_concept-"  ?f)))

        (printout ?*mrs-fp* "(MRS_info "(implode$ (create$ ?f1))" "?id " "?mrsCon" "(implode$ (create$ ?v))")"crlf)
        (printout ?*mrs-dbug* "(rule-rel-values mrs-info-other "(implode$ (create$ ?f1))" "?id " "?mrsCon" "(implode$ (create$ ?v))")"crlf)
)

; (rule-rel-values printMRSfacts  MRS_info id-MRS_concept 10001 _of_p)
(defrule printMRSfacts
(declare (salience -9000))
?f<-(MRS_info ?rel  ?id ?mrscon ?lbl $?all)
=>
(retract ?f)
   (printout ?*mrs-fp* "(MRS_info "?rel" "?id" "?mrscon" "?lbl" "(implode$ (create$ $?all))")"crlf)
   (printout ?*mrs-dbug* "(rule-rel-values printMRSfacts  MRS_info "?rel" "?id" "?mrscon" "?lbl" "(implode$ (create$ $?all))")"crlf)
)
