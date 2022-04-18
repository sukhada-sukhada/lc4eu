;generates output file "id-concept_label-mrs_concept.dat" which contains id,hindi concept label, and MRS concept for the hindi user csv by matching concepts from hindi clips facts from the file hin-clips-facts.dat.

(defglobal ?*mrsCon* = mrs-file)
(defglobal ?*mrs-dbug* = mrs-dbug)

;(matches concept from hin-clips-facts.dat)
(defrule mrs-rels
;(declare (salience 100))
(id-concept_label       ?id   ?conLabel)
(concept_label-concept_in_Eng-MRS_concept ?conLabel ?enCon ?mrsConcept)
=>
(assert (id-hin_concept-MRS_concept ?id ?conLabel ?mrsConcept))
(printout ?*mrs-dbug* "(rule-rel-values mrs-rels id-hin_concept-MRS_concept "?id " " ?conLabel " "?mrsConcept ")"crlf)
)


;Deletes the MRS concept fact of stative verb "be" if Predicative adjective exists.
;e.g #rAma acCA hE. (Rama is good).
(defrule state-pred-adj
(id-concept_label       ?id   state_copula)
(id-guNavAcI    ?id1   yes) 
?f<-(id-hin_concept-MRS_concept ?id ?conLabel ?mrsConcept)
=>
(retract ?f)
;(printout ?*mrsCon* "(id-hin_concept-MRS_concept "?id " " ?conLabel " " ?mrsConcept ")"crlf)
(printout ?*mrs-dbug* "(rule-rel-values state-pred-adj id-hin_concept-MRS_concept "?id " " ?conLabel " " ?mrsConcept ")"crlf)
)

;Deletes the MRS concept fact of stative verb (existential) "be" .
;e.g #rAma xillI meM HE. (Rama is in Delhi).
(defrule state-existential
(id-concept_label       ?id   state_existential)
(rel_name-ids   AXAra-AXeya     ?id1  ?id2)
?f<-(id-hin_concept-MRS_concept ?id ?conLabel ?mrsConcept)
=>
(retract ?f)
;(printout ?*mrsCon* "(id-hin_concept-MRS_concept "?id " " ?conLabel " " ?mrsConcept ")"crlf)
(printout ?*mrs-dbug* "(rule-rel-values state-existential id-hin_concept-MRS_concept "?id " " ?conLabel " " ?mrsConcept ")"crlf)
)

(defrule print-mrs-rels
;(declare (salience 100))
?f<-(id-hin_concept-MRS_concept ?id ?conLabel ?mrsConcept)
=>
(retract ?f)
(printout ?*mrsCon* "(id-hin_concept-MRS_concept "?id " " ?conLabel " " ?mrsConcept ")"crlf)
(printout ?*mrs-dbug* "(rule-rel-values print-mrs-rel id-hin_concept-MRS_concept "?id " " ?conLabel " " ?mrsConcept ")"crlf)
)



