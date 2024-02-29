;generates output file "mrs_info.dat" that contains id and MRS concept for a and the.
;udef_q for plural noun and mass noun.
;neg for negation.

(defglobal ?*mrsdef* = mrs-def-fp)
(defglobal ?*defdbug* = mrs-def-dbug)

;(rel_name-ids	card	30000	20000)

;Rule for generating udef_q for plural nouns. 
;Rule for plural noun : if (?n is pl) generate ((id-MRS_Rel ?id _udef_q)
(defrule mrs_pl_notDef
(id-num	?id	?n)
(or (test (eq ?n pl))(id-abs ?id yes) (rel_name-ids meas ?id ?)(rel_name-ids card ?id ?))
(not (id-def ?id yes))
(not (id-mass ?id yes))
(not (rel_name-ids dem ?id ?v))
(not (rel_name-ids quant ?id ?v))
(not (rel_name-ids r6 ?id ?v))
(not(id-concept_label	?id 	?concept&speaker|addressee|wyax|saba_4))
(not (rel_name-ids coref ?	?id))
=>
(printout ?*mrsdef* "(MRS_info id-MRS_concept "(+ ?id 10) " udef_q)"crlf)
(printout ?*defdbug* "(rule-rel-values mrs_pl_notDef id-MRS_concept "(+ ?id 10)" udef_q)"crlf)
)

;Rule for mass noun : if (id-mass ?id yes) , generate (id-MRS_Rel ?id _udef_q)
(defrule mrs_mass_notDef
;(id-num	?id	?n)
(id-mass ?id yes)
(not (id-def ?id yes))
(not (rel_name-ids dem ?id ?))
(not (rel_name-ids quant ?id ?))
(not (sentence_type	)) ;;#kuwwA! ;#billI Ora kuwwA.
=>
(printout ?*mrsdef* "(MRS_info id-MRS_concept "(+ ?id 10)" udef_q)"crlf)
(printout ?*defdbug* "(rule-rel-values  mrs_mass_notDef id-MRS_concept "(+ ?id 10)" udef_q)"crlf)
)

;Rule for mass noun : if (id-mass ?id yes) , generate (id-MRS_Rel ?id _udef_q)
(defrule mrs_numex
(id-concept_label	?id	eka_1)
(id-concept_label	?noun	?hinconcept)
(rel_name-ids	card	?noun	?id)
(id-numex ?id yes)
=>
(printout ?*mrsdef* "(MRS_info id-MRS_concept "(+ ?noun 10)" udef_q)"crlf)
(printout ?*defdbug* "(rule-rel-values  mrs_numex id-MRS_concept "(+ ?noun 10)" udef_q)"crlf)
)

;Rule for creating unknown for non-sentence type.
;In case of topic names we need to generate unknown and udef_q.
(defrule udef_unknown-pl
(id-num	?id	pl)
(sentence_type	)
=>
(printout ?*mrsdef* "(MRS_info id-MRS_concept 0000000 unknown)"crlf)
(printout ?*defdbug* "(rule-rel-values  udef_unknown-pl id-MRS_concept 0000000 unknown)"crlf)
)

;Rule for creating unknown for non-sentence type.
;In case of topic names we need to generate unknown and udef_q for Plurals
(defrule udef_unknown-sg
(sentence_type	)
(not (id-num	?id	pl))
=>
(printout ?*mrsdef* "(MRS_info id-MRS_concept 0000000 unknown)"crlf)
(printout ?*defdbug* "(rule-rel-values  udef_unknown-sg id-MRS_concept 0000000 unknown)"crlf)
)

;rAma dAktara nahIM hE.	 rAma xillI meM nahIM hE. #usane KAnA nahIM KAyA. #use Gara nahIM jAnA cAhie.
(defrule mrs_neg_notDef
(rel_name-ids neg  ?kid ?negid)
=>
(printout ?*mrsdef* "(MRS_info id-MRS_concept "?negid " neg)"crlf)
(printout ?*defdbug* "(rule-rel-values mrs_neg_notDef id-MRS_concept "?negid " neg)"crlf)
)

;Rule for proper noun: if ((id-propn ?id yes) is present, generate (id-MRS_concept ?id proper_q) and  (id-MRS_concept ?id named)
(defrule mrs_propn
(or (id-per  ?id yes) (id-place  ?id yes) (id-org  ?id yes)  (id-ne  ?id yes) )
(not (rel_name-ids coref ?idd	?id))
=>
(printout ?*mrsdef* "(MRS_info id-MRS_concept "(+ ?id 10) " proper_q)"crlf)
(printout ?*defdbug* "(rule-rel-values mrs_propn  id-MRS_concept "(+ ?id 10)" proper_q)"crlf)

(printout ?*mrsdef* "(MRS_info id-MRS_concept "?id " named)"crlf)
(printout ?*defdbug* "(rule-rel-values mrs_propn  id-MRS_concept "?id " named)"crlf)
)

;rule for interrogative sentences for 'what',
;generates (id-MRS_concept "?id " thing)
;	   (id-MRS_concept "?id " which_q)
(defrule mrs_inter_what
(id-concept_label ?id kim)
(rel_name-ids	k2	?kri	?id)
(not (id-anim	?id	yes))
=>
(printout ?*mrsdef* "(MRS_info id-MRS_concept "(+ ?id 10) " which_q)"crlf)
(printout ?*defdbug* "(rule-rel-values mrs_inter_what  id-MRS_concept "(+ ?id 10)" which_q)"crlf)
(printout ?*mrsdef* "(MRS_info id-MRS_concept "?id" thing)"crlf)
(printout ?*defdbug* "(rule-rel-values mrs_inter_what id-MRS_concept "?id" thing)"crlf)
)

;Who did fill the pot, with water?
;rule for interrogative sentences for 'who',
;generates (id-MRS_concept "?id " person)
;	   (id-MRS_concept "?id " which_q)
(defrule mrs_inter_who
(id-concept_label ?id kim)
(rel_name-ids	k1	?kri	?id)
=>
(printout ?*mrsdef* "(MRS_info id-MRS_concept "(+ ?id 10) " which_q)"crlf)
(printout ?*defdbug* "(rule-rel-values mrs_inter_who  id-MRS_concept " (+ ?id 10) " which_q)"crlf)
(printout ?*mrsdef* "(MRS_info id-MRS_concept "?id" person)"crlf)
(printout ?*defdbug* "(rule-rel-values mrs_inter_who id-MRS_concept "?id" person)"crlf)
)

;Who are you?
;rule for interrogative sentences for 'who',
;generates (id-MRS_concept "?id " person)
;	   (id-MRS_concept "?id " which_q)
(defrule mrs_inter_who-k1s
(id-concept_label ?id kim)
(rel_name-ids	k1s	?kri	?id)
(id-num	?id	pl)
(id-anim	?id	yes)
=>
(printout ?*mrsdef* "(MRS_info id-MRS_concept "(+ ?id 10) " which_q)"crlf)
(printout ?*defdbug* "(rule-rel-values mrs_inter_who-k1s-pl id-MRS_concept " (+ ?id 10) " which_q)"crlf)
(printout ?*mrsdef* "(MRS_info id-MRS_concept "?id" person)"crlf)
(printout ?*defdbug* "(rule-rel-values mrs_inter_who-k1s-pl id-MRS_concept "?id" person)"crlf)
)

;Who are you?
;rule for interrogative sentences for 'who',
;generates (id-MRS_concept "?id " person)
;	   (id-MRS_concept "?id " which_q)
(defrule mrs_inter_who-k1s
(id-concept_label ?id kim)
(rel_name-ids	k1s	?kri	?id)
(id-anim	?id	yes)
(not (id-num	?id	pl))
=>
(printout ?*mrsdef* "(MRS_info id-MRS_concept "(+ ?id 10) " which_q)"crlf)
(printout ?*defdbug* "(rule-rel-values mrs_inter_who-k1s-sg id-MRS_concept " (+ ?id 10) " which_q)"crlf)
(printout ?*mrsdef* "(MRS_info id-MRS_concept "?id" person)"crlf)
(printout ?*defdbug* "(rule-rel-values mrs_inter_who-k1s-sg id-MRS_concept "?id" person)"crlf)
)

;Rule for generating person and which_q for generating whom in the MRS 
;Whom did Rama meet? ;Whom did Rama ask a question?
(defrule mrs_inter_whom
(id-concept_label ?id kim)
(rel_name-ids	k2|k2g|k4	?kri	?id)
(id-anim	?id	yes)
=>
(printout ?*mrsdef* "(MRS_info id-MRS_concept "(+ ?id 10) " which_q)"crlf)
(printout ?*defdbug* "(rule-rel-values mrs_inter_whom  id-MRS_concept " (+ ?id 10) " which_q)"crlf)
(printout ?*mrsdef* "(MRS_info id-MRS_concept "?id" person)"crlf)
(printout ?*defdbug* "(rule-rel-values mrs_inter_whom id-MRS_concept "?id" person)"crlf)
)

;rule for interrogative sentences for 'where',
;generates (id-MRS_concept "?id " place)
;          (id-MRS_concept "?id " which_q)
(defrule mrs_inter_where
(id-concept_label ?id kim)
(rel_name-ids	k7p|k2p	?kri	?id)
=>
(printout ?*mrsdef* "(MRS_info id-MRS_concept "(+ ?id 10)" which_q)"crlf)
(printout ?*defdbug* "(rule-rel-values mrs_inter_where id-MRS_concept "(+ ?id 10)" which_q)"crlf)

(printout ?*mrsdef* "(MRS_info id-MRS_concept "(+ ?id 10)" loc_nonsp)"crlf)
(printout ?*defdbug* "(rule-rel-values mrs_inter_where id-MRS_concept "(+ ?id 10)" loc_nonsp)"crlf)

(printout ?*mrsdef* "(MRS_info id-MRS_concept "?id" place_n)"crlf)
(printout ?*defdbug* "(rule-rel-values mrs_inter_where id-MRS_concept "?id" place_n)"crlf)
)

;written by sakshi yadav (NIT-Raipur)
;date-27.05.19
;rule for sentence -consists of word 'home'
; example -i am coming home
;generates (id-MRS_concept "?id " place_n)
;          (id-MRS_concept "?id " def_implicit_q)
;          (id-MRS_concept "?id " loc_nonsp)
(defrule mrs_place
(id-concept_label ?id Gara_1|vahAz_1|bAhara_2)
(not (id-concept_label ?id bAhara_1))
=>
(printout ?*mrsdef* "(MRS_info id-MRS_concept "?id " place_n)"crlf)
(printout ?*defdbug* "(rule-rel-values mrs_place id-MRS_concept "?id " place_n)"crlf)

;(printout ?*mrsdef* "(MRS_info id-MRS_concept "(+ ?id 10)" def_implicit_q)"crlf)
(printout ?*mrsdef* "(MRS_info id-MRS_concept "?id" def_implicit_q)"crlf)
(printout ?*defdbug* "(rule-rel-values mrs_place id-MRS_concept "?id " def_implicit_q)"crlf)

;(printout ?*mrsdef* "(MRS_info id-MRS_concept "(+ ?id 10) " loc_nonsp)"crlf)
(printout ?*mrsdef* "(MRS_info id-MRS_concept "?id " loc_nonsp)"crlf)
(printout ?*defdbug* "(rule-rel-values mrs_place id-MRS_concept "?id " loc_nonsp)"crlf)
)

; written by sakshi yadav (NIT-Raipur)
; date-27.05.19
;rule for sentence -consists of words 'yesterday','today','tomorrow' 
;example -i came yesterday
;generates (id-MRS_concept "?id " time_n)
;          (id-MRS_concept "?id " def_implicit_q)
;          (id-MRS_concept "?id " loc_nonsp)
(defrule mrs_kala
(id-concept_label ?id pahale_4|kala_1|kala_2|Aja_1|jalxI_9|xera_11|aba_1)
(rel_name-ids   ?relname        ?id1  ?id2)	;To restrict the generation of "loc_nonsp" when "kala, Aja" are in "samanadhikaran" relation.
=>
(printout ?*mrsdef* "(MRS_info id-MRS_concept "?id " time_n)"crlf)
(printout ?*defdbug* "(rule-rel-values mrs_kala  id-MRS_concept "?id " time_n)"crlf)

;(printout ?*mrsdef* "(MRS_info id-MRS_concept "(+ ?id 10)" def_implicit_q)"crlf)
(printout ?*mrsdef* "(MRS_info id-MRS_concept "?id" def_implicit_q)"crlf)
(printout ?*defdbug* "(rule-rel-values mrs_kala  id-MRS_concept "?id" def_implicit_q)"crlf)

(if (neq ?relname samAnAXi) then	;;To restrict the generation of "loc_nonsp" when "kala, Aja" are in "samanadhikaran" relation.e.g Today is Monday.
 ;(printout ?*mrsdef* "(MRS_info id-MRS_concept "(+ ?id 10)" loc_nonsp)"crlf)
 (printout ?*mrsdef* "(MRS_info id-MRS_concept "?id" loc_nonsp)"crlf)
 (printout ?*defdbug* "(rule-rel-values mrs_kala  id-MRS_concept "?id" loc_nonsp)"crlf)
)
)

;written by sakshi yadav(NIT Raipur) Date-7.06.19
;Generates new facts for days of weeks then generate (MRS_info id-MRS_concept ?id _on_p_temp) and (MRS_info id-MRS_concept ?id dofw) and  (MRS_info id-MRS_concept ?id proper_q) 
(defrule daysofweeks
(id-concept_label	?id	?hinconcept)
(id-dow	?id	yes)
=>
(printout ?*mrsdef* "(MRS_info id-MRS_concept "?id " dofw)"crlf)
(printout ?*defdbug* "(rule-rel-values  daysofweeks id-MRS_concept "?id " dofw)"crlf)
(printout ?*mrsdef* "(MRS_info id-MRS_concept "(+ ?id 10) " proper_q)"crlf)
(printout ?*defdbug* "(rule-rel-values  daysofweeks id-MRS_concept "(+ ?id 10) " proper_q)"crlf)
)

;written by sakshi yadav(NIT Raipur) Date-11.06.19
;Generates new facts for months of years then generate (MRS_info id-MRS_concept ?id _on_p_temp) and (MRS_info id-MRS_concept ?id mofy) and  (MRS_info id-MRS_concept ?id proper_q) 
(defrule monthsofyears
(id-concept_label ?id ?hinconcept)
(id-moy	 ?id yes)
=>
(printout ?*mrsdef* "(MRS_info id-MRS_concept "?id " mofy)"crlf)
(printout ?*defdbug* "(rule-rel-values  monthsofyears id-MRS_concept "?id" mofy)"crlf)
(printout ?*mrsdef* "(MRS_info id-MRS_concept "(+ ?id 10) " proper_q)"crlf)
(printout ?*defdbug* "(rule-rel-values  monthsofyears id-MRS_concept "(+ ?id 10)" proper_q)"crlf)
)

(defrule yearsofcenturies
(id-concept_label ?id ?num)
(rel_name-ids k7t ?kri  ?id&:(numberp ?id))
(not (id-concept_label  ?k-id   ?hiConcept&kim|Aja_1|kala_1|kala_2|rAwa_1|xina_1|jalxI_9|xera_11|aba_1|pahale_4|rojZa_2|subaha_1|bAxa_1|sarxI_2|bAxa_14|GantA_1|xopahara_2))
;(test (eq (str-index "+baje" ?num) FALSE))
=>
(printout ?*mrsdef* "(MRS_info id-MRS_concept "(+ ?id 10)" proper_q)"crlf)
(printout ?*defdbug* "(rule-rel-values  yearsofcenturies id-MRS_concept "(+ ?id 10) " proper_q)"crlf)
)

(defrule dayandnight
(id-concept_label ?id ?num)
(rel_name-ids k7t ?kri  ?id&:(numberp ?id))
(id-concept_label  ?k-id   ?hiConcept&rAwa_1)
=>
(printout ?*mrsdef* "(MRS_info id-MRS_concept "?id " def_implicit_q)"crlf)
(printout ?*defdbug* "(rule-rel-values  yearsofcenturies id-MRS_concept "?id" def_implicit_q)"crlf)
)

(defrule mrs_parg_d
(sentence_type  pass-affirmative|pass-interrogative)
(kriyA-TAM ?kri ?tam)
(not (rel_name-ids	rpk	?id	?kri))
=>
(printout ?*mrsdef* "(MRS_info id-MRS_concept "?kri " parg_d)"crlf)
(printout ?*defdbug* "(rule-rel-values mrs_parg_d  id-MRS_concept "?kri" parg_d)"crlf)
)

;#rAma ne skUla jAkara KAnA KAyA.
(defrule mrs_subord
(rel_name-ids	rpk	?id	?kri)
=>
(printout ?*mrsdef* "(MRS_info id-MRS_concept -20000 subord)"crlf)
(printout ?*defdbug* "(rule-rel-values mrs_subord id-MRS_concept -20000 subord)"crlf)
)

;rule for interrogative sentences for 'when'
(defrule mrs_inter_when
(id-concept_label ?id kim)
(rel_name-ids	k7t	?kri	?id)
=>
(printout ?*mrsdef* "(MRS_info id-MRS_concept "(+ ?id 10) " which_q)"crlf)
(printout ?*defdbug* "(rule-rel-values mrs_inter_when  id-MRS_concept "(+ ?id 10)" which_q)"crlf)

(printout ?*mrsdef* "(MRS_info id-MRS_concept "?id " time_n)"crlf)
(printout ?*defdbug* "(rule-rel-values mrs_inter_when  id-MRS_concept "?id " time_n)"crlf)

(printout ?*mrsdef* "(MRS_info id-MRS_concept "(+ ?id 10)" loc_nonsp)"crlf)
(printout ?*defdbug* "(rule-rel-values mrs_inter_when  id-MRS_concept "(+ ?id 10) " loc_nonsp)"crlf)
)

;Rule for generating the mrs_concept: nominalization, for kriyArWa_kriyA
; #mEM Kelane ke liye krIdAMgaNa meM gayA.
; I went to the playground for playing.
; (rel_name-ids	kriyArWa_kriyA	40000	20000)
(defrule nominalization
(rel_name-ids	k1	?kri ?krikri)
(id-hin_concept-MRS_concept ?krikri ?hinconcept ?mrsconcept)
(test (neq (str-index _v_ ?mrsconcept) FALSE))
=>
(printout ?*mrsdef* "(MRS_info  id-MRS_concept "(+ ?krikri 200) "  nominalization)"crlf)
(printout ?*defdbug* "(rule-rel-values    nominalization  id-MRS_concept "(+ ?krikri 200) "  nominalization)"crlf)

(printout ?*mrsdef* "(MRS_info  id-MRS_concept "(+ ?krikri 10) "  udef_q)"crlf)
(printout ?*defdbug* "(rule-rel-values  nominalization   id-MRS_concept "(+ ?krikri 10) "  udef_q)"crlf)
)

;Generate 'superl' mrs_concept for superlative degree adjectives
;#sUrya sabase badA nakRawra hE.
;The sun is the largest star.
;(id-degree      20000   superl)
(defrule superl
(id-degree	?id	superl)
=>
(printout ?*mrsdef* "(MRS_info  id-MRS_concept "(+ ?id 10) "  superl)"crlf)
(printout ?*defdbug* "(rule-rel-values  superl   id-MRS_concept "(+ ?id 10) "  superl)"crlf)
)

;Rule for creating comp mrs concept for comparative sentences.
;#rAma mohana se jyAxA buxXimAna hE.
(defrule compermore
(id-degree	?id	compermore)
=>
(printout ?*mrsdef* "(MRS_info  id-MRS_concept "(+ ?id 20) "  comp)"crlf)
(printout ?*defdbug* "(rule-rel-values  compermore   id-MRS_concept "(+ ?id 20) "  comp)"crlf)
)

;Rule for creating comp mrs concept for comparative sentences.
;#rAma mohana se kama buxXimAna hE .
(defrule comperless
(id-degree	?id comperless)
=>
(printout ?*mrsdef* "(MRS_info  id-MRS_concept "(+ ?id 30) "  comp_less)"crlf)
(printout ?*defdbug* "(rule-rel-values  compermore   id-MRS_concept "(+ ?id 30) "  comp_less)"crlf)
)

;Rule for bringing comp_equal for ru relation.
(defrule comper-equal
(rel_name-ids ru ?id ?id1)
(rel_name-ids	k1	?kri	?id) ;#गुलाब जैसे फूल पानी में नहीं उगते हैं।
(rel_name-ids	k1s	?kri	?adj)
=>
(printout ?*mrsdef* "(MRS_info  id-MRS_concept "(+ ?id 40) "  comp_equal)"crlf)
(printout ?*defdbug* "(rule-rel-values  comper-equal   id-MRS_concept "(+ ?id 40) "  comp_equal)"crlf)
)

;Rule for creating implicit_conj when the construction is more than two values. 
;Ex. Rama buxXimAna, motA, xilera, Ora accA hE.
(defrule implicit_conj
(construction-ids	conj  $?v)
=>
(bind ?count (length$ (create$ $?v)))
(if (> ?count 2)  then
  (loop-for-count (?i 1  (- ?count 2))
   (printout ?*mrsdef* "(MRS_info id-MRS_concept "(+  (nth$ ?i (create$ $?v)) 600)" implicit_conj)"crlf)
   (printout ?*defdbug* "(rule-rel-values implicit_conj id-MRS_concept "(+  (nth$ ?i (create$ $?v)) 600)" implicit_conj)"crlf)
)))

;Rule for creating ude_q when the construction values are in subjective position with noun entries. 
;Ex. rAma, hari Ora sIwA acCe hEM.
(defrule implicit_conj4pred-pl
(construction-ids	conj  $? ?n $? ?x ?y)
(rel_name-ids   ?rel        ?id ?n)
(id-per	?n	yes)
=>
(printout ?*mrsdef* "(MRS_info id-MRS_concept "(+ ?n 10)" udef_q)"crlf)
(printout ?*defdbug* "(rule-rel-values implicit_conj4pred-pl id-MRS_concept "(+ ?n 10)" udef_q)"crlf)
)

;Rule for creating ude_q when the construction values are in subjective position with noun entries. 
;Ex. rAma, hari Ora sIwA acCe hEM.
(defrule implicit_conj4pred
(construction-ids	conj  $? ?n $? ?x ?y)
(rel_name-ids   ?rel        ?id ?n)
(id-concept_label	?n	?hincon)
(id-hin_concept-MRS_concept ?n ?hin ?mrscon)
(not (id-num	?n	?pl))
(test (eq (str-index _a_ ?mrscon) FALSE))
=>
(printout ?*mrsdef* "(MRS_info id-MRS_concept "(+ ?n 10)" udef_q)"crlf)
(printout ?*defdbug* "(rule-rel-values implicit_conj4pred-sg id-MRS_concept "(+ ?n 10)" udef_q)"crlf)
)

;Rule for creating udef_q for when the sentence consists of only two noun entries in the construction for unknown.
;#billI Ora kuwwA.
(defrule implicit_conj4unknown
(construction-ids	conj  ?n ?y)
(id-concept_label	?n	?hincon)
(id-num	?n	?pl)
=>
(printout ?*mrsdef* "(MRS_info id-MRS_concept "(+ ?n 10)" udef_q)"crlf)
(printout ?*defdbug* "(rule-rel-values implicit_conj4unknown-pl id-MRS_concept "(+ ?n 10)" udef_q)"crlf)
)

;Rule for creating udef_q for the construction with two subjective entries. 
;;#rAma Ora sIwA acCe hEM.
(defrule udefq_conj4subj-pl
(declare (salience 100))
(construction-ids	conj  $? ?n ?y)
(id-concept_label	?n	?hincon)
(id-per	?n	yes)
=>
(printout ?*mrsdef* "(MRS_info id-MRS_concept "(+ ?n 10)" udef_q)"crlf)
(printout ?*defdbug* "(rule-rel-values udefq_conj4subj-pl id-MRS_concept "(+ ?n 10)" udef_q)"crlf)
)

;Rule for creating udef_q for the construction with two subjective entries. 
;;#rAma Ora sIwA acCe hEM.
(defrule udefq_conj4subj-sg
(declare (salience 100))
(construction-ids	conj  $? ?n ?y)
(id-concept_label	?n	?hincon)
(id-hin_concept-MRS_concept ?n ?hincon ?mrscon)
(test (eq (str-index _a_ ?mrscon) FALSE))
(not (id-num	?n	?pl))
=>
(printout ?*mrsdef* "(MRS_info id-MRS_concept "(+ ?n 10)" udef_q)"crlf)
(printout ?*defdbug* "(rule-rel-values udefq_conj4subj-sg id-MRS_concept "(+ ?n 10)" udef_q)"crlf)
)

;Rule for bringing number_q when card is coming in the k2 position.
;The cat chased one.
(defrule eka-k2
(id-concept_label	?ic	eka_1)
(rel_name-ids	k2	?kri	?ic)
=>
(printout ?*mrsdef* "(MRS_info id-MRS_concept "(+ ?ic 50)" number_q)"crlf)
(printout ?*defdbug* "(rule-rel-values eka-k2 id-MRS_concept "(+ ?ic 50)" number_q)"crlf)
)

;Rule to bring def_implicit_q and poss for the sentences with whose word.
;;#kiska kuwwA BOMkA? 
(defrule mrs_inter_whose
(id-concept_label ?id kim)
(rel_name-ids	r6	?noun	?id)
=>
(printout ?*mrsdef* "(MRS_info id-MRS_concept "(+ ?id 10) " def_implicit_q)"crlf)
(printout ?*defdbug* "(rule-rel-values mrs_inter_whose  id-MRS_concept "(+ ?id 10)" def_implicit_q)"crlf)

(printout ?*mrsdef* "(MRS_info id-MRS_concept "(+ ?id 11) " poss)"crlf)
(printout ?*defdbug* "(rule-rel-values mrs_inter_whose  id-MRS_concept "(+ ?id 11)" poss)"crlf)

(printout ?*mrsdef* "(MRS_info id-MRS_concept "?id " person)"crlf)
(printout ?*defdbug* "(rule-rel-values mrs_inter_whose  id-MRS_concept "?id " person)"crlf)

(printout ?*mrsdef* "(MRS_info id-MRS_concept "(+ ?id 10) " which_q)"crlf)
(printout ?*defdbug* "(rule-rel-values mrs_inter_whose  id-MRS_concept "(+ ?id 10) " which_q)"crlf)
)

;Rule for bringing which_q, property, unspec_adj, prpstn_to_prop for sentence ;How are you?
(defrule mrs_inter_how
(id-concept_label	?id	kim)
(rel_name-ids	k1s	?kri	?id)
(not (id-num	?id	?n))
(not (id-anim	?id	yes))
=>
(printout ?*mrsdef* "(MRS_info id-MRS_concept "(+ ?id 10) " which_q)"crlf)
(printout ?*defdbug* "(rule-rel-values mrs_inter_how  id-MRS_concept "?id " which_q)"crlf)

(printout ?*mrsdef* "(MRS_info id-MRS_concept "(+ ?id 2) " property)"crlf)
(printout ?*defdbug* "(rule-rel-values mrs_inter_how  id-MRS_concept "?id " property)"crlf)

(printout ?*mrsdef* "(MRS_info id-MRS_concept "(+ ?id 3) " unspec_adj)"crlf)
(printout ?*defdbug* "(rule-rel-values mrs_inter_how  id-MRS_concept "?id " unspec_adj)"crlf)

(printout ?*mrsdef* "(MRS_info id-MRS_concept "(+ ?id 3) " prpstn_to_prop)"crlf)
(printout ?*defdbug* "(rule-rel-values mrs_inter_how  id-MRS_concept "?id " prpstn_to_prop)"crlf)
)

;It creates mrs rel feature subord for sentences with vmod_krvn
;verified sentence 338 #vaha laMgadAkara calawA hE. 
(defrule mrs_subord-kr
(rel_name-ids	krvn	?kri	?kvn)
(id-hin_concept-MRS_concept ?kvn ?hin1 ?mrsCon) 
(test (neq (str-index _v_ ?mrsCon) FALSE)) ;Exception to I kicked the blind boy slowly.
=>
(printout ?*mrsdef* "(MRS_info id-MRS_concept -20000 subord)"crlf)
(printout ?*defdbug* "(rule-rel-values mrs_subord-kr id-MRS_concept -20000 subord)"crlf)
)

;Rule for bringing which_q, abstr_deg, measure for the relation degree.
;;How happy was Abramas? 
(defrule mrs_inter_how-adj
(id-concept_label ?id kim)
(rel_name-ids	degree	?noun	?id)
=>
(printout ?*mrsdef* "(MRS_info id-MRS_concept "(+ ?id 10) " which_q)"crlf)
(printout ?*defdbug* "(rule-rel-values mrs_inter_how-adj  id-MRS_concept "(+ ?id 10) " which_q)"crlf)
(printout ?*mrsdef* "(MRS_info id-MRS_concept "(+ ?id 2) " abstr_deg)"crlf)
(printout ?*defdbug* "(rule-rel-values mrs_inter_how-adj id-MRS_concept "(+ ?id 2)" abstr_deg)"crlf)
(printout ?*mrsdef* "(MRS_info id-MRS_concept "(+ ?id 3) " measure)"crlf)
(printout ?*defdbug* "(rule-rel-values mrs_inter_how-adj id-MRS_concept "(+ ?id 3) " measure)"crlf)
)

;Rule for creating unspec_manner, which_q, manner for k3 relation with kim word.
;How did you complete the work?
(defrule mrs_inter_how-verb
(id-concept_label ?id kim)
(rel_name-ids	krvn	?noun	?id)
=>
(printout ?*mrsdef* "(MRS_info id-MRS_concept "(+ ?id 10) " which_q)"crlf)
(printout ?*defdbug* "(rule-rel-values mrs_inter_how-verb  id-MRS_concept "(+ ?id 10) " which_q)"crlf)
(printout ?*mrsdef* "(MRS_info id-MRS_concept "(+ ?id 2) " unspec_manner)"crlf)
(printout ?*defdbug* "(rule-rel-values mrs_inter_how-verb id-MRS_concept "(+ ?id 2)" unspec_manner)"crlf)
(printout ?*mrsdef* "(MRS_info id-MRS_concept "(+ ?id 3) " manner)"crlf)
(printout ?*defdbug* "(rule-rel-values mrs_inter_how-verb id-MRS_concept "(+ ?id 3) " manner)"crlf)
)

;Rule for creating udef_q for dijunct entries or noun.
;I like tea or coffee.
(defrule disjunct
(construction-ids	disjunct ?id1 ?id2)
(rel_name-ids   ?rel        ?id ?id1)
(id-concept_label	?id1	?hincon)
(id-hin_concept-MRS_concept ?id1 ?hincon ?mrscon)
(test (eq (str-index _a_ ?mrscon) FALSE))
(id-num	?id1	?pl)
=>
(printout ?*mrsdef* "(MRS_info id-MRS_concept "(+ ?id1 510)" udef_q)"crlf)
(printout ?*defdbug* "(rule-rel-values disjunct-pl id-MRS_concept "(+ ?id1 510)" udef_q)"crlf)
)

;Rule for creating udef_q for dijunct entries or noun.
;I like tea or coffee.
(defrule disjunct
(construction-ids	disjunct ?id1 ?id2)
(rel_name-ids   ?rel        ?id ?id1)
(id-concept_label	?id1	?hincon)
(id-hin_concept-MRS_concept ?id1 ?hincon ?mrscon)
(test (eq (str-index _a_ ?mrscon) FALSE))
(not (id-num	?id1	?pl))
=>
(printout ?*mrsdef* "(MRS_info id-MRS_concept "(+ ?id1 510)" udef_q)"crlf)
(printout ?*defdbug* "(rule-rel-values disjunct-sg id-MRS_concept "(+ ?id1 510)" udef_q)"crlf)
)

;Rule for creating recip_pro and pronoun_q for reciprocal pronouns
;We love each other.
(defrule mrs_recip_pronoun
(id-concept_label	?rp	eka+xUsarA)
(rel_name-ids	?rell	?kri	?rp)
=>
(printout ?*mrsdef* "(MRS_info id-MRS_concept "(+ ?rp 10) " pronoun_q)"crlf)
(printout ?*defdbug* "(rule-rel-values mrs_recip_pronoun  id-MRS_concept "(+ ?rp 10) " pronoun_q)"crlf)

(printout ?*mrsdef* "(MRS_info id-MRS_concept "?rp" recip_pro)"crlf)
(printout ?*defdbug* "(rule-rel-values mrs_recip_pronoun  id-MRS_concept "?rp " recip_pro)"crlf)
)

;Rule for bringing place_n, which_q, _from_p_dir for k5 relation with kim word in the second row. 
;Where did Rama come from?
(defrule mrs_inter_where-k5
(id-concept_label ?id kim)
(rel_name-ids	k5	?noun	?id)
(not (id-anim	?id	yes)) ;#राम किससे डरता है
=>
(printout ?*mrsdef* "(MRS_info id-MRS_concept "(+ ?id 10) " which_q)"crlf)
(printout ?*defdbug* "(rule-rel-values mrs_inter_where-k5  id-MRS_concept "(+ ?id 10) " which_q)"crlf)
(printout ?*mrsdef* "(MRS_info id-MRS_concept "?id"  place_n)"crlf)
(printout ?*defdbug* "(rule-rel-values mrs_inter_where-k5 "?id" id-MRS_concept place_n)"crlf)
)

;Rule for bringing person and which_q when kim+anim+k5 form exists in the USR
;#राम किससे डरता है
(defrule mrs_inter_where_anim_k5
(id-concept_label ?id kim)
(rel_name-ids	k5	?noun	?id)
(id-anim	?id	yes)
=>
(printout ?*mrsdef* "(MRS_info id-MRS_concept "(+ ?id 10) " which_q)"crlf)
(printout ?*defdbug* "(rule-rel-values mrs_inter_where_anim-k5  id-MRS_concept "(+ ?id 10) " which_q)"crlf)
(printout ?*mrsdef* "(MRS_info id-MRS_concept "?id"  person)"crlf)
(printout ?*defdbug* "(rule-rel-values mrs_inter_where_anim-k5 "?id" id-MRS_concept person)"crlf)
)
;I will come to India in 2017.
(defrule years_of_century
(id-concept_label	?id	?hinconcept)
(id-yoc	?id	yes)
=>
(printout ?*mrsdef* "(MRS_info id-MRS_concept "?id " yofc)"crlf)
(printout ?*defdbug* "(rule-rel-values  years_of_century id-MRS_concept "?id " yofc)"crlf)
)

;My birthday is 23 September.
;Rule for generating dofm abstract predicate for dates of month.
(defrule date_of_month
(id-concept_label	?id	?hinconcept)
(id-dom	?id	yes)
=>
(printout ?*mrsdef* "(MRS_info id-MRS_concept "?id " dofm)"crlf)
(printout ?*defdbug* "(rule-rel-values  date_of_month id-MRS_concept "?id " dofm)"crlf)
)

(defrule mrs_inter_why
(id-concept_label ?id kim)
(rel_name-ids	rh	?kri	?id)
=>
(printout ?*mrsdef* "(MRS_info id-MRS_concept "(+ ?id 10)" which_q)"crlf)
(printout ?*defdbug* "(rule-rel-values mrs_inter_why id-MRS_concept "(+ ?id 10)" which_q)"crlf)

(printout ?*mrsdef* "(MRS_info id-MRS_concept "(+ ?id 1)" _for_p)"crlf)
(printout ?*defdbug* "(rule-rel-values mrs_inter_why id-MRS_concept "(+ ?id 1)" _for_p)"crlf)

(printout ?*mrsdef* "(MRS_info id-MRS_concept "?id" reason)"crlf)
(printout ?*defdbug* "(rule-rel-values mrs_inter_why id-MRS_concept "?id" reason)"crlf)
)

;This rule generates MRS concept 'compound' for the feature 'respect' with gender 'f'. 
;405: rajani ji ne apane bete Ora apanI betI ko somavAra ko kASI ke sabase bade vixyAlaya meM BarawI kiyA. Eng: Ms. Rajani ...
(defrule respect-feminine
(id-respect  ?id  yes)
(rel_name-ids ?rel ?idd ?id)
(id-num	?id	?pl)
(id-female	?id	yes)
(not(id-concept_label	?id 	addressee))
=>
(printout ?*mrsdef* "(MRS_info id-MRS_concept "(+ ?id 2) " compound)"crlf)
(printout ?*defdbug* "(rule-rel-values respect-feminine-pl id-MRS_concept " (+ ?id 2)" compound)"crlf)

(printout ?*mrsdef* "(MRS_info id-MRS_concept "(+ ?id 10) " udef_q)"crlf)
(printout ?*defdbug* "(rule-rel-values respect-feminine-pl id-MRS_concept "(+ ?id 10)" udef_q)"crlf)
)

;This rule generates MRS concept 'compound' for the feature 'respect' with gender 'f'. 
;405: rajani ji ne apane bete Ora apanI betI ko somavAra ko kASI ke sabase bade vixyAlaya meM BarawI kiyA. Eng: Ms. Rajani ...
(defrule respect-feminine
(id-respect  ?id  yes)
(rel_name-ids ?rel ?idd ?id)
(id-female	?id	yes)
(not(id-concept_label	?id 	addressee))
(not (id-num	?id	?pl))
=>
(printout ?*mrsdef* "(MRS_info id-MRS_concept "(+ ?id 2) " compound)"crlf)
(printout ?*defdbug* "(rule-rel-values respect-feminine-sg id-MRS_concept " (+ ?id 2)" compound)"crlf)

(printout ?*mrsdef* "(MRS_info id-MRS_concept "(+ ?id 10) " udef_q)"crlf)
(printout ?*defdbug* "(rule-rel-values respect-feminine-sg id-MRS_concept "(+ ?id 10)" udef_q)"crlf)
)

;This rule generates MRS concept 'compound' for the feature 'respect' with gender 'm'. 
;Mr. Sanju came.
(defrule respect-masculine
(id-respect  ?id  yes)
(id-per  ?id  yes)
(rel_name-ids ?rel ?idd ?id)
(id-num	?id	?pl)
(id-male	?id	yes)
(not(id-concept_label	?id 	addressee))
=>
(printout ?*mrsdef* "(MRS_info id-MRS_concept "(+ ?id 2) " compound)"crlf)
(printout ?*defdbug* "(rule-rel-values respect-masculine-pl id-MRS_concept " (+ ?id 2)" compound)"crlf)

(printout ?*mrsdef* "(MRS_info id-MRS_concept "(+ ?id 10) " udef_q)"crlf)
(printout ?*defdbug* "(rule-rel-values respect-masculine-pl id-MRS_concept "(+ ?id 10)" udef_q)"crlf)
)

;This rule generates MRS concept 'compound' for the feature 'respect' with gender 'm'. 
;Mr. Sanju came.
(defrule respect-masculine
(id-respect  ?id  yes)
(id-per  ?id  yes)
(rel_name-ids ?rel ?idd ?id)
(id-male	?id	yes)
(not(id-concept_label	?id 	addressee))
(not (id-num	?id	?pl))
=>
(printout ?*mrsdef* "(MRS_info id-MRS_concept "(+ ?id 2) " compound)"crlf)
(printout ?*defdbug* "(rule-rel-values respect-masculine-sg id-MRS_concept " (+ ?id 2)" compound)"crlf)

(printout ?*mrsdef* "(MRS_info id-MRS_concept "(+ ?id 10) " udef_q)"crlf)
(printout ?*defdbug* "(rule-rel-values respect-masculine-sg id-MRS_concept "(+ ?id 10)" udef_q)"crlf)
)

;Rule for generating season abstract predicate
;Summer is good.
(defrule season
(id-season	?id	yes)
=>
(printout ?*mrsdef* "(MRS_info id-MRS_concept "(+ ?id 10)" udef_q)"crlf)
(printout ?*defdbug* "(rule-rel-values season id-MRS_concept "(+ ?id 10)" udef_q)"crlf)
)

;rule for bringing parg_d for the rbks relation
;The fruit eaten by Rama was sweet.
(defrule mrs_parg_d_rbks
(sentence_type  affirmative)
(rel_name-ids	rbks	?id	?kri)
=>
(printout ?*mrsdef* "(MRS_info id-MRS_concept "?kri " parg_d)"crlf)
(printout ?*defdbug* "(rule-rel-values mrs_parg_d_rbks  id-MRS_concept "?kri" parg_d)"crlf)
)

(defrule mrs_subord_rblsk
(rel_name-ids	rblsk	?id	?kri)
=>
(printout ?*mrsdef* "(MRS_info id-MRS_concept -20000 _as_x_subord)"crlf)
(printout ?*defdbug* "(rule-rel-values mrs_subord_rblsk id-MRS_concept -20000 _as_x_subord)"crlf)
)

;Rule for bringing generic_entity when no card information available and numex tag available and number concept in the concept row.
;Three barked.
(defrule mrs_generic_Entity
(id-concept_label	?id1	?number)
(id-numex	?id1	yes)
(rel_name-ids	k1	?kri	?id1)
(not (rel_name-ids	card	?kri	?id1))
=>
(printout ?*mrsdef* "(MRS_info id-MRS_concept "?id1" generic_entity)"crlf)
(printout ?*defdbug* "(rule-rel-values mrs_generic_Entity id-MRS_concept "?id1" generic_entity)"crlf)
(printout ?*mrsdef* "(MRS_info id-MRS_concept "(+ ?id1 10) " udef_q)"crlf)
(printout ?*defdbug* "(rule-rel-values mrs_generic_Entity id-MRS_concept "(+ ?id1 10)" udef_q)"crlf)
)

;Rule for generating unknown for the kAryakAraNa relation in the discourse row.
;Because, he has to go home. #kyoMki vo Gara jAnA hE.
(defrule unknown-kAryakAraNa
(rel_name-ids kAryakAraNa ?previousid	?verb)
=>
(printout ?*mrsdef* "(MRS_info id-MRS_concept "(+ ?verb 1) "  unknown)"crlf)
(printout ?*defdbug* "(rule-rel-values  unknown-kAryakAraNa id-MRS_concept "(+ ?verb 1) "  unknown)"crlf)
)

(defrule date_of_month-compound
(id-dom	?id1	yes)
(id-moy	?id2	yes)
(rel_name-ids	r6	?id1	?id2)
=>
(printout ?*mrsdef* "(MRS_info id-MRS_concept "(+ ?id1 2) " compound)"crlf)
(printout ?*defdbug* "(rule-rel-values date_of_month-compound id-MRS_concept " (+ ?id1 2)" compound)"crlf)

(printout ?*mrsdef* "(MRS_info id-MRS_concept "(+ ?id1 10) " udef_q)"crlf)
(printout ?*defdbug* "(rule-rel-values date_of_month-compound id-MRS_concept "(+ ?id1 10)" udef_q)"crlf)
)

(defrule clock_time
(id-concept_label	?ct	 ?num)
(id-clocktime	?ct	yes)
(rel_name-ids	k7t	?kri	?ct)
(test (neq (str-index "+baje" ?num) FALSE))
=>
(printout ?*mrsdef* "(MRS_info id-MRS_concept "?ct" numbered_hour)"crlf)
(printout ?*defdbug* "(rule-rel-values clock_time id-MRS_concept " ?ct" numbered_hour)"crlf)

(printout ?*mrsdef* "(MRS_info id-MRS_concept "(+ ?ct 1) " minute)"crlf)
(printout ?*defdbug* "(rule-rel-values clock_time id-MRS_concept "(+ ?ct 1) " minute)"crlf)

(printout ?*mrsdef* "(MRS_info id-MRS_concept "(+ ?ct 10) " def_implicit_q)"crlf)
(printout ?*defdbug* "(rule-rel-values clock_time id-MRS_concept "(+ ?ct 10) " def_implicit_q)"crlf)
)

(defrule clock_time-noon
(id-concept_label	?ct	 ?num)
(id-concept_label	?ct	 xopahara_2)
(rel_name-ids	k7t	?kri	?ct)
;(test (neq (str-index "+baje" ?num) FALSE))
=>
(printout ?*mrsdef* "(MRS_info id-MRS_concept "?ct" numbered_hour)"crlf)
(printout ?*defdbug* "(rule-rel-values clock_time-noon id-MRS_concept " ?ct" numbered_hour)"crlf)
(printout ?*mrsdef* "(MRS_info id-MRS_concept "(+ ?ct 10) " def_implicit_q)"crlf)
(printout ?*defdbug* "(rule-rel-values clock_time-noon id-MRS_concept "(+ ?ct 10) " def_implicit_q)"crlf)
)

;Example:  He comes here daily. 
;generates (id-MRS_concept "?id " place_n)
;          (id-MRS_concept "?id " def_implicit_q)
;          (id-MRS_concept "?id " loc_nonsp)
(defrule aps_of_here
(id-concept_label	?id	wyax)
(id-proximal	?id	yes)
(rel_name-ids	k7p	?kri	?id)
=>
(printout ?*mrsdef* "(MRS_info id-MRS_concept "?id " place_n)"crlf)
(printout ?*defdbug* "(rule-rel-values aps_of_here id-MRS_concept "?id " place_n)"crlf)

(printout ?*mrsdef* "(MRS_info id-MRS_concept "?id" def_implicit_q)"crlf)
(printout ?*defdbug* "(rule-rel-values aps_of_here id-MRS_concept "?id " def_implicit_q)"crlf)

(printout ?*mrsdef* "(MRS_info id-MRS_concept "?id " loc_nonsp)"crlf)
(printout ?*defdbug* "(rule-rel-values aps_of_here id-MRS_concept "?id " loc_nonsp)"crlf)
)

;rule for quantitative pronoun
(defrule quantitative_pronoun
(id-concept_label	?quant	kuCa_1)
(rel_name-ids	quant	?verb	?quant)
(id-hin_concept-MRS_concept ?verb ?hin ?mrsconcept)
(test (neq (str-index _v_ ?mrsconcept) FALSE))
=>
(printout ?*mrsdef* "(MRS_info id-MRS_concept "(+ ?quant 10) " generic_entity)"crlf)
(printout ?*defdbug* "(rule-rel-values quantitative_pronoun id-MRS_concept "(+ ?quant 10)" generic_entity)"crlf)
)

;Rule for generating abstract predicates 
;More than 300 people will come tomorrow.
(defrule quantmore-abst
(id-concept_label	?id	?num)
(rel_name-ids	quantmore	?modifier	?id)
=>
(printout ?*mrsdef* "(MRS_info id-MRS_concept "?id" card)"crlf)
(printout ?*defdbug* "(rule-rel-values quantmore-abst id-MRS_concept "?id" card)"crlf)
(printout ?*mrsdef* "(MRS_info id-MRS_concept "(+ ?id 10) " udef_q)"crlf)
(printout ?*defdbug* "(rule-rel-values quantmore-abst id-MRS_concept "(+ ?id 10) " udef_q)"crlf)
(printout ?*mrsdef* "(MRS_info  id-MRS_concept "(+ ?id 20) "  comp)"crlf)
(printout ?*defdbug* "(rule-rel-values  quantmore-abst   id-MRS_concept "(+ ?id 20) "  comp)"crlf)
(printout ?*mrsdef* "(MRS_info id-MRS_concept "?id" generic_entity)"crlf)
(printout ?*defdbug* "(rule-rel-values quantmore-abst id-MRS_concept "?id" generic_entity)"crlf)
(printout ?*mrsdef* "(MRS_info id-MRS_concept "(+ ?id 100)" much-many_a)"crlf)
(printout ?*defdbug* "(rule-rel-values quantmore-abst id-MRS_concept "(+ ?id 100)" much-many_a)"crlf)
)

;Rule for generating abstract predicates 
;Less than 300 people will come tomorrow.
(defrule quantless-abst
(id-concept_label	?id	?num)
(rel_name-ids	quantless	?modifier	?id)
=>
(printout ?*mrsdef* "(MRS_info id-MRS_concept "?id" card)"crlf)
(printout ?*defdbug* "(rule-rel-values quantless-abst id-MRS_concept "?id" card)"crlf)
(printout ?*mrsdef* "(MRS_info id-MRS_concept "(+ ?id 10) " udef_q)"crlf)
(printout ?*defdbug* "(rule-rel-values quantless-abst id-MRS_concept "(+ ?id 10) " udef_q)"crlf)
(printout ?*mrsdef* "(MRS_info  id-MRS_concept "(+ ?id 20) "  comp)"crlf)
(printout ?*defdbug* "(rule-rel-values  quantless-abst   id-MRS_concept "(+ ?id 20) "  comp)"crlf)
(printout ?*mrsdef* "(MRS_info id-MRS_concept "?id" generic_entity)"crlf)
(printout ?*defdbug* "(rule-rel-values quantless-abst id-MRS_concept "?id" generic_entity)"crlf)
(printout ?*mrsdef* "(MRS_info id-MRS_concept "(+ ?id 100)" little-few_a)"crlf)
(printout ?*defdbug* "(rule-rel-values quantless-abst id-MRS_concept "(+ ?id 100)" little-few_a)"crlf)
)

;My country.
(defrule unknown-title
(id-concept_label	?id	?hinconcept)
(rel_name-ids	main	0	?id)
(sentence_type	TITLE)
=>
(printout ?*mrsdef* "(MRS_info id-MRS_concept 0000000 unknown)"crlf)
(printout ?*defdbug* "(rule-rel-values  unknown-title id-MRS_concept 0000000 unknown)"crlf)
)

;Flora found in India
(defrule unknown-heading
(id-concept_label	?id	?hinconcept)
(rel_name-ids	main	0	?id)
(sentence_type	heading)
=>
(printout ?*mrsdef* "(MRS_info id-MRS_concept 0000000 unknown)"crlf)
(printout ?*defdbug* "(rule-rel-values  unknown-heading id-MRS_concept 0000000 unknown)"crlf)
)

(defrule mrs_parg_d-heading
(sentence_type  heading)
(rel_name-ids	mod	?noun	?modifier)
(id-hin_concept-MRS_concept ?modifier ?hinconcept ?verb)
(test (neq (str-index _v_ ?verb) FALSE))
(construction-ids	conj	?noun ?noun2)
=>
(printout ?*mrsdef* "(MRS_info id-MRS_concept "?modifier " parg_d)"crlf)
(printout ?*defdbug* "(rule-rel-values mrs_parg_d-heading  id-MRS_concept "?modifier" parg_d)"crlf)
)


;#अब्राम उस घंटे पहुंचे थे।
(defrule dem_time
(id-concept_label	?dem	 wyax)
(id-concept_label	?time	 ?hintime)
(rel_name-ids	dem	?time	?dem)
(rel_name-ids	k7t	?kriya	?time)
=>
(printout ?*mrsdef* "(MRS_info id-MRS_concept "?time " loc_nonsp)"crlf)
(printout ?*defdbug* "(rule-rel-values aps_of_dow_timeadverb id-MRS_concept "?time" loc_nonsp)"crlf)
)

