;generates output file "mrs_info.dat" that contains id and MRS concept for a and the.
;udef_q for plural noun and mass noun.
;neg for negation.

(defglobal ?*mrsdef* = mrs-def-fp)
(defglobal ?*defdbug* = mrs-def-dbug)

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
(not(id-concept_label	?id 	?concept&speaker|addressee|vaha|yaha|saba_4))
(not (rel_name-ids coref ?	?id))
;(not (sentence_type	)) ;;#kuwwA! ;#billI Ora kuwwA.
=>
(printout ?*mrsdef* "(MRS_info id-MRS_concept "(+ ?id 10) " udef_q)"crlf)
(printout ?*defdbug* "(rule-rel-values mrs_pl_notDef id-MRS_concept "(+ ?id 10)" udef_q)"crlf)
)

;Rule for mass noun : if (id-mass ?id yes) , generate (id-MRS_Rel ?id _udef_q)
(defrule mrs_mass_notDef
(id-num	?id	?n)
(id-mass ?id yes)
(not (id-def ?id yes))
(not (rel_name-ids dem ?id ?))
(not (rel_name-ids quant ?id ?))
(not (sentence_type	)) ;;#kuwwA! ;#billI Ora kuwwA.
=>
(printout ?*mrsdef* "(MRS_info id-MRS_concept "(+ ?id 10)" udef_q)"crlf)
(printout ?*defdbug* "(rule-rel-values  mrs_mass_notDef id-MRS_concept "(+ ?id 10)" udef_q)"crlf)
)

;Rule for creating unknown for non-sentence type.
;In case of topic names we need to generate unknown and udef_q.

(defrule udef_unknown
(id-num	?id	?n)
(sentence_type	)
=>
(printout ?*mrsdef* "(MRS_info id-MRS_concept 0000000 unknown)"crlf)
(printout ?*defdbug* "(rule-rel-values  udef_unknown id-MRS_concept 0000000 unknown)"crlf)
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
(sentence_type  interrogative)
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
(sentence_type  interrogative)
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
(sentence_type  interrogative)
(id-num	?id	?num)
(id-anim	?id	yes)
=>
(printout ?*mrsdef* "(MRS_info id-MRS_concept "(+ ?id 10) " which_q)"crlf)
(printout ?*defdbug* "(rule-rel-values mrs_inter_who-k1s id-MRS_concept " (+ ?id 10) " which_q)"crlf)
(printout ?*mrsdef* "(MRS_info id-MRS_concept "?id" person)"crlf)
(printout ?*defdbug* "(rule-rel-values mrs_inter_who-k1s id-MRS_concept "?id" person)"crlf)
)

;Rule for generating person and which_q for generating whom in the MRS 
;Whom did Rama meet? ;Whom did Rama ask a question?
(defrule mrs_inter_whom
(id-concept_label ?id kim)
(rel_name-ids	k2|k2g|k4	?kri	?id)
(id-anim	?id	yes)
(sentence_type  interrogative)
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
(sentence_type  interrogative)
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
;(id-concept_label ?id somavAra|maMgalavAra|buXavAra|guruvAra|SukravAra|SanivAra|ravivAra|bqhaspawi_1|bqhaspawivAra_1|buGa_1|buXa_1|buXavAra_1|caMxravAra_1|gurUvAra_1|guruvAra_1|iwavAra_1|jumA_1|jumerAwa_1|jummA_1|maMgala_1|maMgalavAra_1|maMgalavAsara_1|ravivAra_1|ravixina_1|sanIcara_2|SanivAra_1|soma_1|somavAra_1|Sukra_2|SukravAra_1)
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
;(id-concept_label ?id janavarI|ParavarI|mArca|aprELa|maI|jUna|juLAI|agaswa|siwaMbara|aktUbara|navaMbara|xisaMbara)
=>
(printout ?*mrsdef* "(MRS_info id-MRS_concept "?id " mofy)"crlf)
(printout ?*defdbug* "(rule-rel-values  monthsofyears id-MRS_concept "?id" mofy)"crlf)
(printout ?*mrsdef* "(MRS_info id-MRS_concept "(+ ?id 10) " proper_q)"crlf)
(printout ?*defdbug* "(rule-rel-values  monthsofyears id-MRS_concept "(+ ?id 10)" proper_q)"crlf)
)

(defrule yearsofcenturies
(id-concept_label ?id ?num)
(rel_name-ids k7t ?kri  ?id&:(numberp ?id))
(not (id-concept_label  ?k-id   ?hiConcept&kim|Aja_1|kala_1|kala_2|rAwa_1|xina_1|jalxI_9|xera_11|aba_1|pahale_4|rojZa_2|subaha_1|bAxa_1|sarxI_2))
=>
(printout ?*mrsdef* "(MRS_info id-MRS_concept "(+ ?id 10)" proper_q)"crlf)
(printout ?*defdbug* "(rule-rel-values  yearsofcenturies id-MRS_concept "(+ ?id 10) " proper_q)"crlf)
)

(defrule dayandnight
(id-concept_label ?id ?num)
(rel_name-ids k7t ?kri  ?id&:(numberp ?id))
(id-concept_label  ?k-id   ?hiConcept&rAwa_1)
=>
;(printout ?*mrsdef* "(MRS_info id-MRS_concept "(+ ?id 10)" def_implicit_q)"crlf)
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
;(id-hin_concept-MRS_concept ?id ?hinconcept ?engcon) 	
;(test (eq (str-index _n_ ?engcon) FALSE))
=>
(printout ?*mrsdef* "(MRS_info id-MRS_concept -20000 subord)"crlf)
(printout ?*defdbug* "(rule-rel-values mrs_subord id-MRS_concept -20000 subord)"crlf)
)

;rule for interrogative sentences for 'when'
(defrule mrs_inter_when
(id-concept_label ?id kim)
(rel_name-ids	k7t	?kri	?id)
(sentence_type  interrogative)
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
;(defrule nominalization
;(rel_name-ids	rt	?kri ?krikri)
;(id-hin_concept-MRS_concept ?krikri ?hinconcept ?mrsconcept)
;(test (neq (str-index _v_ ?mrsconcept) FALSE))
;=>
;(printout ?*mrsdef* "(MRS_info  id-MRS_concept "(+ ?krikri 200) "  nominalization)"crlf)
;(printout ?*defdbug* "(rule-rel-values    nominalization  id-MRS_concept "(+ ?krikri 200) "  nominalization)"crlf)

;(printout ?*mrsdef* "(MRS_info  id-MRS_concept "(+ ?krikri 10) "  udef_q)"crlf)
;(printout ?*defdbug* "(rule-rel-values  nominalization   id-MRS_concept "(+ ?krikri 10) "  udef_q)"crlf)
;)

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
(defrule comper_more
(id-degree	?id	comper_more)
=>
(printout ?*mrsdef* "(MRS_info  id-MRS_concept "(+ ?id 20) "  comp)"crlf)
(printout ?*defdbug* "(rule-rel-values  comper_more   id-MRS_concept "(+ ?id 20) "  comp)"crlf)
)

;Rule for creating comp mrs concept for comparative sentences.
;#rAma mohana se kama buxXimAna hE .
(defrule comper_less
(id-degree	?id comper_less)
=>
(printout ?*mrsdef* "(MRS_info  id-MRS_concept "(+ ?id 30) "  comp_less)"crlf)
(printout ?*defdbug* "(rule-rel-values  comper_more   id-MRS_concept "(+ ?id 30) "  comp_less)"crlf)
)

;Rule for bringing comp_equal for ru relation.
(defrule comper-equal
(rel_name-ids ru ?id ?id1)
(not (id-degree	?adjid	comper_more)) 
(not (id-degree	?adjid	comper_less))
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
(defrule implicit_conj4pred
(construction-ids	conj  $? ?n $? ?x ?y)
(rel_name-ids   ?rel        ?id ?n)
(id-concept_label	?n	?hincon)
(id-num	?n	?sgpl)
=>
(printout ?*mrsdef* "(MRS_info id-MRS_concept "(+ ?n 10)" udef_q)"crlf)
(printout ?*defdbug* "(rule-rel-values implicit_conj4pred id-MRS_concept "(+ ?n 10)" udef_q)"crlf)
)

;Rule for creating udef_q for when the sentence consists of only two noun entries in the construction for unknown.
;#billI Ora kuwwA.
(defrule implicit_conj4unknown
(construction-ids	conj  ?n ?y)
(rel_name-ids   ?rel        ?id ?n)
(id-concept_label	?n	?hincon)
(id-num	?n	?sgpl)
=>
(printout ?*mrsdef* "(MRS_info id-MRS_concept "(+ ?n 10)" udef_q)"crlf)
(printout ?*defdbug* "(rule-rel-values implicit_conj4unknown id-MRS_concept "(+ ?n 10)" udef_q)"crlf)
)

;Rule for creating udef_q for the construction with two subjective entries. 
;;#rAma Ora sIwA acCe hEM.
(defrule udefq_conj4subj
(declare (salience 100))
(construction-ids	conj  $? ?n ?y)
(id-num	?n	?sgpl)
=>
(printout ?*mrsdef* "(MRS_info id-MRS_concept "(+ ?n 10)" udef_q)"crlf)
(printout ?*defdbug* "(rule-rel-values udefq_conj4subj id-MRS_concept "(+ ?n 10)" udef_q)"crlf)
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
(sentence_type  interrogative)
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
(sentence_type  interrogative)
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
(sentence_type  interrogative)
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
(sentence_type  interrogative)
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
(id-num	?id1	?sgpl)
=>
(printout ?*mrsdef* "(MRS_info id-MRS_concept "(+ ?id1 510)" udef_q)"crlf)
(printout ?*defdbug* "(rule-rel-values disjunct id-MRS_concept "(+ ?id1 510)" udef_q)"crlf)
)

;Rule for creating recip_pro and pronoun_q for reciprocal pronouns
;We love each other.
(defrule mrs_recip_pronoun
(id-concept_label	?rp	eka+xUsarA_1)
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
(sentence_type  interrogative)
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
(sentence_type  interrogative)
(id-anim	?id	yes)
=>
(printout ?*mrsdef* "(MRS_info id-MRS_concept "(+ ?id 10) " which_q)"crlf)
(printout ?*defdbug* "(rule-rel-values mrs_inter_where_anim-k5  id-MRS_concept "(+ ?id 10) " which_q)"crlf)
(printout ?*mrsdef* "(MRS_info id-MRS_concept "?id"  person)"crlf)
(printout ?*defdbug* "(rule-rel-values mrs_inter_where_anim-k5 "?id" id-MRS_concept person)"crlf)
)

(defrule years_of_century
(id-concept_label	?id	?hinconcept)
(id-yoc	?id	yes)
=>
(printout ?*mrsdef* "(MRS_info id-MRS_concept "?id " yofc)"crlf)
(printout ?*defdbug* "(rule-rel-values  years_of_century id-MRS_concept "?id " yofc)"crlf)
)

(defrule mrs_inter_why
(id-concept_label ?id kim)
(rel_name-ids	rh	?kri	?id)
(sentence_type  interrogative)
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
(id-num	?id	?sgpl)
(id-female	?id	yes)
(not(id-concept_label	?id 	addressee))
=>
(printout ?*mrsdef* "(MRS_info id-MRS_concept "(+ ?id 2) " compound)"crlf)
(printout ?*defdbug* "(rule-rel-values respect-feminine id-MRS_concept " (+ ?id 2)" compound)"crlf)

(printout ?*mrsdef* "(MRS_info id-MRS_concept "(+ ?id 10) " udef_q)"crlf)
(printout ?*defdbug* "(rule-rel-values respect-feminine id-MRS_concept "(+ ?id 10)" udef_q)"crlf)
)

;This rule generates MRS concept 'compound' for the feature 'respect' with gender 'm'. 
;Mr. Sanju came.
(defrule respect-masculine
(id-respect  ?id  yes)
(id-per  ?id  yes)
(rel_name-ids ?rel ?idd ?id)
(id-num	?id	?sgpl)
(id-male	?id	yes)
(not(id-concept_label	?id 	addressee))
=>
(printout ?*mrsdef* "(MRS_info id-MRS_concept "(+ ?id 2) " compound)"crlf)
(printout ?*defdbug* "(rule-rel-values respect-masculine id-MRS_concept " (+ ?id 2)" compound)"crlf)

(printout ?*mrsdef* "(MRS_info id-MRS_concept "(+ ?id 10) " udef_q)"crlf)
(printout ?*defdbug* "(rule-rel-values respect-masculine id-MRS_concept "(+ ?id 10)" udef_q)"crlf)
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
