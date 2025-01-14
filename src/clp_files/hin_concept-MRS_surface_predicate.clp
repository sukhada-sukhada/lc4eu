;generates output file "id-cl-mrs_concept.dat" which contains id,hindi concept label, and MRS concept for the hindi user csv by matching concepts from hindi clips facts from the file hin-clips-facts.dat.

(defglobal ?*mrsCon* = mrs-file)
(defglobal ?*mrs-dbug* = mrs-dbug)
(defglobal ?*unkmrs* = unkmrs)
(defglobal ?*unkmrs-debug* = unkmrs-dbug)

;Rule for changing feature values with NN.*_u_unknown with a known word leviathan.
;This rule checks for features having NN.*_u_unknown and then parse with the word leviathan.
;#rAma kaserA nahIM hE.
;#mEMne AleKa paDI.
;If the NN needs feature values till ARG0 then count 4 condition will replace the original word with word leviathan
;If the NN needs feature values till ARG1 then count 6 condition will replace the original word with word resuscitation
;If the NN needs feature values till ARG2 then count 8 condition will replace the original word with word gift
(defrule unknown-NN
(declare (salience 10000))
(id-cl       ?id   ?conLabel)
?f<-(cl-ls-mrs ?conLabel ?enCon ?mrsConcept)
(MRSc-FVs ?mrsConcept $?fv)
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
(id-cl       ?id   ?conLabel)
?f<-(cl-ls-mrs ?conLabel ?enCon ?mrsConcept)
(MRSc-FVs ?mrsConcept $?fv)
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
(id-cl       ?id   ?conLabel)
?f<-(cl-ls-mrs ?conLabel ?enCon ?mrsConcept)
(MRSc-FVs ?mrsConcept $?fv)
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
(id-cl       ?id   ?conLabel)
?f<-(cl-ls-mrs ?conLabel ?enCon ?mrsConcept)
(MRSc-FVs ?mrsConcept $?fv)
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
;This rule generates the concepts from concept dictionary using the clips facts.
(defrule mrs-rels
(id-cl       ?id   ?conLabel)
(cl-ls-mrs ?conLabel ?enCon ?mrsConcept)
=>
(assert (id-hin_concept-MRS_concept ?id ?conLabel ?mrsConcept))
(printout ?*mrs-dbug* "(rule-rel-values mrs-rels id-hin_concept-MRS_concept "?id " " ?conLabel " "?mrsConcept ")"crlf)
)

(defrule print-mrs-rels
?f<-(id-hin_concept-MRS_concept ?id ?conLabel ?mrsConcept)
=>
(retract ?f)
(printout ?*mrsCon* "(id-hin_concept-MRS_concept "?id " " ?conLabel " " ?mrsConcept ")"crlf)
(printout ?*mrs-dbug* "(rule-rel-values print-mrs-rels id-hin_concept-MRS_concept "?id " " ?conLabel " " ?mrsConcept ")"crlf)
)

;rule for generating  _have_v_1 for k4a
;muJe buKAra hE.
(defrule k4a
(declare (salience 10000))
?f1<-(id-cl	?kri	hE_1)
(rel-ids	k4a	?kri	?k4a)
?f<-(id-hin_concept-MRS_concept ?kri hE_1 ?mrsConcept)
=>
(retract ?f ?f1)
(assert (id-hin_concept-MRS_concept ?kri hE_1  _have_v_1))
(printout ?*mrs-dbug* "(rule-rel-values  k4a  id-MRS_concept "?kri"  _have_v_1)"crlf)
)

;It creates mrs rel feature _while_x for sentences with rsk
; #rAma sowe hue KarrAte BarawA hE. 
(defrule mrs_while
(rel-ids	rsk		?id	?kri)
=>
(printout ?*mrsCon* "(MRS_info id-MRS_concept 500  _while_x)"crlf)
(printout ?*mrs-dbug* "(rule-rel-values mrs_while id-MRS_concept 500  _while_x)"crlf)
)

;It creates mrs rel feature _frequent_a_1 for sentences with rpk
;rAma KA -KAkara motA ho gayA .
(defrule mrs_frequent
(rel-ids	rpk	?id	?kri)
(not (rel-ids	k2	?id	?karma))
=>
(printout ?*mrsCon* "(MRS_info id-MRS_concept "(+ ?kri 2)" _frequent_a_1)"crlf)
(printout ?*mrs-dbug* "(rule-rel-values mrs_frequent id-MRS_concept "(+ ?kri 2)"  _frequent_a_1)"crlf)
)

;rule for generating  _should_v_modal
;muJe Gara jAnA cAhie.
; I should go home.
(defrule should_v_modal
(kriyA-TAM	?id  nA_cAhie_1)
=>
(printout ?*mrsCon* "(MRS_info id-MRS_concept "?id "  _should_v_modal)"crlf)
(printout ?*mrs-dbug* "(rule-rel-values  should_v_modal  id-MRS_concept "?id "  _should_v_modal)"crlf)
)

;rule for generating  _would_v_modal
;kyA wuma nahIM Keloge?
;Would you not play?
(defrule would_v_modal
(kriyA-TAM ?id  gA_2)
=>
(printout ?*mrsCon* "(MRS_info id-MRS_concept "?id "  _would_v_modal)"crlf)
(printout ?*mrs-dbug* "(rule-rel-values  would_v_modal  id-MRS_concept "?id "  _would_v_modal)"crlf)
)

;rule for generating  _might_v_modal
;mEM Gara jA sakawA hUz
;He might go home.
(defrule might_v_modal
(kriyA-TAM	?id  0_sakawA_hE_2|yA_hogA_2)
=>
(printout ?*mrsCon* "(MRS_info id-MRS_concept "?id "  _might_v_modal)"crlf)
(printout ?*mrs-dbug* "(rule-rel-values  might_v_modal  id-MRS_concept "?id "  _might_v_modal)"crlf)
)

;rule for generating  _may_v_modal
;mEM Kela sakawA hUz.
;I may play.
(defrule may_v_modal
(kriyA-TAM	?id  0_sakawA_hE_3)
=>
(printout ?*mrsCon* "(MRS_info id-MRS_concept "?id"  _may_v_modal)"crlf)
(printout ?*mrs-dbug* "(rule-rel-values  may_v_modal  id-MRS_concept "?id "  _may_v_modal)"crlf)
)

;rule for generating  _can_v_modal 
;mEM Gara jA sakawA hUz. kyA Apa ruka sakawe hEM? mEM nahIM so sakawA hUz. mEM so sakawA WA. mEM so sakA.
;I can go home.          Can you stop?            I can not sleep.         I could sleep.    I could sleep.
;"_can_v_modal + past tense" generates "could" in ACE parser
(defrule can_v_modal
(kriyA-TAM	?id  0_sakawA_hE_1|0_sakawA_1|0_sakawA_WA_1|0_sakA_1)
=>
(printout ?*mrsCon* "(MRS_info id-MRS_concept "?id "  _can_v_modal)"crlf)
(printout ?*mrs-dbug* "(rule-rel-values  can_v_modal  id-MRS_concept "?id "  _can_v_modal)"crlf)
)


;rule for generating  _must_v_modal
;bacce ko Pala KAnA cAhie.
;child must eat fruit.
(defrule must_v_modal
(kriyA-TAM	?id  nA_cAhie_2|nA_hogA_1|nA_padegA_1)
=>
(printout ?*mrsCon* "(MRS_info id-MRS_concept "?id "  _must_v_modal)"crlf)
(printout ?*mrs-dbug* "(rule-rel-values  must_v_modal  id-MRS_concept "?id "  _must_v_modal)"crlf)
)

;rule for generating  _used+to_v_qmodal
;vaha xillI meM rahawA WA.
;He used to live in Xilli.
(defrule _used+to_v_qmodal
(kriyA-TAM      ?id  wA_WA_1|0_jAwA_WA_1)
=>
(printout ?*mrsCon* "(MRS_info id-MRS_concept "?id "  _used+to_v_qmodal)"crlf)
(printout ?*mrs-dbug* "(rule-rel-values  _used+to_v_qmodal  id-MRS_concept "?id"  _used+to_v_qmodal)"crlf)
)

;rule for generating  _have_v_qmodal
;Rahesh ko seba KAnA hE.
;Ramesh has to eat an apple.
(defrule _have_v_qmodal
(kriyA-TAM	?id  nA_hE_1|nA_padZA_1|nA_padZawA_hE_1|nA_padZawA_WA_1|nA_padZegA_1)
=>
(printout ?*mrsCon* "(MRS_info id-MRS_concept "?id "  _have_v_qmodal)"crlf)
(printout ?*mrs-dbug* "(rule-rel-values  _have_v_qmodal  id-MRS_concept "?id "  _have_v_qmodal)"crlf)
)
;To generate "_want_v_1" MRS concept for the TAM "nA_cAhawA_hE_1" 
;rAma sonA cAhawA hE.
;RAma wants to sleep.
(defrule _want_v_1
(kriyA-TAM      ?id  nA_cAhawA_hE_1)
=>
(printout ?*mrsCon* "(MRS_info id-MRS_concept "?id "  _want_v_1)"crlf)
(printout ?*mrs-dbug* "(rule-rel-values  _want_v_1  id-MRS_concept "?id "  _want_v_1)"crlf)
)

;To generate "_get_v_state" MRS concept for the TAM "yA_gayA_1" 
;KAnA mere xvArA KAyA gayA.
;The food got eaten by me.
(defrule _get_v_state
(id-stative	?id	yes)
=>
(printout ?*mrsCon* "(MRS_info id-MRS_concept "?id " _get_v_state)"crlf)
(printout ?*mrs-dbug* "(rule-rel-values  _get_v_state  id-MRS_concept "?id " _get_v_state)"crlf)
)

;rule for generating  _make_v_cause
;SikRikA ne CAwroM se kakRA ko sAPa karAyA.
;The teacher made the students clean the class.
(defrule make_v_cause
(id-morph_sem	?id	causative)
=>
(printout ?*mrsCon* "(MRS_info id-MRS_concept "?id "  _make_v_cause)"crlf)
(printout ?*mrs-dbug* "(rule-rel-values  _make_v_cause  id-MRS_concept "?id "  _make_v_cause)"crlf)
)

;Rule to genrate _make_v_cause and _ask_v_1 when doublecausative morphological information exists in morpho-semantic row
;#mAz ne rAma se bacce ko KAnA KilavAyA.
(defrule make_ask
(id-morph_sem	?id	doublecausative)
=>
(printout ?*mrsCon* "(MRS_info id-MRS_concept "?id "  _make_v_cause)"crlf)
(printout ?*mrs-dbug* "(rule-rel-values  _make_ask  id-MRS_concept "?id "  _make_v_cause)"crlf)
(printout ?*mrsCon* "(MRS_info id-MRS_concept "?id "  _ask_v_1)"crlf)
(printout ?*mrs-dbug* "(rule-rel-values  _make_ask  id-MRS_concept "(+ ?id 3) "  _ask_v_1)"crlf)
)


;This rules creates _also_a_1 when emphatic exists in the USR
;101 verified sentence #viveka ne rAhula ko BI samAroha meM AmaMwriwa kiyA.
;113 verified sentence #sUrya camakawA BI hE.
(defrule BI_1
(id-dis_part  ?id  BI_1)
(not (rel-ids samuccaya ?previousid	?id))
=>
(printout ?*mrsCon* "(MRS_info id-MRS_concept  "(+ ?id 40)"  _also_a_1)"crlf)
(printout ?*mrs-dbug* "(rule-rel-values BI_1 id-MRS_concept "(+ ?id 40)" _also_a_1)"crlf)
)

;Rule for bring _before_x_h for the rblak relation. ;gAyoM ke xuhane se pahale rAma Gara gayA.
(defrule rblak
(rel-ids	rblak	?id	?kri)
=>
(printout ?*mrsCon* "(MRS_info id-MRS_concept "(+ ?kri 200)" _before_x_h)"crlf)
(printout ?*mrs-dbug* "(rule-rel-values rblak id-MRS_concept "(+ ?kri 200)" _before_x_h)"crlf)
)

;Rule for bring _when_x_subord for the rblk relation. ;rAma ke vana jAne para xaSaraWa mara gaye.
(defrule rblpk
(rel-ids	rblpk	?id	?kri)
=>
(printout ?*mrsCon* "(MRS_info id-MRS_concept "(+ ?kri 200)" _when_x_subord)"crlf)
(printout ?*mrs-dbug* "(rule-rel-values rblpk id-MRS_concept "(+ ?kri 200)" _when_x_subord)"crlf)
)

;Rule for bringing _and_c for conj relation.
;#rAma Ora sIwA acCe hEM.
;#rAma, hari Ora sIwA acCe hEM.
;#Rama buxXimAna, motA, xilera, Ora accA hE.

(defrule conj_1
(cxnlbl-id-values ?conj ?conjid $?var ?op1 ?op2)
(cxnlbl-id-val_ids	?conj	?conjid $?v ?id1 ?id2)
(test (neq (str-index conj_ ?conj) FALSE))
=>
(printout ?*mrsCon* "(MRS_info id-MRS_concept "?conjid"  _and_c)"crlf)
(printout ?*mrs-dbug* "(rule-rel-values conj_1 id-MRS_concept "?conjid" _and_c)"crlf)
)

;Rule for bringing _which_q for $kim with modifier relation.
;Which dog barked?
(defrule mrs_inter_which
(id-cl ?id $kim)
(rel-ids	mod	?noun	?id)
(sent_type  %interrogative)
=>
(printout ?*mrsCon* "(MRS_info id-MRS_concept "(+ ?noun 10)" _which_q)"crlf)
(printout ?*mrs-dbug* "(rule-rel-values mrs_inter_which  id-MRS_concept "(+ ?noun 10)" _which_q)"crlf)
)

;Rule for creation _or_c for disjunct relation.
;Is Rama good or bad?
;I like tea or coffee.
(defrule disjunct_or
(construction-ids	disjunct	$?v ?id1 ?id2)
=>
(printout ?*mrsCon* "(MRS_info id-MRS_concept "(+ ?id1 200)" _or_c)"crlf)
(printout ?*mrs-dbug* "(rule-rel-values disjunct_or id-MRS_concept "(+ ?id1 200)" _or_c)"crlf)
)

;Rule for a as a determiner : if the is not present,is not a mass noun and not plural then generate (id-MRS_Rel ?id _a_q)
(defrule mrsCon_not
(cl-ls-mrs ?hinconcept ?ceng ?mrscon)
(id-cl	?id	?hinconcept)
(test (neq (str-index _n_ ?mrscon) FALSE))
(not (id-speakers_view	 ?id	 def)) ;#rAma apane piwA ke sAWa vixyAlaya gayA.
(not (id-mass ?id yes)) ;#wuma pAnI se GadZe ko Baro.
;(not (id-anim ?id yes))
(not (id-morph_sem	?id	pl))
;(test (neq ?n  pl)) 
(not(id-cl	?id 	$speaker|$addressee|$wyax))
(not(id-org ?id yes))
(not(id-per ?id yes)) ;#rAvana mArA gayA.
(not(id-place ?id yes)) ;#rAma xillI meM nahIM hE.
(not (rel-ids ord ?id $?v)) ;#usane eka Kewa xeKA
(not (rel-ids card ?id $?v)) ;#saviwA rImA ko xasa seba xegI.
(not (rel-ids dem ?id $?v1)) ;#rAma yaha kAma kara sakawA hE.
(not (rel-ids quant ?id $?v1)) ;#prawyeka baccA Kela rahA hE.
(not (rel-ids r6 ?id ?r6))  ;merA_xoswa_bagIcA_meM_Kela_rahA_hE My friend is playing in the garden.
(not (id-cl	?id	$kim)) ;Who won the match?
(not (id-cl	?id	Gara_1))
(not (id-cl	?id	mAwA_1+piwA_1))
(not (id-cl	?id	saba_4))
(not (rel-ids deic ?ida	?id)) ;#yaha Gara hE.
(not (rel-ids coref ?	?id)) ;#usane nahIM KAyA.
(not  (id-abs ?id yes)) ;#kyA wumako buKAra hE?
(not  (id-ne ?id yes)) ;#KIra ke liye cAvala KarIxo.
;(not (sent_type	)) ;#kuwwA! ;#billI Ora kuwwA.
(not (no_a_q_required ?id)) ;Which dog did bark?
(not (rel-ids meas ?id $?v)) ;#rAma bAjAra se wIna kilo cakkI AtA KarIxegA.
(not (cxn_rel-ids	 mod	 ?nc	 ?id))
(not (cxn_rel-ids	 head	 ?nc	 ?id))

=>
(printout ?*mrsCon* "(MRS_info id-MRS_concept "(+ ?id 10) " _a_q)"crlf)
(printout ?*mrs-dbug* "(rule-rel-values  mrsCon_not id-MRS_concept "(+ ?id 10)" _a_q)"crlf)
)

;Rule for removing _a_q for $kim which is in modifier relation. 
;Which dog did bark?
(defrule $kim
(declare (salience 10000))
(id-cl	?kid	$kim)
(id-cl	?nid	?noun)
(rel-ids mod ?nid ?kid)
=>
(assert (no_a_q_required ?nid))
(printout ?*mrs-dbug* "(rule-rel-values  $kim no_a_q_required " ?nid ")"crlf)
)

;Rules for common noun with the as a determiner : if (id-def ? yes), generate (id-MRS_Rel ?id _the_q)
;The book is good.
(defrule mrsCon_yes
(id-speakers_view	 ?id	 def)

=>
(printout ?*mrsCon* "(MRS_info id-MRS_concept "(+ ?id 10) " _the_q )"crlf)
(printout ?*mrs-dbug* "(rule-rel-values mrsCon_yes id-MRS_concept "(+ ?id 10)" _the_q )"crlf)
)

;Rule for bringing _from_p_dir for the sentence with k5 relation along with $kim word. 
;Where did you come from?
(defrule mrs_inter_where-k5-from
(id-cl ?id $kim)
(rel-ids	k5	?noun	?id)
(sent_type  %interrogative)
(not (id-anim	?id	yes)) ;#राम किससे डरता है
=>
(printout ?*mrsCon* "(MRS_info id-MRS_concept "(+ ?id 1) " _from_p_dir)"crlf)
(printout ?*mrs-dbug* "(rule-rel-values mrs_inter_where-k5-from id-MRS_concept "(+ ?id 1) " _from_p_dir)"crlf)
)

;This rule generates ms_n_1 for the feature 'respect' with gender 'f'. 
;405: rajani ji ne apane bete Ora apanI betI ko somavAra ko kASI ke sabase bade vixyAlaya meM BarawI kiyA. Eng: Ms. Rajani ...
(defrule respect-feminine
(id-speakers_view  ?id  respect)
(id-per ?id  yes)
(rel-ids ?rel ?idd ?id)
(id-female ?id  yes)
(not(id-cl	?id 	$addressee))
=>
(printout ?*mrsCon* "(MRS_info id-MRS_concept "(+ ?id 500) "  _ms_n_1 )"crlf)
(printout ?*mrs-dbug* "(rule-rel-values respect-feminine id-MRS_concept "(+ ?id 500) " _ms_n_1 )"crlf)
)

;This rule creates _honorable_a_1 for the respect word "ji" and doesn't create for the respect word of the $addressee.
;361: manwrIjI ne kala manxira kA uxGAtana kiyA. The honorable minister inaugurated the temple yesterday.
(defrule respect-honorable
(id-speakers_view  ?id  respect)
(rel-ids ?rel ? ?id)
(not(id-cl	?id 	$addressee))
(not (id-per ?id  yes))
=>
(printout ?*mrsCon* "(MRS_info id-MRS_concept  "(+ ?id 20)"  _honorable_a_1 )"crlf)
(printout ?*mrs-dbug* "(rule-rel-values respect-honorable id-MRS_concept "(+ ?id 20)" _honorable_a_1 )"crlf)
)

;This rule generates mister_n_1 for the feature 'respect' with gender 'm'. 
;Mr. Sanju came.
(defrule respect-masculine
(id-speakers_view  ?id  respect)
(id-per ?id  yes)
(rel-ids ?rel ?idd ?id)
(id-male ?id  yes)
(not(id-cl	?id 	$addressee))
=>
(printout ?*mrsCon* "(MRS_info id-MRS_concept  "(+ ?id 500) "  _mister_n_1 )"crlf)
(printout ?*mrs-dbug* "(rule-rel-values respect-masculine id-MRS_concept "(+ ?id 500) " _mister_n_1 )"crlf)
)

;Rule to generate _definite_a_1 for the BI_2 discourse particle.
;#rAma ayegA hI.
(defrule hI_2
(id-dis_part  ?id  hI_2)
=>
(printout ?*mrsCon* "(MRS_info id-MRS_concept  "(+ ?id 40)"  _definite_a_1)"crlf)
(printout ?*mrs-dbug* "(rule-rel-values hI_2 id-MRS_concept "(+ ?id 40)" _definite_a_1)"crlf)
)

;Rule to generate _only_a_1 for the exclusive discourse particle.
;SIlA hI apane piwA ko KilAwI hE.
(defrule hI_6
(id-dis_part  ?id  hI_6)
=>
(printout ?*mrsCon* "(MRS_info id-MRS_concept  "(+ ?id 40)"  _only_a_1)"crlf)
(printout ?*mrs-dbug* "(rule-rel-values exclusive id-MRS_concept "(+ ?id 40)" _only_a_1)"crlf)
)


;Rule to generate _certain_a_1 for the wo_1 discourse particle.
;#rAma wo ayegA.
(defrule wo_1
(id-dis_part  ?id  wo_1)
=>
(printout ?*mrsCon* "(MRS_info id-MRS_concept  "(+ ?id 40)"  _certain_a_1)"crlf)
(printout ?*mrs-dbug* "(rule-rel-values BI_2 id-MRS_concept "(+ ?id 40)" _certain_a_1)"crlf)
)

;Rule for generating this_q_dem for the demonstrative other than proximal and distal words. 
;This is a book. 
(defrule this_q_dem
(id-cl	?id	$wyax)
(id-cl	?karwa	?hinconcept)
(or (rel-ids	k1	?kri	?id) (rel-ids	k2	?kri	?id))
(id-speakers_view	 ?id	 proximal)
(not (id-morph_sem	?karwa	pl))
(not (rel-ids	r6	?karwa	?id))
(not (rel-ids	dem	?karwa	?id))
(not (rel-ids	k7p	?kri	?id)) ; He comes here daily.
(not (rel-ids coref ?kuchh	?id))
=>
(printout ?*mrsCon* "(MRS_info id-MRS_concept  "(+ ?id 10)"  _this_q_dem)"crlf)
(printout ?*mrs-dbug* "(rule-rel-values this_q_dem id-MRS_concept "(+ ?id 10)" _this_q_dem)"crlf)
)

;Rule for generating this_q_dem for the demonstrative other than proximal and distal words.
;Rama can do this work.
(defrule this_q_dem_noun
(id-cl	?id	$wyax)
(id-cl	?karwa	?hinconcept)
(rel-ids	dem	?karwa	?id)
(id-speakers_view	 ?id	 proximal)
(not (id-morph_sem	?karwa	pl))
(not (rel-ids	r6	?karwa	?id))
(not (rel-ids	k7p	?kri	?id)) ; He comes here daily.
(not (rel-ids coref ?kuchh	?id))
=>
(printout ?*mrsCon* "(MRS_info id-MRS_concept  "(+ ?karwa 10)"  _this_q_dem)"crlf)
(printout ?*mrs-dbug* "(rule-rel-values this_q_dem_noun id-MRS_concept "(+ ?karwa 10)" _this_q_dem)"crlf)
)

;Rule for generating that_q_dem for distal relation.
;That book is beautiful.
(defrule that_q_dem_distal_noun
(id-cl	?id	$wyax)
(rel-ids	dem	?karwa	?id)  ;Rama arrived that hour.
(id-speakers_view	 ?id	 distal)
(not (id-morph_sem	?karwa	?n))
(not (rel-ids coref ?kuch	?id))
=>
(printout ?*mrsCon* "(MRS_info id-MRS_concept  "(+ ?karwa 10)"  _that_q_dem)"crlf)
(printout ?*mrs-dbug* "(rule-rel-values that_q_dem_distal_noun id-MRS_concept "(+ ?karwa 10)" _that_q_dem)"crlf)
)

;Rule for generating that_q_dem for distal relation.
;That is a book.
(defrule that_q_dem_distal
(id-cl	?id	$wyax) 
(or (rel-ids	k1	?kri	?id)) ;Rama arrived that hour.
(id-speakers_view	 ?id	 distal)
(not (id-morph_sem	?karwa	?n))
(not (rel-ids coref ?kuch	?id))
=>
(printout ?*mrsCon* "(MRS_info id-MRS_concept  "(+ ?id 10)"  _that_q_dem)"crlf)
(printout ?*mrs-dbug* "(rule-rel-values that_q_dem_distal id-MRS_concept "(+ ?id 10)" _that_q_dem)"crlf)
)

;Rule for generating _and_c for the samuccaya relation in the discourse row.
;and He went.
(defrule samuccaya_and
(rel-ids samuccaya ?previousid	?verb)
(not (id-dis_part	?verb	BI_1))
=>
(printout ?*mrsCon* "(MRS_info id-MRS_concept 100  _and_c)"crlf)
(printout ?*mrs-dbug* "(rule-rel-values  samuccaya_and  id-MRS_concept 100  _and_c)"crlf)
)

;Rule for generating _or_c for the anyawra relation in the discourse row.
;or Mohana will go.
(defrule anyawra_or
(rel-ids anyawra ?previousid	?verb)
=>
(printout ?*mrsCon* "(MRS_info id-MRS_concept 100  _or_c)"crlf)
(printout ?*mrs-dbug* "(rule-rel-values  anyawra_or  id-MRS_concept 100  _or_c)"crlf)
)

;Rule for generating _but_c for the viroXI relation in the discourse row.
;but he didn't eat food.
(defrule viroXi_but
(rel-ids viroXi ?previousid	?verb)
=>
(printout ?*mrsCon* "(MRS_info id-MRS_concept 100  _but_c)"crlf)
(printout ?*mrs-dbug* "(rule-rel-values  viroXi_but  id-MRS_concept 100  _but_c)"crlf)
)

;Rule for generating _but_c for the viroXI relation in the discourse row.
;but he didn't eat food.
(defrule viroXi_but
(rel-ids viroXi ?previousid	?verb)
=>
(printout ?*mrsCon* "(MRS_info id-MRS_concept 100  _but_c)"crlf)
(printout ?*mrs-dbug* "(rule-rel-values  viroXi_but  id-MRS_concept 100  _but_c)"crlf)
)


;Rule for generating _then_a_1 for the AvaSyakwA-pariNAma relation in the discourse row.
;wo meM jAUMgA. Then I will go.
(defrule AvaSyakwA-pariNAma_but
(rel-ids AvaSyakwA-pariNAma|samAnakAla ?previousid	?verb)
=>
(printout ?*mrsCon* "(MRS_info id-MRS_concept "(+ ?verb 40) "  _then_a_1)"crlf)
(printout ?*mrs-dbug* "(rule-rel-values  AvaSyakwA-pariNAma_but  id-MRS_concept "(+ ?verb 40) "  _then_a_1)"crlf)
)

;Rule for generating _because_x for the kAryakAraNa relation in the discourse row.
;Because, he has to go home. #kyoMki vo Gara jAnA hE.
(defrule kAryakAraNa_because
(rel-ids kAryakAraNa ?previousid	?verb)
=>
(printout ?*mrsCon* "(MRS_info id-MRS_concept 100  _because_x)"crlf)
(printout ?*mrs-dbug* "(rule-rel-values  kAryakAraNa_because  id-MRS_concept 100  _because_x)"crlf)
)

;Rule for generating _here_a_1 for proximal relation with $wyax word.
;He comes here daily.
(defrule here_a_1
(id-cl	?id	$wyax)
(id-speakers_view	 ?id	 proximal)
(rel-ids	k7p	?kri	?id)
=>
(printout ?*mrsCon* "(MRS_info id-MRS_concept  "?id"  _here_a_1)"crlf)
(printout ?*mrs-dbug* "(rule-rel-values here_a_1 id-MRS_concept "?id" _here_a_1)"crlf)
)

;rule to generate _those_q_dem.
;Those two books are good.
(defrule those_q_dem_distal
(id-cl	?id	$wyax)
(id-speakers_view	 ?id	 distal)
(rel-ids dem ?v ?id)
(id-morph_sem	?v	pl)
=>
(printout ?*mrsCon* "(MRS_info id-MRS_concept  "(+ ?v 10)"  _those_q_dem)"crlf)
(printout ?*mrs-dbug* "(rule-rel-values those_q_dem_distal id-MRS_concept "(+ ?v 10)" _those_q_dem)"crlf)
)

;rule to generate _these_q_dem.
;these two have done it.
(defrule these_q_dem_distal
(id-cl	?id	$wyax)
(id-speakers_view	 ?id	 proximal)
(rel-ids dem ?v ?id)
(id-morph_sem	?v	pl)
=>
(printout ?*mrsCon* "(MRS_info id-MRS_concept  "(+ ?v 10)"  _these_q_dem)"crlf)
(printout ?*mrs-dbug* "(rule-rel-values those_q_dem_distal id-MRS_concept "(+ ?v 10)" _these_q_dem)"crlf)
)

;Rule for generating _if_x_then for the AvaSyakawApariNAma relation in the discourse row.
(defrule AvaSyakawApariNAma
(rel-ids AvaSyakawApariNAma ?previousid	?verb)
=>
(printout ?*mrsCon* "(MRS_info id-MRS_concept "(+ ?verb 40) "  _if_x_then)"crlf)
(printout ?*mrs-dbug* "(rule-rel-values  AvaSyakawApariNAma  id-MRS_concept "(+ ?verb 40) "  _if_x_then)"crlf)
)

;Rule to generate _certain_a_1 for the wo_1 discourse particle.
;#rAma wo ayegA.
(defrule hI_1
(id-dis_part ?id  hI_1)
=>
(printout ?*mrsCon* "(MRS_info id-MRS_concept  "(+ ?id 40)"  _only_x_deg)"crlf)
(printout ?*mrs-dbug* "(rule-rel-values hI_1 id-MRS_concept "(+ ?id 40)" _only_x_deg)"crlf)
)

;Rule to generate _but_c when we have samuccaya and BI_1 relation 
;Rule for generating _but_c for the viroXI relation in the discourse row.
;but he didn't eat food.
(defrule samuccaya_BI_but
(rel-ids samuccaya ?previousid	?verb)
(id-dis_part	?verb	BI_1)
=>
(printout ?*mrsCon* "(MRS_info id-MRS_concept 100  _but_c)"crlf)
(printout ?*mrs-dbug* "(rule-rel-values  samuccaya_BI_but  id-MRS_concept 100  _but_c)"crlf)
)

;Rule to generate _that_q_dem for vyABIcAra discourse relation and when there is distal.
;#इसके बावजूद  वे बहुत घनिष्ठ मित्र थे
(defrule vyABIcAra_that
(rel-ids vyABIcAra ?previousid	?id)
(rel-ids	k1	?id	?karwa)
(id-speakers_view	 ?karwa	 distal)
=>
(printout ?*mrsCon* "(MRS_info id-MRS_concept  "(+ ?id 10) " _that_q_dem)"crlf)
(printout ?*mrs-dbug* "(rule-rel-values vyABIcAra_that id-MRS_concept "(+ ?id 10) "  _that_q_dem)"crlf)
)
;Rule to generate _that_q_dem for vyABIcAra discourse relation and when there is distal.
;#इस कारण उनके माता पिता उनसे बहुत परेशान रहते थे
(defrule pariNAma_that
(rel-ids pariNAma ?previousid	?id)
=>
(printout ?*mrsCon* "(MRS_info id-MRS_concept  "(+ ?id 10) " _that_q_dem)"crlf)
(printout ?*mrs-dbug* "(rule-rel-values pariNAma_that id-MRS_concept "(+ ?id 10) "  _that_q_dem)"crlf)
)

;Rule to generate _despite_p for vyABIcAra discourse relation. 
;#इसके बावजूद  वे बहुत घनिष्ठ मित्र थे
(defrule vyABIcAra_despite
(rel-ids vyABIcAra ?previousid	?id)
(rel-ids	k1	?id	?karwa)
(id-speakers_view	 ?karwa	 distal)
=>
(printout ?*mrsCon* "(MRS_info id-MRS_concept "(+ ?id 1) " _despite_p)"crlf)
(printout ?*mrs-dbug* "(rule-rel-values vyABIcAra_despite id-MRS_concept "(+ ?id 1) " _despite_p)"crlf)
)

;Rule to generate _because+of_p for vyABIcAra discourse relation. 
;#इस कारण उनके माता पिता उनसे बहुत परेशान रहते थे
(defrule _because+of_p
(rel-ids pariNAma ?previousid	?id)
=>
(printout ?*mrsCon* "(MRS_info id-MRS_concept "(+ ?id 1) " _because+of_p)"crlf)
(printout ?*mrs-dbug* "(rule-rel-values _because+of_p id-MRS_concept "(+ ?id 1) " _because+of_p)"crlf)
)

;Rule to generate _there_a_1 for $wyax relation with k7p relation.
;#vahIM para bila meM eka cUhA rahawA WA.
(defrule _there_a_1
(id-cl	?id	$wyax)
(rel-ids	k7p	?kriya	?id)
(not (id-speakers_view	 ?id	 proximal)) ; He comes here daily.
=>
(printout ?*mrsCon* "(MRS_info id-MRS_concept "?id " _there_a_1)"crlf)
(printout ?*mrs-dbug* "(rule-rel-values _there_a_1 id-MRS_concept " ?id " _there_a_1)"crlf)
)

;Rule to generate _only_a_1 for the exclusive discourse particle.
;SIlA hI apane piwA ko KilAwI hE.
(defrule hI_1
(id-dis_part  ?id  hI_1)
=>
(printout ?*mrsCon* "(MRS_info id-MRS_concept  "(+ ?id 40)"  _only_x_deg)"crlf)
(printout ?*mrs-dbug* "(rule-rel-values hI_1 id-MRS_concept "(+ ?id 40)" _only_x_deg)"crlf)
)


