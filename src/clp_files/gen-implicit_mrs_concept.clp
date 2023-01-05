;generates output file "mrs_info.dat" that contains id and MRS concept for a and the.
;udef_q for plural noun and mass noun.
;neg for negation.

(defglobal ?*mrsdef* = mrs-def-fp)
(defglobal ?*defdbug* = mrs-def-dbug)

;Rules for common noun with the as a determiner : if (id-def ? yes), generate (id-MRS_Rel ?id _the_q)
(defrule mrsDef_yes
(id-def  ?id  yes)
=>
(printout ?*mrsdef* "(MRS_info id-MRS_concept "(+ ?id 10) " _the_q )"crlf)
(printout ?*defdbug* "(rule-rel-values mrsDef_yes id-MRS_concept "(+ ?id 10)" _the_q )"crlf)
)

;Rule for a as a determiner : if the is not present,is not a mass noun and not plural then generate (id-MRS_Rel ?id _a_q)
(defrule mrsDef_not
(id-gen-num-pers ?id ?g ?n ?p)
(not (id-def ?id yes)) ;#rAma apane piwA ke sAWa vixyAlaya gayA.
(not (id-mass ?id yes)) ;#wuma pAnI se GadZe ko Baro.
;(not (id-anim ?id yes))
(test (neq ?n  pl)) 
(not(id-concept_label	?id 	speaker|addressee|vaha|yaha))
(not(id-org ?id yes))
(not(id-per ?id yes)) ;#rAvana mArA gayA.
(not(id-place ?id yes)) ;#rAma xillI meM nahIM hE.
(not (rel_name-ids ord ?id $?v)) ;#usane eka Kewa xeKA
(not (rel_name-ids card ?id $?v)) ;#saviwA rImA ko xasa seba xegI.
(not (rel_name-ids dem ?id $?v1)) ;#rAma yaha kAma kara sakawA hE.
(not (rel_name-ids quant ?id $?v1)) ;#prawyeka baccA Kela rahA hE.
(not (rel_name-ids r6 ?id ?r6))  ;merA_xoswa_bagIcA_meM_Kela_rahA_hE My friend is playing in the garden.
(not (id-concept_label	?id	kim)) ;Who won the match?
(not (id-concept_label	?id	Gara_1))
(not (rel_name-ids deic ?ida	?id)) ;#yaha Gara hE.
(not (rel_name-ids coref ?	?id)) ;#usane nahIM KAyA.
(not  (id-abs ?id yes)) ;#kyA wumako buKAra hE?
(not  (id-ne ?id yes)) ;#KIra ke liye cAvala KarIxo.
;(not (sentence_type	)) ;#kuwwA! ;#billI Ora kuwwA.
(not (no_a_q_required ?id)) ;Which dog did bark?
=>
(printout ?*mrsdef* "(MRS_info id-MRS_concept "(+ ?id 10) " _a_q)"crlf)
(printout ?*defdbug* "(rule-rel-values  mrsDef_not id-MRS_concept "(+ ?id 10)" _a_q)"crlf)
)


;Rule for removing _a_q for kim which is in modifier relation. 
;Which dog did bark?
(defrule kim
(declare (salience 10000))
(id-concept_label	?kid	kim)
(id-concept_label	?nid	?noun)
(rel_name-ids mod ?nid ?kid)
=>
(assert (no_a_q_required ?nid))
(printout ?*defdbug* "(rule-rel-values  kim no_a_q_required " ?nid ")"crlf)
)

;Rule for plural noun : if (?n is pl) generate ((id-MRS_Rel ?id _udef_q)
(defrule mrs_pl_notDef
(id-gen-num-pers ?id ?g ?n ?p)
(or (test (eq ?n pl)) (rel_name-ids card  ?id ?) (id-abs ?id yes))
(not (id-def ?id yes))
(not (id-mass ?id yes))
(not (rel_name-ids dem ?id ?v))
(not (rel_name-ids quant ?id ?v))
(not (rel_name-ids r6 ?id ?v))
(not(id-concept_label	?id 	?concept&speaker|addressee|vaha|yaha|saba_4))
(not (rel_name-ids coref ?	?id))
;(not (sentence_type	)) ;;#kuwwA! ;#billI Ora kuwwA.
=>
(printout ?*mrsdef* "(MRS_info id-MRS_concept "(+ ?id 10) " udef_q)"crlf)
(printout ?*defdbug* "(rule-rel-values mrs_pl_notDef id-MRS_concept "(+ ?id 10)" udef_q)"crlf)
)

;Rule for mass noun : if (id-mass ?id yes) , generate (id-MRS_Rel ?id _udef_q)
(defrule mrs_mass_notDef
(id-gen-num-pers ?id ?g ?n ?p)
(id-mass ?id yes)
(not (id-def ?id yes))
(not (rel_name-ids dem ?id ?))
(not (rel_name-ids quant ?id ?))
(not (sentence_type	)) ;;#kuwwA! ;#billI Ora kuwwA.
=>
(printout ?*mrsdef* "(MRS_info id-MRS_concept "(+ ?id 10)" udef_q)"crlf)
(printout ?*defdbug* "(rule-rel-values  mrs_mass_notDef id-MRS_concept "(+ ?id 10)" udef_q)"crlf)
)

;Rule for creating udef_q and unknown for non-sentence type.
;In case of topic names we need to generate unknown and udef_q.

(defrule udef_unknown
(id-gen-num-pers ?id ?g ?n ?p)
(sentence_type	)
=>
;(printout ?*mrsdef* "(MRS_info id-MRS_concept "(+ ?id 10)" udef_q)"crlf)
;(printout ?*defdbug* "(rule-rel-values  udef_unknown id-MRS_concept "(+ ?id 10)" udef_q)"crlf)
(printout ?*mrsdef* "(MRS_info id-MRS_concept 0000000 unknown)"crlf)
(printout ?*defdbug* "(rule-rel-values  udef_unknown id-MRS_concept 0000000 unknown)"crlf)
)

;rule for generating  _this_q_dem
;mEMne yaha Pala KAyA.
;I ate this fruit.
;(defrule this_q_dem
;(id-concept_label       ?id   yaha_1)
;((rel_name-ids viSeRya-dem       ?nid   ?demid))
;(sentence_type  assertive)
;=>
;(printout ?*mrsdef* "(MRS_info id-MRS_concept "(+ ?id 100) "  _can_v_modal)"crlf)
;(printout ?*mrsdef* "(MRS_info id-MRS_concept " ?nid "  _this_q_dem)"crlf)
;(printout ?*defdbug* "(rule-rel-values  can_v_modal  id-MRS_concept "(+ ?id 100) "  _can_v_modal)"crlf)
;(printout ?*defdbug* "(rule-rel-values  this_q_dem  id-MRS_concept " ?id "  _this_q_dem)"crlf)
;)


;rAma dAktara nahIM hE.	 rAma xillI meM nahIM hE. #usane KAnA nahIM KAyA. #use Gara nahIM jAnA cAhie.
(defrule mrs_neg_notDef
(rel_name-ids neg  ?kid ?negid)
=>
(printout ?*mrsdef* "(MRS_info id-MRS_concept "?negid " neg)"crlf)
(printout ?*defdbug* "(rule-rel-values mrs_neg_notDef id-MRS_concept "?negid " neg)"crlf)
)

;Rule for proper noun: if ((id-propn ?id yes) is present, generate (id-MRS_concept ?id proper_q) and  (id-MRS_concept ?id named)
(defrule mrs_propn
(or (id-per  ?id yes) (id-place  ?id yes) (id-org  ?id yes)  (id-ne  ?id yes) )
=>
(printout ?*mrsdef* "(MRS_info id-MRS_concept "(+ ?id 10) " proper_q)"crlf)
(printout ?*defdbug* "(rule-rel-values mrs_propn  id-MRS_concept "(+ ?id 10)" proper_q)"crlf)

(printout ?*mrsdef* "(MRS_info id-MRS_concept "?id " named)"crlf)
(printout ?*defdbug* "(rule-rel-values mrs_propn  id-MRS_concept "?id " named)"crlf)
)


;rule for interrogative sentences for 'what',
;generates (id-MRS_concept "?id " thing)
;	   (id-MRS_concept "?id " which_q)
(defrule mrs_inter_what
(id-concept_label ?id kim)
(rel_name-ids	k2	?kri	?id)
(sentence_type  interrogative)
=>
(printout ?*mrsdef* "(MRS_info id-MRS_concept "(+ ?id 10) " which_q)"crlf)
(printout ?*defdbug* "(rule-rel-values mrs_inter_what  id-MRS_concept "(+ ?id 10)" which_q)"crlf)
(printout ?*mrsdef* "(MRS_info id-MRS_concept "?id" thing)"crlf)
(printout ?*defdbug* "(rule-rel-values mrs_inter_what id-MRS_concept "?id" thing)"crlf)
)

;rule for interrogative sentences for 'who',
;generates (id-MRS_concept "?id " person)
;	   (id-MRS_concept "?id " which_q)
(defrule mrs_inter_who
(id-concept_label ?id kim)
(rel_name-ids	k1	?kri	?id)
(sentence_type  interrogative)

=>

(printout ?*mrsdef* "(MRS_info id-MRS_concept "(+ ?id 10) " which_q)"crlf)
(printout ?*defdbug* "(rule-rel-values mrs_inter_who  id-MRS_concept " (+ ?id 10) " which_q)"crlf)
(printout ?*mrsdef* "(MRS_info id-MRS_concept "?id" person)"crlf)
(printout ?*defdbug* "(rule-rel-values mrs_inter_who id-MRS_concept "?id" person)"crlf)
)

;rule for interrogative sentences for 'where',
;generates (id-MRS_concept "?id " place)
;          (id-MRS_concept "?id " which_q)
(defrule mrs_inter_where
(id-concept_label ?id kim)
(rel_name-ids	k7p	?kri	?id)
(sentence_type  interrogative)
=>
(printout ?*mrsdef* "(MRS_info id-MRS_concept "(+ ?id 10)" which_q)"crlf)
(printout ?*defdbug* "(rule-rel-values mrs_inter_where id-MRS_concept "(+ ?id 10)" which_q)"crlf)

(printout ?*mrsdef* "(MRS_info id-MRS_concept "(+ ?id 10)" loc_nonsp)"crlf)
(printout ?*defdbug* "(rule-rel-values mrs_inter_where id-MRS_concept "(+ ?id 10)" loc_nonsp)"crlf)

(printout ?*mrsdef* "(MRS_info id-MRS_concept "?id" place_n)"crlf)
(printout ?*defdbug* "(rule-rel-values mrs_inter_where id-MRS_concept "?id" place_n)"crlf)
)


;written by sakshi yadav (NIT-Raipur)
;date-27.05.19
;rule for sentence -consists of word 'home'
; example -i am coming home
;generates (id-MRS_concept "?id " place_n)
;          (id-MRS_concept "?id " def_implicit_q)
;          (id-MRS_concept "?id " loc_nonsp)
(defrule mrs_place
(id-concept_label ?id Gara_1|vahAz_1|vahAz+para_1|bAhara_1|bAhara_2)
=>
(printout ?*mrsdef* "(MRS_info id-MRS_concept "?id " place_n)"crlf)
(printout ?*defdbug* "(rule-rel-values mrs_place id-MRS_concept "?id " place_n)"crlf)

;(printout ?*mrsdef* "(MRS_info id-MRS_concept "(+ ?id 10)" def_implicit_q)"crlf)
(printout ?*mrsdef* "(MRS_info id-MRS_concept "?id" def_implicit_q)"crlf)
(printout ?*defdbug* "(rule-rel-values mrs_place id-MRS_concept "?id " def_implicit_q)"crlf)

;(printout ?*mrsdef* "(MRS_info id-MRS_concept "(+ ?id 10) " loc_nonsp)"crlf)
(printout ?*mrsdef* "(MRS_info id-MRS_concept "?id " loc_nonsp)"crlf)
(printout ?*defdbug* "(rule-rel-values mrs_place id-MRS_concept "?id " loc_nonsp)"crlf)
)

; written by sakshi yadav (NIT-Raipur)
; date-27.05.19
;rule for sentence -consists of words 'yesterday','today','tomorrow' 
;example -i came yesterday
;generates (id-MRS_concept "?id " time_n)
;          (id-MRS_concept "?id " def_implicit_q)
;          (id-MRS_concept "?id " loc_nonsp)
(defrule mrs_kala
(id-concept_label ?id pahale_4|kala_1|kala_2|Aja_1|jalxI_9|xera_11|aba_1)
(rel_name-ids   ?relname        ?id1  ?id2)	;To restrict the generation of "loc_nonsp" when "kala, Aja" are in "samanadhikaran" relation.
=>
(printout ?*mrsdef* "(MRS_info id-MRS_concept "?id " time_n)"crlf)
(printout ?*defdbug* "(rule-rel-values mrs_kala  id-MRS_concept "?id " time_n)"crlf)

;(printout ?*mrsdef* "(MRS_info id-MRS_concept "(+ ?id 10)" def_implicit_q)"crlf)
(printout ?*mrsdef* "(MRS_info id-MRS_concept "?id" def_implicit_q)"crlf)
(printout ?*defdbug* "(rule-rel-values mrs_kala  id-MRS_concept "?id" def_implicit_q)"crlf)

(if (neq ?relname samAnAXi) then	;;To restrict the generation of "loc_nonsp" when "kala, Aja" are in "samanadhikaran" relation.e.g Today is Monday.
 ;(printout ?*mrsdef* "(MRS_info id-MRS_concept "(+ ?id 10)" loc_nonsp)"crlf)
 (printout ?*mrsdef* "(MRS_info id-MRS_concept "?id" loc_nonsp)"crlf)
 (printout ?*defdbug* "(rule-rel-values mrs_kala  id-MRS_concept "?id" loc_nonsp)"crlf)

 
)
)

;written by sakshi yadav(NIT Raipur) Date-7.06.19
;Generates new facts for days of weeks then generate (MRS_info id-MRS_concept ?id _on_p_temp) and (MRS_info id-MRS_concept ?id dofw) and  (MRS_info id-MRS_concept ?id proper_q) 
(defrule daysofweeks
(id-concept_label ?id somavAra|maMgalavAra|buXavAra|guruvAra|SukravAra|SanivAra|ravivAra|bqhaspawi_1|bqhaspawivAra_1|buGa_1|buXa_1|buXavAra_1|caMxravAra_1|gurUvAra_1|guruvAra_1|iwavAra_1|jumA_1|jumerAwa_1|jummA_1|maMgala_1|maMgalavAra_1|maMgalavAsara_1|ravivAra_1|ravixina_1|sanIcara_2|SanivAra_1|soma_1|somavAra_1|Sukra_2|SukravAra_1)
=>
(printout ?*mrsdef* "(MRS_info id-MRS_concept "(+ ?id 10) " proper_q)"crlf)
(printout ?*defdbug* "(rule-rel-values  daysofweeks id-MRS_concept "(+ ?id 10) " proper_q)"crlf)
)


;written by sakshi yadav(NIT Raipur) Date-11.06.19
;Generates new facts for months of years then generate (MRS_info id-MRS_concept ?id _on_p_temp) and (MRS_info id-MRS_concept ?id mofy) and  (MRS_info id-MRS_concept ?id proper_q) 
(defrule monthsofyears
(id-concept_label ?id janavarI|ParavarI|mArca|aprELa|maI|jUna|juLAI|agaswa|siwaMbara|aktUbara|navaMbara|xisaMbara)
=>
(printout ?*mrsdef* "(MRS_info id-MRS_concept "(+ ?id 10) " proper_q)"crlf)
(printout ?*defdbug* "(rule-rel-values  monthsofyears id-MRS_concept "(+ ?id 10)" proper_q)"crlf)
)


(defrule yearsofcenturies
(id-concept_label ?id ?num)
(rel_name-ids k7t ?kri  ?id&:(numberp ?id))
(not (id-concept_label  ?k-id   ?hiConcept&kim|Aja_1|kala_1|kala_2|rAwa_1|xina_1|jalxI_9|xera_11|aba_1|pahale_4))
=>
(printout ?*mrsdef* "(MRS_info id-MRS_concept "(+ ?id 10)" proper_q)"crlf)
(printout ?*defdbug* "(rule-rel-values  yearsofcenturies id-MRS_concept "(+ ?id 10) " proper_q)"crlf)
)

(defrule dayandnight
(id-concept_label ?id ?num)
(rel_name-ids k7t ?kri  ?id&:(numberp ?id))
(id-concept_label  ?k-id   ?hiConcept&rAwa_1)
=>
;(printout ?*mrsdef* "(MRS_info id-MRS_concept "(+ ?id 10)" def_implicit_q)"crlf)
(printout ?*mrsdef* "(MRS_info id-MRS_concept "?id " def_implicit_q)"crlf)
(printout ?*defdbug* "(rule-rel-values  yearsofcenturies id-MRS_concept "?id" def_implicit_q)"crlf)
)


(defrule mrs_parg_d
(sentence_type  pass-affirmative|pass-interrogative)
(kriyA-TAM ?kri ?tam)
(not (rel_name-ids	rpk	?id	?kri))
=>
(printout ?*mrsdef* "(MRS_info id-MRS_concept "?kri " parg_d)"crlf)
(printout ?*defdbug* "(rule-rel-values mrs_parg_d  id-MRS_concept "?kri" parg_d)"crlf)
)

;#rAma ne skUla jAkara KAnA KAyA.
(defrule mrs_subord
(rel_name-ids	rpk	?id	?kri)
(id-hin_concept-MRS_concept ?id ?hinconcept ?engcon) 	
(test (eq (str-index _n_ ?engcon) FALSE))
=>
(printout ?*mrsdef* "(MRS_info id-MRS_concept -20000 subord)"crlf)
(printout ?*defdbug* "(rule-rel-values mrs_subord id-MRS_concept -20000 subord)"crlf)
)

;It creates mrs rel feature _while_x for sentences with rsk
;verified sentence 339 #rAma sowe hue KarrAte BarawA hE. 
(defrule mrs_while
(rel_name-ids	rsk		?id	?kri)
=>
(printout ?*mrsdef* "(MRS_info id-MRS_concept -30000  _while_x)"crlf)
(printout ?*defdbug* "(rule-rel-values mrs_while id-MRS_concept -30000  _while_x)"crlf)
)

;It creates mrs rel feature _frequent_a_1 for sentences with rpk
;rAma KA -KAkara motA ho gayA .
(defrule mrs_frequent
(rel_name-ids	rpk	?id	?kri)
(id-hin_concept-MRS_concept ?id ?hinconcept ?engcon) 	
(test (eq (str-index _n_ ?engcon) FALSE))
(not (rel_name-ids	k2	?id	?karma))

=>
(printout ?*mrsdef* "(MRS_info id-MRS_concept -5000 _frequent_a_1)"crlf)
(printout ?*defdbug* "(rule-rel-values mrs_frequent id-MRS_concept -5000  _frequent_a_1)"crlf)
)

;It creates mrs rel feature _while_x for sentences with vmod_kr_vn
; verified sentence 340#BAgawe hue Sera ko xeKo
;(defrule krvn_while
;(rel_name-ids	kr_vn ?kri ?kvn)
;(MRSc-FVs ?mrscon ?lbl ?l ?arg0 ?a0 ?arg1 ?a1 ARG2: ?a2)
;(id-hin_concept-MRS_concept ?kri ?hin ?mrscon)
;=>
;(printout ?*mrsdef* "(MRS_info id-MRS_concept -30000  _while_x)"crlf)
;(printout ?*defdbug* "(rule-rel-values krvn_while id-MRS_concept -30000  _while_x)"crlf)
;)

;rule for interrogative sentences for 'when'
(defrule mrs_inter_when
(id-concept_label ?id kim)
(rel_name-ids	k7t	?kri	?id)
(sentence_type  interrogative)
=>
(printout ?*mrsdef* "(MRS_info id-MRS_concept "(+ ?id 10) " which_q)"crlf)
(printout ?*defdbug* "(rule-rel-values mrs_inter_when  id-MRS_concept "(+ ?id 10)" which_q)"crlf)

(printout ?*mrsdef* "(MRS_info id-MRS_concept "?id " time_n)"crlf)
(printout ?*defdbug* "(rule-rel-values mrs_inter_when  id-MRS_concept "?id " time_n)"crlf)

(printout ?*mrsdef* "(MRS_info id-MRS_concept "(+ ?id 10)" loc_nonsp)"crlf)
(printout ?*defdbug* "(rule-rel-values mrs_inter_when  id-MRS_concept "(+ ?id 10) " loc_nonsp)"crlf)
)

;rule for generating  _should_v_modal
;muJe Gara jAnA cAhie.
; I should go home.
(defrule should_v_modal
(kriyA-TAM	?id  nA_cAhie_1)
=>
(printout ?*mrsdef* "(MRS_info id-MRS_concept "(+ ?id 100) "  _should_v_modal)"crlf)
(printout ?*defdbug* "(rule-rel-values  should_v_modal  id-MRS_concept "(+ ?id 100) "  _should_v_modal)"crlf)
)

;rule for generating  _would_v_modal
;kyA wuma nahIM Keloge?
;Would you not play?
(defrule would_v_modal
(kriyA-TAM ?id  gA_2)
;(sentence_type  assertive|question|negation)
=>
(printout ?*mrsdef* "(MRS_info id-MRS_concept "(+ ?id 100) "  _would_v_modal)"crlf)
(printout ?*defdbug* "(rule-rel-values  would_v_modal  id-MRS_concept "(+ ?id 100) "  _would_v_modal)"crlf)
)

;rule for generating  _might_v_modal
;mEM Gara jA sakawA hUz
;He might go home.
(defrule might_v_modal
(kriyA-TAM	?id  0_sakawA_hE_2)
=>
(printout ?*mrsdef* "(MRS_info id-MRS_concept "(+ ?id 100) "  _might_v_modal)"crlf)
(printout ?*defdbug* "(rule-rel-values  might_v_modal  id-MRS_concept "(+ ?id 100) "  _might_v_modal)"crlf)
)

;rule for generating  _may_v_modal
;mEM Kela sakawA hUz.
;I may play.
(defrule may_v_modal
(kriyA-TAM	?id  0_sakawA_hE_3)
=>
(printout ?*mrsdef* "(MRS_info id-MRS_concept "(+ ?id 100) "  _may_v_modal)"crlf)
(printout ?*defdbug* "(rule-rel-values  may_v_modal  id-MRS_concept "(+ ?id 100) "  _may_v_modal)"crlf)
)

;rule for generating  _can_v_modal
;mEM Gara jA sakawA hUz. kyA Apa ruka sakawe hEM? mEM nahIM so sakawA hUz.
;I can go home.          Can you stop?            I can not sleep.
(defrule can_v_modal
(kriyA-TAM	?id  0_sakawA_hE_1|0_sakawA_1)
=>
(printout ?*mrsdef* "(MRS_info id-MRS_concept "(+ ?id 100) "  _can_v_modal)"crlf)
(printout ?*defdbug* "(rule-rel-values  can_v_modal  id-MRS_concept "(+ ?id 100) "  _can_v_modal)"crlf)
)

;rule for generating  _could_v_modal
;mEM so sakawA WA.
;I could sleep.
(defrule could_v_modal
(kriyA-TAM      ?id  0_sakawA_WA_1|0_sakA_1)
=>
(printout ?*mrsdef* "(MRS_info id-MRS_concept "(+ ?id 100) "  _could_v_modal)"crlf)
(printout ?*defdbug* "(rule-rel-values  could_v_modal  id-MRS_concept "(+ ?id 100) "  _could_v_modal)"crlf)
)


;rule for generating  _must_v_modal
;bacce ko Pala KAnA cAhie.
;child must eat fruit.
(defrule must_v_modal
(kriyA-TAM	?id  nA_cAhie_2|nA_hogA_1|nA_padegA_1)
=>
(printout ?*mrsdef* "(MRS_info id-MRS_concept "(+ ?id 100) "  _must_v_modal)"crlf)
(printout ?*defdbug* "(rule-rel-values  must_v_modal  id-MRS_concept "(+ ?id 100) "  _must_v_modal)"crlf)
)


;rule for generating  _used+to_v_qmodal
;vaha xillI meM rahawA WA.
;He used to live in Xilli.
(defrule _used+to_v_qmodal
(kriyA-TAM      ?id  wA_WA_1|0_jAwA_WA_1)
=>
(printout ?*mrsdef* "(MRS_info id-MRS_concept "(+ ?id 100) "  _used+to_v_qmodal)"crlf)
(printout ?*defdbug* "(rule-rel-values  _used+to_v_qmodal  id-MRS_concept "(+ ?id 100) "  _used+to_v_qmodal)"crlf)
)



;rule for generating  _have_v_qmodal
;Rahesh ko seba KAnA hE.
;Ramesh has to eat an apple.
(defrule _have_v_qmodal
(kriyA-TAM	?id  nA_hE_1|nA_padZA_1|nA_padZawA_hE_1|nA_padZawA_WA_1|nA_padZegA_1)
=>
(printout ?*mrsdef* "(MRS_info id-MRS_concept "(+ ?id 100) "  _have_v_qmodal)"crlf)
(printout ?*defdbug* "(rule-rel-values  _have_v_qmodal  id-MRS_concept "(+ ?id 100) "  _have_v_qmodal)"crlf)
)
;To generate "_want_v_1" MRS concept for the TAM "nA_cAhawA_hE_1" 
;rAma sonA cAhawA hE.
;RAma wants to sleep.
(defrule _want_v_1
(kriyA-TAM      ?id  nA_cAhawA_hE_1)
=>
(printout ?*mrsdef* "(MRS_info id-MRS_concept "(+ ?id 100) "  _want_v_1)"crlf)
(printout ?*defdbug* "(rule-rel-values  _want_v_1  id-MRS_concept "(+ ?id 100) "  _want_v_1)"crlf)
)

;To generate "_get_v_state" MRS concept for the TAM "yA_gayA_1" 
;KAnA mere xvArA KAyA gayA.
;The food got eaten by me.
(defrule _get_v_state
(id-stative	?id	yes)
=>
(printout ?*mrsdef* "(MRS_info id-MRS_concept "(+ ?id 100) " _get_v_state)"crlf)
(printout ?*defdbug* "(rule-rel-values  _get_v_state  id-MRS_concept "(+ ?id 100) " _get_v_state)"crlf)
)



;written by Yash Goyal(IIT Varanasi) Date-06.05.20
;rule for generating compound for concepts that have some noun like _left_n_1, _right_n_1, _half_n_of etc as viSeRaNa
;Cexa bAeM wOliyA meM hE.
;The hole is in the left towel.
;(rel_name-ids viSeRya-viSeRaNa 20000 21000)
;(id-hin_concept-MRS_concept 21000 bAeM_1 _left_n_1)
(defrule compound-vi_n
(declare (salience 10000))
(rel_name-ids viSeRya-viSeRaNa ?vi ?vina)
(id-hin_concept-MRS_concept ?vina ?noun ?vinan)
(test (neq (str-index _n_ ?vinan) FALSE))
=>
(printout ?*mrsdef* "(MRS_info  id-MRS_concept "(+ ?vi 200) "  compound)"crlf)
(printout ?*defdbug* "(rule-rel-values    compound-vi_n  id-MRS_concept "(+ ?vi 200) "  compound)"crlf)

(printout ?*mrsdef* "(MRS_info  id-MRS_concept "(+ ?vina 10) "  udef_q)"crlf)
(printout ?*defdbug* "(rule-rel-values   compound-vi_n  id-MRS_concept "(+ ?vi 10) "  udef_q)"crlf)
)


;Rule for generating the mrs_concept: nominalization, for kriyArWa_kriyA
; #mEM Kelane ke liye krIdAMgaNa meM gayA.
; I went to the playground for playing.
; (rel_name-ids	kriyArWa_kriyA	40000	20000)
(defrule nominalization
(rel_name-ids	kriyArWa_kriyA	?kri ?krikri)
=>
(printout ?*mrsdef* "(MRS_info  id-MRS_concept "(+ ?krikri 200) "  nominalization)"crlf)
(printout ?*defdbug* "(rule-rel-values    nominalization  id-MRS_concept "(+ ?krikri 200) "  nominalization)"crlf)

(printout ?*mrsdef* "(MRS_info  id-MRS_concept "(+ ?krikri 10) "  udef_q)"crlf)
(printout ?*defdbug* "(rule-rel-values  nominalization   id-MRS_concept "(+ ?krikri 10) "  udef_q)"crlf)
)

;Generate 'superl' mrs_concept for superlative degree adjectives
;#sUrya sabase badA nakRawra hE.
;The sun is the largest star.
;(id-degree      20000   superl)
(defrule superl
(id-degree	?id	superl)
=>
(printout ?*mrsdef* "(MRS_info  id-MRS_concept "(+ ?id 10) "  superl)"crlf)
(printout ?*defdbug* "(rule-rel-values  superl   id-MRS_concept "(+ ?id 10) "  superl)"crlf)
)

;Rule for creating comp mrs concept for comparative sentences.
;#rAma mohana se jyAxA buxXimAna hE.
(defrule comper_more
(id-degree	?id	comper_more)
=>
(printout ?*mrsdef* "(MRS_info  id-MRS_concept "(+ ?id 20) "  comp)"crlf)
(printout ?*defdbug* "(rule-rel-values  comper_more   id-MRS_concept "(+ ?id 20) "  comp)"crlf)
)

;Rule for creating comp mrs concept for comparative sentences.
;#rAma mohana se kama buxXimAna hE .
(defrule comper_less
(id-degree	?id comper_less)
=>
(printout ?*mrsdef* "(MRS_info  id-MRS_concept "(+ ?id 30) "  comp_less)"crlf)
(printout ?*defdbug* "(rule-rel-values  comper_more   id-MRS_concept "(+ ?id 30) "  comp_less)"crlf)
)


;Rule for bringing comp_equal for ru relation.
(defrule comper-equal
(rel_name-ids ru ?id ?id1)
(not (id-degree	?adjid	comper_more)) 
(not (id-degree	?adjid	comper_less))
(rel_name-ids	k1	?kri	?id) ;#गुलाब जैसे फूल पानी में नहीं उगते हैं।
(rel_name-ids	k1s	?kri	?adj)
=>
(printout ?*mrsdef* "(MRS_info  id-MRS_concept "(+ ?id 40) "  comp_equal)"crlf)
(printout ?*defdbug* "(rule-rel-values  comper-equal   id-MRS_concept "(+ ?id 40) "  comp_equal)"crlf)
)

;rule for generating  _make_v_cause
;SikRikA ne CAwroM se kakRA ko sAPa karAyA.
;The teacher made the students clean the class.
(defrule make_v_cause
(id-causative	?id	yes)
=>
(printout ?*mrsdef* "(MRS_info id-MRS_concept "(+ ?id 100) "  _make_v_cause)"crlf)
(printout ?*defdbug* "(rule-rel-values  _make_v_cause  id-MRS_concept "(+ ?id 100) "  _make_v_cause)"crlf)
)

(defrule make_ask
(id-double_causative	?id	yes)
=>
(printout ?*mrsdef* "(MRS_info id-MRS_concept "(+ ?id 100) "  _make_v_cause)"crlf)
(printout ?*defdbug* "(rule-rel-values  _make_ask  id-MRS_concept "(+ ?id 100) "  _make_v_cause)"crlf)
(printout ?*mrsdef* "(MRS_info id-MRS_concept "(+ ?id 200) "  _ask_v_1)"crlf)
(printout ?*defdbug* "(rule-rel-values  _make_ask  id-MRS_concept "(+ ?id 200) "  _ask_v_1)"crlf)
)

;This rule creates _honorable_a_1 for the respect word "ji" and doesn't create for the respect word of the addressee.
;361: manwrIjI ne kala manxira kA uxGAtana kiyA. The honorable minister inaugurated the temple yesterday.
(defrule respect
(id-respect  ?id  yes)
(rel_name-ids ?rel ? ?id)
(not(id-concept_label	?id 	addressee))
=>
(printout ?*mrsdef* "(MRS_info id-MRS_concept  "(+ ?id 1000)"  _honorable_a_1 )"crlf)
(printout ?*defdbug* "(rule-rel-values respect id-MRS_concept "(+ ?id 1000)" _honorable_a_1 )"crlf)
)

;This rules creates _also_a_1 when emphatic exists in the USR
;101 verified sentence #viveka ne rAhula ko BI samAroha meM AmaMwriwa kiyA.
;113 verified sentence #sUrya camakawA BI hE.
(defrule emphatic
(id-emph  ?id  yes)
=>
(printout ?*mrsdef* "(MRS_info id-MRS_concept  "(+ ?id 1000)"  _also_a_1)"crlf)
(printout ?*defdbug* "(rule-rel-values emphatic id-MRS_concept "(+ ?id 1000)" _also_a_1)"crlf)
)

;Rule for bring _before_x_h for the rblak relation. ;gAyoM ke xuhane se pahale rAma Gara gayA.
(defrule rblak
(rel_name-ids	rblak	?id	?kri)
=>
(printout ?*mrsdef* "(MRS_info id-MRS_concept -40000 _before_x_h)"crlf)
(printout ?*defdbug* "(rule-rel-values rblak id-MRS_concept -40000 _before_x_h)"crlf)
)

;Rule for bring _when_x_subord for the rblk relation. ;rAma ke vana jAne para xaSaraWa mara gaye.
(defrule rblpk
(rel_name-ids	rblpk	?id	?kri)
=>
(printout ?*mrsdef* "(MRS_info id-MRS_concept -50000 _when_x_subord)"crlf)
(printout ?*defdbug* "(rule-rel-values rblpk id-MRS_concept -50000 _when_x_subord)"crlf)
)


;Rule for bringing _and_c for conj relation.
;#rAma Ora sIwA acCe hEM.
;#rAma, hari Ora sIwA acCe hEM.
;#Rama buxXimAna, motA, xilera, Ora accA hE.
(defrule conj
(construction-ids	conj	$?v ?id1 ?id2)
=>
(printout ?*mrsdef* "(MRS_info id-MRS_concept "(+ ?id1 500)" _and_c)"crlf)
(printout ?*defdbug* "(rule-rel-values conj id-MRS_concept "(+ ?id1 500)" _and_c)"crlf)
)


;Rule for creating implicit_conj when the construction is more than two values. 
;Ex. Rama buxXimAna, motA, xilera, Ora accA hE.
(defrule implicit_conj
(construction-ids	conj  $?v)
=>
(bind ?count (length$ (create$ $?v)))
(if (> ?count 2)  then
  (loop-for-count (?i 1  (- ?count 2))
   (printout ?*mrsdef* "(MRS_info id-MRS_concept "(+  (nth$ ?i (create$ $?v)) 600)" implicit_conj)"crlf)
   (printout ?*defdbug* "(rule-rel-values implicit_conj id-MRS_concept "(+  (nth$ ?i (create$ $?v)) 600)" implicit_conj)"crlf)
)))

;Rule for creating ude_q when the construction values are in subjective position with noun entries. 
;Ex. rAma, hari Ora sIwA acCe hEM.
(defrule implicit_conj4pred
(construction-ids	conj  $? ?n $? ?x ?y)
(rel_name-ids   ?rel        ?id ?n)
(id-concept_label	?n	?hincon)
(id-gen-num-pers	?n	?gen ?num ?per)
=>
(printout ?*mrsdef* "(MRS_info id-MRS_concept "(+ ?n 10)" udef_q)"crlf)
(printout ?*defdbug* "(rule-rel-values implicit_conj4pred id-MRS_concept "(+ ?n 10)" udef_q)"crlf)
)


;Rule for creating udef_q for when the sentence consists of only two noun entries in the construction for unknown.
;#billI Ora kuwwA.
(defrule implicit_conj4unknown
(construction-ids	conj  ?n ?y)
(rel_name-ids   ?rel        ?id ?n)
(id-concept_label	?n	?hincon)
(id-gen-num-pers	?n	?gen ?num ?per)
=>
(printout ?*mrsdef* "(MRS_info id-MRS_concept "(+ ?n 10)" udef_q)"crlf)
(printout ?*defdbug* "(rule-rel-values implicit_conj4unknown id-MRS_concept "(+ ?n 10)" udef_q)"crlf)
)

;Rule for creating udef_q for the construction with two subjective entries. 
;;#rAma Ora sIwA acCe hEM.
(defrule udefq_conj4subj
(construction-ids	conj  $? ?n ?y)
(id-gen-num-pers	?n	?gen ?num ?per)
=>
(printout ?*mrsdef* "(MRS_info id-MRS_concept "(+ ?n 10)" udef_q)"crlf)
(printout ?*defdbug* "(rule-rel-values udefq_conj4subj id-MRS_concept "(+ ?n 10)" udef_q)"crlf)
)

;Rule for bringing number_q when card is coming in the k2 position.
;The cat chased one.
(defrule eka-k2
(id-concept_label	?ic	eka_6)
(rel_name-ids	k2	?kri	?ic)
=>
(printout ?*mrsdef* "(MRS_info id-MRS_concept "(+ ?ic 50)" number_q)"crlf)
(printout ?*defdbug* "(rule-rel-values udefq_conj4subj id-MRS_concept "(+ ?ic 50)" number_q)"crlf)
)

;Rule to bring def_implicit_q and poss for the sentences with whose word.
;;#kiska kuwwA BOMkA? 
(defrule mrs_inter_whose
(id-concept_label ?id kim)
(rel_name-ids	r6	?noun	?id)
(sentence_type  interrogative)
=>
(printout ?*mrsdef* "(MRS_info id-MRS_concept "(+ ?id 10) " def_implicit_q)"crlf)
(printout ?*defdbug* "(rule-rel-values mrs_inter_whose  id-MRS_concept "(+ ?id 10)" def_implicit_q)"crlf)

(printout ?*mrsdef* "(MRS_info id-MRS_concept "(+ ?id 11) " poss)"crlf)
(printout ?*defdbug* "(rule-rel-values mrs_inter_whose  id-MRS_concept "(+ ?id 11)" poss)"crlf)

(printout ?*mrsdef* "(MRS_info id-MRS_concept "?id " person)"crlf)
(printout ?*defdbug* "(rule-rel-values mrs_inter_whose  id-MRS_concept "?id " person)"crlf)

(printout ?*mrsdef* "(MRS_info id-MRS_concept "(+ ?id 10) " which_q)"crlf)
(printout ?*defdbug* "(rule-rel-values mrs_inter_whose  id-MRS_concept "(+ ?id 10) " which_q)"crlf)
)

;Rule for bringing _which_q for kim with modifier relation.
;Which dog barked?
(defrule mrs_inter_which
(id-concept_label ?id kim)
(rel_name-ids	mod	?noun	?id)
(sentence_type  interrogative)
=>
(printout ?*mrsdef* "(MRS_info id-MRS_concept "?id " _which_q)"crlf)
(printout ?*defdbug* "(rule-rel-values mrs_inter_which  id-MRS_concept "?id " _which_q)"crlf)
)

;Rule for bringing which_q, property, unspec_adj, prpstn_to_prop for sentence ;How are you?
(defrule mrs_inter_how
(id-concept_label	?id	kim)
(rel_name-ids	k1s	?kri	?id)
(sentence_type  interrogative)
=>
(printout ?*mrsdef* "(MRS_info id-MRS_concept "(+ ?id 10) " which_q)"crlf)
(printout ?*defdbug* "(rule-rel-values mrs_inter_how  id-MRS_concept "?id " which_q)"crlf)

(printout ?*mrsdef* "(MRS_info id-MRS_concept "(+ ?id 2) " property)"crlf)
(printout ?*defdbug* "(rule-rel-values mrs_inter_how  id-MRS_concept "?id " property)"crlf)

(printout ?*mrsdef* "(MRS_info id-MRS_concept "(+ ?id 3) " unspec_adj)"crlf)
(printout ?*defdbug* "(rule-rel-values mrs_inter_how  id-MRS_concept "?id " unspec_adj)"crlf)

(printout ?*mrsdef* "(MRS_info id-MRS_concept "(+ ?id 3) " prpstn_to_prop)"crlf)
(printout ?*defdbug* "(rule-rel-values mrs_inter_how  id-MRS_concept "?id " prpstn_to_prop)"crlf)
)


;It creates mrs rel feature subord for sentences with vmod_kr_vn
;verified sentence 338 #vaha laMgadAkara calawA hE.
(defrule mrs_subord-kr
(rel_name-ids	kr_vn	?kri	?kvn)
(MRSc-FVs ?mrscon ?lbl ?l ?arg0 ?a0 ARG1: ?a1)
(id-hin_concept-MRS_concept ?kvn ?hin1 ?mrsCon)
(test (neq (str-index _v_ ?mrsCon) FALSE))
(not (id-hin_concept-MRS_concept ?kvn ?hin ?mrscon))
(test (neq (str-index _a_ ?mrscon) FALSE))
=>
(printout ?*mrsdef* "(MRS_info id-MRS_concept -20000 subord)"crlf)
(printout ?*defdbug* "(rule-rel-values mrs_subord-kr id-MRS_concept -20000 subord)"crlf)
)

;Rule for bringing which_q, abstr_deg, measure for the relation degree.
;;How happy was Abramas? 
(defrule mrs_inter_how-adj
(id-concept_label ?id kim)
(rel_name-ids	degree	?noun	?id)
(sentence_type  interrogative)
=>
(printout ?*mrsdef* "(MRS_info id-MRS_concept "(+ ?id 10) " which_q)"crlf)
(printout ?*defdbug* "(rule-rel-values mrs_inter_how-adj  id-MRS_concept "(+ ?id 10) " which_q)"crlf)
(printout ?*mrsdef* "(MRS_info id-MRS_concept "(+ ?id 2) " abstr_deg)"crlf)
(printout ?*defdbug* "(rule-rel-values mrs_inter_how-adj id-MRS_concept "(+ ?id 2)" abstr_deg)"crlf)
(printout ?*mrsdef* "(MRS_info id-MRS_concept "(+ ?id 3) " measure)"crlf)
(printout ?*defdbug* "(rule-rel-values mrs_inter_how-adj id-MRS_concept "(+ ?id 3) " measure)"crlf)
)

