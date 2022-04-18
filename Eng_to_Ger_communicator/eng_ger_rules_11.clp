(load-facts "mrs_facts.dat")


(defrule proper_q
?f0<-(name-mrs_id-mrs_hndl-id ?name ?mrs_id ?hndl ?id) 
(test (eq ?name proper_q))
=>
	(retract ?f0)
        (assert (name-mrs_id-mrs_hndl-id "udef_q_rel" ?mrs_id ?hndl ?id) )
)

(defrule named
?f1<-(named-mrs_id-mrs_hndl-CARG ?named ?mrs_id ?hndl ?CARG)
(test (eq ?named named))
=>
       (retract ?f1)
       (assert (named-mrs_id-mrs_hndl-id named_rel ?mrs_id ?hndl ?CARG) )
)
(defrule pronoun_q
?f2<-(name-mrs_id-mrs_hndl-id ?name ?mrs_id ?hndl ?id)
(test (eq ?name pronoun_q))
=>
       (retract ?f2)
       (assert (name-mrs_id-mrs_hndl-id "pronoun_q_rel" ?mrs_id ?hndl ?id) )
)
(defrule which_q
?f3<-(name-mrs_id-mrs_hndl-id ?name ?mrs_id ?hndl ?id)
(test (eq ?name which_q))
=>
       (retract ?f3)
       (assert (name-mrs_id-mrs_hndl-id "wh_q_rel" ?mrs_id ?hndl ?id) )
)

(defrule time
?f22<-(name-mrs_id-mrs_hndl-id ?name ?mrs_id ?hndl ?id)
(test (eq ?name time_n))
=>
       (retract ?f22)
       (assert (name-mrs_id-mrs_hndl-id "time_rel" ?mrs_id ?hndl ?id) )
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


(defrule card
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
(defrule udef_q
?f5<-(name-mrs_id-mrs_hndl-id ?name ?mrs_id ?hndl ?id)
(test (eq ?name udef_q))
=>
       (retract ?f5)
       (assert (name-mrs_id-mrs_hndl-id "focus_d_rel" ?mrs_id ?hndl ?id) )
)
(defrule _a_q
?f6<-(name-mrs_id-mrs_hndl-id ?name ?mrs_id ?hndl ?id)
(test (eq ?name _a_q))
=>
       (retract ?f6)
       (assert (name-mrs_id-mrs_hndl-id "_ein_q_rel" ?mrs_id ?hndl ?id) )
)
(defrule _the_q
?f7<-(name-mrs_id-mrs_hndl-id ?name ?mrs_id ?hndl ?id)
(test (eq ?name _the_q))
=>
       (retract ?f7)
       (assert (name-mrs_id-mrs_hndl-id "_def_q_rel" ?mrs_id ?hndl ?id) )
)
(defrule _for_p
?f8<-(name-mrs_id-mrs_hndl-id ?name ?mrs_id ?hndl ?id)
(test (eq ?name _for_p))
=>
       (retract ?f8)
       (assert (name-mrs_id-mrs_hndl-id "_cause_a_rel" ?mrs_id ?hndl ?id) )
)

(defrule pron
?f10<-(name-mrs_id-mrs_hndl-id ?name ?mrs_id ?hndl ?id)
(test (eq ?name pron))
=>
       (retract ?f10)
       (assert (name-mrs_id-mrs_hndl-id "_pron_n_ppro_rel" ?mrs_id ?hndl ?id) )
)


(defrule rm_IND
?f11<-(x_mrs_id-pers-Num-Ind ?x_mrs_id ?pers ?Num +)
=>
       (retract ?f11)
       (assert (x_mrs_id-pers-Num-Ind ?x_mrs_id ?pers ?Num) )
)



(defrule default3
?f9<-(e_mrs_id-SF-Tns-Mood-prog-perf ?e_mrs_id ?SF ?Tns indicative ?p ?pe)
=>
       (retract ?f9)
       (assert (e_mrs_id-SF-Tns-Mood-prog-perf ?e_mrs_id ?SF ?Tns) )
)

(defrule default4
?f12<-(pr_mrs_id-pers-Num-Pt ?pr_mrs_id ?pers ?Num std)
=>
       (retract ?f12)
       (assert (pr_mrs_id-pers-Num-Pt ?pr_mrs_id ?pers ?Num) )
)


(defrule rm_arg
?f17<-(name-mrs_id-mrs_hndl-id  ?name ?mid ?m_hid ?id )
?f171<-(mrs_id-Args ?mid $?pre ?arg $?post)
(test (or (eq (sub-string 1 1 ?arg) "i")
	  (eq (sub-string 1 1 ?arg) "p")
	  (eq (sub-string 1 1 ?arg) "u")))
=>
        (retract ?f171)
        (assert (mrs_id-Args  ?mid $?pre $?post ))
)

(defrule mod_tense
(declare (salience 100))
?f14<-(name-mrs_id-mrs_hndl-id  ?name ?mid ?m_hid ?id )
?f13<-(e_mrs_id-SF-Tns-Mood-prog-perf ?mid ?sf untensed ?m ?prog ?perf )
(test (or (eq (sub-string (- (length ?name) 1) (- (length ?name ) 0) ?name) "_a")
          (eq (sub-string (- (length ?name) 1) (- (length ?name ) 0) ?name) "_p"))
)
=>
        (retract ?f13)
        (assert (e_mrs_id-SF-Tns-Mood-prog-perf ?mid ?sf none))
)

(defrule mod_tense1
(declare (salience 100))
?f14<-(name-mrs_id-mrs_hndl-id  ?name ?mid ?m_hid ?id )
?f13<-(e_mrs_id-SF-Tns-Mood-prog-perf ?mid ?sf untensed ?m ?prog ?perf )
(test (or (eq (sub-string (- (length ?name) 3) (- (length ?name ) 1) ?name) "_a_")
          (eq (sub-string (- (length ?name) 3) (- (length ?name ) 1) ?name) "_p_"))
)
=>
        (retract ?f13)
        (assert (e_mrs_id-SF-Tns-Mood-prog-perf ?mid ?sf none))
)

(defrule mod_tense2
(declare (salience 100))
?f14<-(name-mrs_id-mrs_hndl-id  ?name ?mid ?m_hid ?id )
?f13<-(e_mrs_id-SF-Tns-Mood-prog-perf ?mid ?sf untensed ?m ?prog ?perf )
(test (or (eq (sub-string (- (length ?name) 4) (- (length ?name ) 2) ?name) "_a_")
          (eq (sub-string (- (length ?name) 4) (- (length ?name ) 2) ?name) "_p_"))
)
=>
        (retract ?f13)
        (assert (e_mrs_id-SF-Tns-Mood-prog-perf ?mid ?sf none))
)

(defrule mod_tense3
(declare (salience 1000))
?f14<-(name-mrs_id-mrs_hndl-id  ?name ?mid ?m_hid ?id )
?f13<-(e_mrs_id-SF-Tns-Mood-prog-perf ?mid ?sf untensed ?m ?prog ?perf )
(test (or (eq (sub-string (- (length ?name) 11) (- (length ?name ) 9) ?name) "_a_")
          (eq (sub-string (- (length ?name) 11) (- (length ?name ) 9) ?name) "_p_"))
)
=>
        (retract ?f13)
        (assert (e_mrs_id-SF-Tns-Mood-prog-perf ?mid ?sf none))
)

(defrule mod_tense4
(declare (salience 100))
?f14<-(name-mrs_id-mrs_hndl-id  ?name ?mid ?m_hid ?id )
?f13<-(e_mrs_id-SF-Tns-Mood-prog-perf ?mid ?sf untensed ?m ?prog ?perf )
(test (or (eq (sub-string (- (length ?name) 6) (- (length ?name ) 4) ?name) "_a_")
          (eq (sub-string (- (length ?name) 6) (- (length ?name ) 4) ?name) "_p_"))
)
=>
        (retract ?f13)
        (assert (e_mrs_id-SF-Tns-Mood-prog-perf ?mid ?sf none))
)

(defrule mod_tense5
(declare (salience 100))
?f14<-(name-mrs_id-mrs_hndl-id  ?name ?mid ?m_hid ?id )
?f13<-(e_mrs_id-SF-Tns-Mood-prog-perf ?mid ?sf untensed ?m ?prog ?perf )
(test (or (eq (sub-string (- (length ?name) 5) (- (length ?name ) 3) ?name) "_a_")
          (eq (sub-string (- (length ?name) 5) (- (length ?name ) 3) ?name) "_p_"))
)
=>
        (retract ?f13)
        (assert (e_mrs_id-SF-Tns-Mood-prog-perf ?mid ?sf none))
)

(defrule stat
?f182<-(ltop-index ?h ?mid)
?f18<-(name-mrs_id-mrs_hndl-id  ?name ?mid ?m_hid ?id )
?f181<-(e_mrs_id-SF-Tns-Mood-prog-perf   ?mid ?sf ?Tns ?m ?prog ?perf )
(test (or (eq (sub-string (- (length ?name) 3) (- (length ?name ) 1) ?name) "_a_")
          (eq (sub-string (- (length ?name) 3) (- (length ?name ) 1) ?name) "_p_"))
)
=>
        (retract ?f181)
        (assert (e_mrs_id-SF-Tns-STAT   ?mid ?sf ?Tns +))
)

(defrule stat1
?f182<-(ltop-index ?h ?mid)
?f18<-(name-mrs_id-mrs_hndl-id  ?name ?mid ?m_hid ?id )
?f181<-(e_mrs_id-SF-Tns-Mood-prog-perf   ?mid ?sf ?Tns ?m ?prog ?perf )
(test (or (eq (sub-string (- (length ?name) 4) (- (length ?name ) 2) ?name) "_a_")
          (eq (sub-string (- (length ?name) 4) (- (length ?name ) 2) ?name) "_p_"))
)
=>
        (retract ?f181)
        (assert (e_mrs_id-SF-Tns-STAT   ?mid ?sf ?Tns +))
)


(defrule stat2
?f212<-(ltop-index ?h ?mid)
?f21<-(name-mrs_id-mrs_hndl-id  _be_v_id ?mid ?m_hid ?id )
?f211<-(e_mrs_id-SF-Tns-Mood-prog-perf   ?mid ?sf ?Tns ?m ?prog ?perf )


=>
        (retract ?f211)
        (assert (e_mrs_id-SF-Tns-STAT   ?mid ?sf ?Tns +))
)


  
(facts)
(agenda)
(watch rules)
(watch facts)
(run)
(save-facts "ger_mrs.dat" visible)
(exit)


	 
