# To install: pip install pydelphin
# To run:  python3 lc-debugger-new.py ../tmp_dir/2/2_mrs "The teacher has just come."

import sys
import subprocess
from pathlib import Path
from collections import defaultdict, Counter
from delphin.codecs.simplemrs import decode

# We fetch the path of home directory, and access all files with a relative address
# This eliminates the need to write any person's name in paths, and so code can work
# on any machine without changes
HOME = str(Path.home())
# Command to run ace parser
ACE_COMMAND = [
    HOME + "/ace-0.9.34/ace", # Location of ace executable
    "-g", # Flag for grammar
    HOME + "/ace-0.9.34/erg-1214-x86-64-0.9.34.dat", # Location of grammar
    "-fTq",
    # q --> do not print input sentence,
    # T --> Only output MRS and not Trees,
    ".ace_input", # Temporary File
]


class bcolors:
    """Utility Class to contain color codes for printing in terminal"""
    HEADER = "\033[95m"
    OKBLUE = "\033[94m"
    OKCYAN = "\033[96m"
    OKGREEN = "\033[92m"
    WARNING = "\033[93m"
    FAIL = "\033[91m"
    ENDC = "\033[0m"
    BOLD = "\033[1m"
    UNDERLINE = "\033[4m"


def warn_print(s):
    """Utility Function to print a string in Yellow Color"""
    print(f"{bcolors.WARNING + bcolors.BOLD}{s}{bcolors.ENDC}")


def fail_print(s):
    """Utility Function to print a string in Red Color"""
    print(f"{bcolors.FAIL + bcolors.BOLD}{s}{bcolors.ENDC}")


def safe_print(s):
    """Utility Function to print a string in Green Color"""
    print(f"{bcolors.OKGREEN + bcolors.BOLD}{s}{bcolors.ENDC}")


def cyan_print(s):
    """Utility Function to print a string in Cyan/Blue Color"""
    print(f"{bcolors.OKCYAN + bcolors.BOLD}{s}{bcolors.ENDC}")


def star_line(s=""):
    """Utility Function to print a line of separators in Cyan/Blue Color"""
    if len(s) != 0:
        s = " " + s + " "
    ct = 40 - (len(s) // 2)
    s = "*" * ct + s + "*" * ct
    cyan_print(s)


def parse_simplemrs(data):
    """Utility function to parse MRS and return a Python Object with all semantic data"""
    try:
        obj = decode(data)
    except:
        fail_print("Invalid MRS Object")
        print(data)
        exit()
    return obj


def make_var_arg_dict(obj):
    """MRS has temporary variable names like h3, x2, h5, i21 etc. This function collects
    all associated data with a temporary name in one place, and returns it as a sorted list.
    The list contains elements of the form, (predicate, argument number).

    Example:
    For this MRS,

    [ LTOP: h0
    INDEX: e9
    RELS: <
    [ _sit_v_1 LBL: h8 ARG0: e9 [ e SF: prop TENSE: pres MOOD: indicative PROG: + PERF: - ] ARG1: x2 ]
    [ named LBL: h1 ARG0: x2 CARG: "Rama" ]
    [ proper_q LBL: h4 ARG0: x2 RSTR: h6 BODY: h7 ] >
    HCONS: < h0 qeq h8 h6 qeq h1 > ]

    For x2, we would get this.

    'x2': [('_sit_v_1', 'ARG1'), ('named', 'ARG0'), ('proper_q', 'ARG0')]

    This is useful when we need to compare two objects without giving significance to temporary names.

    Args:
        obj: Parsed MRS Object
    """
    args = defaultdict(list)
    args[obj.top].append("LTOP")
    for p in obj.predications: # We iterate over all predications in the object, like "_sit_v_1"
        for key, value in p.args.items(): # For each predicate, we iterate over its arguments, like ('ARG1', 'x2')
            args[value].append((p.predicate, key)) # We accumulate it in a dictionary using temporary name as key
        args[p.label].append((p.predicate, "LBL")) # We add the label of p as 'LBL'
    for key in args:
        args[key].sort() # Sort it so we have a unique order
    return args


def get_predicates(exp, recv):
    """Function to return expected predicates, received predicates, and all unique predicates

    Args:
        exp: MRS Object of ACE Parser Output
        recv: MRS Object of lc.sh output

    Returns:
        Predicates in ACE Parser Output, Predicates in lc.sh Output, All Unique Predicates in both
    """
    exp_pred = [i.predicate for i in exp.rels] # Expected Predicates
    recv_pred = [i.predicate for i in recv.rels] # Received Predicates
    all_pred = list(set(exp_pred + recv_pred)) # Combine them and select unique
    return exp_pred, recv_pred, all_pred


def compare_rels(exp, recv):
    star_line("Predicates Comparison")
    exp_pred, recv_pred, all_pred = get_predicates(exp, recv) # Get predicates in objects, and a unique predicate list
    exp_dict, recv_dict = Counter(exp_pred), Counter(recv_pred)
    for p in all_pred:
        if p in exp_dict and p in recv_dict: # If predicate present in ACE and lc.sh both
            expected_count = exp_dict[p]
            received_count = recv_dict[p]
            if expected_count == received_count:
                safe_print(p + f": Correct Count: {expected_count}")
            else:
                fail_print(p + f": Incorrect Expected: {expected_count}" + f" Received: {received_count}")
        elif p in exp_dict and p not in recv_dict: # If predicate present in ACE but missing in lc.sh
            fail_print(p + ": Missing")
        elif p not in exp_dict and p in recv_dict: # If predicate present in lc.sh but not in ACE, it was not expected
            warn_print(p + ": Not expected")
        else:
            print(p + ": Missing from both :(")
    star_line()


def get_properties_for_predicate(predicate, object):
    """Function to return properties of a given predicate in a given object"""
    for id in object._pidx:
        if object[id].predicate == predicate:
            return object.properties(id)
    return {} # Return empty dictionary incase of no properties

def compare_properties_for_predicate(predicate, exp, recv):
    """Get properties of both objects for the same predicate, and then check whether a given property
    exists in both and is same or not.
    """
    # Get property data for predicate
    exp_properties = get_properties_for_predicate(predicate, exp)
    recv_properties = get_properties_for_predicate(predicate, recv)
    all_properties = set(list(exp_properties.keys()) + list(recv_properties.keys()))
    # Loop over all properties
    for property in all_properties:
        # if property in both ace and lc.sh
        if property in exp_properties and property in recv_properties:
            exp_value = exp_properties[property]
            recv_value = recv_properties[property]
            # if value also matches for that property
            if exp_value != recv_value:
                fail_print(property + ": Received: " + recv_value + "Expected: " + exp_value)
            else:
                safe_print(property + ": OK " + exp_value)
        # if property not expected
        elif property not in exp_properties:
            warn_print(property + ": Property Not Expected: Value: " + recv_properties[property])
        # if property missing
        elif property not in recv_properties:
            fail_print(property + ": Property Missing Expected: " + exp_properties[property])

def compare_properties(exp, recv):
    star_line("Properties Comparison")
    """We first find predicates that exist in both ACE and lc.sh, and compare properties for common ones"""
    exp_pred, recv_pred, all_pred = get_predicates(exp, recv) # Get predicates in objects, and a unique predicate list
    for p in all_pred:
        if p in exp_pred and p in recv_pred: # If predicate present in ACE and lc.sh both
            print("Comparing properties for " + p)
            compare_properties_for_predicate(p, exp, recv)
        elif p in exp_pred and p not in recv_pred: # If predicate present in ACE but missing in lc.sh
            fail_print(p + ": Missing")
        elif p not in exp_pred and p in recv_pred: # If predicate present in lc.sh but not in ACE, it was not expected
            warn_print(p + ": Not expected")
        else:
            print(p + ": Missing from both :(")
    star_line()



def compare_valuetype_for_predicate(pred, exp, recv):
    print("Comparing Valuetypes for " + pred)
    exp_args, recv_args = None, None
    """
    For this MRS:
    [ LTOP: h0
    INDEX: e2 [ e SF: prop TENSE: pres MOOD: indicative PROG: + PERF: - ]
    RELS: < [ udef_q<0:3> LBL: h4 ARG0: x3 [ x PERS: 3 NUM: sg ] RSTR: h5 BODY: h6 ]
    [ _ram_n_1<0:3> LBL: h7 ARG0: x3 ]
    [ _sit_v_1<7:15> LBL: h1 ARG0: e2 ARG1: x3 ] >
    HCONS: < h0 qeq h1 h5 qeq h7 > ]

    We would get the following argument list.
    _sit_v_1 - {'ARG0': 'e2', 'ARG1': 'x3'}
    Now we compare the argument list such that ARG0 in both ACE and lc.sh begin with same character, say e
    """


    # First we loop over predications of ACE object, and if the predicate matches, store its args in a temporary object
    for element in exp.predications:
        if element.predicate == pred:
            exp_args = element.args
            break
    # Do the same for lc.sh object
    for element in recv.predications:
        if element.predicate == pred:
            recv_args = element.args
            break

    # Now create a combined list of args, such that arg is in atleast lc.sh or ACE or both
    common_args = list(set(list(exp_args.keys()) + list(recv_args.keys())))
    # Now we check if argument is present in both ACE and lc.sh or missing in one of them
    # and print accordingly
    for arg in common_args:
        if arg not in exp_args:
            warn_print(arg + ": Unexpected argument") # Missing in lc.sh
        elif arg not in recv_args:
            fail_print(arg + ": Missing argument") # Missing in ACE
        elif exp_args[arg][0] != recv_args[arg][0]: # Comparing first character, present in both but incorrect type, like 'x' instead of 'i'
            fail_print(
                arg
                + ": Wrong ValueType Expected: "
                + exp_args[arg][0]
                + " Received: "
                + recv_args[arg][0]
            )
        else:
            safe_print(arg + " Correct ValueType " + exp_args[arg][0])

def substitute_temp_names_in_bindings(obj):
    """
    For this MRS
    [ LTOP: h0
    INDEX: e2 [ e SF: prop TENSE: pres MOOD: indicative PROG: + PERF: - ]
    RELS: < [ udef_q<0:3> LBL: h4 ARG0: x3 [ x PERS: 3 NUM: sg ] RSTR: h5 BODY: h6 ]
    [ _ram_n_1<0:3> LBL: h7 ARG0: x3 ]
    [ _sit_v_1<7:15> LBL: h1 ARG0: e2 ARG1: x3 ] >
    HCONS: < h0 qeq h1 h5 qeq h7 > ]

    We extract HCONS pairs, like this (h0, h1), (h5, h7)
    Now since h0, h1, h5, h7, are temporary names, and they might differ in ACE and lc.sh
    we replace them with their argument dictionary using `make_var_arg_dict` function, and
    return the bindings with an argument list representing the temporary.
    """
    hcons = obj.hcons
    args = make_var_arg_dict(obj)
    processed_bindings = set()
    for binding in hcons:
        # For a binding (h0 qeq h1)
        # binding.hi == h0
        # binding.lo == h1

        # Replace binding.hi and binding.lo with args
        left = tuple(args[binding.hi])
        right = tuple(args[binding.lo])
        processed_bindings.add((left, right))
    return processed_bindings

def compare_qeq(exp, recv):
    """Function to compare HCONS of MRS"""
    star_line("QEQ Bindings Comparison")
    """
    We get processed hcons qeq bindings for both ACE and lc.sh objects, and check if
    they match, and if they dont, we report differences.
    """
    exp_set = substitute_temp_names_in_bindings(exp)
    recv_set = substitute_temp_names_in_bindings(recv)
    for it in recv_set.union(exp_set):
        if it in recv_set and it in exp_set:
            safe_print(str(it) + ": Correct")
        elif it not in exp_set:
            warn_print(str(it) + ": Not expected")
        elif it not in recv_set:
            fail_print(str(it) + ": Missing")
    star_line()


def compare_arguments(exp, recv):
    star_line("Argument Sharing Comparison")
    recv_args = make_var_arg_dict(recv) # Process lc.sh MRS Object
    exp_args = make_var_arg_dict(exp) # Process ACE MRS Object

    # We discard the temporary variables and only consider argument pairs
    # If we had
    # 'x2': [('_sit_v_1', 'ARG1'), ('named', 'ARG0'), ('proper_q', 'ARG0')]
    # We discard x2, and only consider values and store them in a set
    # So we have
    # (('_sit_v_1', 'ARG1'), ('named', 'ARG0'), ('proper_q', 'ARG0'))
    # Now we check if these same predicates, with same argument numbers occur in the other MRS as well.

    recv_set = {tuple(i) for i in recv_args.values()} # Discard temp names for lc.sh
    exp_set = {tuple(i) for i in exp_args.values()} # Discard temp names for ACE
    all_set = recv_set.union(exp_set) # Combine both while keeping unique, and
    # check if predicate argument pair list is present in both ACE and lc.sh
    for pred_arg_pair in all_set:
        if pred_arg_pair in recv_set and pred_arg_pair in exp_set:
            safe_print(str(pred_arg_pair) + ": Correct")
        elif pred_arg_pair not in exp_set:
            warn_print(str(pred_arg_pair) + ": Not expected")
        elif pred_arg_pair not in recv_set:
            fail_print(str(pred_arg_pair) + ": Missing")
    star_line()


def compare_valuetypes(exp, recv):
    star_line("ValueType Comparison")
    # We get Predicates in ACE, Predicates in lc.sh, and all predicates, i.e either in ACE or lc.sh or both
    exp_pred, recv_pred, all_pred = get_predicates(exp, recv)
    for p in all_pred:
        if p in exp_pred and p in recv_pred:
            # If the predicate exists in both ACE and lc.sh, we compare valuetypes for the predicate
            compare_valuetype_for_predicate(p, exp, recv)
        elif p in exp_pred and p not in recv_pred:
            fail_print(p + ": Predicate Missing")
        elif p not in exp_pred and p in recv_pred:
            warn_print(p + ": Predicate Unexpected")
        else:
            print(p + ": Missing from both :(")

# Main function which calls all functions
def compare_output(exp_output, recv_output):
    exp_object = parse_simplemrs(exp_output)
    recv_object = parse_simplemrs(recv_output)
    compare_rels(exp_object, recv_object)
    compare_arguments(exp_object, recv_object)
    compare_valuetypes(exp_object, recv_object)
    compare_properties(exp_object, recv_object)
    compare_qeq(exp_object, recv_object)
    return
def split_to_different_mrs(s):
    """We take as input a string containing multiple MRS, and split it into different MRS"""
    st = []
    op = [[]]
    for i in s:
        if i in '[{<(':
            st.append(i)
            op[-1].append(i)
        elif i in ']}>)':
            st.pop()
            op[-1].append(i)
        else:
            op[-1].append(i)
        if len(st) == 0 and len(op[-1]) != 0:
            op.append([])
    for idx in range(len(op)):
        op[idx] = ''.join(op[idx]).rstrip()
    op = [x for x in op if len(x) != 0]
    return op

if __name__ == "__main__":
    # We read the lc.sh MRS Path, and an english sentence
    # If any of them is missing or incorrect, we exit
    try:
        # Checking both arguments are present
        lc_mrs_file_path = sys.argv[1]
        english_sentence = sys.argv[2]
        # Checking LC MRS Path is valid and openable
        try:
            with open(lc_mrs_file_path, "r") as f:
                lc_mrs = f.read()
        except:
            fail_print("(lc mrs output path) is Not Valid.")
            exit()
    except:
        fail_print('Command is not Valid => eg (python3 mrs-binding.py "lc mrs output path" "English Sentence")')
        exit()

    # We try to create a temporary file and write our sentence to it
    # This file is then sent to the ace parser
    # If this file cannot be created, then we cannot continue, and we exit
    if lc_mrs.lower().find('ltop') == -1:
        fail_print("lc.sh output does not have a LTOP.")
        exit()
    try:
        with open(".ace_input", "w") as f:
            f.write(english_sentence)
    except:
        fail_print("Unable to write temporary file .ace_input")
        exit()

    try:
        result = subprocess.run(ACE_COMMAND, stdout=subprocess.PIPE, stderr=subprocess.PIPE)
        ace_output = str(result.stdout, "utf-8")
    except:
        fail_print("Failed to run ace.")
        exit()
    if ace_output == "":
        fail_print("Failed to run ace.")
        exit()

    ace_mrs_list = split_to_different_mrs(ace_output)
    if len(ace_mrs_list) > 1:
        print(f"ACE generated {len(ace_mrs_list)} MRS. Which MRS to use [1-{len(ace_mrs_list)}]?")
        try:
            ct = int(input())
        except:
            print("Invalid Input")
            exit()
        if 1 <= ct <= len(ace_mrs_list):
            ace_mrs = ace_mrs_list[ct - 1]
        else:
            print(f"{ct} is not between [1-{len(ace_mrs_list)}].")
            exit()
    else:
        print("Only one mrs generated by ace. Using that.")
        ace_mrs = ace_mrs_list[0]

    star_line("ACE MRS Output")
    print(ace_mrs)
    star_line("End")
    star_line("lc.sh MRS Output")
    print(lc_mrs)
    star_line("End")
    compare_output(ace_mrs, lc_mrs)
