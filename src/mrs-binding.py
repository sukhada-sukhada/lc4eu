# Writen by Sukhada (22.05.19)
# This program prints the MRS feature values along with their features and MRS concepts/relations
# which have bindings with more than one MRS relations/concepts.
# It would be helpful to the developers who want to check the feature value bindings
# for writing CLIPS rules.

# To run:
# python mrs-bindings.py <mrs_output>
# Ex.     python mrs-bindings.py mrs_output.txt

# INPUT MRS:
# [ LTOP: h0
# INDEX: e29 [ e SF: ques TENSE: pres MOOD: indicative PROG: + PERF: - ]
# RELS: < [ time_n LBL: h20 ARG0: x21 ]
# [ _city_n_1 LBL: h26 ARG0: x27 [ x NUM: sg PERS: 3 ] ]
# [ _go_v_1 LBL: h28 ARG0: e29 ARG1: x10 ]
# [ loc_nonsp LBL: h28 ARG0: e17 ARG1: e29 ARG2: x21 ]
# [ _to_p LBL: h28 ARG0: e2 ARG1: e29 ARG2: x27 ]
# [ named LBL: h9 ARG0: x10 [ x NUM: sg PERS: 3 ] CARG: "rAma" ]
# [ proper_q LBL: h12 ARG0: x10 RSTR: h14 BODY: h15 ]
# [ which_q LBL: h22 ARG0: x21 RSTR: h24 BODY: h25 ]
# [ _the_q LBL: h5 ARG0: x27 RSTR: h7 BODY: h8 ] >
# HCONS: < h0 qeq h28 h14 qeq h9 h24 qeq h20 h7 qeq h26 > ]
# 
# OUTPUT:
# e29 ((([('INDEX:', 'INDEX:')], '_go_v_1', 'ARG0:'), 'loc_nonsp', 'ARG1:'), '_to_p', 'ARG1:')
# h28 (([('_go_v_1', 'LBL:')], 'loc_nonsp', 'LBL:'), '_to_p', 'LBL:')
# 3 ([('_city_n_1', 'PERS:')], 'named', 'PERS:')
# x27 (([('_city_n_1', 'ARG0:')], '_to_p', 'ARG2:'), '_the_q', 'ARG0:')
# x21 (([('time_n', 'ARG0:')], 'loc_nonsp', 'ARG2:'), 'which_q', 'ARG0:')
# x10 (([('_go_v_1', 'ARG1:')], 'named', 'ARG0:'), 'proper_q', 'ARG0:')
# sg ([('_city_n_1', 'NUM:')], 'named', 'NUM:')

import sys

f = open(sys.argv[1], 'r')
fr = f.readlines()

bindings = {}
for i in range(len(fr)):
    if fr[i].strip().startswith('RELS:'):
        fr[i] = fr[i][7:]
    featVals = fr[i].strip().split()
    for j in range(len(featVals)):
        if featVals[j].endswith(':'):
            if featVals[j+1] not in list(bindings.keys()):
                if fr[i].strip().startswith('['):
                    bindings[featVals[j+1]] = [(featVals[1], featVals[j])]
                else:
                    bindings[featVals[j+1]] = [(featVals[0], featVals[j])]
            else:
                vals = (bindings[featVals[j+1]]) 
                bindings[featVals[j+1]] = (vals, featVals[1], featVals[j])

for k in list(bindings.keys()):
    if len(bindings[k]) > 1:
        print((k, bindings[k]))



