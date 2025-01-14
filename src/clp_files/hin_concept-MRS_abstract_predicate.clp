;generates output file "mrs_info.dat" that contains id and MRS concept for a and the.
;udef_q for plural noun
;neg for negation.

(defglobal ?*mrsdef* = mrs-def-fp)
(defglobal ?*defdbug* = mrs-def-dbug)

;(rel-ids	card	30000	20000)

;Rule for generating udef_q for plural nouns. 
;Rule for plural noun : if (?n is pl) generate ((id-MRS_Rel ?id _udef_q)
(defrule mrs_pl_notDef
(id-morph_sem	?id	?n)
(or (test (eq ?n pl))(id-abs ?id yes) (rel-ids meas ?id ?)(rel-ids card ?id ?))
(not (id-speakers_view	 ?id	 def))
(not (rel-ids dem ?id ?v))
(not (rel-ids quant ?id ?v))
(not (rel-ids r6 ?id ?v))
(not(id-cl	?id 	?concept&$speaker|$addressee|$wyax|saba_4|mAwA_1+piwA_1)) 
(not (rel-ids coref ?	?id))
(not (rel-ids	dem	?	?v)) ;Those two boys must have done it.
;(not (rel-ids	rhh	?id	?)) ;इस कारण उनके माता पिता उनसे बहुत परेशान रहते थे
=>
(printout ?*mrsdef* "(MRS_info id-MRS_concept "(+ ?id 10) " udef_q)"crlf)
(printout ?*defdbug* "(rule-rel-values mrs_pl_notDef id-MRS_concept "(+ ?id 10)" udef_q)"crlf)
)

(defrule mrs_numex
(id-cl	?id	1)
(id-cl	?noun	?hinconcept)
(rel-ids	card	?noun	?id)
(id-numex ?id yes)
=>
(printout ?*mrsdef* "(MRS_info id-MRS_concept "(+ ?noun 10)" udef_q)"crlf)
(printout ?*defdbug* "(rule-rel-values  mrs_numex id-MRS_concept "(+ ?noun 10)" udef_q)"crlf)
)

;Rule for creating unknown for non-sentence type.
;In case of topic names we need to generate unknown and udef_q.
(defrule udef_unknown-pl
(id-morph_sem	?id	pl)
(sent_type	)
=>
(printout ?*mrsdef* "(MRS_info id-MRS_concept 0000000 unknown)"crlf)
(printout ?*defdbug* "(rule-rel-values  udef_unknown-pl id-MRS_concept 0000000 unknown)"crlf)
)
;Rule for creating udef_q for when the sentence consists of only two noun entries in the construction for unknown.
;#billI Ora kuwwA.

(defrule implicit_conj4unknown
(cxnlbl-id-values ?conj ?conjid ?op1 ?op2)
(cxnlbl-id-val_ids	?conj	?conjid ?n ?y)
(id-cl	?n	?hincon)
(id-morph_sem	?n	?pl)
(test (neq (str-index conj_ ?conj) FALSE))
=>
(printout ?*mrsdef* "(MRS_info id-MRS_concept "(+ ?conjid 10)" udef_q)"crlf)
(printout ?*defdbug* "(rule-rel-values implicit_conj4unknown-pl id-MRS_concept "(+ ?conjid 10)" udef_q)"crlf)
)


;Rule for creating unknown for non-sentence type.
;In case of topic names we need to generate unknown and udef_q for Plurals
(defrule udef_unknown-sg
(sent_type	)
(not (id-morph_sem	?id	pl))
=>
(printout ?*mrsdef* "(MRS_info id-MRS_concept 0000000 unknown)"crlf)
(printout ?*defdbug* "(rule-rel-values  udef_unknown-sg id-MRS_concept 0000000 unknown)"crlf)
)

;rAma dAktara nahIM hE.	 rAma xillI meM nahIM hE. #usane KAnA nahIM KAyA. #use Gara nahIM jAnA cAhie.
(defrule mrs_neg_notDef
(or (rel-ids neg  ?kid ?negid) (id-hI_1	?negid	yes))
=>
(printout ?*mrsdef* "(MRS_info id-MRS_concept "?negid " neg)"crlf)
(printout ?*defdbug* "(rule-rel-values mrs_neg_notDef id-MRS_concept "?negid " neg)"crlf)
)

;Rule for proper noun: if ((id-propn ?id yes) is present, generate (id-MRS_concept ?id proper_q) and  (id-MRS_concept ?id named)
(defrule mrs_propn
(or (id-per  ?id yes) (id-place  ?id yes) (id-org  ?id yes)  (id-ne  ?id yes) )
(not (rel-ids coref ?idd	?id))
=>
(printout ?*mrsdef* "(MRS_info id-MRS_concept "(+ ?id 10) " proper_q)"crlf)
(printout ?*defdbug* "(rule-rel-values mrs_propn  id-MRS_concept "(+ ?id 10)" proper_q)"crlf)

(printout ?*mrsdef* "(MRS_info id-MRS_concept "?id " named)"crlf)
(printout ?*defdbug* "(rule-rel-values mrs_propn  id-MRS_concept "?id " named)"crlf)
)

;rule for %interrogative sentences for 'what',
;generates (id-MRS_concept "?id " thing)
;	   (id-MRS_concept "?id " which_q)
(defrule mrs_inter_what
(id-cl ?id $kim)
(rel-ids	k2	?kri	?id)
(not (id-anim	?id	yes))
=>
(printout ?*mrsdef* "(MRS_info id-MRS_concept "(+ ?id 10) " which_q)"crlf)
(printout ?*defdbug* "(rule-rel-values mrs_inter_what  id-MRS_concept "(+ ?id 10)" which_q)"crlf)
(printout ?*mrsdef* "(MRS_info id-MRS_concept "?id" thing)"crlf)
(printout ?*defdbug* "(rule-rel-values mrs_inter_what id-MRS_concept "?id" thing)"crlf)
)

;Who did fill the pot, with water?
;rule for %interrogative sentences for 'who',
;generates (id-MRS_concept "?id " person)
;	   (id-MRS_concept "?id " which_q)
(defrule mrs_inter_who
(id-cl ?id $kim)
(rel-ids	k1|rask1	?kri	?id)
=>
(printout ?*mrsdef* "(MRS_info id-MRS_concept "(+ ?id 10) " which_q)"crlf)
(printout ?*defdbug* "(rule-rel-values mrs_inter_who  id-MRS_concept " (+ ?id 10) " which_q)"crlf)
(printout ?*mrsdef* "(MRS_info id-MRS_concept "?id" person)"crlf)
(printout ?*defdbug* "(rule-rel-values mrs_inter_who id-MRS_concept "?id" person)"crlf)
)

;Who are you?
;rule for %interrogative sentences for 'who',
;generates (id-MRS_concept "?id " person)
;	   (id-MRS_concept "?id " which_q)
(defrule mrs_inter_who-k1s
(id-cl ?id $kim)
(rel-ids	k1s	?kri	?id)
(id-morph_sem	?id	pl)
(id-anim	?id	yes)
=>
(printout ?*mrsdef* "(MRS_info id-MRS_concept "(+ ?id 10) " which_q)"crlf)
(printout ?*defdbug* "(rule-rel-values mrs_inter_who-k1s-pl id-MRS_concept " (+ ?id 10) " which_q)"crlf)
(printout ?*mrsdef* "(MRS_info id-MRS_concept "?id" person)"crlf)
(printout ?*defdbug* "(rule-rel-values mrs_inter_who-k1s-pl id-MRS_concept "?id" person)"crlf)
)

;Who are you?
;rule for %interrogative sentences for 'who',
;generates (id-MRS_concept "?id " person)
;	   (id-MRS_concept "?id " which_q)
(defrule mrs_inter_who-k1s
(id-cl ?id $kim)
(rel-ids	k1s	?kri	?id)
(id-anim	?id	yes)
(not (id-morph_sem	?id	pl))
=>
(printout ?*mrsdef* "(MRS_info id-MRS_concept "(+ ?id 10) " which_q)"crlf)
(printout ?*defdbug* "(rule-rel-values mrs_inter_who-k1s-sg id-MRS_concept " (+ ?id 10) " which_q)"crlf)
(printout ?*mrsdef* "(MRS_info id-MRS_concept "?id" person)"crlf)
(printout ?*defdbug* "(rule-rel-values mrs_inter_who-k1s-sg id-MRS_concept "?id" person)"crlf)
)

;Rule for generating person and which_q for generating whom in the MRS 
;Whom did Rama meet? ;Whom did Rama ask a question?
(defrule mrs_inter_whom
(id-cl ?id $kim)
(rel-ids	k2|k2g|k4	?kri	?id)
(id-anim	?id	yes)
=>
(printout ?*mrsdef* "(MRS_info id-MRS_concept "(+ ?id 10) " which_q)"crlf)
(printout ?*defdbug* "(rule-rel-values mrs_inter_whom  id-MRS_concept " (+ ?id 10) " which_q)"crlf)
(printout ?*mrsdef* "(MRS_info id-MRS_concept "?id" person)"crlf)
(printout ?*defdbug* "(rule-rel-values mrs_inter_whom id-MRS_concept "?id" person)"crlf)
)

;rule for %interrogative sentences for 'where',
;generates (id-MRS_concept "?id " place)
;          (id-MRS_concept "?id " which_q)
(defrule mrs_inter_where
(id-cl ?id $kim)
(rel-ids	k7p|k2p	?kri	?id)
=>
(printout ?*mrsdef* "(MRS_info id-MRS_concept "(+ ?id 10)" which_q)"crlf)
(printout ?*defdbug* "(rule-rel-values mrs_inter_where id-MRS_concept "(+ ?id 10)" which_q)"crlf)

(printout ?*mrsdef* "(MRS_info id-MRS_concept "(+ ?id 1)" loc_nonsp)"crlf)
(printout ?*defdbug* "(rule-rel-values mrs_inter_where id-MRS_concept "(+ ?id 1)" loc_nonsp)"crlf)

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
(id-cl ?id Gara_1|vahAz_1|bAhara_2)
(not (id-cl ?id bAhara_1))
=>
(printout ?*mrsdef* "(MRS_info id-MRS_concept "?id " place_n)"crlf)
(printout ?*defdbug* "(rule-rel-values mrs_place id-MRS_concept "?id " place_n)"crlf)

(printout ?*mrsdef* "(MRS_info id-MRS_concept "(+ ?id 10) " def_implicit_q)"crlf)
(printout ?*defdbug* "(rule-rel-values mrs_place id-MRS_concept "(+ ?id 10) " def_implicit_q)"crlf)

(printout ?*mrsdef* "(MRS_info id-MRS_concept "(+ ?id 1)" loc_nonsp)"crlf)
(printout ?*defdbug* "(rule-rel-values mrs_place id-MRS_concept "(+ ?id 1)" loc_nonsp)"crlf)
)

;Rule to generate place_n, def_implicit_q, loc_nonsp for $wyax with k7p relation.
;A mouse used to live in the hole, there.
(defrule mrs_place_there
(id-cl ?id $wyax)
(rel-ids	k7p	?kri	?id)
(not (id-speakers_view	 ?id	 proximal))
=>
(printout ?*mrsdef* "(MRS_info id-MRS_concept "?id " place_n)"crlf)
(printout ?*defdbug* "(rule-rel-values mrs_place_there id-MRS_concept "?id " place_n)"crlf)

(printout ?*mrsdef* "(MRS_info id-MRS_concept "(+ ?id 10)" def_implicit_q)"crlf)
(printout ?*defdbug* "(rule-rel-values mrs_place_there id-MRS_concept "(+ ?id 10)" def_implicit_q)"crlf)

(printout ?*mrsdef* "(MRS_info id-MRS_concept "(+ ?id 1)" loc_nonsp)"crlf)
(printout ?*defdbug* "(rule-rel-values mrs_place_there id-MRS_concept "(+ ?id 1) " loc_nonsp)"crlf)
)


; written by sakshi yadav (NIT-Raipur)
; date-27.05.19
;rule for sentence -consists of words 'yesterday','today','tomorrow' 
;example -i came yesterday
;generates (id-MRS_concept "?id " time_n)
;          (id-MRS_concept "?id " def_implicit_q)
;          (id-MRS_concept "?id " loc_nonsp)
(defrule mrs_kala
(id-cl ?id pahale_4|kala_1|kala_2|Aja_1|jalxI_9|xera_11|aba_1|xera_9|aBI_4)
(rel-ids   ?relname        ?id1  ?id2)	;To restrict the generation of "loc_nonsp" when "kala, Aja" are in "samanadhikaran" relation.
=>
(printout ?*mrsdef* "(MRS_info id-MRS_concept "?id " time_n)"crlf)
(printout ?*defdbug* "(rule-rel-values mrs_kala  id-MRS_concept "?id " time_n)"crlf)

(printout ?*mrsdef* "(MRS_info id-MRS_concept "(+ ?id 10)" def_implicit_q)"crlf)
(printout ?*defdbug* "(rule-rel-values mrs_kala  id-MRS_concept "(+ ?id 10)" def_implicit_q)"crlf)

(if (neq ?relname samAnAXi) then	;;To restrict the generation of "loc_nonsp" when "kala, Aja" are in "samanadhikaran" relation.e.g Today is Monday.
 (printout ?*mrsdef* "(MRS_info id-MRS_concept "(+ ?id 1)" loc_nonsp)"crlf)
 (printout ?*defdbug* "(rule-rel-values mrs_kala  id-MRS_concept "(+ ?id 1)" loc_nonsp)"crlf)
)
)

;written by sakshi yadav(NIT Raipur) Date-7.06.19
;Generates new facts for days of weeks then generate (MRS_info id-MRS_concept ?id _on_p_temp) and (MRS_info id-MRS_concept ?id dofw) and  (MRS_info id-MRS_concept ?id proper_q) 
(defrule daysofweeks
(id-cl	?id	?hinconcept)
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
(id-cl ?id ?hinconcept)
(id-moy	 ?id yes)
=>
(printout ?*mrsdef* "(MRS_info id-MRS_concept "?id " mofy)"crlf)
(printout ?*defdbug* "(rule-rel-values  monthsofyears id-MRS_concept "?id" mofy)"crlf)
(printout ?*mrsdef* "(MRS_info id-MRS_concept "(+ ?id 10) " proper_q)"crlf)
(printout ?*defdbug* "(rule-rel-values  monthsofyears id-MRS_concept "(+ ?id 10)" proper_q)"crlf)
)

(defrule yearsofcenturies
(id-cl ?id ?num)
(rel-ids k7t ?kri  ?id&:(numberp ?id))
(not (id-cl  ?k-id   ?hiConcept&$kim|Aja_1|kala_1|kala_2|rAwa_1|xina_1|jalxI_9|xera_11|aba_1|pahale_4|rojZa_2|subaha_1|bAxa_1|sarxI_2|bAxa_14|GantA_1|xopahara_2|garamI_3|SAma_1|xera_9|aBI_4))
;(test (eq (str-index "+baje" ?num) FALSE))
=>
(printout ?*mrsdef* "(MRS_info id-MRS_concept "(+ ?id 10)" proper_q)"crlf)
(printout ?*defdbug* "(rule-rel-values  yearsofcenturies id-MRS_concept "(+ ?id 10) " proper_q)"crlf)
)

(defrule dayandnight
(id-cl ?id ?num)
(rel-ids k7t ?kri  ?id&:(numberp ?id))
(id-cl  ?k-id   ?hiConcept&rAwa_1)
=>
(printout ?*mrsdef* "(MRS_info id-MRS_concept "(+ ?id 10) " def_implicit_q)"crlf)
(printout ?*defdbug* "(rule-rel-values  yearsofcenturies id-MRS_concept "(+ ?id 10)" def_implicit_q)"crlf)
)

(defrule mrs_parg_d
(sent_type  %pass_affirmative|%pass_interrogative)
(kriyA-TAM ?kri ?tam)
(not (rel-ids	rpk	?id	?kri))
(not (rel-ids	rblak	?kri	?id)) ;Before the cows were milked, Rama went.
=>
(printout ?*mrsdef* "(MRS_info id-MRS_concept "(+ ?kri 1) " parg_d)"crlf)
(printout ?*defdbug* "(rule-rel-values mrs_parg_d  id-MRS_concept "(+ ?kri 1)" parg_d)"crlf)
)

;Before the cows were milked, Rama went.
(defrule mrs_parg_d_rblak
(sent_type  %pass_affirmative|%pass_interrogative)
(rel-ids	rblak	?kri	?id)
=>
(printout ?*mrsdef* "(MRS_info id-MRS_concept "(+ ?id 1) " parg_d)"crlf)
(printout ?*defdbug* "(rule-rel-values mrs_parg_d_rblak  id-MRS_concept "(+ ?id 1)" parg_d)"crlf)
)

;#rAma ne skUla jAkara KAnA KAyA.
(defrule mrs_subord
(rel-ids	rpk	?id	?kri)
=>
(printout ?*mrsdef* "(MRS_info id-MRS_concept "(+ ?kri 2000)" subord)"crlf)
(printout ?*defdbug* "(rule-rel-values mrs_subord id-MRS_concept "(+ ?kri 2000)" subord)"crlf)
)

;rule for %interrogative sentences for 'when'
(defrule mrs_inter_when
(id-cl ?id $kim)
(rel-ids	k7t	?kri	?id)
=>
(printout ?*mrsdef* "(MRS_info id-MRS_concept "(+ ?id 10) " which_q)"crlf)
(printout ?*defdbug* "(rule-rel-values mrs_inter_when  id-MRS_concept "(+ ?id 10)" which_q)"crlf)

(printout ?*mrsdef* "(MRS_info id-MRS_concept "?id " time_n)"crlf)
(printout ?*defdbug* "(rule-rel-values mrs_inter_when  id-MRS_concept "?id " time_n)"crlf)

(printout ?*mrsdef* "(MRS_info id-MRS_concept "(+ ?id 1)" loc_nonsp)"crlf)
(printout ?*defdbug* "(rule-rel-values mrs_inter_when  id-MRS_concept "(+ ?id 1) " loc_nonsp)"crlf)
)

;Rule for generating the mrs_concept: nominalization, for kriyArWa_kriyA
; #mEM Kelane ke liye krIdAMgaNa meM gayA.
; I went to the playground for playing.
; (rel-ids	kriyArWa_kriyA	40000	20000)
(defrule nominalization
(rel-ids	k1	?kri ?krikri)
(id-hin_concept-MRS_concept ?krikri ?hinconcept ?mrsconcept)
(test (neq (str-index _v_ ?mrsconcept) FALSE))
=>
(printout ?*mrsdef* "(MRS_info  id-MRS_concept "?krikri "  nominalization)"crlf)
(printout ?*defdbug* "(rule-rel-values    nominalization  id-MRS_concept "?krikri "  nominalization)"crlf)

(printout ?*mrsdef* "(MRS_info  id-MRS_concept "(+ ?krikri 10) "  udef_q)"crlf)
(printout ?*defdbug* "(rule-rel-values  nominalization   id-MRS_concept "(+ ?krikri 10) "  udef_q)"crlf)
)

;Generate 'superl' mrs_concept for superlative degree adjectives
;#sUrya sabase badA nakRawra hE.
;The sun is the largest star.
;(id-morph_sem      20000   superl)
(defrule superl
(id-morph_sem	?id	superl)
=>
(printout ?*mrsdef* "(MRS_info  id-MRS_concept "(+ ?id 2) "  superl)"crlf)
(printout ?*defdbug* "(rule-rel-values  superl   id-MRS_concept "(+ ?id 2) "  superl)"crlf)
)

;Rule for creating comp mrs concept for comparative sentences.
;#rAma mohana se jyAxA buxXimAna hE.
(defrule compermore
(id-morph_sem	?id	compermore)
=>
(printout ?*mrsdef* "(MRS_info  id-MRS_concept "(+ ?id 1) "  comp)"crlf)
(printout ?*defdbug* "(rule-rel-values  compermore   id-MRS_concept "(+ ?id 1) "  comp)"crlf)
)

;Rule for creating comp mrs concept for comparative sentences.
;#rAma mohana se kama buxXimAna hE .
(defrule comperless
(id-morph_sem	?id comperless)
=>
(printout ?*mrsdef* "(MRS_info  id-MRS_concept "(+ ?id 1) "  comp_less)"crlf)
(printout ?*defdbug* "(rule-rel-values  compermore   id-MRS_concept "(+ ?id 1) "  comp_less)"crlf)
)

;Rule for bringing comp_equal for ru relation.
(defrule comper-equal
(rel-ids ru ?id ?id1)
(rel-ids	k1	?kri	?id) ;#गुलाब जैसे फूल पानी में नहीं उगते हैं।
(rel-ids	k1s	?kri	?adj)
=>
(printout ?*mrsdef* "(MRS_info  id-MRS_concept "(+ ?id1 1) "  comp_equal)"crlf)
(printout ?*defdbug* "(rule-rel-values  comper-equal   id-MRS_concept "(+ ?id 1) "  comp_equal)"crlf)
)

;Rule for creating implicit_conj when the construction is more than two values. 
;Ex. Rama buxXimAna, motA, xilera, Ora accA hE.
(defrule implicit_conj
(cxnlbl-id-values ?conj ?conjid $?var)
(cxnlbl-id-val_ids	?conj	?conjid $?v)
(test (neq (str-index conj_ ?conj) FALSE))

=>
(bind ?count (length$ (create$ $?v)))
(if (> ?count 2)  then
  (loop-for-count (?i 1  (- ?count 2))
   (printout ?*mrsdef* "(MRS_info id-MRS_concept "(+  (nth$ ?i (create$ $?v)) 200)" implicit_conj)"crlf)
   (printout ?*defdbug* "(rule-rel-values implicit_conj id-MRS_concept "(+  (nth$ ?i (create$ $?v)) 200)" implicit_conj)"crlf)
)))

;Rule for creating ude_q when the construction values are in subjective position with noun entries. 
;Ex. rAma, hari Ora sIwA acCe hEM.
(defrule implicit_conj4pred-pl
(cxnlbl-id-values ?conj ?conjid $?var)
(cxnlbl-id-val_ids	?conj	?conjid $?v)
(test (neq (str-index conj_ ?conj) FALSE))

=>
(bind ?count (length$ (create$ $?v)))
(if (> ?count 2)  then
  (loop-for-count (?i 1  (- ?count 2))
   (printout ?*mrsdef* "(MRS_info id-MRS_concept "(+  (nth$ ?i (create$ $?v)) 210)" udef_q)"crlf)
  (printout ?*defdbug* "(rule-rel-values implicit_conj4pred-pl id-MRS_concept "(+  (nth$ ?i (create$ $?v)) 210)" udef_q)"crlf)
)))


;Rule for creating ude_q when the construction values are in subjective position with noun entries. 
;Ex. rAma, hari Ora sIwA acCe hEM.
(defrule implicit_conj4pred
(cxnlbl-id-values ?conj ?conjid $?var ?n1 $?v2 ?op1 ?op2)
(cxnlbl-id-val_ids	?conj	?conjid $?v ?n $?v1 ?x ?y)
(rel-ids   ?rel        ?id ?n)
(id-cl	?n	?hincon)
(id-hin_concept-MRS_concept ?n ?hin ?mrscon)
(not (id-morph_sem	?n	?pl))
(test (eq (str-index _a_ ?mrscon) FALSE))
(test (neq (str-index conj_ ?conj) FALSE))
=>
(printout ?*mrsdef* "(MRS_info id-MRS_concept "(+ ?n 210)" udef_q)"crlf)
(printout ?*defdbug* "(rule-rel-values implicit_conj4pred-sg id-MRS_concept "(+ ?n 210)" udef_q)"crlf)
)

;Rule for creating udef_q for the construction with two subjective entries. 
;;#rAma Ora sIwA acCe hEM.
(defrule udefq_conj4subj
(declare (salience 100))
(cxnlbl-id-values ?conj ?conjid $?var ?op1 ?op2)
(cxnlbl-id-val_ids	?conj	?conjid $?v ?n ?y)
(test (neq (str-index "conj_" ?conj) FALSE))
=>
(printout ?*mrsdef* "(MRS_info id-MRS_concept "(+ ?conjid 10)" udef_q)"crlf)
(printout ?*defdbug* "(rule-rel-values udefq_conj4subj-pl id-MRS_concept "(+ ?conjid 10)" udef_q)"crlf)
)


;Rule for bringing number_q when card is coming in the k2 position.
;The cat chased one.
(defrule eka-k2
(id-cl	?ic	eka_1)
(rel-ids	k2	?kri	?ic)
=>
(printout ?*mrsdef* "(MRS_info id-MRS_concept "(+ ?ic 10)" number_q)"crlf)
(printout ?*defdbug* "(rule-rel-values eka-k2 id-MRS_concept "(+ ?ic 10)" number_q)"crlf)
)

;Rule to bring def_implicit_q and poss for the sentences with whose word.
;;#kiska kuwwA BOMkA? 
(defrule mrs_inter_whose
(id-cl ?id $kim)
(rel-ids	r6	?noun	?id)
=>
(printout ?*mrsdef* "(MRS_info id-MRS_concept "(+ ?noun 10) " def_implicit_q)"crlf)
(printout ?*defdbug* "(rule-rel-values mrs_inter_whose  id-MRS_concept "(+ ?noun 10)" def_implicit_q)"crlf)

(printout ?*mrsdef* "(MRS_info id-MRS_concept "(+ ?noun 20) " poss)"crlf)
(printout ?*defdbug* "(rule-rel-values mrs_inter_whose  id-MRS_concept "(+ ?noun 20)" poss)"crlf)

(printout ?*mrsdef* "(MRS_info id-MRS_concept "?id " person)"crlf)
(printout ?*defdbug* "(rule-rel-values mrs_inter_whose  id-MRS_concept "?id " person)"crlf)

(printout ?*mrsdef* "(MRS_info id-MRS_concept "(+ ?id 10) " which_q)"crlf)
(printout ?*defdbug* "(rule-rel-values mrs_inter_whose  id-MRS_concept "(+ ?id 10) " which_q)"crlf)
)

;Rule for bringing which_q, property, unspec_adj, prpstn_to_prop for sentence ;How are you?
(defrule mrs_inter_how
(id-cl	?id	$kim)
(rel-ids	k1s	?kri	?id)
(not (id-morph_sem	?id	?n))
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
(rel-ids	krvn	?kri	?kvn)
(id-hin_concept-MRS_concept ?kvn ?hin1 ?mrsCon) 
(test (neq (str-index _v_ ?mrsCon) FALSE)) ;Exception to I kicked the blind boy slowly.
=>
(printout ?*mrsdef* "(MRS_info id-MRS_concept "(+ ?kri 2000)" subord)"crlf)
(printout ?*defdbug* "(rule-rel-values mrs_subord-kr id-MRS_concept "(+ ?kri 2000)" subord)"crlf)
)

;Rule for bringing which_q, abstr_deg, measure for the relation degree.
;;How happy was Abramas? 
(defrule mrs_inter_how-adj
(id-cl ?id $kim)
(rel-ids	degree	?degree	?id)
=>
(printout ?*mrsdef* "(MRS_info id-MRS_concept "(+ ?id 10) " which_q)"crlf)
(printout ?*defdbug* "(rule-rel-values mrs_inter_how-adj  id-MRS_concept "(+ ?id 10) " which_q)"crlf)
(printout ?*mrsdef* "(MRS_info id-MRS_concept "?id  " abstr_deg)"crlf)
(printout ?*defdbug* "(rule-rel-values mrs_inter_how-adj id-MRS_concept "?id " abstr_deg)"crlf)
(printout ?*mrsdef* "(MRS_info id-MRS_concept "(+ ?degree 1) " measure)"crlf)
(printout ?*defdbug* "(rule-rel-values mrs_inter_how-adj id-MRS_concept "(+ ?degree 1) " measure)"crlf)
)

;Rule for creating unspec_manner, which_q, manner for k3 relation with $kim word.
;How did you complete the work?
(defrule mrs_inter_how-verb
(id-cl ?id $kim)
(rel-ids	krvn	?kriya	?id)
=>
(printout ?*mrsdef* "(MRS_info id-MRS_concept "(+ ?id 10) " which_q)"crlf)
(printout ?*defdbug* "(rule-rel-values mrs_inter_how-verb  id-MRS_concept "(+ ?id 10) " which_q)"crlf)
(printout ?*mrsdef* "(MRS_info id-MRS_concept "(+ ?id 1) " unspec_manner)"crlf)
(printout ?*defdbug* "(rule-rel-values mrs_inter_how-verb id-MRS_concept "(+ ?id 1)" unspec_manner)"crlf)
(printout ?*mrsdef* "(MRS_info id-MRS_concept "?id " manner)"crlf)
(printout ?*defdbug* "(rule-rel-values mrs_inter_how-verb id-MRS_concept "?id " manner)"crlf)
)

;Rule for creating udef_q for dijunct entries or noun.
;I like tea or coffee.
(defrule disjunct
(cxnlbl-id-values ?conj ?conjid $?var ?op1 ?op2)
(cxnlbl-id-val_ids	?conj	?conjid $?v ?n ?y)
(id-cl	?id1	?hincon)
(test (neq (str-index "disjunct_" ?conj) FALSE))
=>
(printout ?*mrsdef* "(MRS_info id-MRS_concept "(+ ?conjid 10)" udef_q)"crlf)
(printout ?*defdbug* "(rule-rel-values disjunct-pl id-MRS_concept "(+ ?conjid 10)" udef_q)"crlf)
)

;Rule for creating udef_q for dijunct entries or noun.
;I like tea or coffee.
(defrule disjunct
(construction-ids	disjunct $? ?id1 ?id2)
(rel-ids   ?rel        ?id ?id1)
(id-cl	?id1	?hincon)
(id-hin_concept-MRS_concept ?id1 ?hincon ?mrscon)
(test (eq (str-index _a_ ?mrscon) FALSE))
(not (id-morph_sem	?id1	?pl))
=>
(printout ?*mrsdef* "(MRS_info id-MRS_concept "(+ ?id1 210)" udef_q)"crlf)
(printout ?*defdbug* "(rule-rel-values disjunct-sg id-MRS_concept "(+ ?id1 210)" udef_q)"crlf)
)

;Rule for creating recip_pro and pronoun_q for reciprocal pronouns
;We love each other.
(defrule mrs_recip_pronoun
(id-cl	?rp	eka+xUsarA)
(rel-ids	?rell	?kri	?rp)
=>
(printout ?*mrsdef* "(MRS_info id-MRS_concept "(+ ?rp 10) " pronoun_q)"crlf)
(printout ?*defdbug* "(rule-rel-values mrs_recip_pronoun  id-MRS_concept "(+ ?rp 10) " pronoun_q)"crlf)

(printout ?*mrsdef* "(MRS_info id-MRS_concept "?rp" recip_pro)"crlf)
(printout ?*defdbug* "(rule-rel-values mrs_recip_pronoun  id-MRS_concept "?rp " recip_pro)"crlf)
)

;Rule for bringing place_n, which_q, _from_p_dir for k5 relation with $kim word in the second row. 
;Where did Rama come from?
(defrule mrs_inter_where-k5
(id-cl ?id $kim)
(rel-ids	k5	?noun	?id)
(not (id-anim	?id	yes)) ;#राम किससे डरता है
=>
(printout ?*mrsdef* "(MRS_info id-MRS_concept "(+ ?id 10) " which_q)"crlf)
(printout ?*defdbug* "(rule-rel-values mrs_inter_where-k5  id-MRS_concept "(+ ?id 10) " which_q)"crlf)
(printout ?*mrsdef* "(MRS_info id-MRS_concept "?id"  place_n)"crlf)
(printout ?*defdbug* "(rule-rel-values mrs_inter_where-k5 "?id" id-MRS_concept place_n)"crlf)
)

;Rule for bringing person and which_q when $kim+anim+k5 form exists in the USR
;#राम किससे डरता है
(defrule mrs_inter_where_anim_k5
(id-cl ?id $kim)
(rel-ids	k5	?noun	?id)
(id-anim	?id	yes)
=>
(printout ?*mrsdef* "(MRS_info id-MRS_concept "(+ ?id 10) " which_q)"crlf)
(printout ?*defdbug* "(rule-rel-values mrs_inter_where_anim-k5  id-MRS_concept "(+ ?id 10) " which_q)"crlf)
(printout ?*mrsdef* "(MRS_info id-MRS_concept "?id"  person)"crlf)
(printout ?*defdbug* "(rule-rel-values mrs_inter_where_anim-k5 "?id" id-MRS_concept person)"crlf)
)
;I will come to India in 2017.
(defrule years_of_century
(id-cl	?id	?hinconcept)
(id-yoc	?id	yes)
=>
(printout ?*mrsdef* "(MRS_info id-MRS_concept "?id " yofc)"crlf)
(printout ?*defdbug* "(rule-rel-values  years_of_century id-MRS_concept "?id " yofc)"crlf)
)

;#एक गांव में चार लडके रहते थे
(defrule numbers
(id-cl	?id	?hinconcept)
(id-numex	?id	yes)
(rel-ids	card	?noun	?id)

=>
(printout ?*mrsdef* "(MRS_info id-MRS_concept "(+ ?noun 20) " card)"crlf)
(printout ?*defdbug* "(rule-rel-values  numbers id-MRS_concept "(+ ?noun 20)" card)"crlf)
)

;My birthday is 23 September.
;Rule for generating dofm abstract predicate for dates of month.
(defrule date_of_month
(id-cl	?id	?hinconcept)
(id-dom	?id	yes)
=>
(printout ?*mrsdef* "(MRS_info id-MRS_concept "?id " dofm)"crlf)
(printout ?*defdbug* "(rule-rel-values  date_of_month id-MRS_concept "?id " dofm)"crlf)
)

(defrule mrs_inter_why
(id-cl ?id $kim)
(rel-ids	rh	?kri	?id)
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
(id-speakers_view  ?id  respect)
(rel-ids ?rel ?idd ?id)
(id-morph_sem	?id	?pl)
(id-female	?id	yes)
(not(id-cl	?id 	$addressee))
=>
(printout ?*mrsdef* "(MRS_info id-MRS_concept "(+ ?id 200)" compound)"crlf)
(printout ?*defdbug* "(rule-rel-values respect-feminine-pl id-MRS_concept "(+ ?id 200)" compound)"crlf)

(printout ?*mrsdef* "(MRS_info id-MRS_concept "(+ ?id 510)" udef_q)"crlf)
(printout ?*defdbug* "(rule-rel-values respect-feminine-pl id-MRS_concept "(+ ?id 510)" udef_q)"crlf)
)


;This rule generates MRS concept 'compound' for the feature 'respect' with gender 'f'. 
;405: rajani ji ne apane bete Ora apanI betI ko somavAra ko kASI ke sabase bade vixyAlaya meM BarawI kiyA. Eng: Ms. Rajani ...
(defrule respect-feminine
(id-speakers_view  ?id  respect)
(rel-ids ?rel ?idd ?id)
(id-female	?id	yes)
(not(id-cl	?id 	$addressee))
(not (id-morph_sem	?id	?pl))
=>
(printout ?*mrsdef* "(MRS_info id-MRS_concept "(+ ?id 200)" compound)"crlf)
(printout ?*defdbug* "(rule-rel-values respect-feminine-sg id-MRS_concept "(+ ?id 200)" compound)"crlf)

(printout ?*mrsdef* "(MRS_info id-MRS_concept "(+ ?id 510)" udef_q)"crlf)
(printout ?*defdbug* "(rule-rel-values respect-feminine-sg id-MRS_concept "(+ ?id 510)" udef_q)"crlf)
)

;This rule generates MRS concept 'compound' for the feature 'respect' with gender 'm'. 
;Mr. Sanju came.
(defrule respect-masculine
(id-speakers_view  ?id  respect)
(id-per  ?id  yes)
(rel-ids ?rel ?idd ?id)
(id-morph_sem	?id	?pl)
(id-male	?id	yes)
(not(id-cl	?id 	$addressee))
=>
(printout ?*mrsdef* "(MRS_info id-MRS_concept "(+ ?id 200)" compound)"crlf)
(printout ?*defdbug* "(rule-rel-values respect-masculine-pl id-MRS_concept "(+ ?id 200)" compound)"crlf)

(printout ?*mrsdef* "(MRS_info id-MRS_concept "(+ ?id 510)" udef_q)"crlf)
(printout ?*defdbug* "(rule-rel-values respect-masculine-pl id-MRS_concept "(+ ?id 510)" udef_q)"crlf)
)

;This rule generates MRS concept 'compound' for the feature 'respect' with gender 'm'. 
;Mr. Sanju came.
(defrule respect-masculine
(id-speakers_view  ?id  respect)
(id-per  ?id  yes)
(rel-ids ?rel ?idd ?id)
(id-male	?id	yes)
(not(id-cl	?id 	$addressee))
(not (id-morph_sem	?id	?pl))
=>
(printout ?*mrsdef* "(MRS_info id-MRS_concept "(+ ?id 200)" compound)"crlf)
(printout ?*defdbug* "(rule-rel-values respect-masculine-sg id-MRS_concept "(+ ?id 200)" compound)"crlf)

(printout ?*mrsdef* "(MRS_info id-MRS_concept "(+ ?id 510)" udef_q)"crlf)
(printout ?*defdbug* "(rule-rel-values respect-masculine-sg id-MRS_concept "(+ ?id 510)" udef_q)"crlf)
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
(sent_type  %affirmative)
(rel-ids	rbks	?id	?kri)
=>
(printout ?*mrsdef* "(MRS_info id-MRS_concept "(+ ?kri 1) " parg_d)"crlf)
(printout ?*defdbug* "(rule-rel-values mrs_parg_d_rbks  id-MRS_concept "(+ ?kri 1)" parg_d)"crlf)
)

(defrule mrs_subord_rblsk
(rel-ids	rblsk	?id	?kri)
=>
(printout ?*mrsdef* "(MRS_info id-MRS_concept "(+ ?kri 2000) " _as_x_subord)"crlf)
(printout ?*defdbug* "(rule-rel-values mrs_subord_rblsk id-MRS_concept "(+ ?kri 2000) " _as_x_subord)"crlf)
)

;Rule for bringing generic_entity when no card information available and numex tag available and number concept in the concept row.
;Three barked.
(defrule mrs_generic_Entity
(id-cl	?id1	?number)
(id-numex	?id1	yes)
(rel-ids	k1	?kri	?id1)
(not (rel-ids	card	?kri	?id1))
=>
(printout ?*mrsdef* "(MRS_info id-MRS_concept "?id1" generic_entity)"crlf)
(printout ?*defdbug* "(rule-rel-values mrs_generic_Entity id-MRS_concept "?id1" generic_entity)"crlf)
(printout ?*mrsdef* "(MRS_info id-MRS_concept "(+ ?id1 10) " udef_q)"crlf)
(printout ?*defdbug* "(rule-rel-values mrs_generic_Entity id-MRS_concept "(+ ?id1 10)" udef_q)"crlf)
)

;Rule for generating unknown for the kAryakAraNa relation in the discourse row.
;Because, he has to go home. #kyoMki vo Gara jAnA hE.
(defrule unknown-kAryakAraNa
(rel-ids kAryakAraNa ?previousid	?verb)
=>
(printout ?*mrsdef* "(MRS_info id-MRS_concept "(+ ?verb 1) "  unknown)"crlf)
(printout ?*defdbug* "(rule-rel-values  unknown-kAryakAraNa id-MRS_concept "(+ ?verb 1) "  unknown)"crlf)
)

(defrule date_of_month-compound
(id-dom	?id1	yes)
(id-moy	?id2	yes)
(rel-ids	r6	?id1	?id2)
=>
(printout ?*mrsdef* "(MRS_info id-MRS_concept "(+ ?id1 200) " compound)"crlf)
(printout ?*defdbug* "(rule-rel-values date_of_month-compound id-MRS_concept " (+ ?id1 200)" compound)"crlf)

(printout ?*mrsdef* "(MRS_info id-MRS_concept "(+ ?id1 210) " udef_q)"crlf)
(printout ?*defdbug* "(rule-rel-values date_of_month-compound id-MRS_concept "(+ ?id1 210)" udef_q)"crlf)
)

(defrule clock_time
(id-cl	?ct	 ?num)
(id-clocktime	?ct	yes)
(rel-ids	k7t	?kri	?ct)
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
(id-cl	?ct	 ?num)
(id-cl	?ct	 xopahara_2)
(rel-ids	k7t	?kri	?ct)
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
(id-cl	?id	$wyax)
(id-speakers_view	 ?id	 proximal)
(rel-ids	k7p	?kri	?id)
=>
(printout ?*mrsdef* "(MRS_info id-MRS_concept "?id " place_n)"crlf)
(printout ?*defdbug* "(rule-rel-values aps_of_here id-MRS_concept "?id " place_n)"crlf)

(printout ?*mrsdef* "(MRS_info id-MRS_concept "(+ ?id 10)" def_implicit_q)"crlf)
(printout ?*defdbug* "(rule-rel-values aps_of_here id-MRS_concept "(+ ?id 10)" def_implicit_q)"crlf)

(printout ?*mrsdef* "(MRS_info id-MRS_concept "(+ ?id 1) " loc_nonsp)"crlf)
(printout ?*defdbug* "(rule-rel-values aps_of_here id-MRS_concept "(+ ?id 1) " loc_nonsp)"crlf)
)

;rule for quantitative pronoun
(defrule quantitative_pronoun
(id-cl	?quant	kuCa_1)
(rel-ids	quant	?verb	?quant)
(id-hin_concept-MRS_concept ?verb ?hin ?mrsconcept)
(test (neq (str-index _v_ ?mrsconcept) FALSE))
=>
(printout ?*mrsdef* "(MRS_info id-MRS_concept "?quant" generic_entity)"crlf)
(printout ?*defdbug* "(rule-rel-values quantitative_pronoun id-MRS_concept "?quant" generic_entity)"crlf)
)

;Rule for generating abstract predicates 
;More than 300 people will come tomorrow.
(defrule quantmore-abst
(id-cl	?id	?num)
(rel-ids	quantmore	?modifier	?id)
=>
(printout ?*mrsdef* "(MRS_info id-MRS_concept "(+ ?id 20)" card)"crlf)
(printout ?*defdbug* "(rule-rel-values quantmore-abst id-MRS_concept "(+ ?id 20)" card)"crlf)
(printout ?*mrsdef* "(MRS_info id-MRS_concept "(+ ?id 10) " udef_q)"crlf)
(printout ?*defdbug* "(rule-rel-values quantmore-abst id-MRS_concept "(+ ?id 10) " udef_q)"crlf)
(printout ?*mrsdef* "(MRS_info  id-MRS_concept "(+ ?id 1) "  comp)"crlf)
(printout ?*defdbug* "(rule-rel-values  quantmore-abst   id-MRS_concept "(+ ?id 1) "  comp)"crlf)
(printout ?*mrsdef* "(MRS_info id-MRS_concept "?id" generic_entity)"crlf)
(printout ?*defdbug* "(rule-rel-values quantmore-abst id-MRS_concept "?id" generic_entity)"crlf)
(printout ?*mrsdef* "(MRS_info id-MRS_concept "(+ ?id 20)" much-many_a)"crlf)
(printout ?*defdbug* "(rule-rel-values quantmore-abst id-MRS_concept "(+ ?id 20)" much-many_a)"crlf)
)

;Rule for generating abstract predicates 
;Less than 300 people will come tomorrow.
(defrule quantless-abst
(id-cl	?id	?num)
(rel-ids	quantless	?modifier	?id)
=>
(printout ?*mrsdef* "(MRS_info id-MRS_concept "(+ ?id 20)" card)"crlf)
(printout ?*defdbug* "(rule-rel-values quantless-abst id-MRS_concept "(+ ?id 20)" card)"crlf)
(printout ?*mrsdef* "(MRS_info id-MRS_concept "(+ ?id 10) " udef_q)"crlf)
(printout ?*defdbug* "(rule-rel-values quantless-abst id-MRS_concept "(+ ?id 10) " udef_q)"crlf)
(printout ?*mrsdef* "(MRS_info  id-MRS_concept "(+ ?id 1) "  comp)"crlf)
(printout ?*defdbug* "(rule-rel-values  quantless-abst   id-MRS_concept "(+ ?id 1) "  comp)"crlf)
(printout ?*mrsdef* "(MRS_info id-MRS_concept "?id" generic_entity)"crlf)
(printout ?*defdbug* "(rule-rel-values quantless-abst id-MRS_concept "?id" generic_entity)"crlf)
(printout ?*mrsdef* "(MRS_info id-MRS_concept "(+ ?id 20)" little-few_a)"crlf)
(printout ?*defdbug* "(rule-rel-values quantless-abst id-MRS_concept "(+ ?id 20)" little-few_a)"crlf)
)

;My country.
(defrule unknown-title
(id-cl	?id	?hinconcept)
(rel-ids	main	0	?id)
(sent_type	%TITLE)
=>
(printout ?*mrsdef* "(MRS_info id-MRS_concept 0000000 unknown)"crlf)
(printout ?*defdbug* "(rule-rel-values  unknown-title id-MRS_concept 0000000 unknown)"crlf)
)

;Flora found in India
(defrule unknown-heading
(id-cl	?id	?hinconcept)
(rel-ids	main	0	?id)
(sent_type	heading)
=>
(printout ?*mrsdef* "(MRS_info id-MRS_concept 0000000 unknown)"crlf)
(printout ?*defdbug* "(rule-rel-values  unknown-heading id-MRS_concept 0000000 unknown)"crlf)
)

(defrule mrs_parg_d-heading
(sent_type  heading)
(rel-ids	mod	?noun	?modifier)
(id-hin_concept-MRS_concept ?modifier ?hinconcept ?verb)
(test (neq (str-index _v_ ?verb) FALSE))
(cxnlbl-id-values ?conj ?conjid ?op1 ?op2)
(cxnlbl-id-val_ids	?conj	?conjid  ?noun ?noun2)
(test (neq (str-index conj_ ?conj) FALSE))
=>
(printout ?*mrsdef* "(MRS_info id-MRS_concept "(+ ?modifier 10)" parg_d)"crlf)
(printout ?*defdbug* "(rule-rel-values mrs_parg_d-heading  id-MRS_concept "(+ ?modifier 10)" parg_d)"crlf)
)


;#अब्राम उस घंटे पहुंचे थे।
(defrule dem_time
(id-cl	?dem	 $wyax)
(id-cl	?time	 ?hintime)
(rel-ids	dem	?time	?dem)
(rel-ids	k7t	?kriya	?time)
=>
(printout ?*mrsdef* "(MRS_info id-MRS_concept "(+ ?time 1) " loc_nonsp)"crlf)
(printout ?*defdbug* "(rule-rel-values aps_of_dow_timeadverb id-MRS_concept "(+ ?time 1) " loc_nonsp)"crlf)
)

;Rule for generating unknown for the AvaSyakawApariNAma relation in the discourse row.
(defrule AvaSyakawApariNAma_ap
(rel-ids AvaSyakawApariNAma ?previousid	?verb)
=>
(printout ?*mrsdef* "(MRS_info id-MRS_concept "(+ ?verb 1) "  unknown)"crlf)
(printout ?*defdbug* "(rule-rel-values  AvaSyakawApariNAma id-MRS_concept "(+ ?verb 1) "  unknown)"crlf)
)

;Rule for generating thing AP for BI_3 discourse particle.
;If anything go wrong in the village.
(defrule anything
(id-cl	?id	?hinconcept)
(id-dis_part	?id	BI_3)
=>
(printout ?*mrsdef* "(MRS_info id-MRS_concept "?id" thing)"crlf)
(printout ?*defdbug* "(rule-rel-values anything id-MRS_concept "?id" thing)"crlf)
)

;Rule to generate focus_d for vyABIcAra discourse relation.
;#इसके बावजूद  वे बहुत घनिष्ठ मित्र थे
(defrule vyABIcAra
(rel-ids vyABIcAra|pariNAma ?previousid	?id)
=>
(printout ?*mrsdef* "(MRS_info id-MRS_concept "(+ ?id 1) " focus_d)"crlf)
(printout ?*defdbug* "(rule-rel-values vyABIcAra id-MRS_concept "(+ ?id 1) " focus_d)"crlf)
)

;Rule to generate generic_entity for vyABIcAra discourse relation.
;#इसके बावजूद  वे बहुत घनिष्ठ मित्र थे
(defrule vyABIcAra-ge
(rel-ids vyABIcAra ?previousid	?id)
(rel-ids	k1	?id	?karwa)
(id-speakers_view	 ?karwa	 distal)
=>
(printout ?*mrsdef* "(MRS_info id-MRS_concept "?id  " generic_entity)"crlf)
(printout ?*defdbug* "(rule-rel-values vyABIcAra-ge id-MRS_concept "?id " generic_entity)"crlf)
)

;Rule to generate generic_entity for pariNAma discourse relation.
;#इस कारण उनके माता पिता उनसे बहुत परेशान रहते थे
(defrule pariNAma-ge
(rel-ids pariNAma ?previousid	?id)
=>
(printout ?*mrsdef* "(MRS_info id-MRS_concept "?id " generic_entity)"crlf)
(printout ?*defdbug* "(rule-rel-values pariNAma-ge id-MRS_concept "?id " generic_entity)"crlf)
)

;Rule to generate loc_nonsp for xina word in the concept row with k7t relation.
;I will certainly help you one day.
(defrule loc_nonsp_xina
(id-cl	?id	?number)
(id-cl	?id1	xina_1)
(rel-ids	card	?id1	?id)
(rel-ids	k7t	?kriya	?id1)
=>
(printout ?*mrsdef* "(MRS_info id-MRS_concept "(+ ?id1 1) " loc_nonsp)"crlf)
(printout ?*defdbug* "(rule-rel-values loc_nonsp_xina id-MRS_concept "(+ ?id1 1)" loc_nonsp)"crlf)
)

(defrule samasa_udef_q_mod
(id-cl	 ?compounid	 ?nc_concept)
(cxn_rel-ids	 mod	 ?compoundid	 ?modval)
(cxnlbl-id-values ?nc_concept ?compounid  mod $?var)
(cxnlbl-id-val_ids ?nc_concept ?compounid ?modval $?vv)
(test (neq (str-index "nc_"  ?nc_concept) FALSE)) 
=>
(printout ?*mrsdef* "(MRS_info id-MRS_concept "(+ ?modval 10) " udef_q)"crlf)
(printout ?*defdbug* "(rule-rel-values samasa_udef_q_mod id-MRS_concept "(+ ?modval 10)" udef_q)"crlf)
)

(defrule transfer_samasa_udef_q
(id-hin_concept-MRS_concept ?compid ?hinconcept ?comp_mrs)
(test (neq (str-index "+"  ?comp_mrs) FALSE)) 
=>
(bind ?index (str-index "+" ?comp_mrs))
(bind ?purvapada (sub-string 0 (- ?index 1) ?comp_mrs))
(bind ?uttarapada (sub-string (+ ?index 1) (str-length  ?comp_mrs) ?comp_mrs))
(printout ?*mrsdef* "(MRS_info id-MRS_concept "(+ ?compid 1010)" udef_q)"crlf)
(printout ?*defdbug* "(rule-rel-values transfer_samasa_udef_q id-MRS_concept "(+ ?compid 1010)" udef_q)"crlf)
)

