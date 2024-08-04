;generates output file "mrs_info-pron.dat" which contains id, pron and pronoun_q for all the pronouns


(defglobal ?*mrsdef* = mrs-def-fp)
(defglobal ?*defdbug* = mrs-def-dbug)

;Rule for pronoun : if (id-pron ?id yes) generate (id-MRS_Rel ?id pronoun_q) and (id-MRS_Rel ?id pron)
;#mEM Gara jA sakawA hUz.
(defrule mrsPron_yes
(id-concept_label	?id 	speaker|addressee|wyax)
(not (rel_name-ids	dem	?kri	?id))
(not (rel_name-ids	k7p	?kri	?id)) ;A mouse used to live in the hole, there.
(not (id-proximal	?id	yes))
(not (id-distal	?id	yes))
=>
(printout ?*mrsdef* "(MRS_info id-MRS_concept "(+ ?id 10)" pronoun_q )"crlf)
(printout ?*defdbug* "(rule-rel-values mrsPron_yes id-MRS_concept "(+ ?id 10)" pronoun_q )"crlf)

(printout ?*mrsdef* "(MRS_info id-MRS_concept "?id " pron)"crlf)
(printout ?*defdbug* "(rule-rel-values mrsPron_yes id-MRS_concept "?id " pron)"crlf)
)

; Generates new facts (MRS_info id-MRS_concept ID pron) and (MRS_info id-MRS_concept ID _pronoun) for imperative sentences ;(rel_name-ids	k1	30000	10000)

; Ex. Sahara jAo
(defrule pron4imper
(sentence_type imperative)
(or (kriyA-TAM	?id1	o_1) (kriyA-TAM	?id1	o_2))
(not (and (id-concept_label	?id 	speaker|addressee|wyax) (rel_name-ids k1 ?id1 ?id))) ;#Apa Sahara jAo!
=>
(printout ?*mrsdef* "(MRS_info id-MRS_concept "(+ ?id1 10)" pronoun_q)"crlf) 
(printout ?*defdbug* "(rule-rel-values pron4imper id-MRS_concept "(+ ?id1 10)"  pronoun_q )"crlf)

(printout ?*mrsdef* "(MRS_info id-MRS_concept "?id1 " pron)"crlf)
(printout ?*defdbug* "(rule-rel-values pron4imper id-MRS_concept "?id1 " pron)"crlf)
)

;(rel_name-ids	r6	30000	20000)
;(rel_name-ids coref  10000	20000)
;rule for possesive pronoun :if ((rel_name-ids r6 ?id) is present, generate (id-MRS_concept ?id def_explicit_q) and (id-MRS_concept ?id poss)
(defrule mrs_poss_pron
(rel_name-ids r6 ?viSeRya ?r6)
(not (id-concept_label	?r6	kisa_1))
(not (sentence_type  interrogative))
(not (id-concept_label	?viSeRya pICA+kara_1))
(not (id-moy	?r6	yes))
;(not (construction-ids	conj	$?v1 ?viSeRya $?v))
=>
(printout ?*mrsdef* "(MRS_info id-MRS_concept "(+ ?viSeRya 10) " def_explicit_q)"crlf)
(printout ?*defdbug* "(rule-rel-values mrs_poss_pron id-MRS_concept "(+ ?viSeRya 10)" def_explicit_q)"crlf)

(printout ?*mrsdef* "(MRS_info id-MRS_concept "(+ ?viSeRya 20)" poss)"crlf)
(printout ?*defdbug* "(rule-rel-values mrs_poss_pron id-MRS_concept "(+ ?viSeRya 20)" poss)"crlf)
)

;rule for generating MRS concept 'every_q' for 'saba_4/everyone/everybody'.
(defrule mrs_every_q
(id-concept_label ?id saba_4)
=>
(printout ?*mrsdef* "(MRS_info id-MRS_concept "(+ ?id 10)" every_q)"crlf)
(printout ?*defdbug* "(rule-rel-values mrs_every_q  id-MRS_concept "(+ ?id 10)" every_q)"crlf)
)


;rule for demonstrative pronoun
(defrule mrs_dem_pron-this
(id-concept_label	?dem	wyax)
(id-proximal	?dem	yes)
(rel_name-ids	k1|k2	?noun	?dem)
(not (rel_name-ids coref ?kuchh	?dem))
=>
(printout ?*mrsdef* "(MRS_info id-MRS_concept "?dem " generic_entity)"crlf)
(printout ?*defdbug* "(rule-rel-values mrs_dem_pron-this id-MRS_concept "?dem" generic_entity)"crlf)
)

;rule for demonstrative pronoun
(defrule mrs_dem_pron-that
(id-concept_label	?dem	wyax)
(id-distal	?dem	yes)
(rel_name-ids	k1	?noun	?dem)
(not (rel_name-ids coref ?ddd	?dem))
=>
(printout ?*mrsdef* "(MRS_info id-MRS_concept "?dem " generic_entity)"crlf)
(printout ?*defdbug* "(rule-rel-values mrs_dem_pron-that id-MRS_concept "?dem" generic_entity)"crlf)
)

;345: vaha apane piwA  ke sAWa vixyAlaya gayI 
;343: rAma apane piwA  ke sAWa vixyAlaya gayA 
(defrule coref
(rel_name-ids coref  ?referent    ?coref)
(id-concept_label       ?coref    ?conL)
(not (id-concept_label	?coref eka+xUsarA)) ; 326: #hama eka xUsare se pyAra karawe hEM.
(not (rel_name-ids	dem	?ddd	?coref))
(not (rel_name-ids	k7p	?ddd	?coref))
=>
(printout ?*mrsdef* "(MRS_info id-MRS_concept "(+ ?coref 10)" pronoun_q)"crlf)
(printout ?*defdbug* "(rule-rel-values  coref  id-MRS_concept "(+ ?coref 10)" pronoun_q )"crlf)

(printout ?*mrsdef* "(MRS_info id-MRS_concept "?coref " pron)"crlf)
(printout ?*defdbug* "(rule-rel-values  coref  id-MRS_concept "?coref " pron)"crlf)
)

;Rule to generate poss and def_explicit_q for r6 and rhh relation with wyax as a concept in the concept row.
(defrule mrs_poss_pron_wyax
(rel_name-ids r6|rhh ?viSeRya ?r6)
(id-concept_label	?r6	wyax)
=>
(printout ?*mrsdef* "(MRS_info id-MRS_concept "(+ ?viSeRya 10) " def_explicit_q)"crlf)
(printout ?*defdbug* "(rule-rel-values mrs_poss_pron_wyax id-MRS_concept "(+ ?viSeRya 10)" def_explicit_q)"crlf)

(printout ?*mrsdef* "(MRS_info id-MRS_concept "(+ ?viSeRya 20)" poss)"crlf)
(printout ?*defdbug* "(rule-rel-values mrs_poss_pron_wyax id-MRS_concept "(+ ?viSeRya 20)" poss)"crlf)
)


