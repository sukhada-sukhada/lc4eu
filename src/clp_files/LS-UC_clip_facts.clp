(defglobal ?*mrsCon* = ls-uc)
(defglobal ?*mrs-dbug* = ls-uc-dbug)

(defrule updateConcepts
(declare (salience 9000)) 
?f1<-(USRinfo id-lsl	 ?id	 ?lanspec)
?f<-(cl-ls-mrs ?conLabel ?lanspec ?mrsConcept)
=>
(retract ?f ?f1)
(printout ?*mrsCon* "(id-cl	 "?id"	 "?conLabel")"crlf)
(printout ?*mrs-dbug* "(rule-rel-values updateConcepts id-cl	 "?id"	 "?conLabel")"crlf)
)

(defrule updateTAM
(USRinfo kriyA-TAM	 ?id2	 ?lanspectam)
(U_TAM-LS_TAM-Perfective_Aspect-Progressive_Aspect-Tense-Modal ?uni_label ?lanspectam $?var)
=>
(printout ?*mrsCon* "(kriyA-TAM	 "?id2"	 "?uni_label")"crlf)
(printout ?*mrs-dbug* "(rule-rel-values updateTAM kriyA-TAM	 "?id2"	 "?uni_label")"crlf)
)

(defrule printFacts_concepts
?f<-(USRinfo id-lsl	 $?vars)
=>
(retract ?f)
(printout ?*mrsCon* "(id-cl "(implode$ (create$ $?vars))")" crlf)
(printout ?*mrs-dbug* "(rule-rel-values printFacts_concepts id-cl "(implode$ (create$ $?vars))")"crlf)
)

(defrule printFacts
?f<-(USRinfo  $?vars)
=>
(retract ?f)
(printout ?*mrsCon* "("(implode$ (create$ $?vars))")" crlf)
(printout ?*mrs-dbug* "(rule-rel-values printFacts "(implode$ (create$ $?vars))")"crlf)
)
