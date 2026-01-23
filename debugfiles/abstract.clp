(load "global_path.clp")
(bind ?*path* (str-cat ?*path* "/src/clp_files/hin_concept-MRS_abstract_predicate.clp"))
(load ?*path*)
(load-facts "USR-CLIPS-facts.dat")
(load-facts "hin_concept-MRS_surface_predicate.dat")
(open "hin_concept-MRS_abstract_predicate.dat" mrs-def-fp "w")
(open "hin_concept-MRS_abstract_predicate_debug.dat" mrs-def-dbug "w")
(watch facts)
(watch rules)
(agenda)


