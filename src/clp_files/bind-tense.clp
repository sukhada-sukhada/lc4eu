;generates output file "bind-mrs-tense-etc.dat" and contains information of all the tense and MRS relation features
(defglobal ?*tense-etc* = open-tense)
(defglobal ?*tense-etc-dbg* = debug_tense)

;example:-Apa kahAz rahawe hEM?
;solution:-Where do you live?
(defrule tense
?f1<-(id-SF-TENSE-MOOD-PROG-PERF ?id ?sf ?tense ?mood ?prog ?perf )
?f<-(MRS_info ?rel ?id ?mrs ?l ?a0 $?va)
(not (id-morph_sem	?id	doublecausative)) ;mAz ne rAma se bacce ko KAnA KilavAyA.
(not (id-morph_sem	?id	causative)) ;SikRikA ne CAwroM se kakRA ko sAPa karAyA.
(not (id-stative	?id	yes))
(not (id-cl       ?v   hE_1|WA_1))
(not (modified_tense ?id))
(test (eq (str-index "_x_" ?mrs)FALSE)) ;Before the cows were milked, Rama went.
=>
(assert (modified_tense ?id))
(retract ?f1 ?f)
(printout ?*tense-etc* "(tense-MRS_info "?rel" "?id" "?mrs" "?l" "?a0" "?sf" "?tense" "?mood" "?prog" "?perf" "(implode$ (create$ $?va))")" crlf)
(printout ?*tense-etc-dbg* "(rule-rel-values  tense  "?rel " " ?id " " ?mrs " " ?l " " ?a0 "  " ?sf " " ?tense " " ?mood " " ?prog " " ?perf " " (implode$ (create$ $?va)) ")" crlf)
)

;example:-mAz ne rAma se bacce ko KAnA KilavAyA
;solution:-The mother asked Rama to make the child eat food.
(defrule tensedc
(id-morph_sem	?id	doublecausative)
?f1<-(id-SF-TENSE-MOOD-PROG-PERF ?id ?sf ?tense ?mood ?prog ?perf )
?f<-(MRS_info ?rel ?id ?mrs ?l ?a0 $?va)
(not (modified_tense ?id))
(test (neq (str-index _ask_v_1 ?mrs) FALSE))
=>
(assert (modified_tense ?id))
(retract ?f ?f1)
(printout ?*tense-etc* "(tense-MRS_info  "?rel " " ?id " " ?mrs " " ?l " " ?a0 " " ?sf " " ?tense " " ?mood " " ?prog " " ?perf " " (implode$ (create$ $?va)) ")" crlf)
(printout ?*tense-etc-dbg* "(rule-rel-values  tensedc  "?rel " " ?id " " ?mrs " " ?l " " ?a0 " " ?sf " " ?tense " " ?mood " " ?prog " " ?perf " " (implode$ (create$ $?va)) ")" crlf)
)

;example:-SikRikA ne CAwroM se kakRA ko sAPa karAyA.
;solution:-The teacher made the students clean the class.
;Rama made Mohana buy a ticket.
(defrule tensec
(id-morph_sem	?id	causative)
?f1<-(id-SF-TENSE-MOOD-PROG-PERF ?id ?sf ?tense ?mood ?prog ?perf )
?f<-(MRS_info ?rel ?kri ?mrs ?l ?a0 $?va)
(not (modified_tense ?id))
(test (neq (str-index "_v_" ?mrs)FALSE)) 
=>
(assert (modified_tense ?id))
(retract ?f1 ?f)
(printout ?*tense-etc* "(tense-MRS_info "?rel " " ?id " " ?mrs " " ?l " " ?a0 " " ?sf " " ?tense " " ?mood " " ?prog " " ?perf " " (implode$ (create$ $?va)) ")" crlf)
(printout ?*tense-etc-dbg* "(rule-rel-values  tensec  "?rel " " ?id " " ?mrs " " ?l " " ?a0 " " ?sf " " ?tense " " ?mood " " ?prog " " ?perf " " (implode$ (create$ $?va)) ")" crlf)
)

;example:-kuCa bacce koI Kela Kela sakawe hEM.
;solution-Some kids can play any game.
(defrule tensemodal
(declare (salience 10000))
(LTOP-INDEX h0 ?e)
?f1<-(id-SF-TENSE-MOOD-PROG-PERF ?id ?sf ?tense ?mood ?prog ?perf )
?f<-(MRS_info ?rel ?kri ?mrs ?l ?e $?va)
(test (or (neq (str-index _v_modal ?mrs) FALSE) (neq (str-index _v_qmodal ?mrs) FALSE)))
(not (modified_tense ?kri))
=>
(assert (modified_tense ?kri))
(assert (modified_tense ?id))
(retract ?f ?f1)
(printout ?*tense-etc* "(tense-MRS_info  "?rel " " ?id " " ?mrs " " ?l " " ?e " " ?sf " " ?tense " " ?mood " " ?prog " " ?perf " " (implode$ (create$ $?va)) ")" crlf)
(printout ?*tense-etc-dbg* "(rule-rel-values  tensemodal  "?rel " " ?id " " ?mrs " " ?l " " ?e " " ?sf " " ?tense " " ?mood " " ?prog " " ?perf " " (implode$ (create$ $?va)) ")" crlf)
)

;example:-rAma sAzpa ko xeKakara dara gayA
;solution:-Having seen the snake Rama got scared.
(defrule tensest
(id-stative	?id	yes)
(rel-ids	rpk	?id	?id1)
?f1<-(id-SF-TENSE-MOOD-PROG-PERF ?id ?sf untensed ?mood ?prog ?perf)
?f<-(MRS_info ?rel ?id ?mrs ?l ?a0 $?va)
?f2<-(id-SF-TENSE-MOOD-PROG-PERF ?id1 ?sf1 untensed ?mood1 ?prog1 ?perf1)
?f3<-(MRS_info ?rel1 ?id1 ?mrs1 ?l1 ?a01 $?vas)
(not (modified_tense ?id))
=>
(assert (modified_tense ?id))
(retract ?f ?f1 ?f2 ?f3)
(printout ?*tense-etc* "(tense-MRS_info  "?rel " " ?id " " ?mrs " " ?l " " ?a0 " " ?sf " untensed " ?mood " " ?prog " " ?perf " " (implode$ (create$ $?va)) ")" crlf)
(printout ?*tense-etc-dbg* "(rule-rel-values  tensest  "?rel " " ?id " " ?mrs " " ?l " " ?a0 " " ?sf " untensed " ?mood " " ?prog " " ?perf " " (implode$ (create$ $?va)) ")" crlf)
(printout ?*tense-etc* "(tense-MRS_info "?rel1 " " ?id1 " " ?mrs1 " " ?l1 " " ?a01 " " ?sf1 " untensed " ?mood1 " " ?prog1 " " ?perf1 " " (implode$ (create$ $?vas)) ")" crlf)
(printout ?*tense-etc-dbg* "(rule-rel-values  tensest  "?rel1 " " ?id1 " " ?mrs1 " " ?l1 " " ?a01 " " ?sf1 " untensed " ?mood1 " " ?prog1 " " ?perf1 " " (implode$ (create$ $?vas)) ")" crlf)
)

;example:-KaragoSa Waka gayA.
;solution:-The rabbit got tired.
(defrule tenses
(declare (salience -10))
(id-stative	?id	yes)
?f1<-(id-SF-TENSE-MOOD-PROG-PERF ?id ?sf ?tense ?mood ?prog ?perf)
?f<-(MRS_info ?rel ?kri ?mrs ?l ?a0 $?va)
(test (eq ?kri (+ ?id 100)))
(not (modified_tensest ?id))
=>
(assert (modified_tensest ?id))
(retract ?f1 ?f)
(printout ?*tense-etc* "(tense-MRS_info  "?rel " " ?id " " ?mrs " " ?l " " ?a0 " " ?sf " "?tense" " ?mood " " ?prog " " ?perf " " (implode$ (create$ $?va)) ")" crlf)
(printout ?*tense-etc-dbg* "(rule-rel-values  tenses  "?rel " " ?id " " ?mrs " " ?l " " ?a0 " " ?sf " "?tense" " ?mood " " ?prog " " ?perf " " (implode$ (create$ $?va)) ")" crlf)
)

;example:-yaha Gara hE.
;solution:-This is a house.
(defrule tensexs
(declare (salience -10))
(id-cl       ?v   hE_1|WA_1)
?f1<-(id-SF-TENSE-MOOD-PROG-PERF ?id ?sf ?tense ?mood ?prog ?perf )
?f<-(MRS_info ?rel ?id ?mrs ?l ?a0 $?va)
(not (id-morph_sem	?id	doublecausative))
(not (modified_tensexs ?id))
=>
(assert (modified_tensexs ?id))
(retract ?f ?f1)
(printout ?*tense-etc* "(tense-MRS_info "?rel " " ?id " " ?mrs " " ?l " " ?a0 " " ?sf " "?tense" " ?mood " " ?prog " " ?perf " " (implode$ (create$ $?va)) ")" crlf)
(printout ?*tense-etc-dbg* "(rule-rel-values  tensexs  "?rel " " ?id " " ?mrs " " ?l " " ?a0 " " ?sf " "?tense" " ?mood " " ?prog " " ?perf " " (implode$ (create$ $?va)) ")" crlf)
)

;example:-vaha kiwAba suMxara hE.
;solution:-That book is beautiful.
(defrule tensexstad
(id-cl       ?v   hE_1|WA_1)
(rel-ids   k1s        ?v  ?id)
?f1<-(id-SF-TENSE-MOOD-PROG-PERF ?v ?sf ?tense ?mood ?prog ?perf )
?f<-(MRS_info ?rel ?id ?mrs ?l ?a0 $?va)
(test(neq (str-index "_a_" ?mrs)FALSE))
(not (construction-ids	conj	$? ?id $?)) ;#Rama buxXimAna, motA, xilera, Ora accA hE.
(not (modified_tensexstad ?id))
=>
(assert (modified_tenseexstad ?id))
(retract ?f ?f1)
(printout ?*tense-etc* "(tense-MRS_info "?rel " " ?id " " ?mrs " " ?l " " ?a0 " " ?sf " "?tense" " ?mood " " ?prog " " ?perf " " (implode$ (create$ $?va)) ")" crlf)
(printout ?*tense-etc-dbg* "(rule-rel-values  tensexstad  "?rel " " ?id " " ?mrs " " ?l " " ?a0 " " ?sf " "?tense" " ?mood " " ?prog " " ?perf " " (implode$ (create$ $?va)) ")" crlf)
)

;Rule for creating tense to the head of the sentence when the sentence is in construction form. 
;Here it creates tense for the first implicit_conj when the construction is in predicative construction.
;#Rama buxXimAna, motA, xilera, Ora accA hE.
(defrule tenseConj_adj
(declare (salience 1000))
(id-cl       ?v   hE_1|WA_1)
(rel-ids   k1s        ?v  ?id)
(construction-ids	conj	$? ?id $? ?x ?y)
(id-SF-TENSE-MOOD-PROG-PERF ?v ?sf ?tense ?mood ?prog ?perf )
?f<-(MRS_info ?rel ?id ?mrs ?l ?a0 $?va)
(test(neq (str-index "_a_" ?mrs)FALSE))
(not (modified_tensexstad ?id))
=>
(assert (modified_tenseexstad ?id))
(retract ?f)
(printout ?*tense-etc* "(tense-MRS_info "?rel " " ?id " " ?mrs " " ?l " " ?a0 " " ?sf " "?tense" " ?mood " " ?prog " " ?perf " " (implode$ (create$ $?va)) ")" crlf)
(printout ?*tense-etc-dbg* "(rule-rel-values  tenseConj_adj  "?rel " " ?id " " ?mrs " " ?l " " ?a0 " " ?sf " "?tense" " ?mood " " ?prog " " ?perf " " (implode$ (create$ $?va)) ")" crlf)
)


;Rule for creating TENSE information for the implicit_conj when it is became the head of the sentence.
;Rama is intelligent, calm, brave, and good.
(defrule tenseimplicit_conjarg0
(declare (salience 1000))
(rel-ids   k1s        ?v  ?k1s)
(construction-ids	conj	?k1s $?)
(id-SF-TENSE-MOOD-PROG-PERF ?v ?sf ?tense ?mood ?prog ?perf )
?f<-(MRS_info id-MRS_concept-LBL-ARG0-L_INDEX-R_INDEX-L_HNDL-R_HNDL ?imconid implicit_conj ?lbl ?arg0 $?vs)
(test (eq  (+ ?k1s 200) ?imconid))
=>
(retract ?f)
(printout ?*tense-etc* "(tense-MRS_info id-MRS_concept-LBL-ARG0-L_INDEX-R_INDEX-L_HNDL-R_HNDL "?imconid" implicit_conj "?lbl" "?arg0" " ?sf " "?tense" " ?mood " " ?prog " " ?perf " " (implode$ (create$ $?vs)) ")" crlf)
(printout ?*tense-etc-dbg* "(rule-rel-values  tenseimplicit_conjarg0  id-MRS_concept-LBL-ARG0-L_INDEX-R_INDEX-L_HNDL-R_HNDL "?imconid" implicit_conj "?lbl" "?arg0" " ?sf " "?tense" " ?mood " " ?prog " " ?perf " " (implode$ (create$ $?vs)) ")" crlf)
)


;example:-mEM Delhi meM hUz.
;Eng-I am in Delhi.
(defrule tensexsti
(id-cl       ?v   hE_1|WA_1)
(rel-ids   k7p        ?v  ?id)
?f1<-(id-SF-TENSE-MOOD-PROG-PERF ?v ?sf ?tense ?mood ?prog ?perf )
?f<-(MRS_info ?rel ?id1 _in_p ?l ?a0 $?va)
(not (modified_tensexsti ?id1))
(not (id-morph_sem	?id	doublecausative))
(test (eq ?id1 (+ ?id 1)))
(not (rel-ids   k1s       ?v  ?id2))
=>
(assert (modified_tenseexsti ?id1))
(retract ?f ?f1)
(printout ?*tense-etc* "(tense-MRS_info  "?rel " " ?id1 " _in_p " ?l " " ?a0 " " ?sf " "?tense" " ?mood " " ?prog " " ?perf " " (implode$ (create$ $?va)) ")" crlf)
(printout ?*tense-etc-dbg* "(rule-rel-values  tensexsti  "?rel " " ?id1 " _in_p " ?l " " ?a0 " " ?sf " "?tense" " ?mood " " ?prog " " ?perf " " (implode$ (create$ $?va)) ")" crlf)
)


(defrule print-ltop
?f1<- (LTOP-INDEX ?rel1  $?vars) 
=>
(retract ?f1)
(printout ?*tense-etc*   "(LTOP-INDEX  "?rel1 " " (implode$ (create$ $?vars)) ")"crlf)
(printout ?*tense-etc-dbg* "(rule-rel-values  print-ltop LTOP-INDEX  "?rel1 " " (implode$ (create$ $?vars)) ")"crlf)
)

(defrule print-mrs
(declare (salience -1000))
?f1<-(MRS_info ?rel1  ?id ?mrs $?vars)
;(test (neq (sub-string (- (str-length ?mrs) 1) (str-length ?mrs) ?mrs) "_q"))
;(test (neq (sub-string (- (str-length ?mrs) 3) (str-length ?mrs) ?mrs) "_dem"))
(not (modified_tense_modal ?id))
=>
(retract ?f1)
(printout ?*tense-etc*   "(MRS_info  "?rel1 " " ?id " " ?mrs " " (implode$ (create$ $?vars)) ")"crlf)
(printout ?*tense-etc-dbg* "(rule-rel-values  print-mrs  "?rel1 " " ?id " " ?mrs " " (implode$ (create$ $?vars)) ")"crlf)
)

(defrule ya_hoga_2
(kriyA-TAM	?kriya	yA_hogA_2)
(id-cl	?kriya	?hinconcept)
?f1<-(id-SF-TENSE-MOOD-PROG-PERF ?id ?sf ?tense ?mood ?prog ?perf )
(MRS_info ?rel ?kriya ?mrscon ?lbl ?arg0 $?v)
(test (eq (str-index _v_modal ?mrscon) FALSE))
=>
(printout ?*tense-etc* "(tense-MRS_info "?rel" "?kriya" "?mrscon" "?lbl" "?arg0" "?sf" "?tense" "?mood" "?prog" "?perf" "(implode$ (create$ $?v))")" crlf)
(printout ?*tense-etc-dbg* "(rule-rel-values ya_hoga_2  "?rel" "?kriya" "?mrscon" "?lbl" "?arg0" "?sf" "?tense" "?mood" "?prog" "?perf" " (implode$ (create$ $?v)) ")" crlf)
)


