;generates output file "initial-mrs_info.dat" which contains id,MRS concept and their respective relation features.


(defglobal ?*mrs-fp* = mrs-file)
(defglobal ?*mrs-dbug* = mrs-debug)
(defglobal ?*count* = 1)

;rule for deleting be_v_id for k1s 
;Rama is good.
(defrule rm_be_v_id
(declare (salience 10000))
?f<-(id-cl	?kri	hE_1)
(rel-ids	k1s	?kri	?k1s)
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
?f<-(id-cl	?kri	hE_1)
(rel-ids	ru	?pru	?wal)
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
?f<-(id-cl	?kri	hE_1)
(rel-ids	k7p	?kri	?k7p)
?f1<-(id-hin_concept-MRS_concept ?kri  hE_1   _be_v_id)
(not (rel-ids k1s ?kri ?k1s))
=>
(retract ?f ?f1)
(printout ?*mrs-dbug* "(rule-rel-values   rm_be_v_id-k7p id-MRS_concept " ?kri " hE_1)"crlf)
)

;Rules to delete _a_q etc for concepts that already have some quantifiers like _some_q, _all_q, _every_q etc as viSeRana
;prawyeka baccA Kela rahe hEM. hara baccA Kela rahe hEM. saBI bacce Kela rahe hEM. prawyeka pedZa lambA hE.	
;Each kid is playing.          Every kid is playing.     All kids are playing.     Each tree is tall.
(defrule rm-qcon4quantifier
(declare (salience 10000))
(rel-ids mod	?vi 	?vina)
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
(rel-ids k2   ?kri	?k2)
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
?f1<-(sent_type     %pass_affirmative)
?f<-(MRS_info ?rel ?kri ?mrscon ?lbl ?arg0 ?arg1 ?arg2 $?var)
(not (rel-ids k1   ?kri    ?k1))
=>
(retract ?f1 ?f)
(bind ?a1 (str-cat "u" (sub-string 2 (str-length ?arg1) ?arg1)))
;(assert (MRS_info   ?kri ?arg1  (explode$ ?a1) ))
(printout ?*mrs-fp* "(MRS_info "?rel" "?kri" "?mrscon" "?lbl" "?arg0" "?a1" "?arg2" "(implode$ (create$ $?var))")"crlf)
(printout ?*mrs-dbug* "(rule-rel-values passive-v-k1 MRS_info "?rel" "?kri" "?mrscon" "?lbl" "?arg0" "?a1" "?arg2" "(implode$ (create$ $?var))")"crlf)
)

;Rule for converting arg1 value (x*) of transtive verb when k1 is absent to u*
;Ex. rAma ne skUla jAkara KAnA KAyA.
;   Having gone to the school Rama ate food.
(defrule k1-absent
(declare (salience 200))
?f1<-(sent_type    %affirmative|%negative|%interrogative|%yn_interrogative)
?f<-(MRS_info ?rel ?kri ?mrscon ?lbl ?arg0 ?arg1 $?v)
(not (rel-ids k1   ?kri    ?k1))
(test (neq (str-index _v_ ?mrscon) FALSE))
(not (rel-ids rsk   ?kri    ?verb))
=>
(retract ?f1 ?f)
;(retract ?f1)
(bind ?a1 (str-cat "u" (sub-string 2 (str-length ?arg1) ?arg1)))
;(assert (MRS_info ?rel ?kri ?mrscon ?lbl ?arg0 ?a1 $?v))
(printout ?*mrs-fp* "(MRS_info "?rel" "?kri" "?mrscon" "?lbl" "?arg0" "?a1" "(implode$ (create$ $?v))")"crlf)
(printout ?*mrs-dbug* "(rule-rel-values k1-absent "?rel" "?kri" "?mrscon" "?lbl" "?arg0" "?a1" "(implode$ (create$ $?v))")"crlf)
)
;Rule for converting arg2 value (x*) of transtive verb when k2 is absent to u*
;Ex. #usane nahIM KAyA.  
;     He did not eat.
(defrule active-k2-absent
(declare (salience 200))
?f1<-(sent_type    %affirmative|%negative|%interrogative|%yn_interrogative|%imperative)
?f<-(MRS_info id-MRS_concept-LBL-ARG0-ARG1-ARG2 ?kri ?mrscon ?lbl ?arg0 ?arg1 ?arg2)
(not (rel-ids k2   ?kri    ?k2))
(test (eq (str-index _have_v_1 ?mrscon) FALSE))
(not (verb_bind_notrequired ?mrscon))
=>
(retract ?f1 ?f)
(bind ?a2 (str-cat "u" (sub-string 2 (str-length ?arg2) ?arg2)))
(printout ?*mrs-fp* "(MRS_info id-MRS_concept-LBL-ARG0-ARG1-ARG2 "?kri" "?mrscon" "?lbl" "?arg0" "?arg1" "?a2")"crlf)
(printout ?*mrs-dbug* "(rule-rel-values active-k2-absent MRS_info id-MRS_concept-LBL-ARG0-ARG1-ARG2 "?kri" "?mrscon" "?lbl" "?arg0" "?arg1" "?a2")"crlf)
)


;Rule converts arg1 and arg2 of rpk kriya into u*
;#rAma KA -KAkara motA ho gayA .
(defrule rpk
(declare (salience 500))
;?f1<-(sent_type    %affirmative|%negative|%interrogative|%yn_interrogative)
?f<-(MRS_info ?rel ?kri ?mrscon ?lbl ?arg0 ?arg1 ?arg2)
(rel-ids rpk  ?id    ?kri)
(test (neq (str-index _v_ ?mrscon) FALSE))
=>
(retract ?f)
(bind ?a1 (str-cat "u" (sub-string 2 (str-length ?arg1) ?arg1)))
(bind ?a2 (str-cat "u" (sub-string 2 (str-length ?arg2) ?arg2)))
(printout ?*mrs-fp* "(MRS_info "?rel" "?kri" "?mrscon" "?lbl" "?arg0" "?a1" "?a2")"crlf)
(printout ?*mrs-dbug* "(rule-rel-values rpk "?rel" "?kri" "?mrscon" "?lbl" "?arg0" "?a1" "?a2")"crlf)
)

;This rule converts kridant arg1 x* to u* when k1 is absent for any type of sentence.
; verified sentence 340 #BAgawe hue Sera ko xeKo
(defrule k1-absent-4-vmod
(declare (salience 200))
;?f1<-(sent_type    %affirmative|%negative|%interrogative|%yn_interrogative)
?f<-(MRS_info ?rel ?kridant ?mrscon ?lbl ?arg0 ?arg1 $?v)
(rel-ids ?vmod   ?main    ?kridant)
(not (rel-ids k1   ?kridant    ?k1))
(test (neq (str-index _v_ ?mrscon) FALSE))
(test (neq (str-index r ?vmod) FALSE))
=>
(retract ?f)
(bind ?a1 (str-cat "u" (sub-string 2 (str-length ?arg1) ?arg1)))
(printout ?*mrs-fp* "(MRS_info "?rel" "?kridant" "?mrscon" "?lbl" "?arg0" "?a1" "(implode$ (create$ $?v))")"crlf)
(printout ?*mrs-dbug* "(rule-rel-values k1-absent-4-vmod "?rel" "?kridant" "?mrscon" "?lbl" "?arg0" "?a1" "(implode$ (create$ $?v))")"crlf)
)

;Changing the ARG0 value (e*) to i* for %imperative(-nagetive) sentences.
;Ex. 320 Sahara mawa jAo!  =  Don't go to the city.
(defrule imper-neg
(declare (salience 2200))
(sent_type	%imperative)
(rel-ids neg	?kri	?negid)
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
(not (rel-ids k2 ?id ?k2))
=>
(retract ?f)
(printout ?*mrs-fp* "(MRS_info id-MRS_concept-LBL-ARG0-ARG1 "?id" _speak_v_to "?lbl" "?arg0" "?arg1")"crlf)
(printout ?*mrs-dbug*  "(rule-rel-values speak_k2 MRS_info id-MRS_concept-LBL-ARG0-ARG1 "?id" _speak_v_to "?lbl" "?arg0" "?arg1")"crlf)
)

;deleting ARG2 value for irregular adjective forms in comperative and superlative degree
(defrule rmARG2Irregular-adj
(declare (salience 5000))
(id-morph_sem	?id	superl|comperless|compermore)
?f<-(MRS_info id-MRS_concept-LBL-ARG0-ARG1-ARG2 ?id ?adj ?lbl ?arg0 ?arg1 ?arg2)
(test (or (eq ?adj _good_a_at-for-of) (eq ?adj _bad_a_at) (eq ?adj _much_x_deg)))
=>
(retract ?f)
(printout ?*mrs-fp* "(MRS_info id-MRS_concept-LBL-ARG0-ARG1 "?id" "?adj" "?lbl" "?arg0" "?arg1")"crlf)
(printout ?*mrs-dbug*  "(rule-rel-values rmARG2Irregular-adj MRS_info id-MRS_concept-LBL-ARG0-ARG1 "?id" "?adj" "?lbl" "?arg0" "?arg1")"crlf)
)



;Rule for generating initial mrs info for concepts in file "id-cl-mrs_concept.dat"
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
(MRSc-FVs ?mrscon LBL: h* ARG0: x* L_INDEX: x* R_INDEX: x*)
?f<-(rel-ids	k1s	?kri	?k1s)
(construction-ids	conj	$? ?k1s $?)
(MRS_info id-MRS_concept ?implicit ?mrscon)
(test (or (eq ?mrscon implicit_conj) (eq ?mrscon _and_c)) )
(test (eq  (+ ?k1s 200) ?implicit))
(test (neq (str-index _a_ ?mrscon) False))
=>
(retract ?f) 
(assert (MRSc-FVs ?mrscon LBL: h* ARG0: e* L_INDEX: e* R_INDEX: e* L_HNDL: h* R_HNDL: h*))
   (printout ?*mrs-dbug* "(rule-rel-values implict_handle  MRSc-FVs "?mrscon" LBL: h* ARG0: e* L_INDEX: e* R_INDEX: e* L_HNDL: h* R_HNDL: h*)"crlf)
)

;Rule to change the ARG2 value x* to h* of the verb want when it takes a verb as k2
;Ex. Rama wants to sleep.
(defrule want-k2-v
(declare (salience 300))
?f<-(MRS_info ?rel ?kri _want_v_1 ?l ?a0 ?a1 ?a2)
(rel-ids k2   ?kri	?k2)
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
(rel-ids k2   ?kri	?ic)
(MRS_info ?r ?kri  ?mrscon $?v)
(test (neq (str-index _v_ ?mrscon) FALSE))
=>
(retract ?f)
(bind ?arg0 (str-cat "x" (sub-string 2 (str-length ?a0) ?a0)))
(bind ?arg1 (str-cat "i" (sub-string 2 (str-length ?a1) ?a1)))    
(printout ?*mrs-fp* "(MRS_info "?rel" "?ic" card "?l" "?arg0" "?arg1" "?carg")"crlf)
(printout ?*mrs-dbug* "(rule-rel-values card-x-i "?rel" "?ic" card "?l" "?arg0" "?arg1" "?carg")"crlf)
)

;Removing be_v_id for for $kim with k1s relation. 
;How are you?
(defrule rm_be_v_id-how
(declare (salience 10000))
?f<-(id-cl	?kri	hE_1) 
(id-cl	?k1s	$kim)
(rel-ids	k1s	?kri	?k1s)
?f1<-(id-hin_concept-MRS_concept ?kri  hE_1   _be_v_id)
(sent_type  %interrogative)
(not (id-morph_sem	?k1s	?n))
(not (id-anim	?k1s	yes))
=>
(retract ?f ?f1)
(printout ?*mrs-dbug* "(rule-rel-values   rm_be_v_id-how id-MRS_concept " ?kri " hE_1)"crlf)
)



;Rule for changing ARG3 value of verb into i* when it is in a relation of rt.
;He challenged the turtle, for a race.
(defrule verb-ARG3-u
?f<-(MRS_info ?rel ?kri ?mrscon ?l ?a0 ?a1 ?a2 ?a3)
(id-cl	?kri	?hinconcept)
(rel-ids	rt	?kri	?noun)
(test (neq (str-index _v_ ?mrscon) FALSE))
=>
(retract ?f)
(bind ?arg3 (str-cat "u" (sub-string 2 (str-length ?a3) ?a3)))  
(printout ?*mrs-fp* "(MRS_info "?rel" "?kri" "?mrscon" "?l" "?a0" "?a1" "?a2" "?arg3")"crlf)
(printout ?*mrs-dbug* "(rule-rel-values verb-ARG3-i "?rel" "?kri" "?mrscon" "?l" "?a0" "?a1" "?a2" "?arg3")"crlf)
)

;Rule for converting ARG3 of _give_v_1  into u* when there is no k4 relation.  
;Bad works give bad results.
(defrule k4-absent
(id-hin_concept-MRS_concept ?kri ?hin _give_v_1|_explain_v_to|_describe_v_to)
?f<-(MRS_info id-MRS_concept-LBL-ARG0-ARG1-ARG2-ARG3 ?kri ?mrscon ?lbl ?arg0 ?arg1 ?arg2 ?arg3)
(not (rel-ids k4   ?kri    ?id))
=>
(bind ?a3 (str-cat "u" (sub-string 2 (str-length ?arg3) ?arg3)))
(printout ?*mrs-fp* "(MRS_info id-MRS_concept-LBL-ARG0-ARG1-ARG2-ARG3 "?kri" "?mrscon" "?lbl" "?arg0" "?arg1" "?arg2" "?a3")"crlf)
(printout ?*mrs-dbug* "(rule-rel-values k4-absent MRS_info id-MRS_concept-LBL-ARG0-ARG1-ARG2-ARG3 "?kri" "?mrscon" "?lbl" "?arg0" "?arg1" "?arg2" "?a3")"crlf)
)


;Rule for bringing L_HNDL and R_HNDL for _or_c when the construction is in predicative form.
;Rules of udef_q will not work this rule only works for adjective or verb constructions.
;It creates L_HNDL and R_HNDL with h values and L_INDEX and R_INDEX with e values. 
;Is Rama good or bad?
(defrule or_implicit_handle
(declare (salience 5000)) 
(MRSc-FVs implicit_conj LBL: h* ARG0: x* L_INDEX: x* R_INDEX: x*)
?f<-(rel-ids	k1s	?kri	?k1s)
(construction-ids	disjunct	$? ?k1s $?)
(MRS_info id-MRS_concept ?implicit ?mrs)
(MRSc-FVs ?mrscon $?v)
(test (or (eq ?mrs implicit_conj) (eq ?mrs _or_c)) )
(test (neq (str-index _a_ ?mrscon) False))
=>
(retract ?f) 
(assert (MRSc-FVs ?mrs LBL: h* ARG0: e* L_INDEX: e* R_INDEX: e* L_HNDL: h* R_HNDL: h*))
   (printout ?*mrs-dbug* "(rule-rel-values or_implict_handle  MRSc-FVs "?mrs" LBL: h* ARG0: e* L_INDEX: e* R_INDEX: e* L_HNDL: h* R_HNDL: h*)"crlf)
)

(defrule arg2change_not_required
(declare (salience 300))
(id-cl	?verb	?hinconcept)
(rel-ids	k1	?kriya	?verb)
(MRS_info  id-MRS_concept ?nominalized  nominalization)
?f<-(MRSc-FVs ?mrscon LBL: h* ARG0: e* ARG1: x* ARG2: x*)
(test (neq (str-index _v_ ?mrscon) FALSE))
(test (eq  (+ ?verb 200) ?nominalized))
(not (rel-ids k2   ?kri    ?k2))
=>
(assert (verb_bind_notrequired ?mrscon))
(printout ?*mrs-dbug* "(rule-rel-values  arg2change_not_required verb_bind_notrequired "?mrscon")"crlf)
)

;Rule for creating L_HNDL and R_HNDL values for the _and_c predicate when the samuccaya relation exists in the USR.
;and He went.
(defrule samuccaya_and_handles
(declare (salience 5000))
?f<-(rel-ids samuccaya ?previousid	?verb)
(MRSc-FVs _and_c LBL: h* ARG0: x* L_INDEX: x* R_INDEX: x*)
(MRS_info id-MRS_concept ?iddd _and_c)
=>
(retract ?f) 
(assert (MRSc-FVs _and_c LBL: h* ARG0: e* L_INDEX: u* R_INDEX: e* L_HNDL: u* R_HNDL: h*))
   (printout ?*mrs-dbug* "(rule-rel-values samuccaya_and_handles MRSc-FVs _and_c LBL: h* ARG0: e* L_INDEX: u* R_INDEX: e* L_HNDL: u* R_HNDL: h*)"crlf)
)

;Rule for creating L_HNDL and R_HNDL values for the _or_c predicate when the anyawra relation exists in the USR.
;or Mohana will go.
(defrule anyawra_or_handles
(declare (salience 5000))
?f<-(rel-ids anyawra ?previousid	?verb)
(MRSc-FVs _or_c LBL: h* ARG0: x* L_INDEX: x* R_INDEX: x*)
(MRS_info id-MRS_concept ?iddd _or_c)
=>
(retract ?f) 
(assert (MRSc-FVs _or_c LBL: h* ARG0: e* L_INDEX: u* R_INDEX: e* L_HNDL: u* R_HNDL: h*))
   (printout ?*mrs-dbug* "(rule-rel-values anyawra_or_handles MRSc-FVs _or_c LBL: h* ARG0: e* L_INDEX: u* R_INDEX: e* L_HNDL: u* R_HNDL: h*)"crlf)
)
;(MRS_info id-MRS_concept 100  _but_c)
;Rule for creating L_HNDL and R_HNDL values for the _but_c predicate when the viroxi relation exists in the USR.
;But he didn't eat food.
(defrule viroXi_but_handles
(declare (salience 5000))
?f<-(rel-ids viroXi ?previousid	?verb)
(MRSc-FVs _but_c LBL: h* ARG0: e* L_INDEX: e* R_INDEX: e*)
(MRS_info id-MRS_concept ?iddd _but_c)
;(test (eq  (+ ?verb 1000) ?but))
=>
(retract ?f) 
(assert (MRSc-FVs _but_c LBL: h* ARG0: e* L_INDEX: u* R_INDEX: e* L_HNDL: u* R_HNDL: h*))
   (printout ?*mrs-dbug* "(rule-rel-values viroXi_or_handles MRSc-FVs _but_c LBL: h* ARG0: e* L_INDEX: u* R_INDEX: e* L_HNDL: u* R_HNDL: h*)"crlf)
)

;Rule for changing x* into u* for the unknown abstract predicate when kAryakAraNa relation. 
;Because he has to go home. kyoMki vo Gara jAnA hE.
(defrule kAryakAraNa-unknown
(declare (salience 100))
(MRS_info id-MRS_concept ?unknn  ?mrs)
?f<-(rel-ids kAryakAraNa ?previousid	?verb)
(MRSc-FVs ?mrs LBL: h* ARG0: e* ARG: x*)
(test (eq  (+ ?verb 1) ?unknn))
=>
(retract ?f) 
(assert (MRSc-FVs ?mrs LBL: h* ARG0: e* ARG: u*))
(printout ?*mrs-dbug* "(rule-rel-values kAryakAraNa-unknown MRSc-FVs "?mrs" LBL: h* ARG0: e* ARG: u*)" crlf)
)



;Rule for converting arg1 value (x*) of the verb when k1 is absent to u*
;(MRS_info id-MRS_concept-LBL-ARG0-ARG1-ARG2 20000 _read_v_1 h22 e23 x24 u25)
;(MRS_info id-MRS_concept-LBL-ARG0-ARG1 40000 _go_v_1 h26 e27 x28)
;(rel-ids	rsk	jana	2padna0000)
;Ex. Rama went to the school while reading.
(defrule rsk-k1present_ARG1absent
(rel-ids rsk   ?kri    ?verb)
(id-hin_concept-MRS_concept ?verb ?hinconcept ?verbC)
?f<-(MRSc-FVs ?verbC LBL: h* ARG0: e* ARG1: x* ARG2: x*)
(test (neq (str-index _v_ ?verbC) FALSE))
=>
(retract ?f)
(assert (MRSc-FVs ?verbC LBL: h* ARG0: e* ARG1: u* ARG2: u*))
(printout ?*mrs-dbug* "(rule-rel-values rsk-k1present_ARG1absent  MRSc-FVs "?verbC" LBL: h* ARG0: e* ARG1: u* ARG2: u*)"crlf)
)



