;generate output file "mrs_info-prep.dat" and gives id and MRS concept for prepositions

(defglobal ?*mrsdef* = mrs-def-fp)
(defglobal ?*defdbug* = mrs-def-dbug)

;Rule for prepositions : if (kriyA-k*/r* ?id1 ?id2) and is present in "karaka_relation_preposition_default_mapping.dat", generate (id-MRS_Rel ?id ?respective preposition_p)
;Ex-Apa kahAz rahawe hEM?  Where do you live? ,baccA somavAra ko Pala KAwA hE babies eat fruits on monday,baccA baccA  janavarI meM Pala KAwA hE Babies eat fruits in january
(defrule mrsPrep
(rel_name-ids ?rel ?kri ?k-id)
(Karaka_Relation-Preposition    ?rel  ?prep)
(id-concept_label	?k-id	?comp)
(not (id-concept_label	?k-id	?hiConcept&kahAz_1|kaba_1|somavAra|janavarI|ParavarI|mArca|aprELa|maI|jUna|juLAI|agaswa|siwaMbara|aktUbara|navaMbara|xisaMbara|maMgalavAra|buXavAra|guruvAra|SukravAra|SanivAra|ravivAra|Aja_1|kala_1|kala_2|vahAz_1|bqhaspawi_1|bqhaspawivAra_1|buGa_1|buXa_1|buXavAra_1|caMxravAra_1|gurUvAra_1|guruvAra_1|iwavAra_1|jumA_1|jumerAwa_1|jummA_1|maMgala_1|maMgalavAra_1|maMgalavAsara_1|ravivAra_1|ravixina_1|sanIcara_2|SanivAra_1|soma_1|somavAra_1|Sukra_2|SukravAra_1))
(not (rel_name-ids k4 ?kri ?k-id))
(not (generated_prep_for ?k-id))
;(test (neq (str-index "-" ?rel) FALSE))
;(test (eq (sub-string (+ (str-index "-" ?rel)1) (str-length ?rel) ?rel) (implode$ (create$ ?karaka))))
=>
(bind ?myprep (str-cat "_" ?prep "_p"))
(printout ?*mrsdef* "(MRS_info id-MRS_concept " (+ ?k-id 1) " " ?myprep")"crlf)
(printout ?*defdbug* "(rule-rel-values mrsPrep id-MRS_concept " (+ ?k-id 1) " " ?myprep")"crlf)
)

;
(defrule on_p_temp
(dofw  ?vaar     ?day)
(id-concept_label ?id	?vaar) 
(rel_name-ids k7|k7t  ?kri   ?k-id)
=>
(printout ?*mrsdef* "(MRS_info id-MRS_concept " (+ ?id 1) " _on_p_temp)"crlf)
(printout ?*defdbug* "(rule-rel-values on_p_temp  id-MRS_concept " (+ ?id 1) " _on_p_temp)"crlf)
)

;Generates MRS concept "_on_p" for para vibhakti.
;Ex. The pencil is on the table.
(defrule on_p_para
(declare (salience 100))
(viSeRya-PSP	?id	para)
=>
(assert (generated_prep_for ?id))
(printout ?*mrsdef* "(MRS_info id-MRS_concept " (+ ?id 1) " _on_p)"crlf)
(printout ?*defdbug* "(rule-rel-values on_p_para  id-MRS_concept " (+ ?id 1) " _on_p)"crlf)
)


;
(defrule in_p_temp_month
(mofy  ?mahInA    ?month)
(id-concept_label ?id	?mahInA) 
=>
(printout ?*mrsdef* "(MRS_info id-MRS_concept " (+ ?id 1) " _in_p_temp)"crlf)
(printout ?*defdbug* "(rule-rel-values in_p_temp_month  id-MRS_concept " (+ ?id 1) " _in_p_temp)"crlf)
)

;Generates MRS concept "_in_p" for AXAra.
;Ex. Rama is in Delhi.
(defrule in_p_AXAra_AXeya
(rel_name-ids   AXAra-AXeya     ?AXAra_id  ?AXeya_id)
(not (generated_prep_for ?AXAra_id))
(not (id-concept_label	?AXAra_id vahAz_1))

=>
(printout ?*mrsdef* "(MRS_info id-MRS_concept " (+ ?AXAra_id 1) " _in_p)"crlf)
(printout ?*defdbug* "(rule-rel-values in_p_AXAra_AXeya  id-MRS_concept " (+ ?AXAra_id 1) " _in_p)"crlf)
)

;Written by sakshi yadav date -13.06.19
;Ex-Rama reads two books in 2019.
(defrule in_p_temp
(id-concept_label	?k-id  ?num)
(rel_name-ids k7t	?kri ?k-id)
(not (id-concept_label  ?k-id   ?hiConcept&kahAz_1|kaba_1|Aja_1|kala_1|kala_2))
=>
(printout ?*mrsdef* "(MRS_info id-MRS_concept " (+ ?k-id 1) " _in_p_temp)"crlf)
(printout ?*defdbug* "(rule-rel-values in_p_temp  id-MRS_concept " (+ ?k-id 1) " _in_p_temp)"crlf)
)

;Commented by Sukhada on 24/04/2020. Because we are getting the output for the given sentence without insertion of '_by_p' but not with the preposition this and many other passive sentences.
;Written by Shastri --date-- 12/06/19
;Rule for inserting MRS concept "_by_p" when karwA is present in passive sentences.
;e.x. rAvaNa rAma ke xvArA mArA gayA.
;(defrule passive_by
;(rel_name-ids kriyA-k1 ?kri ?k1)
;(sentence_type  pass-assertive)
;=>
;(printout ?*mrsdef* "(MRS_info id-MRS_concept " (+ ?k1 1) " _by_p)"crlf)
;(printout ?*defdbug* "(rule-rel-values passive_by id-MRS_concept "  (+ ?k1 1) " _by_p)"crlf)
;)
