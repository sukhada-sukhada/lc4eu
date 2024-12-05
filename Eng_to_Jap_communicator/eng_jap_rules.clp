(load-facts "mrs_facts.dat")


(defrule proper_q
?f0<-(name-mrs_id-mrs_hndl-id ?name ?mrs_id ?hndl ?id) 
(test (eq ?name proper_q))
=>
	(retract ?f0)
        (assert (name-mrs_id-mrs_hndl-id def_q_rel ?mrs_id ?hndl ?id) )
)

(defrule which_q
?f0<-(name-mrs_id-mrs_hndl-id ?name ?mrs_id ?hndl ?id) 
(test (eq ?name which_q))
=>
	(retract ?f0)
        (assert (name-mrs_id-mrs_hndl-id which_q_rel ?mrs_id ?hndl ?id) )
)

(defrule place
?f0<-(name-mrs_id-mrs_hndl-id ?name ?mrs_id ?hndl ?id) 
(test (eq ?name place_n))
=>
	(retract ?f0)
        (assert (name-mrs_id-mrs_hndl-id place_n_rel ?mrs_id ?hndl ?id) )
)

(defrule pronoun_q
?f0<-(name-mrs_id-mrs_hndl-id ?name ?mrs_id ?hndl ?id) 
(test (eq ?name pronoun_q))
=>
	(retract ?f0)
        (assert (name-mrs_id-mrs_hndl-id def_q_rel ?mrs_id ?hndl ?id) )
)

(defrule pron
?f0<-(name-mrs_id-mrs_hndl-id ?name ?mrs_id ?hndl ?id) 
(test (eq ?name pron))
=>
	(retract ?f0)
        (assert (name-mrs_id-mrs_hndl-id pron_rel ?mrs_id ?hndl ?id) )
)

(defrule named
?f1<-(named-mrs_id-mrs_hndl-CARG ?named ?mrs_id ?hndl ?CARG)
(test (eq ?named named))
=>
       (retract ?f1)
       (assert (named-mrs_id-mrs_hndl-id named_rel ?mrs_id ?hndl ?CARG) )
)

(defrule _the_q
?f7<-(name-mrs_id-mrs_hndl-id ?name ?mrs_id ?hndl ?id)
(test (eq ?name _the_q))
=>
       (retract ?f7)
       (assert (name-mrs_id-mrs_hndl-id udef_q_rel ?mrs_id ?hndl ?id) )
)

(defrule _a_q
?f7<-(name-mrs_id-mrs_hndl-id ?name ?mrs_id ?hndl ?id)
(test (eq ?name _a_q))
=>
       (retract ?f7)
       (assert (name-mrs_id-mrs_hndl-id udef_q_rel ?mrs_id ?hndl ?id) )
)

(defrule mod_tense
(declare (salience 100))
?f14<-(name-mrs_id-mrs_hndl-id  ?name ?mid ?m_hid ?id )
?f13<-(e_mrs_id-SF-Tns-Mood-prog-perf ?mid ?sf untensed $?p1)
(test (neq (str-index "_a" ?name) FALSE))
=>
        (retract ?f13)
        (assert (e_mrs_id-SF-Tns-Mood-prog-perf ?mid ?sf pres $?p1))
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

(defrule rm_Num_without_IND
?f18<-(x_mrs_id-pers-Num-Ind  ?id ?pers ?n )
=>
      (retract ?f18)
      (assert (x_mrs_id-pers-Num-Ind  ?id ?pers))
)


(defrule rm_Num_IND
?f18<-(x_mrs_id-pers-Num-Ind  ?id ?pers ?n ?ind)
=>
      (retract ?f18)
      (assert (x_mrs_id-pers-Num-Ind  ?id ?pers))
)
(defrule carg
(declare (salience 100))
?f19<-(named-mrs_id-mrs_hndl-CARG ?named ?mid ?m_hid ?CARG)
?f191<-(x_mrs_id-pers-Num-Ind ?mid ?pers ?Num ?Ind)
=>
       (retract ?f191)
       (assert (x_mrs_id-pers-Num-Ind ?mid ))
)

 
(facts)
(agenda)
(watch rules)
(watch facts)
(run)
(save-facts "jap_mrs.dat" visible)
(exit)


	 
