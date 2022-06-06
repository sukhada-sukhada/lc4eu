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
(not (id-def ?id yes))
(not (id-mass ?id yes))
(test (neq ?n  pl))
(not(id-pron ?id yes))
(not(id-org ?id yes))
(not(id-per ?id yes))
(not(id-place ?id yes))
(not (rel_name-ids ord ?id $?v))
(not (rel_name-ids dem ?id $?v1))
(not (rel_name-ids r6 ?id ?r6))  ;merA_xoswa_bagIcA_meM_Kela_rahA_hE My friend is playing in the garden.
(not (id-concept_label	?id	kOna_1)) ;Who won the match?
(not (id-concept_label	?id	Gara_1))
(not (rel_name-ids deic ?ida	?id))
=>
(printout ?*mrsdef* "(MRS_info id-MRS_concept "(+ ?id 10) " _a_q)"crlf)
(printout ?*defdbug* "(rule-rel-values  mrsDef_not id-MRS_concept "?id " _a_q)"crlf)
)

;Rule for plural noun : if (?n is pl) generate ((id-MRS_Rel ?id _udef_q)
(defrule mrs_pl_notDef
(id-gen-num-pers ?id ?g ?n ?p)
(not (id-def ?id yes))
(not (id-mass ?id yes))
(not (rel_name-ids dem ?id $?v))
(test (eq ?n pl))
(not(id-pron ?id yes))
=>
(printout ?*mrsdef* "(MRS_info id-MRS_concept "(+ ?id 10) " udef_q)"crlf)
(printout ?*defdbug* "(rule-rel-values mrs_pl_notDef id-MRS_concept "?id " udef_q)"crlf)
)

;Rule for mass noun : if (id-mass ?id yes) , generate (id-MRS_Rel ?id _udef_q)
(defrule mrs_mass_notDef
(id-gen-num-pers ?id ?g ?n ?p)
(id-mass ?id yes)
(not (rel_name-ids dem ?id ?))
=>
(printout ?*mrsdef* "(MRS_info id-MRS_concept "(+ ?id 10)" udef_q)"crlf)
(printout ?*defdbug* "(rule-rel-values  mrs_mass_notDef id-MRS_concept "(+ ?id 10)" udef_q)"crlf)
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
(or (id-per  ?id yes) (id-place  ?id yes) (id-org  ?id yes))
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
(id-concept_label ?id kyA_1)
(sentence_type  interrogative)
=>
;(printout ?*mrsdef* "(MRS_info id-MRS_concept "?id " thing)"crlf)
;(printout ?*defdbug* "(rule-rel-values mrs_inter_what  id-MRS_concept "?id " thing)"crlf)

(printout ?*mrsdef* "(MRS_info id-MRS_concept "?id " which_q)"crlf)
(printout ?*defdbug* "(rule-rel-values mrs_inter_what  id-MRS_concept "?id " which_q)"crlf)
)

;rule for interrogative sentences for 'who',
;generates (id-MRS_concept "?id " person)
;	   (id-MRS_concept "?id " which_q)
(defrule mrs_inter_who
(id-concept_label ?id kOna_1)
(sentence_type  interrogative)
=>
(printout ?*mrsdef* "(MRS_info id-MRS_concept "?id " person)"crlf)
(printout ?*defdbug* "(rule-rel-values mrs_inter_who  id-MRS_concept "?id " person)"crlf)

(printout ?*mrsdef* "(MRS_info id-MRS_concept "?id " which_q)"crlf)
(printout ?*defdbug* "(rule-rel-values mrs_inter_who  id-MRS_concept "?id " which_q)"crlf)
)

;rule for interrogative sentences for 'where',
;generates (id-MRS_concept "?id " place)
;          (id-MRS_concept "?id " which_q)
(defrule mrs_inter_where
(id-concept_label ?id kahAz_1)
(sentence_type  interrogative)
=>
(printout ?*mrsdef* "(MRS_info id-MRS_concept "?id " place_n)"crlf)
(printout ?*defdbug* "(rule-rel-values mrs_inter_what  id-MRS_concept "?id " place_n"crlf)

(printout ?*mrsdef* "(MRS_info id-MRS_concept "?id " which_q)"crlf)
(printout ?*defdbug* "(rule-rel-values mrs_inter_what  id-MRS_concept "?id " which_q)"crlf)

(printout ?*mrsdef* "(MRS_info id-MRS_concept "?id " loc_nonsp)"crlf)
(printout ?*defdbug* "(rule-rel-values mrs_inter_what  id-MRS_concept "?id " loc_nonsp)"crlf)

)

;Ex. 
(defrule mrs_there
(id-concept_label ?id vahAz_1|vahAz+para_1)
=>
(printout ?*mrsdef* "(MRS_info id-MRS_concept "?id " place_n)"crlf)
(printout ?*defdbug* "(rule-rel-values mrs_there  id-MRS_concept "?id " place_n)"crlf)

(printout ?*mrsdef* "(MRS_info id-MRS_concept "?id " _there_a_1)"crlf)
(printout ?*defdbug* "(rule-rel-values mrs_there id-MRS_concept "?id " _there_a_1)"crlf)

(printout ?*mrsdef* "(MRS_info id-MRS_concept "?id " loc_nonsp)"crlf)
(printout ?*defdbug* "(rule-rel-values mrs_there  id-MRS_concept "?id " loc_nonsp)"crlf)
(printout ?*mrsdef* "(MRS_info id-MRS_concept "?id " def_implicit_q)"crlf)
(printout ?*defdbug* "(rule-rel-values mrs_there  id-MRS_concept "?id " def_implicit_q)"crlf)
)


;written by sakshi yadav (NIT-Raipur)
;date-27.05.19
;rule for sentence -consists of word 'home'
; example -i am coming home
;generates (id-MRS_concept "?id " place_n)
;          (id-MRS_concept "?id " def_implicit_q)
;          (id-MRS_concept "?id " loc_nonsp)
(defrule mrs_home
(id-concept_label ?id Gara_1)
=>
(printout ?*mrsdef* "(MRS_info id-MRS_concept "?id " place_n)"crlf)
(printout ?*defdbug* "(rule-rel-values mrs_home  id-MRS_concept "?id " place_n)"crlf)

(printout ?*mrsdef* "(MRS_info id-MRS_concept "?id " def_implicit_q)"crlf)
(printout ?*defdbug* "(rule-rel-values mrs_home  id-MRS_concept "?id " def_implicit_q)"crlf)

(printout ?*mrsdef* "(MRS_info id-MRS_concept "?id " loc_nonsp)"crlf)
(printout ?*defdbug* "(rule-rel-values mrs_home  id-MRS_concept "?id " loc_nonsp)"crlf)
)

; written by sakshi yadav (NIT-Raipur)
; date-27.05.19
;rule for sentence -consists of words 'yesterday','today','tomorrow' 
;example -i came yesterday
;generates (id-MRS_concept "?id " time_n)
;          (id-MRS_concept "?id " def_implicit_q)
;          (id-MRS_concept "?id " loc_nonsp)
(defrule mrs_kala
(id-concept_label ?id kala_1|kala_2|Aja_1)
(rel_name-ids   ?relname        ?id1  ?id2)	;To restrict the generation of "loc_nonsp" when "kala, Aja" are in "samanadhikaran" relation.
=>
(printout ?*mrsdef* "(MRS_info id-MRS_concept "?id " time_n)"crlf)
(printout ?*defdbug* "(rule-rel-values mrs_kala  id-MRS_concept "?id " time_n)"crlf)

(printout ?*mrsdef* "(MRS_info id-MRS_concept "?id " def_implicit_q)"crlf)
(printout ?*defdbug* "(rule-rel-values mrs_kala  id-MRS_concept "?id " def_implicit_q)"crlf)
(if (neq ?relname samAnAXi) then	;;To restrict the generation of "loc_nonsp" when "kala, Aja" are in "samanadhikaran" relation.e.g Today is Monday.
 (printout ?*mrsdef* "(MRS_info id-MRS_concept "?id " loc_nonsp)"crlf)
 (printout ?*defdbug* "(rule-rel-values mrs_kala  id-MRS_concept "?id " loc_nonsp)"crlf)

 
)
)

;written by sakshi yadav(NIT Raipur) Date-7.06.19
;Generates new facts for days of weeks then generate (MRS_info id-MRS_concept ?id _on_p_temp) and (MRS_info id-MRS_concept ?id dofw) and  (MRS_info id-MRS_concept ?id proper_q) 
(defrule daysofweeks
(id-concept_label ?id somavAra|maMgalavAra|buXavAra|guruvAra|SukravAra|SanivAra|ravivAra|bqhaspawi_1|bqhaspawivAra_1|buGa_1|buXa_1|buXavAra_1|caMxravAra_1|gurUvAra_1|guruvAra_1|iwavAra_1|jumA_1|jumerAwa_1|jummA_1|maMgala_1|maMgalavAra_1|maMgalavAsara_1|ravivAra_1|ravixina_1|sanIcara_2|SanivAra_1|soma_1|somavAra_1|Sukra_2|SukravAra_1)
=>
;(printout ?*mrsdef* "(MRS_info id-MRS_concept "?id " dofw)"crlf)
;(printout ?*defdbug* "(rule-rel-values  daysofweeks id-MRS_concept "?id " dofw)"crlf)

(printout ?*mrsdef* "(MRS_info id-MRS_concept "?id " proper_q)"crlf)
(printout ?*defdbug* "(rule-rel-values  daysofweeks id-MRS_concept "?id " proper_q)"crlf)
)


;written by sakshi yadav(NIT Raipur) Date-11.06.19
;Generates new facts for months of years then generate (MRS_info id-MRS_concept ?id _on_p_temp) and (MRS_info id-MRS_concept ?id mofy) and  (MRS_info id-MRS_concept ?id proper_q) 
(defrule monthsofyears
(id-concept_label ?id janavarI|ParavarI|mArca|aprELa|maI|jUna|juLAI|agaswa|siwaMbara|aktUbara|navaMbara|xisaMbara)
=>
;(printout ?*mrsdef* "(MRS_info id-MRS_concept "?id " mofy)"crlf)
;(printout ?*defdbug* "(rule-rel-values  monthsofyears id-MRS_concept "?id " mofy)"crlf)

(printout ?*mrsdef* "(MRS_info id-MRS_concept "?id " proper_q)"crlf)
(printout ?*defdbug* "(rule-rel-values  monthsofyears id-MRS_concept "?id " proper_q)"crlf)
)

;written by sakshi yadav(NIT Raipur) Date-11.06.19
;Generates new facts for years of centuries then generate (MRS_info id-MRS_concept ?id _in_p_temp) and  (MRS_info id-MRS_concept ?id proper_q) 
(defrule yearsofcenturies
(id-concept_label ?id ?num)
(rel_name-ids k7t ?kri  ?id&:(numberp ?id))
(not (id-concept_label  ?k-id   ?hiConcept&kahAz_1|kaba_1|Aja_1|kala_1|kala_2))
=>
(printout ?*mrsdef* "(MRS_info id-MRS_concept "?id " proper_q)"crlf)
(printout ?*defdbug* "(rule-rel-values  yearsofcenturies id-MRS_concept "?id " proper_q)"crlf)
)



(defrule mrs_parg_d
(sentence_type  pass-affirmative|pass-interrogative)
(kriyA-TAM ?kri ?tam)
=>
(printout ?*mrsdef* "(MRS_info id-MRS_concept "?kri " parg_d)"crlf)
(printout ?*defdbug* "(rule-rel-values mrs_parg_d  id-MRS_concept "?kri" parg_d)"crlf)
)



;rule for interrogative sentences for 'who'
;(defrule mrs_inter_who
;(id-concept_label ?id kOna_1)
;(sentence_type  question)
;=>
;(printout ?*mrsdef* "(MRS_info id-MRS_concept "?id " which_q)"crlf)
;(printout ?*defdbug* "(rule-rel-values mrs_inter_who  id-MRS_concept "?id " which_q)"crlf)
;)

;rule for interrogative sentences for 'when'
(defrule mrs_inter_when
(id-concept_label ?id kaba_1)
(sentence_type  interrogative)
=>
(printout ?*mrsdef* "(MRS_info id-MRS_concept "?id " which_q)"crlf)
(printout ?*defdbug* "(rule-rel-values mrs_inter_when  id-MRS_concept "?id " which_q)"crlf)

(printout ?*mrsdef* "(MRS_info id-MRS_concept "?id " time_n)"crlf)
(printout ?*defdbug* "(rule-rel-values mrs_inter_when  id-MRS_concept "?id " time_n)"crlf)

(printout ?*mrsdef* "(MRS_info id-MRS_concept "?id " loc_nonsp)"crlf)
(printout ?*defdbug* "(rule-rel-values mrs_inter_when  id-MRS_concept "?id " loc_nonsp)"crlf)
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
(kriyA-TAM	?id  nA_hE_1)
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
;(defrule _get_v_state
;(kriyA-TAM      ?id yA_gayA_1)
;=>
;(printout ?*mrsdef* "(MRS_info id-MRS_concept "(+ ?id 100) " _get_v_state)"crlf)
;(printout ?*defdbug* "(rule-rel-values  _get_v_state  id-MRS_concept "(+ ?id 100) " _get_v_state)"crlf)
;)



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

;rule for generating  _make_v_cause
;SikRikA ne CAwroM se kakRA ko sAPa karAyA.
;The teacher made the students clean the class.
(defrule make_v_cause
(id-causative	?id	yes)
=>
(printout ?*mrsdef* "(MRS_info id-MRS_concept "(+ ?id 100) "  _make_v_cause)"crlf)
(printout ?*defdbug* "(rule-rel-values  _make_v_cause  id-MRS_concept "(+ ?id 100) "  _make_v_cause)"crlf)
)

