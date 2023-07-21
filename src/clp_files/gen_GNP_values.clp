;generates output file "GNP_values.dat" which contains gender number person information for nouns,pronouns, proper nouns etc.


(defglobal ?*rstr-fp* = open-file)
(defglobal ?*rstr-dbug* = debug_fp)

;Rule for generating GEN - NUM - and PER 2 for "you" addressee in English 
;Where do you live? 
(defrule gnp-of-eng_pron-addressee
(id-num ?id1 ?n)
(or (id-male	?id1	yes) (id-female	?id1	yes))
(id-concept_label	?id1 	addressee)
(MRS_info ?rel1 ?id1 ?mrsCon  $?vars)
=>
(printout ?*rstr-fp* "(id-GEN-NUM-PER  "?id1 " - - 2 )"crlf)
(printout ?*rstr-dbug* "(rule-rel-values gnp-of-eng_pron-addressee id-GEN-NUM-PER "?id1 " - - 2 )"crlf)
)

;Rule for generating GEN - NUM sg and PER 3 for third person nouns.
;A baby eats fruit, in August.
(defrule gnp-of-eng_noun-sg
(id-concept_label	?id1	?hinconcept)
(id-num	?id1	?num)
(MRS_info ?rel1 ?id1 ?mrsCon  $?vars)
(not (id-concept_label	?id1	speaker|addressee|eka+xUsarA_1))
=>
(printout ?*rstr-fp* "(id-GEN-NUM-PER  "?id1 " -  "?num"  3 )"crlf)
(printout ?*rstr-dbug* "(rule-rel-values gnp-of-eng_noun-sg id-GEN-NUM-PER "?id1 " - "?num" 3 )"crlf)
)

;Rule for generating masculine gender "m" and generate the number and person information for personal pronouns with pronoun type standard "std"
(defrule gnp-of-eng_pron-personal-male
(id-num	?id1	?n)
(id-male	?id1	yes)
(MRS_info ?rel1 ?id1 ?mrsCon  $?vars)
(or (id-concept_label	?id1 	speaker|addressee) (rel_name-ids coref ?x	?id1))
(MRS_concept-H_P-Eng_P    pron   ?p  ?per)
(not (id-concept_label	?id1	eka+xUsarA_1)) ;We love each other."
=>
(printout ?*rstr-fp* "(id-GEN-NUM-PER-PT  "?id1 " m " ?n " " ?per " std )"crlf)
(printout ?*rstr-dbug* "(rule-rel-values gnp-of-eng_pron-personal-male id-GEN-NUM-PER-PT "?id1 "  m " ?n " "?per " std)"crlf)
)

;;Rule for generating feminine gender "f" and generate the number and person information for personal pronouns with pronoun type standard "std"
(defrule gnp-of-eng_pron-personal-female
(id-num	?id1	?n)
(id-female	?id1	yes)
(MRS_info ?rel1 ?id1 ?mrsCon  $?vars)
(or (id-concept_label	?id1 	speaker|addressee|vaha|yaha) (rel_name-ids coref ?x	?id1))
(MRS_concept-H_P-Eng_P    pron   ?p  ?per)
(not (id-concept_label	?id1	eka+xUsarA_1)) ;We love each other."
=>
(printout ?*rstr-fp* "(id-GEN-NUM-PER-PT  "?id1 " f " ?n " " ?per " std )"crlf)
(printout ?*rstr-dbug* "(rule-rel-values gnp-of-eng_pron-personal-female id-GEN-NUM-PER-PT "?id1 "  f " ?n " "?per " std)"crlf)
)

;Rule for generating neutral gender "-" and generate the number and person information for personal pronouns with pronoun type standard "std"

(defrule gnp-of-eng_pron-personal-neuter
(id-num	?id1	?n)
(MRS_info ?rel1 ?id1 ?mrsCon  $?vars)
(or (id-concept_label	?id1 	speaker|addressee|vaha|yaha) (rel_name-ids coref ?x	?id1))
(MRS_concept-H_P-Eng_P    pron   ?p  ?per)
(not (id-concept_label	?id1	eka+xUsarA_1)) ;We love each other."
=>
(printout ?*rstr-fp* "(id-GEN-NUM-PER-PT  "?id1 " - " ?n " " ?per " std )"crlf)
(printout ?*rstr-dbug* "(rule-rel-values gnp-of-eng_pron-personal-neuter id-GEN-NUM-PER-PT "?id1 "  - " ?n " "?per " std)"crlf)
)

;Rule for generating 3rd person pronouns with standard pronoun type and masculine gender.
;Ex: The food had been eaten by him.
(defrule gnp-of-eng_pron-personal-male-3rdperson
(id-num	?id1	?n)
(id-male	?id1	yes)
(MRS_info ?rel1 ?id1 ?mrsCon  $?vars)
(or (id-concept_label	?id1 	vaha|yaha) (rel_name-ids coref ?x	?id1))
(not (id-num	?id1	pl)) ;They are eating food.
=>
(printout ?*rstr-fp* "(id-GEN-NUM-PER-PT  "?id1 " m " ?n " 3 std )"crlf)
(printout ?*rstr-dbug* "(rule-rel-values gnp-of-eng_pron-personal-male-3rdperson id-GEN-NUM-PER-PT "?id1 "  m " ?n " 3 std)"crlf)
)

;Rule for generating 3rd person pronouns with standard pronoun type and feminine gender.
;Ex: The food had been eaten by her.
(defrule gnp-of-eng_pron-personal-female-3rdperson
(id-num	?id1	?n)
(id-female	?id1	yes)
(MRS_info ?rel1 ?id1 ?mrsCon  $?vars)
(or (id-concept_label	?id1 	vaha|yaha) (rel_name-ids coref ?x	?id1))
(not (id-num	?id1	pl)) ;They are eating food.
=>
(printout ?*rstr-fp* "(id-GEN-NUM-PER-PT  "?id1 " f " ?n " 3 std )"crlf)
(printout ?*rstr-dbug* "(rule-rel-values gnp-of-eng_pron-personal-female-3rdperson id-GEN-NUM-PER-PT "?id1 "  f " ?n " 3 std)"crlf)
)

;;Rule for generating 3rd person possessive pronouns with standard pronoun type and masculine gender. 
;Mohana calls Rama to his house.
(defrule gnp-of-eng_pron-apanA
(id-num	?id1	?n)
(id-male	?id1	yes)
(MRS_info ?rel1 ?id1 ?mrsCon  $?vars)
(id-concept_label	?x 	apanA) 
(rel_name-ids coref ?id1	?x)
(not (id-num	?id1	pl)) ;They are eating food.
=>
(printout ?*rstr-fp* "(id-GEN-NUM-PER-PT  "?x " m " ?n " 3 std )"crlf)
(printout ?*rstr-dbug* "(rule-rel-values gnp-of-eng_pron-apanA id-GEN-NUM-PER-PT "?x "  m " ?n " 3 std)"crlf)
)

;;Rule for generating 3rd person possessive pronouns with standard pronoun type and feminine gender. 
;Sita calls Rama to her house.
(defrule gnp-of-eng_pron-apanA-female
(id-num	?id1	?n)
(id-female	?id1	yes)
(MRS_info ?rel1 ?id1 ?mrsCon  $?vars)
(id-concept_label	?x 	apanA) 
(rel_name-ids coref ?id1	?x)
(not (id-num	?id1	pl)) ;They are eating food.
=>
(printout ?*rstr-fp* "(id-GEN-NUM-PER-PT  "?x " f " ?n " 3 std )"crlf)
(printout ?*rstr-dbug* "(rule-rel-values gnp-of-eng_pron-apanA-female id-GEN-NUM-PER-PT "?x "  f " ?n " 3 std)"crlf)
)

;;Rule for generating 1st person possessive pronouns with standard pronoun type and neuter gender. 
;I couldn't do my work.
(defrule gnp-of-eng_pron-apanA-1stperson
(id-num	?id1	?n)
(id-concept_label	?id1	speaker)
(MRS_info ?rel1 ?id1 ?mrsCon  $?vars)
(id-concept_label	?x 	apanA) 
(rel_name-ids coref ?id1	?x)
;(not (id-num	?id1	pl)) ;They are eating food.
=>
(printout ?*rstr-fp* "(id-GEN-NUM-PER-PT  "?x " " - " " ?n " 1 std )"crlf)
(printout ?*rstr-dbug* "(rule-rel-values gnp-of-eng_pron-apanA-1stperson id-GEN-NUM-PER-PT "?x " " - " " ?n " 1 std )"crlf)
)

;Rule for generating 3rd person reflexive pronouns with reflexive "refl" pronoun type and masculine gender. 
;Ex: He loves himself.
(defrule gnp-of-eng_pron-personal-male-3rdperson-reflexive
(id-num	?id1	?n)
(id-male	?id1	yes)
(MRS_info ?rel1 ?id1 ?mrsCon  $?vars)
(or (id-concept_label	?id1	Kuxa|KZuxa|svayam|svayaM) (rel_name-ids coref ?x	?id1))
(not (id-num	?id1	pl)) ;They are eating food.
(not (id-concept_label	?id1	apanA)) ;Rama calls everybody in his school.
=>
(printout ?*rstr-fp* "(id-GEN-NUM-PER-PT  "?id1 " m " ?n " 3 refl )"crlf)
(printout ?*rstr-dbug* "(rule-rel-values gnp-of-eng_pron-personal-male-3rdperson-reflexive id-GEN-NUM-PER-PT "?id1 "  m " ?n " 3 refl)"crlf)
)

;Rule for generating 3rd person reflexive pronouns with reflexive "refl" pronoun type and feminine gender. 
;She loves herself.
(defrule gnp-of-eng_pron-personal-female-3rdperson-reflexive
(id-num	?id1	?n)
(id-female	?id1	yes)
(MRS_info ?rel1 ?id1 ?mrsCon  $?vars)
(or (id-concept_label	?id1	Kuxa|KZuxa|svayam|svayaM) (rel_name-ids coref ?x	?id1))
(not (id-num	?id1	pl)) ;They are eating food.
(not (id-concept_label	?id1 	apanA)) ;Ms Rajani admitted to her son and her daughter, on Monday, in Kasi's largest school.
=>
(printout ?*rstr-fp* "(id-GEN-NUM-PER-PT  "?id1 " f " ?n " 3 refl )"crlf)
(printout ?*rstr-dbug* "(rule-rel-values gnp-of-eng_pron-personal-female-3rdperson-reflexive id-GEN-NUM-PER-PT "?id1 "  f " ?n " 3 refl)"crlf)
)

;Rule for generating 1st person reflexive pronouns with reflexive "refl" pronoun type and neuter gender. 
;I love myself.
(defrule gnp-of-eng_pron-personal-1stperson-reflexive
(id-num	?id1	?n)
(id-concept_label	?id1	speaker)
(MRS_info ?rel1 ?id1 ?mrsCon  $?vars)
(or (id-concept_label	?x	Kuxa|KZuxa|svayam|svayaM) (rel_name-ids coref ?id1	?x))
(not (id-num	?id1	pl)) ;They are eating food.
(not (id-concept_label	?x 	apanA)) ;mEM apanA kAma nahIM kara sakA.
=>
(printout ?*rstr-fp* "(id-GEN-NUM-PER-PT  "?x " " - " " ?n " 1 refl )"crlf)
(printout ?*rstr-dbug* "(rule-rel-values gnp-of-eng_pron-personal-1stperson-reflexive id-GEN-NUM-PER-PT "?x "  " - " " ?n " 1 refl)"crlf)
)



