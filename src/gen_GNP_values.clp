;generates output file "GNP_values.dat" which contains gender number person information for nouns,pronouns, proper nouns etc.


(defglobal ?*rstr-fp* = open-file)
(defglobal ?*rstr-dbug* = debug_fp)

;Rule for generating GEN - NUM - and PER 2 for "you" addressee in English 
;Where do you live? 
(defrule gnp-of-eng_pron-addressee
(or (id-male	?id1	yes) (id-female	?id1	yes))
(id-concept_label	?id1 	addressee)
(MRS_info ?rel1 ?id1 ?mrsCon  $?vars)
=>
(printout ?*rstr-fp* "(id-GEN-NUM-PER  "?id1 " - - 2 )"crlf)
(printout ?*rstr-dbug* "(rule-rel-values gnp-of-eng_pron-addressee id-GEN-NUM-PER "?id1 " - - 2 )"crlf)
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
(defrule gnp-of-eng_pron-personal-male-pl
(id-num	?id1	?pl)
(id-male	?id1	yes)
(MRS_info ?rel1 ?id1 ?mrsCon  $?vars)
(or (id-concept_label	?id1 	speaker|addressee) (rel_name-ids coref ?x	?id1))
(MRS_concept-H_P-Eng_P    pron   ?p  ?per)
(not (id-concept_label	?id1	eka+xUsarA)) ;We love each other."
=>
(printout ?*rstr-fp* "(id-GEN-NUM-PER-PT  "?id1 " m pl " ?per " std )"crlf)
(printout ?*rstr-dbug* "(rule-rel-values gnp-of-eng_pron-personal-male-pl id-GEN-NUM-PER-PT "?id1 "  m pl "?per " std)"crlf)
)

;Rule for generating masculine gender "m" and generate the number and person information for personal pronouns with pronoun type standard "std"
(defrule gnp-of-eng_pron-personal-male-sg
(id-male	?id1	yes)
(MRS_info ?rel1 ?id1 ?mrsCon  $?vars)
(or (id-concept_label	?id1 	speaker|addressee) (rel_name-ids coref ?x	?id1))
(MRS_concept-H_P-Eng_P    pron   ?p  ?per)
(not (id-concept_label	?id1	eka+xUsarA)) ;We love each other."
(not (id-num	?id1	pl))
=>
(printout ?*rstr-fp* "(id-GEN-NUM-PER-PT  "?id1 " -  sg " ?per " std )"crlf)
(printout ?*rstr-dbug* "(rule-rel-values gnp-of-eng_pron-personal-male-sg id-GEN-NUM-PER-PT "?id1 "  - sg "?per " std)"crlf)
)

;;Rule for generating feminine gender "f" and generate the number and person information for personal pronouns with pronoun type standard "std"
(defrule gnp-of-eng_pron-personal-female-sg
(id-female	?id1	yes)
(MRS_info ?rel1 ?id1 ?mrsCon  $?vars)
(or (id-concept_label	?id1 	speaker|addressee|wyax) (rel_name-ids coref ?x	?id1))
(MRS_concept-H_P-Eng_P    pron   ?p  ?per)
(not (id-concept_label	?id1	eka+xUsarA)) ;We love each other."
(not (id-num	?id1	pl))
=>
(printout ?*rstr-fp* "(id-GEN-NUM-PER-PT  "?id1 " f  sg  " ?per " std )"crlf)
(printout ?*rstr-dbug* "(rule-rel-values gnp-of-eng_pron-personal-female-sg id-GEN-NUM-PER-PT "?id1 "  f sg "?per " std)"crlf)
)

;;Rule for generating feminine gender "f" and generate the number and person information for personal pronouns with pronoun type standard "std"
(defrule gnp-of-eng_pron-personal-female-pl
(id-female	?id1	yes)
(id-num	?id1	pl)
(MRS_info ?rel1 ?id1 ?mrsCon  $?vars)
(or (id-concept_label	?id1 	speaker|addressee|wyax) (rel_name-ids coref ?x	?id1))
(MRS_concept-H_P-Eng_P    pron   ?p  ?per)
(not (id-concept_label	?id1	eka+xUsarA)) ;We love each other."
=>
(printout ?*rstr-fp* "(id-GEN-NUM-PER-PT  "?id1 " f pl " ?per " std )"crlf)
(printout ?*rstr-dbug* "(rule-rel-values gnp-of-eng_pron-personal-female-pl id-GEN-NUM-PER-PT "?id1 "  f pl "?per " std)"crlf)
)
;;Rule for generating feminine gender "f" and generate the number and person information for personal pronouns with pronoun type standard "std"
(defrule gnp-of-eng_pron-personal-female-sg
(id-female	?id1	yes)
(MRS_info ?rel1 ?id1 ?mrsCon  $?vars)
(or (id-concept_label	?id1 	speaker|addressee|wyax) (rel_name-ids coref ?x	?id1))
(MRS_concept-H_P-Eng_P    pron   ?p  ?per)
(not (id-concept_label	?id1	eka+xUsarA)) ;We love each other."
(not (id-num	?id1	pl))
=>
(printout ?*rstr-fp* "(id-GEN-NUM-PER-PT  "?id1 " f sg " ?per " std )"crlf)
(printout ?*rstr-dbug* "(rule-rel-values gnp-of-eng_pron-personal-female-sg id-GEN-NUM-PER-PT "?id1 "  f sg "?per " std)"crlf)
)

;Rule for generating neutral gender "-" and generate the number and person information for personal pronouns with pronoun type standard "std"

(defrule gnp-of-eng_pron-personal-neuter-pl
(id-num	?id1	pl)
(MRS_info ?rel1 ?id1 ?mrsCon  $?vars)
(or (id-concept_label	?id1 	speaker|addressee|wyax) (rel_name-ids coref ?x	?id1))
(MRS_concept-H_P-Eng_P    pron   ?p  ?per)
(not (id-concept_label	?id1	eka+xUsarA)) ;We love each other."
=>
(printout ?*rstr-fp* "(id-GEN-NUM-PER-PT  "?id1 " - pl " ?per " std )"crlf)
(printout ?*rstr-dbug* "(rule-rel-values gnp-of-eng_pron-personal-neuter-pl id-GEN-NUM-PER-PT "?id1 "  - pl "?per " std)"crlf)
)

;Rule for generating neutral gender "-" and generate the number and person information for personal pronouns with pronoun type standard "std"

(defrule gnp-of-eng_pron-personal-neuter-sg
(MRS_info ?rel1 ?id1 ?mrsCon  $?vars)
(or (id-concept_label	?id1 	wyax) (rel_name-ids coref ?x	?id1))
(not (id-concept_label	?id1	eka+xUsarA)) ;We love each other."
(not (id-num	?id1	pl))
(not (id-proximal	?id1	yes)) ; This is a house 
(not (id-distal	?id1	yes)) ; That book is beautiful. 
(not (id-per	?id1	yes)) 
=>
(printout ?*rstr-fp* "(id-GEN-NUM-PER-PT  "?id1 " n sg  3 std )"crlf)
(printout ?*rstr-dbug* "(rule-rel-values gnp-of-eng_pron-personal-neuter-sg id-GEN-NUM-PER-PT "?id1 " n sg  3 std)"crlf)
)

;Rule for generating 3rd person pronouns with standard pronoun type and masculine gender.
;Ex: The food had been eaten by him.
(defrule gnp-of-eng_pron-personal-male-3rdperson
;(id-num	?id1	?n)
(id-male	?id1	yes)
(MRS_info ?rel1 ?id1 ?mrsCon  $?vars)
(or (id-concept_label	?id1 	wyax) (rel_name-ids coref ?x	?id1))
(not (id-num	?id1	pl)) ;They are eating food.
=>
(printout ?*rstr-fp* "(id-GEN-NUM-PER-PT  "?id1 " m  sg  3 std )"crlf)
(printout ?*rstr-dbug* "(rule-rel-values gnp-of-eng_pron-personal-male-3rdperson id-GEN-NUM-PER-PT "?id1 "  m  sg  3 std)"crlf)
)

;Rule for generating 3rd person pronouns with standard pronoun type and feminine gender.
;Ex: The food had been eaten by her.
(defrule gnp-of-eng_pron-personal-female-3rdperson
;(id-num	?id1	?n)
(id-female	?id1	yes)
(MRS_info ?rel1 ?id1 ?mrsCon  $?vars)
(or (id-concept_label	?id1 	wyax) (rel_name-ids coref ?x	?id1))
(not (id-num	?id1	pl)) ;They are eating food.
=>
(printout ?*rstr-fp* "(id-GEN-NUM-PER-PT  "?id1 " f sg 3 std )"crlf)
(printout ?*rstr-dbug* "(rule-rel-values gnp-of-eng_pron-personal-female-3rdperson id-GEN-NUM-PER-PT "?id1 "  f sg 3 std)"crlf)
)

;;Rule for generating 3rd person possessive pronouns with standard pronoun type and masculine gender. 
;Mohana calls Rama to his house.
(defrule gnp-of-eng_pron-apanA
;(id-num	?id1	?n)
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
;(id-num	?id1	?n)
(id-female	?id1	yes)
(MRS_info ?rel1 ?id1 ?mrsCon  $?vars)
(id-concept_label	?x 	apanA) 
(rel_name-ids coref ?id1	?x)
(not (id-num	?id1	pl)) ;They are eating food.
=>
(printout ?*rstr-fp* "(id-GEN-NUM-PER-PT  "?x " f sg 3 std )"crlf)
(printout ?*rstr-dbug* "(rule-rel-values gnp-of-eng_pron-apanA-female id-GEN-NUM-PER-PT "?x "  f sg 3 std)"crlf)
)

;;Rule for generating 1st person possessive pronouns with standard pronoun type and neuter gender. 
;I couldn't do my work.
(defrule gnp-of-eng_pron-apanA-1stperson-sg
(id-num	?id1	pl)
(id-concept_label	?id1	speaker)
(MRS_info ?rel1 ?id1 ?mrsCon  $?vars)
(id-concept_label	?x 	apanA) 
(rel_name-ids coref ?id1	?x)
;(not (id-num	?id1	pl)) ;They are eating food.
=>
(printout ?*rstr-fp* "(id-GEN-NUM-PER-PT  "?x " " - " pl 1 std )"crlf)
(printout ?*rstr-dbug* "(rule-rel-values gnp-of-eng_pron-apanA-1stperson-sg id-GEN-NUM-PER-PT "?x " " - " pl 1 std )"crlf)
)

;;Rule for generating 1st person possessive pronouns with standard pronoun type and neuter gender. 
;I couldn't do my work.
(defrule gnp-of-eng_pron-apanA-1stperson-pl
(id-num	?id1	pl) ;They are eating food.
(id-concept_label	?id1	speaker)
(MRS_info ?rel1 ?id1 ?mrsCon  $?vars)
(id-concept_label	?x 	apanA) 
(rel_name-ids coref ?id1	?x)
=>
(printout ?*rstr-fp* "(id-GEN-NUM-PER-PT  "?x " " - " pl 1 std )"crlf)
(printout ?*rstr-dbug* "(rule-rel-values gnp-of-eng_pron-apanA-1stperson-pl id-GEN-NUM-PER-PT "?x " " - " pl 1 std )"crlf)
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
;(id-num	?id1	?n)
(id-female	?id1	yes)
(MRS_info ?rel1 ?id1 pron  $?vars)
(or (id-concept_label	?id1	Kuxa|KZuxa|svayam|svayaM) (rel_name-ids coref ?x	?id1))
(not (id-num	?id1	pl)) ;They are eating food.
(not (id-concept_label	?id1 	apanA)) ;Ms Rajani admitted to her son and her daughter, on Monday, in Kasi's largest school.
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

;Rule for generating Neuter gender when number is present but no gender information available.
;It is clear.
(defrule gnp-of-eng_neuter-pl
(id-num ?id1 pl)
(not (id-male	?id1	yes))
(not (id-female	?id1	yes))
(MRS_info ?rel1 ?id1 ?mrsCon  $?vars)
(id-concept_label	?id1	wyax)
(not (id-concept_label	?id1	speaker|addressee|eka+xUsarA))
=>
(printout ?*rstr-fp* "(id-GEN-NUM-PER  "?id1 " n pl 3 )"crlf)
(printout ?*rstr-dbug* "(rule-rel-values gnp-of-eng_neuter-pl id-GEN-NUM-PER "?id1 " n pl 3  )"crlf)
)

;Rule for generating Neuter gender when number is present but no gender information available.
;It is clear.
(defrule gnp-of-eng_neuter-sg
(MRS_info ?rel1 ?id1 ?mrsCon  $?vars)
(id-concept_label	?id1	wyax)
(not (id-concept_label	?id1	speaker|addressee|eka+xUsarA))
(not (id-num ?id1 pl))
(not (id-proximal	?id1	yes)) ;This is a house.
(not (id-distal	?id1	yes)) ; That book is beautiful. 
(not (id-per	?id1	yes))
=>
(printout ?*rstr-fp* "(id-GEN-NUM-PER  "?id1 " n pl 3 )"crlf)
(printout ?*rstr-dbug* "(rule-rel-values gnp-of-eng_neuter-sg id-GEN-NUM-PER "?id1 " n pl 3  )"crlf)
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
(id-pl	?id1	yes)
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
(id-pl	?id1	yes)
(MRS_info ?rel1 ?id1 pron  $?vars)
(not (id-concept_label	?id1	speaker|addressee|eka+xUsarA))
=>
(printout ?*rstr-fp* "(id-GEN-NUM-PER-PT  "?id1 " -  pl  3 std )"crlf)
(printout ?*rstr-dbug* "(rule-rel-values gnp-their id-GEN-NUM-PER-PT  "?id1 " - pl 3 std)"crlf)
)
