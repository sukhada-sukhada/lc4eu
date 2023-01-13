;generates output file "GNP_values.dat" which contains gender number person information for nouns,pronouns, proper nouns etc.


(defglobal ?*rstr-fp* = open-file)
(defglobal ?*rstr-dbug* = debug_fp)

;Generate GNP info for pronouns in imperative sentences.
;(MRS_info id-MRS_concept -10000 pronoun_q)
;(MRS_info id-MRS_concept -10000 pron )
;Ex Sahara jAo.
(defrule pronImper
;(id-gen-num-pers -10000 ?hg ?hn m)
(MRS_info ?rel -10000 ?mrsCon  $?vars)
;(test (neq (str-index _n_ ?mrsCon) FALSE))
=>
;[ x PERS: 2 PT: zero ]
(printout ?*rstr-fp* "(id-GEN-NUM-PER  -10000 -  - 2 )"crlf)
(printout ?*rstr-dbug* "(rule-rel-values pronImper id-GEN-NUM-PER -10000 -  -  2 )"crlf)
)


;Generating GEN-NUM-PERS INFO of proper noun
(defrule gnp-of-eng_N_
(id-gen-num-pers ?id1 ?hg ?hn a)
(id-propn ?id1 yes)
(MRS_info ?rel1 ?id1 proper_q  $?vars)
(MRS_concept-H_G-Eng_G    *_n_*   ?hg  ?eg)
(MRS_concept-H_N-Eng_N    *_n_*   ?hn   ?en)
(MRS_concept-H_P-Eng_P    *_n_*   ?hp   3)
;(test (neq (str-index _n_ ?mrsCon) FALSE))
=>
(printout ?*rstr-fp* "(id-GEN-NUM-PER  "?id1 " " - " " ?en "  3 )"crlf)
(printout ?*rstr-dbug* "(rule-rel-values gnp-of-eng_N_ id-GEN-NUM-PER "?id1 " " - " " ?en " 3 )"crlf)
)


;Generating GEN-NUM-PERS INFO of noun : if mrsCon contains _n_ , then pick it's repective values from "H_GNP_to_MRS_GNP.dat" and generate (id-GEN-NUM-PER  ?id - ?n ?p)
(defrule gnp-of-eng_noun_
(id-gen-num-pers ?id1 ?hg ?hn a)
(MRS_info ?rel1 ?id1 ?mrsCon  $?vars)
(MRS_concept-H_G-Eng_G    *_n_*   ?hg  ?eg)
(MRS_concept-H_N-Eng_N    *_n_*   ?hn   ?en)
(MRS_concept-H_P-Eng_P    *_n_*   ?hp   3)
(test (neq (str-index _n_ ?mrsCon) FALSE))
(not (id-concept_label	?id1 	speaker|addressee|vaha|yaha))
=>
(printout ?*rstr-fp* "(id-GEN-NUM-PER  "?id1 " -  " ?en "  3 )"crlf)
(printout ?*rstr-dbug* "(rule-rel-values gnp-of-eng_noun_ id-GEN-NUM-PER "?id1 " - " ?en " 3 )"crlf)
)

;Generating GEN-NUM-PERS INFO on pronoun :  if (id-pron ?id yes),then pick the repective values for the mrsCon from "H_GNP_to_MRS_GNP.dat" and generate (id-GEN-NUM-PER  ?id ?g ?n ?p)

(defrule gnp-of-eng_pron
(id-gen-num-pers ?id1 ?g ?n ?p)
(MRS_info ?rel1 ?id1 ?mrsCon  $?vars)
(or (id-concept_label	?id1 	speaker|addressee|vaha|yaha) (rel_name-ids coref ?x	?id1))
(MRS_concept-H_G-Eng_G    pron   ?g  ?eg)
(MRS_concept-H_N-Eng_N    pron   ?n  ?en)
(MRS_concept-H_P-Eng_P    pron   ?p  ?ep)
(not (id-concept_label	?id1	eka+xUsarA_1)) ;We love each other."
=>
(if (or (neq (str-index u ?p) FALSE) (neq (str-index pl ?n) FALSE))
then
       (printout ?*rstr-fp* "(id-GEN-NUM-PER-PT  "?id1 " - " ?n " " ?ep " std )"crlf)
       (printout ?*rstr-dbug* "(rule-rel-values gnp-of-eng_pron id-GEN-NUM-PER-PT "?id1 "  " ?eg " " ?n " "?ep " std)"crlf)

else
 	(printout ?*rstr-fp* "(id-GEN-NUM-PER-PT  "?id1 "  "  ?eg " " ?n " " ?ep " std )"crlf)
	(printout ?*rstr-dbug* "(rule-rel-values gnp-of-eng_pron id-GEN-NUM-PER-PT "?id1 "  " ?eg " " ?n " "?ep " std)"crlf)
)
)

;This rule is for the gnp values of the addressee. It replaces gender and number of addressee with '-'
(defrule gnp-of-eng_pron-addressee
(declare (salience 1000))
?f<-(id-gen-num-pers ?id1 ?g ?n m)
(id-concept_label	?id1 	addressee)
(MRS_concept-H_G-Eng_G    pron   ?g  ?eg)
(MRS_concept-H_N-Eng_N    pron   ?n  ?en)
(MRS_concept-H_P-Eng_P    pron   ?hp  2)
(not (modified id-gen-num-pers ?id1))
=>
(assert (modified id-gen-num-pers ?id1))
(retract ?f)
(printout ?*rstr-fp* "(id-GEN-NUM-PER  "?id1 " - - 2)"crlf)
(printout ?*rstr-dbug* "(rule-rel-values gnp-of-eng_pron-addressee id-GEN-NUM-PER "?id1 " - - 2)"crlf)
)

;Rule for reflexives pronouns. It generates PT: refl 
;I love myself.
(defrule gnp-of-eng_reflexive 
(id-gen-num-pers ?id1 ?g ?n ?p)
(id-concept_label	?id1	Kuxa|KZuxa|svayam|svayaM)
(MRS_info ?rel1 ?id1 pron  $?vars)
(or (rel_name-ids coref ?x	?id1))
(MRS_concept-H_G-Eng_G    pron   ?g  ?eg)
(MRS_concept-H_N-Eng_N    pron   ?n  ?en)
(MRS_concept-H_P-Eng_P    pron   ?p  ?ep)
(not (id-concept_label	?id1	eka+xUsarA_1)) ;We love each other."
=>
(if (or (neq (str-index u ?p) FALSE) (neq (str-index pl ?n) FALSE))
then
       (printout ?*rstr-fp* "(id-GEN-NUM-PER-PT  "?id1 " - " ?n " " ?ep " refl )"crlf)
       (printout ?*rstr-dbug* "(rule-rel-values gnp-of-eng_reflexive id-GEN-NUM-PER-PT "?id1 "  " ?eg " " ?n " "?ep " refl)"crlf)

else
 	(printout ?*rstr-fp* "(id-GEN-NUM-PER-PT  "?id1 "  "  ?eg " " ?n " " ?ep " refl )"crlf)
	(printout ?*rstr-dbug* "(rule-rel-values gnp-of-eng_reflexive id-GEN-NUM-PER-PT "?id1 "  " ?eg " " ?n " "?ep " refl)"crlf)
)
)

