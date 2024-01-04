;generates output file "GNP_values.dat" which contains gender number person information for nouns,pronouns, proper nouns etc.


(defglobal ?*rstr-fp* = open-file)
(defglobal ?*rstr-dbug* = debug_fp)

;Rule for generating GEN - NUM - and PER 2 for "you" addressee in English 
;Where do you live? 
(defrule gnp-of-eng_pron-addressee-you
;(or (id-male	?id1	yes) (id-female	?id1	yes))
(id-concept_label	?id1 	addressee)
(MRS_info ?rel1 ?id1 ?mrsCon  $?vars)
=>
(printout ?*rstr-fp* "(id-GEN-NUM-PER  "?id1 " - - 2 )"crlf)
(printout ?*rstr-dbug* "(rule-rel-values gnp-of-eng_pron-addressee-you id-GEN-NUM-PER "?id1 " - - 2 )"crlf)
)

;Rule for generating GEN - NUM sg and PER 3 for third person nouns.
;A baby eats fruit, in August.
(defrule gnp-of-eng_noun-pl
(id-concept_label	?id1	?hinconcept)
(id-num	?id1	pl)
(MRS_info ?rel1 ?id1 ?mrsCon  $?vars)
(not (id-concept_label	?id1	speaker|addressee|eka+xUsarA))
=>
(printout ?*rstr-fp* "(id-GEN-NUM-PER  "?id1 " -  pl  3 )"crlf)
(printout ?*rstr-dbug* "(rule-rel-values gnp-of-eng_noun-pl id-GEN-NUM-PER "?id1 " - pl 3 )"crlf)
)

;Rule for generating masculine gender "m" and generate the number and person information for personal pronouns with pronoun type standard "std"
;He is good.
(defrule gnp-of-eng_pron-personal-male-he
(id-male	?id1	yes)
(or (id-concept_label	?id1 	wyax) (rel_name-ids coref ?x	?id1))
(MRS_info ?rel1 ?id1 ?mrsCon  $?vars)
(not (id-num	?id1	pl)) ;They are good.
=>
(printout ?*rstr-fp* "(id-GEN-NUM-PER-PT  "?id1 " m sg 3 std )"crlf)
(printout ?*rstr-dbug* "(rule-rel-values gnp-of-eng_pron-personal-male-he id-GEN-NUM-PER-PT "?id1 " m sg 3 std )"crlf)
)

;;Rule for generating feminine gender "f" and generate the number and person information for personal pronouns with pronoun type standard "std"
;She is good.
(defrule gnp-of-eng_pron-personal-female-she
(id-female	?id1	yes)
(or (id-concept_label	?id1 	wyax) (rel_name-ids coref ?x	?id1))
(MRS_info ?rel1 ?id1 ?mrsCon  $?vars)
(not (id-num	?id1	pl))
=>
(printout ?*rstr-fp* "(id-GEN-NUM-PER-PT  "?id1 " f  sg  3 std )"crlf)
(printout ?*rstr-dbug* "(rule-rel-values gnp-of-eng_pron-personal-female-she id-GEN-NUM-PER-PT "?id1 "  f  sg  3 std)"crlf)
)

;Rule for generating neutral gender "-" and generate the number and person information for personal pronouns with pronoun type standard "std"
;They are good.
(defrule gnp-of-eng_pron-personal-neuter-pl-they
(MRS_info ?rel1 ?id1 ?mrsCon  $?vars)
(or (id-concept_label	?id1 	wyax) (rel_name-ids coref ?x	?id1))
(id-num	?id1	pl)
(id-proximal	?id1	yes)
=>
(printout ?*rstr-fp* "(id-GEN-NUM-PER-PT  "?id1 " - pl  3 std )"crlf)
(printout ?*rstr-dbug* "(rule-rel-values gnp-of-eng_pron-personal-neuter-pl id-GEN-NUM-PER-PT-they "?id1 "  - pl 3 std)"crlf)
)

;Rule for generating neutral gender "-" and generate the number and person information for personal pronouns with pronoun type standard "std"
(defrule gnp-of-eng_pron-personal-neuter-k1
(MRS_info ?rel1 ?id1 ?mrsCon  $?vars)
(or (id-concept_label	?id1 	wyax) (rel_name-ids coref ?x	?id1))
(not (id-num	?id1	pl))
(id-proximal	?id1	yes) ; This is a house
(not (id-anim	?id1	yes))
(not (id-female	?id1	yes))
(not (id-male	?id1	yes))
(not (rel_name-ids	dem	?ii	?id1))
(not (rel_name-ids	k7p	?ii	?id1)) ; He comes here daily.
=>
(printout ?*rstr-fp* "(id-GEN-NUM-PER  "?id1 " n sg  3 )"crlf)
(printout ?*rstr-dbug* "(rule-rel-values gnp-of-eng_pron-personal-neuter-k1 id-GEN-NUM-PER "?id1 " n sg  3)"crlf)
)

;Rule for generating neutral gender "-" and generate the number and person information for personal pronouns with pronoun type standard "std"
(defrule gnp-of-eng_pron-personal-neuter-dem
(MRS_info ?rel1 ?id1 ?mrsCon  $?vars)
(or (id-concept_label	?id1 	wyax) (rel_name-ids coref ?x	?id1))
(rel_name-ids	dem	?ii	?id1)
(not (id-num	?id1	pl))
(id-proximal	?id1	yes) ; This is a house
(not (id-anim	?id1	yes))
(not (id-female	?id1	yes))
(not (id-male	?id1	yes))
=>
(printout ?*rstr-fp* "(id-GEN-NUM-PER  "?id1 " - sg  3 )"crlf)
(printout ?*rstr-dbug* "(rule-rel-values gnp-of-eng_pron-personal-neuter-dem id-GEN-NUM-PER "?id1 " - sg  3)"crlf)
)

;;Rule for generating 3rd person possessive pronouns with standard pronoun type and masculine gender. 
;Mohana calls Rama to his house.
(defrule gnp-of-eng_pron-apanA
(id-male	?id1	yes)
(MRS_info ?rel1 ?id1 ?mrsCon  $?vars)
(id-concept_label	?x 	apanA) 
(rel_name-ids coref ?id1	?x)
(not (id-num	?id1	pl)) ;They are eating food.
=>
(printout ?*rstr-fp* "(id-GEN-NUM-PER-PT  "?x " m sg 3 std )"crlf)
(printout ?*rstr-dbug* "(rule-rel-values gnp-of-eng_pron-apanA id-GEN-NUM-PER-PT "?x "  m sg 3 std)"crlf)
)

;;Rule for generating 3rd person possessive pronouns with standard pronoun type and feminine gender. 
;Sita calls Rama to her house.
(defrule gnp-of-eng_pron-apanA-female
(id-female	?id1	yes)
(MRS_info ?rel1 ?id1 ?mrsCon  $?vars)
(id-concept_label	?x 	apanA) 
(rel_name-ids coref ?id	?x)
(not (id-num	?id1	pl)) ;They are eating food.
=>
(printout ?*rstr-fp* "(id-GEN-NUM-PER-PT  "?x " f sg 3 std )"crlf)
(printout ?*rstr-dbug* "(rule-rel-values gnp-of-eng_pron-apanA-female id-GEN-NUM-PER-PT "?x "  f sg 3 std)"crlf)
)

;;Rule for generating 1st person possessive pronouns with standard pronoun type and neuter gender. 
;I couldn't do "my" work.
(defrule gnp-of-eng_pron-apanA-1stperson-my
(id-concept_label	?id1	speaker)
(MRS_info ?rel1 ?id1 ?mrsCon  $?vars)
(id-concept_label	?x 	apanA) 
(rel_name-ids coref ?id1	?x)
(not (id-num	?id1	pl)) ;They are eating food.
=>
(printout ?*rstr-fp* "(id-GEN-NUM-PER-PT  "?x " " - " sg 1 std )"crlf)
(printout ?*rstr-dbug* "(rule-rel-values gnp-of-eng_pron-apanA-1stperson-my id-GEN-NUM-PER-PT "?x " " - " sg 1 std )"crlf)
)

;;Rule for generating 1st person possessive pronouns with standard pronoun type and neuter gender. 
;Our plan worked.
(defrule gnp-of-eng_pron-apanA-1stperson-our
(id-num	?id1	pl) ;They are eating food.
(id-concept_label	?id1	speaker)
(MRS_info ?rel1 ?id1 ?mrsCon  $?vars)
(id-concept_label	?x 	apanA) 
(rel_name-ids coref ?id1	?x)
=>
(printout ?*rstr-fp* "(id-GEN-NUM-PER-PT  "?x " " - " pl 1 std )"crlf)
(printout ?*rstr-dbug* "(rule-rel-values gnp-of-eng_pron-apanA-1stperson-our id-GEN-NUM-PER-PT "?x " " - " pl 1 std )"crlf)
)

;;Rule for generating 1st person possessive pronouns with standard pronoun type and neuter gender. 
;I couldn't do my work.
(defrule gnp-of-eng_pron-apanA-1stperson-I
(id-concept_label	?id1	speaker)
(MRS_info ?rel1 ?id1 ?mrsCon  $?vars)
(not (id-num	?id1	pl)) ;They are eating food.
=>
(printout ?*rstr-fp* "(id-GEN-NUM-PER-PT  "?id1 " " - " sg 1 std )"crlf)
(printout ?*rstr-dbug* "(rule-rel-values gnp-of-eng_pron-1stperson-sg id-GEN-NUM-PER-PT "?id1 " " - " sg 1 std )"crlf)
)

;;Rule for generating 1st person possessive pronouns with standard pronoun type and neuter gender. 
;We couldn't do our work.
(defrule gnp-of-eng_pron-apanA-1stperson-We
(id-num	?id1	pl) ;They are eating food.
(id-concept_label	?id1	speaker)
(MRS_info ?rel1 ?id1 ?mrsCon  $?vars)
=>
(printout ?*rstr-fp* "(id-GEN-NUM-PER-PT  "?id1 " " - " pl 1 std )"crlf)
(printout ?*rstr-dbug* "(rule-rel-values gnp-of-eng_pron-1stperson-pl id-GEN-NUM-PER-PT "?id1 " " - " pl 1 std )"crlf)
)
;Rule for generating 3rd person reflexive pronouns with reflexive "refl" pronoun type and masculine gender. 
;Ex: He loves himself.
(defrule gnp-of-eng_pron-personal-male-3rdperson-reflexive
(id-male	?id1	yes)
(id-anim	?id1	yes)
(MRS_info ?rel1 ?id1 pron  $?vars)
(or (id-concept_label	?id1	Kuxa|KZuxa|svayam|svayaM) (rel_name-ids coref ?x	?id1))
(not (id-num	?id1	pl)) ;They are eating food.
(not (id-concept_label	?id1	apanA)) ;Rama calls everybody in his school.
=>
(printout ?*rstr-fp* "(id-GEN-NUM-PER-PT  "?id1 " m sg 3 refl )"crlf)
(printout ?*rstr-dbug* "(rule-rel-values gnp-of-eng_pron-personal-male-3rdperson-reflexive id-GEN-NUM-PER-PT "?id1 "  m sg 3 refl)"crlf)
)

;Rule for generating 3rd person reflexive pronouns with reflexive "refl" pronoun type and feminine gender. 
;She loves herself.
(defrule gnp-of-eng_pron-personal-female-3rdperson-reflexive
(id-female	?id1	yes)
(MRS_info ?rel1 ?id1 pron  $?vars)
(or (id-concept_label	?id1	Kuxa|KZuxa|svayam|svayaM) (rel_name-ids coref ?x	?id1))
(not (id-num	?id1	pl)) ;They are eating food.
(not (id-concept_label	?idx 	apanA)) ;Ms Rajani admitted to her son and her daughter, on Monday, in Kasi's largest school.
=>
(printout ?*rstr-fp* "(id-GEN-NUM-PER-PT  "?id1 " f sg 3 refl )"crlf)
(printout ?*rstr-dbug* "(rule-rel-values gnp-of-eng_pron-personal-female-3rdperson-reflexive id-GEN-NUM-PER-PT "?id1 "  f sg 3 refl)"crlf)
)

;Rule for generating 1st person reflexive pronouns with reflexive "refl" pronoun type and neuter gender. 
;I love myself.
(defrule gnp-of-eng_pron-personal-1stperson-reflexive
;(id-num	?id1	?n)
(id-concept_label	?id1	speaker)
(MRS_info ?rel1 ?id1 ?mrsCon  $?vars)
(or (id-concept_label	?x	Kuxa|KZuxa|svayam|svayaM) (rel_name-ids coref ?id1	?x))
(not (id-num	?id1	pl)) ;They are eating food.
(not (id-concept_label	?x 	apanA)) ;mEM apanA kAma nahIM kara sakA.
=>
(printout ?*rstr-fp* "(id-GEN-NUM-PER-PT  "?x " " - " sg 1 refl )"crlf)
(printout ?*rstr-dbug* "(rule-rel-values gnp-of-eng_pron-personal-1stperson-reflexive id-GEN-NUM-PER-PT "?x "  " - " sg 1 refl)"crlf)
)

(defrule def_no_plural-singular
(id-def	?id1	yes)
(id-concept_label	?id1	?hinconcept)
(MRS_info ?rel1 ?id1 ?mrsCon  $?vars)
(not (id-num	?id1	pl)) ;They are eating food.
=>
(printout ?*rstr-fp* "(id-GEN-NUM-PER  "?id1 " - sg 3)"crlf)
(printout ?*rstr-dbug* "(rule-rel-values def_no_plural-singular id-GEN-NUM-PER "?id1 "  - sg 3 )"crlf)
)

;John's son studies in the school.
(defrule no_def-pl
(id-num	?id1	pl)
(id-concept_label	?id1	?hinconcept)
(MRS_info ?rel1 ?id1 ?mrsCon  $?vars)
(not (id-concept_label	?id1	speaker|addressee|eka+xUsarA|wyax))
;(not (id-num	?id1	pl)) ;They are eating food.
(not (id-def	?id1	yes))
=>
(printout ?*rstr-fp* "(id-GEN-NUM-PER  "?id1 " - pl 3)"crlf)
(printout ?*rstr-dbug* "(rule-rel-values no_def-pl id-GEN-NUM-PER "?id1 "  - pl 3 )"crlf)
)

(defrule no_plural_def-singular
(id-concept_label	?id1	?hinconcept)
(MRS_info ?rel1 ?id1 ?mrsCon  $?vars)
(or (id-male	?id1	yes) (id-female	?id1	yes))
(not (id-concept_label	?id1	speaker|addressee|eka+xUsarA|wyax))
(not (id-num	?id1	pl)) ;They are eating food.
(not (id-def	?id1	yes))
(not (id-per  ?id1 yes))
(not (id-place  ?id1 yes))
(not (id-org  ?id yes))
(not (id-ne  ?id yes))
=>
(printout ?*rstr-fp* "(id-GEN-NUM-PER  "?id1 " - sg 3)"crlf)
(printout ?*rstr-dbug* "(rule-rel-values no_plural_def-singular id-GEN-NUM-PER "?id1 " - sg 3 )"crlf)
)

(defrule no_plural_no_def-singular
(id-concept_label	?id1	?hinconcept)
(MRS_info ?rel1 ?id1 ?mrsCon  $?vars)
(test (neq (str-index _n_ ?mrsCon) FALSE))
(not (id-male	?id1	yes))
(not (id-female	?id1	yes))
(not (id-concept_label	?id1	speaker|addressee|eka+xUsarA|wyax))
(not (id-num	?id1	pl)) ;They are eating food.
(not (id-def	?id1	yes))
(not (id-per  ?id1 yes))
(not (id-place  ?id1 yes))
(not (id-org  ?id1 yes))
(not (id-ne  ?id1 yes))
=>
(printout ?*rstr-fp* "(id-GEN-NUM-PER  "?id1 " - sg 3)"crlf)
(printout ?*rstr-dbug* "(rule-rel-values no_plural_no_def-singular id-GEN-NUM-PER "?id1 " - sg 3 )"crlf)
)

;Rule for generating GNP for the sentence having wyax, distal, pl and k2 information. 
;you will look at them carefully.
(defrule gnp-them
(id-concept_label	?id1 	wyax) 
(rel_name-ids coref ?x	?id1)
(rel_name-ids	k2	?kri	?id1)
(id-distal	?id1	yes) ;you will look at them carefully.
(id-num	?id1	pl)
;(id-pl	?id1	yes)
(MRS_info ?rel1 ?id1 pron  $?vars)
(not (id-concept_label	?id1	speaker|addressee|eka+xUsarA))
=>
(printout ?*rstr-fp* "(id-GEN-NUM-PER-PT  "?id1 " -  pl  3 std )"crlf)
(printout ?*rstr-dbug* "(rule-rel-values gnp-them id-GEN-NUM-PER-PT  "?id1 " - pl 3 std)"crlf)
)

;;Rule for generating GNP for the sentence having wyax, proximal, pl and r6 information. 
;But their number rises afterwards.
(defrule gnp-their
(id-concept_label	?id1 	wyax) 
(rel_name-ids coref ?x	?id1)
(rel_name-ids	r6	?kri	?id1)
(id-proximal	?id1	yes) ;you will look at them carefully.
(id-num	?id1	pl)
;(id-pl	?id1	yes)
(MRS_info ?rel1 ?id1 pron  $?vars)
(not (id-concept_label	?id1	speaker|addressee|eka+xUsarA))
=>
(printout ?*rstr-fp* "(id-GEN-NUM-PER-PT  "?id1 " -  pl  3 std )"crlf)
(printout ?*rstr-dbug* "(rule-rel-values gnp-their id-GEN-NUM-PER-PT  "?id1 " - pl 3 std)"crlf)
)
