;generate output file "mrs_info-prep.dat" and gives id and MRS concept for prepositions

(defglobal ?*mrsdef* = mrs-def-fp)
(defglobal ?*defdbug* = mrs-def-dbug)

;Rule for prepositions : if (kriyA-k*/r* ?id1 ?id2) and is present in "karaka_relation_preposition_default_mapping.dat", generate (id-MRS_Rel ?id ?respective preposition_p)
;Ex-Apa kahAz rahawe hEM?  Where do you live? ,baccA somavAra ko Pala KAwA hE babies eat fruits on monday,baccA baccA  janavarI meM Pala KAwA hE Babies eat fruits in january
(defrule mrsPrep
(rel-ids ?rel ?kri ?k-id)
(Karaka_Relation-Preposition    ?rel  ?prep)
(id-cl	?k-id	?comp)
(not (id-cl	?k-id	?hiConcept&$kim|somavAra|janavarI|ParavarI|mArca|aprELa|maI|jUna|juLAI|agaswa|siwaMbara|aktUbara|navaMbara|xisaMbara|maMgalavAra|buXavAra|guruvAra|SukravAra|SanivAra|ravivAra|Aja_1|kala_1|kala_2|bqhaspawi_1|bqhaspawivAra_1|buGa_1|buXa_1|buXavAra_1|caMxravAra_1|gurUvAra_1|guruvAra_1|iwavAra_1|jumA_1|jumerAwa_1|jummA_1|maMgala_1|maMgalavAra_1|maMgalavAsara_1|ravivAra_1|ravixina_1|sanIcara_2|SanivAra_1|soma_1|somavAra_1|Sukra_2|SukravAra_1|bAhara_2|yaha_1|pAsa_2)) ;vaha rojZa yaha AwA hE. ;He comes here daily. ;$wyax for A mouse lived in the hole, there.
(not (rel-ids k4 ?kri ?k-id))
;(not (id-anim	?k-id	yes))
(not (MRS_info  id-MRS_concept ?compeq   comp_equal)) ;#गुलाब जैसे फूल पानी में नहीं उगते हैं।
;(not (and (rel-ids k1s ?kri ?k-id)) ;rAXA mIrA jEsI sunxara hE. 
(not (generated_prep_for ?k-id))
(not (id-morph_sem ?id	compermore)) ;#rAma mohana se jyAxA buxXimAna hE.
(not (id-morph_sem ?id	comperless)) ;rAma mohana se kama buxXimAna hE .
(not (do_not_generate_prep_for_k2p ?k-id)) ;I am coming home.
(not (do_not_generate_prep_for_k7p ?k-id)) ;He comes here daily.
(not (do_not_generate_prep_for_rt ?k-id)) ;This attempted to spread knowledge.
=>
(bind ?myprep (str-cat "_" ?prep "_p"))
(printout ?*mrsdef* "(MRS_info id-MRS_concept " (+ ?k-id 1) " " ?myprep")"crlf)
(printout ?*defdbug* "(rule-rel-values mrsPrep id-MRS_concept " (+ ?k-id 1) " " ?myprep")"crlf)
)

;Not to generate default preposition for k2p when k2p stands for home/there/here.
;Ex. I am coming home/here/there.
(defrule noPrep4k2p
(declare (salience 1000))
(rel-ids k2p ?kri ?k-id)
(id-cl  ?k-id   vahAz_1|vahAz+para_1|Gara_1|yahAz_1|bAhara_1)
;(not (generated_prep_for_k2p ?k-id))
=>
(assert (do_not_generate_prep_for_k2p ?k-id))
(printout ?*defdbug* "(rule-rel-values noPrep4k2p id-MRS_concept " ?k-id ")"crlf)
)

;not to generate preposition for k7p relation 
;He comes here daily.
(defrule noPrep$wyax
(declare (salience 1000))
(rel-ids k7p ?kri ?k-id)
(id-cl  ?k-id   $wyax)
(not (id-anim	10000	yes))
;(not (generated_prep_for_k2p ?k-id))
=>
(assert (do_not_generate_prep_for_k7p ?k-id))
(printout ?*defdbug* "(rule-rel-values noPrep4k7p id-MRS_concept " ?k-id ")"crlf)
)

;Rule for creating _on_p_temp for k7t and k7 relations with days of the week information.
;Babies eat fruits, on Tuesday. (6)
(defrule on_p_temp
(id-dow	?vaar	yes)
;(dofw  ?vaar     ?day)
(id-cl	?vaar	?hinconcept)
(rel-ids	k7t|k7	?kri	?vaar)
;(id-cl ?id	?vaar) 
;(rel-ids k7t|k7  ?kri   ?k-id)
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
(id-cl ?month	?mahInA) 
(not (rel-ids	r6	?id	?month))
=>
(printout ?*mrsdef* "(MRS_info id-MRS_concept " (+ ?month 1) " _in_p_temp)"crlf)
(printout ?*defdbug* "(rule-rel-values in_p_temp_month  id-MRS_concept " (+ ?month 1) " _in_p_temp)"crlf)
)

;Generates MRS concept "_in_p" for AXAra.
;Ex. Rama is in Delhi.
(defrule in_p_AXAra_AXeya
(rel-ids   AXAra-AXeya     ?AXAra_id  ?AXeya_id)
(not (generated_prep_for ?AXAra_id))
(not (id-cl	?AXAra_id vahAz_1))

=>
(printout ?*mrsdef* "(MRS_info id-MRS_concept " (+ ?AXAra_id 1) " _in_p)"crlf)
(printout ?*defdbug* "(rule-rel-values in_p_AXAra_AXeya  id-MRS_concept " (+ ?AXAra_id 1) " _in_p)"crlf)
)

;Ex-Rama reads two books in 2019.
(defrule in_p_temp
(id-cl	?k-id  ?num)
(rel-ids k7t	?kri ?k-id)
(not (id-dow	?k-id	yes))
(not (id-cl  ?k-id   ?hiConcept&$kim|Aja_1|kala_1|kala_2|pahale_4|rojZa_2|bAxa_1|xina_1|aba_1|pahale_2|bAxa_14|GantA_1|xopahara_2|xera_9|aBI_4))
;(test (eq (str-index "+baje" ?num) FALSE))
(not (rel-ids	r6	?k-id	?iid)) ; Rama arrived on Tuesday's morning.
=>
(printout ?*mrsdef* "(MRS_info id-MRS_concept " (+ ?k-id 1) " _in_p_temp)"crlf)
(printout ?*defdbug* "(rule-rel-values in_p_temp  id-MRS_concept " (+ ?k-id 1) " _in_p_temp)"crlf)
)

;Rama arrived on Tuesday's morning.
(defrule on_p_temp-adverboftime
(id-cl	?dow ?week)
(rel-ids k7t	?kri ?adoftime)
(id-cl  ?adoftime subaha_1)
(rel-ids	r6	?adoftime	?dow)
(id-dow	?dow	yes)
=>
(printout ?*mrsdef* "(MRS_info id-MRS_concept " (+ ?adoftime 1) " _on_p_temp)"crlf)
(printout ?*defdbug* "(rule-rel-values on_p_temp-adverboftime  id-MRS_concept " (+ ?adoftime 1) " _on_p_temp)"crlf)
)

(defrule at_p_temp
(id-cl	?k-id  ?num)
(rel-ids k7t	?kri ?k-id)
(not (id-dow	?k-id	yes))
(or (id-cl  ?k-id   xopahara_2) (id-clocktime	?k-id	yes))
=>
(printout ?*mrsdef* "(MRS_info id-MRS_concept " (+ ?k-id 1) " _at_p_temp)"crlf)
(printout ?*defdbug* "(rule-rel-values at_p_temp  id-MRS_concept " (+ ?k-id 1) " _at_p_temp)"crlf)
)

;not to generate preposition for rt with verb relation.
;This attempted to spread knowledge. 
;(defrule noPreprt
;(declare (salience 1000))
;(rel-ids rt ?kri ?k-id)
;(id-cl  ?k-id   ?hinconcept)
;(id-hin_concept-MRS_concept ?k-id ?hinconcept ?verbrt)
;(MRS_info id-MRS_concept-LBL-ARG0-ARG1-ARG2 ?kri ?verbmain ?lbll ?arg0 ?arg1 ?arg2)
;(MRS_info id-MRS_concept-LBL-ARG0-ARG1-ARG2 ?k-id ?verbrt ?lbl $?v)
;(test (neq (str-index _v_ ?verbrt) FALSE))

;=>
;(assert (do_not_generate_prep_for_rt ?k-id))
;(printout ?*defdbug* "(rule-rel-values noPreprt id-MRS_concept " ?k-id ")"crlf)
;)


