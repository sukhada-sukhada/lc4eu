( load-facts "mrs_facts.dat")
(assert (default_line))


;Rule made by Amandeep Kaur[Btech intern]
(defrule topic_focus_to_be
(declare (salience 10))
=>
	(assert (topic_focus_to_be_assigned))
)




;I live in "Germany".
;"Tom" slept.
(defrule proper_q
?f0<-(name-mrs_id-mrs_hndl-id ?name ?mrs_id ?hndl ?id) 
(test (eq ?name proper_q))
=>
	(retract ?f0)
        (assert (name-mrs_id-mrs_hndl-id "udef_q_rel" ?mrs_id ?hndl ?id) )
)

;I live in "Germany".
;"Tom" owns a car.
(defrule named
?f1<-(named-mrs_id-mrs_hndl-CARG ?named ?mrs_id ?hndl ?CARG)
(test (eq ?named named))
=>
       (retract ?f1)
       (assert (named-mrs_id-mrs_hndl-id named_rel ?mrs_id ?hndl ?CARG) )
       
)

;"He" is a thief.
;"He" laughs.
(defrule pronoun_q
?f2<-(name-mrs_id-mrs_hndl-id ?name ?mrs_id ?hndl ?id)
(test (eq ?name pronoun_q))
=>
       (retract ?f2)
       (assert (name-mrs_id-mrs_hndl-id "pronoun_q_rel" ?mrs_id ?hndl ?id) )
)

;He came "yesterday".
(defrule time
?f22<-(name-mrs_id-mrs_hndl-id ?name ?mrs_id ?hndl ?id)
(test (eq ?name time_n))
=>
       (retract ?f22)
       (assert (name-mrs_id-mrs_hndl-id "time_rel" ?mrs_id ?hndl ?id))
)

(defrule loc
?f23<-(name-mrs_id-mrs_hndl-id ?name ?mrs_id ?hndl ?id)
(test (eq ?name loc_nonsp))
=>
      (retract ?f23)
     (assert (name-mrs_id-mrs_hndl-id "unspec_loc_rel" ?mrs_id ?hndl ?id) )
)

(defrule place
?f24<-(name-mrs_id-mrs_hndl-id ?name ?mrs_id ?hndl ?id)
(test (eq ?name place_n))
=>
       (retract ?f24)
       (assert (name-mrs_id-mrs_hndl-id "place_rel" ?mrs_id ?hndl ?id) )
)

(defrule poss
?f24<-(name-mrs_id-mrs_hndl-id ?name ?mrs_id ?hndl ?id)
(test (eq ?name poss))
=>
       (retract ?f24)
       (assert (name-mrs_id-mrs_hndl-id "poss_rel" ?mrs_id ?hndl ?id) )
)

(defrule much
?f24<-(name-mrs_id-mrs_hndl-id ?name ?mrs_id ?hndl ?id)
(test (eq ?name much-many_a))
=>
       (retract ?f24)
       (assert (name-mrs_id-mrs_hndl-id "_viel_a_rel" ?mrs_id ?hndl ?id) )
)

(defrule which
?f24<-(name-mrs_id-mrs_hndl-id ?name ?mrs_id ?hndl ?id)
?f1<-(q_mrs_hndl-Rstr-Body  ?mrs_id ?h11 ?h12)
?f0<-(Restrictor-Restricted  ?h11 ?h8 ) 
(test (eq ?name which_q))
=>
       (retract ?f24)
       (retract ?f0)
      ; (assert (name-mrs_id-mrs_hndl-id "_viel_a_rel" ?mrs_id ?hndl ?id) )
)

(defrule measure
?f24<-(name-mrs_id-mrs_hndl-id ?name ?mrs_id ?hndl ?id)
(test (eq ?name measure))
=>
       (retract ?f24)
      ; (assert (name-mrs_id-mrs_hndl-id "_viel_a_rel" ?mrs_id ?hndl ?id) )
)


(defrule poss_tense
(declare (salience 100))
?f241<-(name-mrs_id-mrs_hndl-id poss ?mid ?hndl ?id)
?f242<-(e_mrs_id-SF-Tns-Mood-prog-perf ?mid ?sf untensed $?p ) 
=>
       (retract ?f242)
       (assert (e_mrs_id-SF-Tns-Mood-prog-perf ?mid ?sf none $?p ) )
)


(defrule card_rel
?f26<-(name-mrs_id-mrs_hndl-id ?name ?mrs_id ?hndl ?id)
(test (eq ?name card))
=>
       (retract ?f26)
       (assert (name-mrs_id-mrs_hndl-id card_rel ?mrs_id ?hndl ?id) )
)


(defrule loc_Tns
(declare (salience 100))
?f25<-(name-mrs_id-mrs_hndl-id loc_nonsp ?mid ?hndl ?id)
?f251<-(e_mrs_id-SF-Tns-Mood-prog-perf ?mid ?sf untensed ?m ?prog ?perf )
=>
       (retract ?f251)
       (assert (e_mrs_id-SF-Tns-Mood-prog-perf ?mid ?sf none ) )
)


(defrule udef_q
?f4<-(name-mrs_id-mrs_hndl-id ?name ?mrs_id ?hndl ?id)
(test (eq ?name udef_q))
=>
       (retract ?f4)
       (assert (name-mrs_id-mrs_hndl-id "udef_q_rel" ?mrs_id ?hndl ?id) )
)


(defrule def_explicit_q
?f4<-(name-mrs_id-mrs_hndl-id ?name ?mrs_id ?hndl ?id)
(test (eq ?name def_explicit_q))
=>
      (retract ?f4)
;     (assert (name-mrs_id-mrs_hndl-id "udef_q_rel" ?mrs_id ?hndl ?id) )
)



;(defrule udef_q
;?f5<-(name-mrs_id-mrs_hndl-id ?name ?mrs_id ?hndl ?id)
;(test (eq ?name udef_q))
;=>
;      (retract ?f5)
;     (assert (name-mrs_id-mrs_hndl-id "focus_d_rel" ?mrs_id ?hndl ?id) )
;)

;Tom owns "a" car.
;I am "a" good doctor.
(defrule _a_q
?f6<-(name-mrs_id-mrs_hndl-id ?name ?mrs_id ?hndl ?id)
(test (eq ?name _a_q))
=>
       (retract ?f6)
       (assert (name-mrs_id-mrs_hndl-id "_ein_q_rel" ?mrs_id ?hndl ?id) )
)

;"The" boy eats a red apple.
;She sits on "the" chair.
;Rule made by Amandeep Kaur[Btech intern]
(defrule _the_q
?f7<-(name-mrs_id-mrs_hndl-id ?name ?mrs_id ?hndl ?id)
(test (eq ?name _the_q))
=>
       (retract ?f7)
       (assert (name-mrs_id-mrs_hndl-id "_def_q_rel" ?mrs_id ?hndl ?id) )
)

;He bought a pen "for" writing.
(defrule _for_p
?f42<-(name-mrs_id-mrs_hndl-id ?name ?mrs_id ?hndl ?id)
(test (eq ?name _for_p))
=>
       (retract ?f42)
       (assert (name-mrs_id-mrs_hndl-id "_zu_p_rel" ?mrs_id ?hndl ?id) )
)

;He came "from" Germany.
(defrule _from_p_dir
?f43<-(name-mrs_id-mrs_hndl-id ?name ?mrs_id ?hndl ?id)
(test (eq ?name _from_p_dir))
=>
       (retract ?f43)
       (assert (name-mrs_id-mrs_hndl-id "udef_q_rel" ?mrs_id ?hndl ?id) )
)

;I went "to" Germany.
(defrule _to_p
?f43<-(name-mrs_id-mrs_hndl-id ?name ?mrs_id ?hndl ?id)
(test (eq ?name _to_p))
=>
       (retract ?f43)
       (assert (name-mrs_id-mrs_hndl-id "_nach_p_rel" ?mrs_id ?hndl ?id) )
)

;Rule made by Amandeep Kaur[Btech intern]
(defrule person
?f60<-(name-mrs_id-mrs_hndl-id ?name ?mrs_id ?hndl ?id)
(test (eq ?name person))
=>
       (retract ?f60)
       (assert (name-mrs_id-mrs_hndl-id "abstr_nom_rel" ?mrs_id ?hndl ?id) )
)

(defrule _about_p
?f46<-(name-mrs_id-mrs_hndl-id ?name ?mrs_id ?hndl ?id)
(test (eq ?name _about_p))
=>
       (retract ?f46)
       (assert (name-mrs_id-mrs_hndl-id "_ueber_p_loc_rel" ?mrs_id ?hndl ?id) )
)

(defrule _with_p
?f47<-(name-mrs_id-mrs_hndl-id ?name ?mrs_id ?hndl ?id)
(test (eq ?name _with_p))
=>
       (retract ?f47)
       (assert (name-mrs_id-mrs_hndl-id "_mit_p_rel" ?mrs_id ?hndl ?id) )
)

(defrule _such_a_1
?f42<-(name-mrs_id-mrs_hndl-id ?name ?mrs_id ?hndl ?id)
(test (eq ?name _such_a_1))
=>
       (retract ?f42)
       (assert (name-mrs_id-mrs_hndl-id "_solch_a_rel" ?mrs_id ?hndl ?id) )
)


;"I" went to Germany.
;"He" laughs.
(defrule pron
?f10<-(name-mrs_id-mrs_hndl-id ?name ?mrs_id ?hndl ?id)
(test (eq ?name pron))
=>
       (retract ?f10)
       (assert (name-mrs_id-mrs_hndl-id "_pron_n_ppro_rel" ?mrs_id ?hndl ?id) )
)

;I went to "Germany".
;The boy eats a red "apple".
(defrule rm_IND
?f11<-(x_mrs_id-pers-Num-Ind ?x_mrs_id ?pers ?Num +)
=>
       (retract ?f11)
       (assert (x_mrs_id-pers-Num-Ind ?x_mrs_id ?pers ?Num) )
)

(defrule rm_IND1
(declare (salience 7))
?f11<-(x_mrs_id-pers-Num-Ind ?x_mrs_id ?pers ?Num +)
=>
       (retract ?f11)
       (assert (x_mrs_id-pers-Num-Ind ?x_mrs_id ?pers) )
)


;I "went" to Germany.
;I "will" go.
(defrule default3
?f9<-(e_mrs_id-SF-Tns-Mood-prog-perf ?e_mrs_id ?SF ?Tns indicative ?p ?pe)
=>
       (retract ?f9)
       (assert (e_mrs_id-SF-Tns-Mood-prog-perf ?e_mrs_id ?SF ?Tns) )
)

;Rule made by Amandeep Kaur[Btech intern]
(defrule default5
(declare (salience 7))
?f9<-(e_mrs_id-SF-Tns-Mood-prog-perf ?e_mrs_id ?SF untensed indicative ?p ?pe)
?f33<-(name-mrs_id-mrs_hndl-id ?name ?e_mrs_id ?hndl ?id )
(test(eq ?name parg_d))
=>
       (retract ?f9)
       (assert (e_mrs_id-SF-Tns-Mood-prog-perf-STAT ?e_mrs_id ?SF none -) )
)

;Rule made by Amandeep Kaur[Btech intern]
(defrule default7
(declare (salience 8))
?f1<-(ltop-index ?h0 ?e2 )
?f9<-(name-mrs_id-mrs_hndl-id ?name ?e2 ?hndl ?id)
?f33<-(name-mrs_id-mrs_hndl-id parg_d ?e_mrs_id ?hndl ?id )
?f0<-(mrs_id-Args  ?e2 ?x9 ?x3 ) 
(test(eq (sub-string 1 1 ?x9) "x"))
=>
       
       (assert (name-mrs_id-mrs_hndl-id _von_p_sel_rel e12 h15 4 ))
       (assert (mrs_id-Args e12 i11 ?x9))
       (assert (e_mrs_id-SF-Tns-Mood-prog-perf e12 prop none -))
)


;"I" went to Germany.
;"Tom" operates a school.
(defrule default4
?f12<-(pr_mrs_id-pers-Num-Pt ?pr_mrs_id ?pers ?Num std)
=>
       (retract ?f12)
       (assert (pr_mrs_id-pers-Num-Pt ?pr_mrs_id ?pers ?Num) )
)

;I am a "good" doctor.
;The girl is "making" a doll.
;Rule made by Amandeep Kaur[Btech intern]
(defrule rm_arg
;;(declare (salience 4 ))
?f17<-(name-mrs_id-mrs_hndl-id ?name ?mid ?m_hid ?id )
;;?f172<-(name-mrs_id-mrs_hndl-id parg_d ?mid1 ?m_hid ?id )
?f171<-(mrs_id-Args ?mid $?pre ?arg $?post)
(test (or (eq (sub-string 1 1 ?arg) "u")
	  (eq (sub-string 1 1 ?arg) "p")))
;	  (eq (sub-string 1 1 ?arg) "u")))
=>
        	(retract ?f171)
        	(assert (mrs_id-Args ?mid $?pre $?post ))

)

;Rule made by Amandeep Kaur[Btech intern]
(defrule default6
(declare (salience 7))
?f9<-(e_mrs_id-SF-Tns-Mood-prog-perf ?e_mrs_id ?SF untensed indicative ?p ?pe)
?f33<-(name-mrs_id-mrs_hndl-id ?name ?e_mrs_id ?hndl ?id )
(test (neq (str-index "_x_" ?name) FALSE))
=>
       (retract ?f9)
       (assert (e_mrs_id-SF-Tns-Mood-prog-perf-STAT ?e_mrs_id ?SF none ) )
)



;Rule made by Amandeep Kaur[Btech intern]
(defrule rm_arg1
(declare (salience 5))
?f17<-(name-mrs_id-mrs_hndl-id ?name ?mid ?m_hid ?id )
;?f172<-(name-mrs_id-mrs_hndl-id parg_d ?mid1 ?m_hid ?id )
?f171<-(mrs_id-Args ?mid $?pre ?arg $?post)
(test (and (or (neq (str-index "_n_" ?name) FALSE ) 
	       (neq (str-index "_a_" ?name) FALSE ))
           (eq (sub-string 1 1 ?arg) "i")))
           
=>
                (retract ?f171)
                (assert (mrs_id-Args ?mid $?pre $?post))

)



;(defrule rm_arg1
;(declare (salience 5))
;?f17<-(name-mrs_id-mrs_hndl-id ?name ?mid ?m_hid ?id )
;;?f172<-(name-mrs_id-mrs_hndl-id parg_d ?mid1 ?m_hid ?id )
;?f171<-(mrs_id-Args ?mid $?pre ?arg $?post) 
;(test (and (or (neq (str-index "_n_" ?name) FALSE ) 
 ;              (neq (str-index "_a_" ?name) FALSE ))
  ;         (or (eq (sub-string 1 1 ?arg) "p")
   ;            (eq (sub-string 1 1 ?arg) "i")
    ;           (eq (sub-string 1 1 ?arg) "u"))))
  
;=>
 ;               (retract ?f171)
  ;              (assert (mrs_id-Args ?mid $?pre $?post))

;)



;(defrule rm_arg1
;(declare (salience 8))
;?f27<-(name-mrs_id-mrs_hndl-id  ?name ?e2 ?hndl ?id )
;?f37<-((ltop-index ?h0 ?e2 )
;?f272<-(name-mrs_id-mrs_hndl-id parg_d ?mrs_id ?hndl ?id )
;;;?f271<-(mrs_id-Args ?mid $?pre ?arg $?post)
;?f371<-(mrs_id-Args  ?e2 $?pre ?arg $?post )
;(test (eq ?name parg_d))
;=>

;	(retract ?f371)
 ;       (assert (mrs_id-Args ?e2 $?pre ?arg $?post ))
		

        
;)

;(test (neq ?name1 parg_d)
;=>
 ;      (retract ?f171)
  ;     (assert (mrs_id-Args ?mid $?pre $?post ))
   ;    )


;Rule made by Amandeep Kaur[Btech intern]
(defrule mod_tense1
(declare (salience 5))
?f11<-(ltop-index ?h0 ?e2 )
?f14<-(name-mrs_id-mrs_hndl-id parg_d ?mrs_id ?hndl ?id )
?f1<-(name-mrs_id-mrs_hndl-id ?name ?e2 ?hndl ?id )
?f13<-(e_mrs_id-SF-Tns-Mood-prog-perf ?e2 ?SF ?Tns indicative ?p ?pe)
(test (neq (str-index "_v_" ?name) FALSE))

=>
        (retract ?f13)
        (assert (e_mrs_id-SF-Tns-Mood-prog-perf---PSV-MOOD ?e2 ?SF ?Tns apsv indicative))
)




;I live "in" Germany.
;He came "from" Germany.
;The carpenter has made a "beautiful" chair.
(defrule mod_tense
(declare (salience 100))
?f14<-(name-mrs_id-mrs_hndl-id  ?name ?mid ?m_hid ?id )
?f13<-(e_mrs_id-SF-Tns-Mood-prog-perf ?mid ?sf untensed $?p1)
(test (or (neq (str-index "_a" ?name) FALSE)
          (neq (str-index "_p" ?name) FALSE))
)
=>
        (retract ?f13)
        (assert (e_mrs_id-SF-Tns-Mood-prog-perf ?mid ?sf none $?p1))
)

;The morning is "clear".
;The cake is "delicious".
(defrule stat
(declare (salience 100))
?f182<-(ltop-index ?h ?mid)
?f18<-(name-mrs_id-mrs_hndl-id  ?name ?mid ?m_hid ?id )
?f181<-(e_mrs_id-SF-Tns-Mood-prog-perf ?mid ?sf ?Tns $?p1)
(test (or (neq (str-index "_a_" ?name) FALSE)
          (neq (str-index "_p_" ?name) FALSE))
)
=>
        (retract ?f181)
        (assert (e_mrs_id-SF-Tns-STAT   ?mid ?sf ?Tns +))
)

;I "am" a good doctor.
;He "is" a theif.
(defrule stat2
?f212<-(ltop-index ?h ?mid)
?f21<-(name-mrs_id-mrs_hndl-id  _be_v_id ?mid ?m_hid ?id )
?f211<-(e_mrs_id-SF-Tns-Mood-prog-perf   ?mid ?sf ?Tns ?m ?prog ?perf )


=>
        (retract ?f211)
        (assert (e_mrs_id-SF-Tns-STAT   ?mid ?sf ?Tns +))
)


;The boy eats an apple "in" the market.
(defrule _in_p
?f40<-(name-mrs_id-mrs_hndl-id ?name ?mrs_id ?hndl ?id)
(test (eq ?name _in_p))
=>
       (retract ?f40)
       (assert (name-mrs_id-mrs_hndl-id "_in_p_loc_rel" ?mrs_id ?hndl ?id) )
)
;He cannot swim.
;He was "not" running.
(defrule neg
(declare (salience 5))
?f1<-(ltop-index ?h0 ?e2)
?f48<-(name-mrs_id-mrs_hndl-id ?name ?u7 ?hndl ?id)
;?msg<-(topic_focus_to_be_assigned)
(test (eq ?name neg))
=>
       (retract ?f48)
 ;      (retract ?msg)
       (assert (name-mrs_id-mrs_hndl-id "_neg_a_rel" ?u7 ?hndl ?id) )
      ; (assert (topic-or-focus_d_rel<-1:-1> LBL: ?hndl ARG1: ?e2 ARG0: e22 ) )
)


(defrule _into_p
?f49<-(name-mrs_id-mrs_hndl-id ?name ?mrs_id ?hndl ?id)
(test (eq ?name _into_p))
=>
       (retract ?f49)
       (assert (name-mrs_id-mrs_hndl-id "_in_p_dir_rel" ?mrs_id ?hndl ?id) )
)

(defrule every_q
?f1<-(name-mrs_id-mrs_hndl-id ?name ?mrs_id ?hndl ?id)
(test (eq ?name every_q))
=>
       (retract ?f1)
       (assert (name-mrs_id-mrs_hndl-id "_all_q_rel" ?mrs_id ?hndl ?id) )
)

;Rule made by Amandeep Kaur[Btech intern]
(defrule parg_d
?f50<-(name-mrs_id-mrs_hndl-id ?name ?mrs_id ?hndl ?id)
(test (eq ?name parg_d))
=>
       (retract ?f50)
       (assert (name-mrs_id-mrs_hndl-id parg_d_rel ?mrs_id ?hndl ?id ) )
)



(defrule _by_p
?f52<-(name-mrs_id-mrs_hndl-id ?name ?mrs_id ?hndl ?id)
(test (eq ?name _by_p))
=>
       (retract ?f52)
       (assert (name-mrs_id-mrs_hndl-id "_von_p_rel" ?mrs_id ?hndl ?id) )
)


;Rule made by Amandeep Kaur[Btech intern]
(defrule defaultin1
(declare (salience -2))
(default_line)
?f200<-(ltop-index ?h0 ?e2)
?f201<-(name-mrs_id-mrs_hndl-id  ?name ?mrs_id ?hndl ?id)
?msg<-(topic_focus_to_be_assigned)
;?f202<-(mrs_id-Args  ?e10 ?mrs_id ?iid)
;?f203<-(name-mrs_id-mrs_hndl-id  ?name1 ?mrs_iid ?hndl ?id1)
(test (eq ?e2 ?mrs_id ))

=>
;; ;      (assert (added_line))
	 (retract ?msg)
	 (assert (topic-or-focus_d_rel<-1:-1> LBL: ?hndl ARG1: ?mrs_id ARG0: e22 ))
)

;Rule made by Amandeep Kaur[Btech intern] 29/03/18
(defrule negdef
(declare (salience -1))
;(default_line)
?msg<-(topic_focus_to_be_assigned)
?f300<-(ltop-index ?h0 ?e2)
?f301<-(name-mrs_id-mrs_hndl-id ?name ?e2 ?hndl ?id)
?f302<-(name-mrs_id-mrs_hndl-id "_neg_a_rel" ?mrs_id ?hndl1 ?id1)
=>
	(retract ?msg)
	(assert (topic-or-focus_d_rel<-1:-1> LBL: ?hndl1 ARG1: ?e2 ARG0: e22 ))
)
  
(facts)
(agenda)
(watch rules)
(watch facts)
(run)
(save-facts "ger_mrs.dat" visible)
(exit)


	 
