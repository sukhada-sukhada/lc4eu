;generates output file "initial-mrs_info.dat" which contains id,MRS concept and their respective relation features.


(defglobal ?*mrs-fp* = mrs-file)
(defglobal ?*mrs-dbug* = mrs-debug)
(defglobal ?*count* = 1)

;rule for deleting be_v_id for k1s 
;Rama is good.
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

;Rule for removing _be_v_id for the sentences consists of ru relation.
;Ex. गुलाब जैसे फूल पानी में नहीं उगते हैं।
(defrule rm_be_v_id-ru
(declare (salience 10000))
?f<-(id-concept_label	?kri	hE_1)
(rel_name-ids	ru	?pru	?wal)
?f1<-(id-hin_concept-MRS_concept ?kri  hE_1   _be_v_id)
(id-hin_concept-MRS_concept ?ru ?hinCon ?mrscon)
(test (neq (str-index _n_ ?mrscon) FALSE) )
=>
(retract ?f ?f1)
(printout ?*mrs-dbug* "(rule-rel-values   rm_be_v_id-ru id-MRS_concept " ?kri " hE_1)"crlf)
)


;rule for deleting be_v_id for k7p
;Rama is in Delhi.
(defrule rm_be_v_id-k7p
(declare (salience 10000))
?f<-(id-concept_label	?kri	hE_1)
(rel_name-ids	k7p	?kri	?k1s)
?f1<-(id-hin_concept-MRS_concept ?kri  hE_1   _be_v_id)
=>
(retract ?f ?f1)
(printout ?*mrs-dbug* "(rule-rel-values   rm_be_v_id-k7p id-MRS_concept " ?kri " hE_1)"crlf)
)

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

;Rule converts arg1 and arg2 of rpka kriya into u*
;#rAma KA -KAkara motA ho gayA .
(defrule rpka
(declare (salience 500))
;?f1<-(sentence_type    affirmative|negative|interrogative|yn_interrogative)
?f<-(MRS_info ?rel ?kri ?mrscon ?lbl ?arg0 ?arg1 ?arg2)
(rel_name-ids rpka  ?id    ?kri)
(test (neq (str-index _v_ ?mrscon) FALSE))
=>
(retract ?f)
(bind ?a1 (str-cat "u" (sub-string 2 (str-length ?arg1) ?arg1)))
(bind ?a2 (str-cat "u" (sub-string 2 (str-length ?arg2) ?arg2)))
(printout ?*mrs-fp* "(MRS_info "?rel" "?kri" "?mrscon" "?lbl" "?arg0" "?a1" "?a2")"crlf)
(printout ?*mrs-dbug* "(rule-rel-values k1-absent "?rel" "?kri" "?mrscon" "?lbl" "?arg0" "?a1" "?a2")"crlf)
)

;This rule converts kridant arg1 x* to u* when k1 is absent for any type of sentence.
; verified sentence 340 #BAgawe hue Sera ko xeKo
(defrule k1-absent-4-vmod
(declare (salience 200))
;?f1<-(sentence_type    affirmative|negative|interrogative|yn_interrogative)
?f<-(MRS_info ?rel ?kridant ?mrscon ?lbl ?arg0 ?arg1 $?v)
(rel_name-ids ?vmod   ?main    ?kridant)
(not (rel_name-ids k1   ?kridant    ?k1))
(test (neq (str-index _v_ ?mrscon) FALSE))
(test (neq (str-index r ?vmod) FALSE))
=>
(retract ?f)
(bind ?a1 (str-cat "u" (sub-string 2 (str-length ?arg1) ?arg1)))
(printout ?*mrs-fp* "(MRS_info "?rel" "?kridant" "?mrscon" "?lbl" "?arg0" "?a1" "(implode$ (create$ $?v))")"crlf)
(printout ?*mrs-dbug* "(rule-rel-values k1-absent-4-vmod "?rel" "?kridant" "?mrscon" "?lbl" "?arg0" "?a1" "(implode$ (create$ $?v))")"crlf)
)

;Changing the ARG0 value (e*) to i* for imperative(-nagetive) sentences.
;Ex. 320 Sahara mawa jAo!  =  Don't go to the city.
(defrule imper-neg
(declare (salience 2200))
(sentence_type	imperative)
(rel_name-ids neg	?kri	?negid)
?f<-(MRSc-FVs neg LBL: h* ARG0: e* ARG1: h*)
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

;deleting ARG2 value for irregular adjective forms in comperative and superlative degree
(defrule rmARG2Irregular-adj
(declare (salience 5000))
(id-degree	?id	superl|comper_less|comper_more)
?f<-(MRS_info id-MRS_concept-LBL-ARG0-ARG1-ARG2 ?id ?adj ?lbl ?arg0 ?arg1 ?arg2)
(test (or (eq ?adj _good_a_at-for-of) (eq ?adj _bad_a_at) (eq ?adj _much_x_deg)))
=>
(retract ?f)
(printout ?*mrs-fp* "(MRS_info id-MRS_concept-LBL-ARG0-ARG1 "?id" "?adj" "?lbl" "?arg0" "?arg1")"crlf)
(printout ?*mrs-dbug*  "(rule-rel-values rmARG2Irregular-adj MRS_info id-MRS_concept-LBL-ARG0-ARG1 "?id" "?adj" "?lbl" "?arg0" "?arg1")"crlf)
)



;Rule for generating initial mrs info for concepts in file "id-concept_label-mrs_concept.dat"
(defrule mrs-info
(id-hin_concept-MRS_concept ?id  ?conLbl  ?mrsCon)
(MRSc-FVs ?mrsCon $?vars)
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
(MRSc-FVs ?mrsCon $?vars)
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

;Rule for bringing L_HNDL and R_HNDL for the implicit_conj and _and_c when the construction is in predicative form.
;Ex. Rama buxXimAna, motA, xilera, Ora accA hE. 
;Rules of udef_q will not work this rule only works for adjective or verb constructions.
;It creates L_HNDL and R_HNDL with h values and L_INDEX and R_INDEX with e values. 
(defrule implict_handle
(declare (salience 5000)) 
(MRSc-FVs implicit_conj LBL: h* ARG0: x* L_INDEX: x* R_INDEX: x*)
?f<-(rel_name-ids	k1s	?kri	?k1s)
(construction-ids	conj	$? ?k1s $?)
(MRS_info id-MRS_concept ?implicit ?mrs)
(MRSc-FVs ?mrscon $?v)
;(test (eq ?mrs implicit_conj) )
(test (or (eq ?mrs implicit_conj) (eq ?mrs _and_c)) )
(test (or (eq  (+ ?k1s 600) ?implicit) (eq  (+ ?k1s 500) ?implicit)))
;(test (eq  (+ ?k1s 600) ?implicit))
(test (neq (str-index _a_ ?mrscon) False))
=>
(retract ?f) 
(assert (MRSc-FVs ?mrs LBL: h* ARG0: e* L_INDEX: e* R_INDEX: e* L_HNDL: h* R_HNDL: h*))
   (printout ?*mrs-dbug* "(rule-rel-values implict_handle  MRSc-FVs "?mrs" LBL: h* ARG0: e* L_INDEX: e* R_INDEX: e* L_HNDL: h* R_HNDL: h*)"crlf)
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

;Rule to change the ARG0 value e* to x* of the card when it takes a verb as k2 and arg1 x* to i*
;When card is coming in k2 position.
;The cat chased one.
(defrule card-x-i
(declare (salience 300))
?f<-(MRS_info ?rel ?ic card ?l ?a0 ?a1 ?carg)
(rel_name-ids k2   ?kri	?ic)
(MRS_info ?r ?kri  ?mrscon $?v)
(test (neq (str-index _v_ ?mrscon) FALSE))
=>
(retract ?f)
(bind ?arg0 (str-cat "x" (sub-string 2 (str-length ?a0) ?a0)))
(bind ?arg1 (str-cat "i" (sub-string 2 (str-length ?a1) ?a1)))    
(printout ?*mrs-fp* "(MRS_info "?rel" "?ic" card "?l" "?arg0" "?arg1" "?carg")"crlf)
(printout ?*mrs-dbug* "(rule-rel-values card-x-i "?rel" "?ic" card "?l" "?arg0" "?arg1" "?carg")"crlf)
)

;Removing be_v_id for for kim with k1s relation. 
;How are you?
(defrule rm_be_v_id-how
(declare (salience 10000))
?f<-(id-concept_label	?kri	hE_1) 
(id-concept_label	?k1s	kim)
(rel_name-ids	k1s	?kri	?k1s)
?f1<-(id-hin_concept-MRS_concept ?kri  hE_1   _be_v_id)
(sentence_type  interrogative)
=>
(retract ?f ?f1)
(printout ?*mrs-dbug* "(rule-rel-values   rm_be_v_id-how id-MRS_concept " ?kri " hE_1)"crlf)
)


;Rule for changing arg0 of which_q from e to i.
;How are you?
(defrule which_q_e-i
;(declare (salience 300))
?f<-(MRSc-FVs which_q LBL: h* ARG0: ?a0 RSTR: h* BODY: h*)
(id-concept_label	?kri	hE_1) 
(id-concept_label	?k1s	kim)
(rel_name-ids	k1s	?kri	?k1s)
(sentence_type  interrogative)
=>
(retract ?f)
(bind ?arg0 (str-cat "i" (sub-string 2 (str-length ?a0) ?a0)))  
(printout ?*mrs-fp* "(MRSc-FVs which_q LBL: h* ARG0: "?arg0" RSTR: h* BODY: h*)"crlf)
(printout ?*mrs-dbug* "(rule-rel-values which_q_e-i MRSc-FVs which_q LBL: h* ARG0: "?arg0" RSTR: h* BODY: h*)"crlf)
)


