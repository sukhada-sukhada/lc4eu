;generates output file "id-concept_label-mrs_concept.dat" which contains id,hindi concept label, and MRS concept for the hindi user csv by matching concepts from hindi clips facts from the file hin-clips-facts.dat.

(defglobal ?*mrsCon* = mrs-file)
(defglobal ?*mrs-dbug* = mrs-dbug)
(defglobal ?*unkmrs* = unkmrs)
(defglobal ?*unkmrs-debug* = unkmrs-dbug)



;Rule for changing feature values with NN.*_u_unknown with a known word leviathan.
;This rule checks for features having NN.*_u_unknown and then parse with the word leviathan.
;#rAma kaserA nahIM hE.
;#mEMne AleKa paDI.
;If the NN needs till ARG0 then count 4 rule will works with word leviathan
;If the NN needs till ARG1 then count 6 rule will works with word resuscitation
;If the NN needs till ARG2 then count 8 rule will works with word gift
(defrule unknown-NN
(declare (salience 10000))
(id-concept_label       ?id   ?conLabel)
?f<-(concept_label-concept_in_Eng-MRS_concept ?conLabel ?enCon ?mrsConcept)
(MRS_concept-label-feature_values ?mrsConcept $?fv)
(test (neq (str-index _u_unknown ?mrsConcept) FALSE))
(test (neq (str-index NN ?mrsConcept) FALSE))
=>
(retract ?f)
(bind ?count (length$ (create$ $?fv)))
(bind ?unknown (sub-string (+(str-index / ?mrsConcept)1) (str-length ?mrsConcept) ?mrsConcept))
(if (neq (str-index NN ?unknown) FALSE) then
  (if (eq ?count 4)    then
    (assert (id-hin_concept-MRS_concept ?id ?conLabel _leviathan_n_1))
    (printout ?*mrs-dbug* "(rule-rel-values unknown-NN id-hin_concept-MRS_concept  "?unknown" "?id " " ?conLabel " _leviathan_n_1)"crlf)
    (bind ?origword (sub-string 2 (-(str-index / ?mrsConcept)1) ?mrsConcept))
    (printout ?*unkmrs* "(origal_word-dummy_word "?origword" leviathan)"crlf)
    (printout ?*unkmrs-debug* "(rule-rel-values unknown-NN origal_word-dummy_word "?origword" leviathan)"crlf)     )
(if (eq ?count 6)    then
    (assert (id-hin_concept-MRS_concept ?id ?conLabel _resuscitation_n_of))
    (printout ?*mrs-dbug* "(rule-rel-values unknown-NN id-hin_concept-MRS_concept  "?unknown" "?id " " ?conLabel " _resuscitation_n_of)"crlf)
    (bind ?origword (sub-string 2 (-(str-index / ?mrsConcept)1) ?mrsConcept))
    (printout ?*unkmrs* "(origal_word-dummy_word "?origword" resuscitation)"crlf)
    (printout ?*unkmrs-debug* "(rule-rel-values unknown-NN origal_word-dummy_word "?origword" resuscitation)"crlf)     )
(if (eq ?count 8)    then
    (assert (id-hin_concept-MRS_concept ?id ?conLabel _gift_n_of-to))
    (printout ?*mrs-dbug* "(rule-rel-values unknown-NN id-hin_concept-MRS_concept  "?unknown" "?id " " ?conLabel " _gift_n_of-to)"crlf)
    (bind ?origword (sub-string 2 (-(str-index / ?mrsConcept)1) ?mrsConcept))
    (printout ?*unkmrs* "(origal_word-dummy_word "?origword" gift)"crlf)
    (printout ?*unkmrs-debug* "(rule-rel-values unknown-NN origal_word-dummy_word "?origword" gift)"crlf)     )
))

;Rule for changing feature values with JJ.*_u_unknown with a known word ostentatious.
;This rule checks for features having JJ.*_u_unknown and then parse with the word ostentatious.
;#mEMne avinaSvara kiwAba paDI for JJ.*_u_unknown.
(defrule unknown-JJ
(declare (salience 10000))
(id-concept_label       ?id   ?conLabel)
?f<-(concept_label-concept_in_Eng-MRS_concept ?conLabel ?enCon ?mrsConcept)
(MRS_concept-label-feature_values ?mrsConcept $?fv)
(test (neq (str-index _u_unknown ?mrsConcept) FALSE))
(test (neq (str-index JJ ?mrsConcept) FALSE))
=>
(retract ?f)
(bind ?count (length$ (create$ $?fv)))
(bind ?unknown (sub-string (+(str-index / ?mrsConcept)1) (str-length ?mrsConcept) ?mrsConcept))
(if (neq (str-index JJ ?unknown) FALSE) then
  (if (eq ?count 6)    then
    (assert (id-hin_concept-MRS_concept ?id ?conLabel _ostentatious_a_1))
    (printout ?*mrs-dbug* "(rule-rel-values unknown-JJ id-hin_concept-MRS_concept  "?unknown" "?id " " ?conLabel " _ostentatious_a_1)"crlf)
    (bind ?origword (sub-string 2 (-(str-index / ?mrsConcept)1) ?mrsConcept))
    (printout ?*unkmrs* "(origal_word-dummy_word "?origword" ostentatious)"crlf)
    (printout ?*unkmrs-debug* "(rule-rel-values unknown-JJ origal_word-dummy_word "?origword" ostentatious)"crlf)     )
))

;Rule for changing feature values with RB.*_u_unknown with a known word discordant.
;This rule checks for features having RB.*_u_unknown and then parse with the word discordant.
;#mEM akAraNa kAma kara huZ. for RB.*_u_unknown
(defrule unknown-RB
(declare (salience 10000))
(id-concept_label       ?id   ?conLabel)
?f<-(concept_label-concept_in_Eng-MRS_concept ?conLabel ?enCon ?mrsConcept)
(MRS_concept-label-feature_values ?mrsConcept $?fv)
(test (neq (str-index _u_unknown ?mrsConcept) FALSE))
(test (neq (str-index RB ?mrsConcept) FALSE))
=>
(retract ?f)
(bind ?count (length$ (create$ $?fv)))
(bind ?unknown (sub-string (+(str-index / ?mrsConcept)1) (str-length ?mrsConcept) ?mrsConcept))
(if (neq (str-index RB ?unknown) FALSE) then
  (if (eq ?count 6)    then
    (assert (id-hin_concept-MRS_concept ?id ?conLabel _discordant_a_1))
    (printout ?*mrs-dbug* "(rule-rel-values unknown-RB id-hin_concept-MRS_concept  "?unknown" "?id " " ?conLabel " _discordant_a_1)"crlf)
    (bind ?origword (sub-string 2 (-(str-index / ?mrsConcept)1) ?mrsConcept))
    (printout ?*unkmrs* "(origal_word-dummy_word "?origword" discordant)"crlf)
    (printout ?*unkmrs-debug* "(rule-rel-values unknown-RB origal_word-dummy_word "?origword" discordant)"crlf)     )
))


;Rule for changing feature values with VB.*_u_unknown with a known word winnow.
;This rule checks for features having VB.*_u_unknown and then parse with the word winnow.
;#rAma kaserA nahIM hE.
;#mEMne AleKa paDI.
;If the VB needs till ARG2 then count 8 rule will works with word winnow
;If the VB needs till ARG3 then count 10 rule will works with word bequeath
;#mEM kala sarAha.
(defrule unknown-VB
(declare (salience 10000))
(id-concept_label       ?id   ?conLabel)
?f<-(concept_label-concept_in_Eng-MRS_concept ?conLabel ?enCon ?mrsConcept)
(MRS_concept-label-feature_values ?mrsConcept $?fv)
(test (neq (str-index _u_unknown ?mrsConcept) FALSE))
(test (neq (str-index VB ?mrsConcept) FALSE))
=>
(retract ?f)
(bind ?count (length$ (create$ $?fv)))
(bind ?unknown (sub-string (+(str-index / ?mrsConcept)1) (str-length ?mrsConcept) ?mrsConcept))
(if (neq (str-index VB ?unknown) FALSE) then
(if (eq ?count 8)    then
    (assert (id-hin_concept-MRS_concept ?id ?conLabel _winnow_v_1))
    (printout ?*mrs-dbug* "(rule-rel-values unknown-VB id-hin_concept-MRS_concept  "?unknown" "?id " " ?conLabel " _winnow_v_1)"crlf)
    (bind ?origword (sub-string 2 (-(str-index / ?mrsConcept)1) ?mrsConcept))
    (printout ?*unkmrs* "(origal_word-dummy_word "?origword" winnow)"crlf)
    (printout ?*unkmrs-debug* "(rule-rel-values unknown-VB origal_word-dummy_word "?origword" winnow)"crlf)     )
)

(if (eq ?count 10)    then
    (assert (id-hin_concept-MRS_concept ?id ?conLabel _bequeath_v_1))
    (printout ?*mrs-dbug* "(rule-rel-values unknown-VB id-hin_concept-MRS_concept  "?unknown" "?id " " ?conLabel " _bequeath_v_1)"crlf)
    (bind ?origword (sub-string 2 (-(str-index / ?mrsConcept)1) ?mrsConcept))
    (printout ?*unkmrs* "(origal_word-dummy_word "?origword" bequeath)"crlf)
    (printout ?*unkmrs-debug* "(rule-rel-values unknown-VB origal_word-dummy_word "?origword" bequeath)"crlf)     )
)

;matches concept from hin-clips-facts.dat
(defrule mrs-rels
;(declare (salience 100))
(id-concept_label       ?id   ?conLabel)
(concept_label-concept_in_Eng-MRS_concept ?conLabel ?enCon ?mrsConcept)
=>
(assert (id-hin_concept-MRS_concept ?id ?conLabel ?mrsConcept))
(printout ?*mrs-dbug* "(rule-rel-values mrs-rels id-hin_concept-MRS_concept "?id " " ?conLabel " "?mrsConcept ")"crlf)
)



;rule for generating  _have_v_1 for k4a
;muJe buKAra hE.
(defrule k4a
(declare (salience 10000))
?f1<-(id-concept_label	?kri	hE_1)
(rel_name-ids	k4a	?kri	?k4a)
?f<-(id-hin_concept-MRS_concept ?kri hE_1 ?mrsConcept)
=>
(retract ?f ?f1)
(assert (id-hin_concept-MRS_concept ?kri hE_1  _have_v_1))
(printout ?*mrs-dbug* "(rule-rel-values  k4a  id-MRS_concept "?kri"  _have_v_1)"crlf)
)


(defrule print-mrs-rels
;(declare (salience 100))
?f<-(id-hin_concept-MRS_concept ?id ?conLabel ?mrsConcept)
=>
(retract ?f)
(printout ?*mrsCon* "(id-hin_concept-MRS_concept "?id " " ?conLabel " " ?mrsConcept ")"crlf)
(printout ?*mrs-dbug* "(rule-rel-values print-mrs-rels id-hin_concept-MRS_concept "?id " " ?conLabel " " ?mrsConcept ")"crlf)
)



