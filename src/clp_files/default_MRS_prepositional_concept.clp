;generate output file "mrs_info-prep.dat" and gives id and MRS concept for prepositions

(defglobal ?*mrsdef* = mrs-def-fp)
(defglobal ?*defdbug* = mrs-def-dbug)

;Rule for prepositions : if (kriyA-k*/r* ?id1 ?id2) and is present in "karaka_relation_preposition_default_mapping.dat", generate (id-MRS_Rel ?id ?respective preposition_p)
;Ex-Apa kahAz rahawe hEM?  Where do you live? ,baccA somavAra ko Pala KAwA hE babies eat fruits on monday,baccA baccA  janavarI meM Pala KAwA hE Babies eat fruits in january
(defrule mrsPrep
(rel_name-ids ?rel ?kri ?k-id)
(Karaka_Relation-Preposition    ?rel  ?prep)
(id-concept_label	?k-id	?comp)
(not (id-concept_label	?k-id	?hiConcept&kim|somavAra|janavarI|ParavarI|mArca|aprELa|maI|jUna|juLAI|agaswa|siwaMbara|aktUbara|navaMbara|xisaMbara|maMgalavAra|buXavAra|guruvAra|SukravAra|SanivAra|ravivAra|Aja_1|kala_1|kala_2|bqhaspawi_1|bqhaspawivAra_1|buGa_1|buXa_1|buXavAra_1|caMxravAra_1|gurUvAra_1|guruvAra_1|iwavAra_1|jumA_1|jumerAwa_1|jummA_1|maMgala_1|maMgalavAra_1|maMgalavAsara_1|ravivAra_1|ravixina_1|sanIcara_2|SanivAra_1|soma_1|somavAra_1|Sukra_2|SukravAra_1|bAhara_2|yaha_1|pAsa_2)) ;vaha rojZa yaha AwA hE.
(not (rel_name-ids k4 ?kri ?k-id))
(not (MRS_info  id-MRS_concept ?compeq   comp_equal)) ;#गुलाब जैसे फूल पानी में नहीं उगते हैं।
;(not (and (rel_name-ids k1s ?kri ?k-id)) ;rAXA mIrA jEsI sunxara hE. 
(not (generated_prep_for ?k-id))
(not (id-degree ?id	compermore)) ;#rAma mohana se jyAxA buxXimAna hE.
(not (id-degree ?id	comperless)) ;rAma mohana se kama buxXimAna hE .
(not (do_not_generate_prep_for_k2p ?k-id)) ;I am coming home.
=>
(bind ?myprep (str-cat "_" ?prep "_p"))
(printout ?*mrsdef* "(MRS_info id-MRS_concept " (+ ?k-id 1) " " ?myprep")"crlf)
(printout ?*defdbug* "(rule-rel-values mrsPrep id-MRS_concept " (+ ?k-id 1) " " ?myprep")"crlf)
)

;Not to generate default preposition for k2p when k2p stands for home/there/here.
;Ex. I am coming home/here/there.
(defrule noPrep4k2p
(declare (salience 1000))
(rel_name-ids k2p ?kri ?k-id)
(id-concept_label  ?k-id   vahAz_1|vahAz+para_1|Gara_1|yahAz_1|bAhara_1)
;(not (generated_prep_for_k2p ?k-id))
=>
(assert (do_not_generate_prep_for_k2p ?k-id))
(printout ?*defdbug* "(rule-rel-values noPrep4k2p id-MRS_concept " ?k-id ")"crlf)
)

;Rule for creating _on_p_temp for k7t and k7 relations with days of the week information.
;Babies eat fruits, on Tuesday. (6)
(defrule on_p_temp
(id-dow	?vaar	yes)
;(dofw  ?vaar     ?day)
(id-concept_label	?vaar	?hinconcept)
(rel_name-ids	k7t|k7	?kri	?vaar)
;(id-concept_label ?id	?vaar) 
;(rel_name-ids k7t|k7  ?kri   ?k-id)
=>
(printout ?*mrsdef* "(MRS_info id-MRS_concept " (+ ?vaar 1) " _on_p_temp)"crlf)
(printout ?*defdbug* "(rule-rel-values on_p_temp  id-MRS_concept " (+ ?vaar 1) " _on_p_temp)"crlf)
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


;Rule for generating _in_p_temp for sentences with month names. 
;Babies eat fruits in January.
(defrule in_p_temp_month
(id-moy	?month	yes)
;(mofy  ?mahInA    ?month)
(id-concept_label ?month	?mahInA) 
(not (rel_name-ids	r6	?id	?month))
=>
(printout ?*mrsdef* "(MRS_info id-MRS_concept " (+ ?month 1) " _in_p_temp)"crlf)
(printout ?*defdbug* "(rule-rel-values in_p_temp_month  id-MRS_concept " (+ ?month 1) " _in_p_temp)"crlf)
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
(not (id-dow	?k-id	yes))
(not (id-concept_label  ?k-id   ?hiConcept&kim|Aja_1|kala_1|kala_2|pahale_4|rojZa_2|bAxa_1|xina_1|aba_1|pahale_2|bAxa_14))
=>
(printout ?*mrsdef* "(MRS_info id-MRS_concept " (+ ?k-id 1) " _in_p_temp)"crlf)
(printout ?*defdbug* "(rule-rel-values in_p_temp  id-MRS_concept " (+ ?k-id 1) " _in_p_temp)"crlf)
)


