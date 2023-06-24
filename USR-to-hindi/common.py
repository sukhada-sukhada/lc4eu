import os
import sys
import re
import subprocess
import constant
from wxconv import WXC

from verb import Verb
from concept import Concept

noun_attribute = dict()
USR_row_info = ['root_words', 'index_data', 'seman_data', 'gnp_data', 'depend_data', 'discourse_data', 'spkview_data', 'scope_data']
nA_list = ['nA_paDa', 'nA_padZA', 'nA_padA', 'nA_hE', 'nA_WA', 'nA_hogA', 'nA_cAhie', 'nA_cAhiye']
spkview_list = ['hI', 'BI', 'jI', 'wo', 'waka', 'lagaBaga', 'lagAwAra', 'kevala']
kisase_k2g_verbs = ['bola', 'pUCa', 'kaha', 'nikAla', 'mAzga']
kisase_k2_verbs = ['mila', 'pyAra']
kisase_k5_verbs = ['dara', 'baca', 'rakSA']
kahAz_k5_verbs = ['A', 'uga', 'gira']
processed_postpositions_dict = {}
construction_dict = {}
spkview_dict = {}
GNP_dict = {}
additional_words_dict = {}
discourse_dict = {'vyabhicara': 'paranwu', 'samuccaya': 'Ora', 'karya-karana': 'isase', 'viroXI': 'lekina'}

def populate_GNP_dict(gnp_info, PPfull_data):
    populate_GNP_dict = False
    morpho_seman = ['comper_more', 'comper-more', 'comper_less', 'comper-less', 'superl', 'mawupa', 'mawup']
    a = 'after'
    b = 'before'
    for i in range(len(gnp_info)):
        input_string = gnp_info[i]
        matches = re.findall(r'\[(.*?)\]', input_string)
        strings = [s.strip() for s in matches]

        for term in strings:
            if term in morpho_seman:
                populate_GNP_dict = True
                if term == 'superl':
                    temp = (b, 'sabase')

                elif term in ('comper_more', 'comper-more'):
                    temp = (b, 'aXika')

                elif term in ('comper_less', 'comper-less'):
                    temp = (b, 'kama')

                else:
                    # fetch GNP of next noun
                    curr_index = i + 1
                    noun_data = nextNounData_fromFullData(curr_index + 1, PPfull_data)
                    if noun_data != ():
                        g = noun_data[4]
                        n = noun_data[5]
                        p = noun_data[6]
                        if g == 'f':
                            temp = (a, 'vAlI')
                        elif n == 'p':
                            temp = (a, 'vAle')
                        elif n == 's':
                            temp = (a, 'vAlA')
                if i + 1 in GNP_dict:
                    GNP_dict[i + 1].append(temp)
                else:
                    GNP_dict[i + 1] = [temp]


    # for i in range(len(gnp_info)):
    #     term = gnp_info[i].strip().strip('][')
    #     if term == 'superl':
    #         GNP_dict[i+1] = 'sabase'
    #         populate_GNP_dict = True
    #     elif term == 'comper_more':
    #         GNP_dict[i+1] = 'jyAxA'
    #         populate_GNP_dict = True
    #     elif term == 'comper_less':
    #         GNP_dict[i+1] = 'kama'
    #         populate_GNP_dict = True
    return populate_GNP_dict


def populate_spkview_dict(spkview_info):
    populate_spk_dict = False
    a = 'after'
    b = 'before'
    for i in range(len(spkview_info)):
        if spkview_info[i] in spkview_list:
            populate_spk_dict = True
            temp = (a, spkview_info[i])
            spkview_dict[i + 1] = [temp]
        elif spkview_info[i] == 'result':
            populate_spk_dict = True
            temp = (b, 'pariNAmasvarUpa,')
            spkview_dict[i + 1] = [temp]

    return populate_spk_dict


def add_discourse_elements(discourse_data, POST_PROCESS_OUTPUT):
    # discourse element value added to sentence as per the element
    #
    found = False
    if len(discourse_data) <= 0:
        return POST_PROCESS_OUTPUT
    else:
        word = ''
        for data_values in discourse_data:
            for element in discourse_dict:
                if element in data_values:
                    word = discourse_dict[element]
                    found = True
        if found:
            POST_PROCESS_OUTPUT = word + " " +POST_PROCESS_OUTPUT

    return POST_PROCESS_OUTPUT


def add_adj_to_noun_attribute(key, value):
    if key is not None:
        if key in noun_attribute:
            noun_attribute[key][0].append(value)
        else:
            noun_attribute[key] = [[],[]]

def add_verb_to_noun_attribute(key, value):
    if key is not None:
        if key in noun_attribute:
            noun_attribute[key][1].append(value)
        else:
            noun_attribute[key] = [[], []]

def get_all_form(morph_forms):
    """
    >>> get_first_form("^mAz/mA<cat:n><case:d><gen:f><num:p>/mAz<cat:n><case:d><gen:f><num:s>/mAz<cat:n><case:o><gen:f><num:s>$")
    'mA<cat:n><case:d><gen:f><num:p>/mAz<cat:n><case:d><gen:f><num:s>/mAz<cat:n><case:o><gen:f><num:s>'
    """
    return morph_forms.split("$")[1]



def get_first_form(morph_forms):
    """
    >>> get_first_form("^mAz/mA<cat:n><case:d><gen:f><num:p>/mAz<cat:n><case:d><gen:f><num:s>/mAz<cat:n><case:o><gen:f><num:s>$")
    'mA<cat:n><case:d><gen:f><num:p>'
    """
    return morph_forms.split("/")[1]

def parse_morph_tags(morph_form):
    """
    >>> parse_morph_tags("mA<cat:n><case:d><gen:f><num:p>")
    {'cat': 'n', 'case': 'd', 'gen': 'f', 'num': 'p', 'form': 'mA'}
    """
    form = morph_form.split("<")[0]
    matches = re.findall("<(.*?):(.*?)>", morph_form)
    result = {match[0]: match[1] for match in matches}
    result["form"] = form
    return result

def parse_morph_tags_as_list(morph_form):
    """
    >>> parse_morph_tags("mA<cat:n><case:d><gen:f><num:p>")
    {'cat': 'n', 'case': 'd', 'gen': 'f', 'num': 'p', 'form': 'mA'}
    """
    form = morph_form.split("<")[0]
    matches = re.findall("<(.*?):(.*?)>", morph_form)
    result = [(match[0], match[1]) for match in matches]
    result.append(('form',form))
    return result

# function to run morph analyzer and get gnp
def find_tags_from_dix(word):
    """
    >>> find_tags_from_dix("mAz")
    {'cat': 'n', 'case': 'd', 'gen': 'f', 'num': 'p', 'form': 'mA'}
    """
    dix_command = "echo {} | apertium-destxt | lt-proc -ac hi.morfLC.bin | apertium-retxt".format(word)
    morph_forms = os.popen(dix_command).read()
    return parse_morph_tags(morph_forms)

def find_tags_from_dix_as_list(word):
    """
    >>> find_tags_from_dix("mAz")
    {'cat': 'n', 'case': 'd', 'gen': 'f', 'num': 'p', 'form': 'mA'}
    """
    dix_command = "echo {} | apertium-destxt | lt-proc -ac hi.morfLC.bin | apertium-retxt".format(word)
    morph_forms = os.popen(dix_command).read()
    return parse_morph_tags_as_list(morph_forms)
def log(mssg, logtype='OK'):
    '''Generates log message in predefined format.'''

    # Format for log message
    print(f'[{logtype}] : {mssg}')
    if logtype == 'ERROR':
        path = sys.argv[1]
        write_hindi_test(' ', 'Error', mssg, 'test.csv', path)

def clean(word, inplace=''):
    """
    Clean concept words by removing numbers and special characters from it using regex.
    >>> clean("kara_1-yA_1")
    'karayA'
    >>> clean("kara_1")
    'kara'
    >>> clean("padZa_1")
    'pada'
    >>> clean("caDZa_1")
    'caDa'

    """
    newWord = word
    if 'dZ' in word:  # handling words with dZ/jZ -Kirti - 15/12
        newWord = word.replace('dZ', 'd')
    elif 'jZ' in word:
        newWord = word.replace('jZ', 'j')
    elif 'DZ' in word:
        newWord = word.replace('DZ', 'D')

    clword = re.sub(r'[^a-zA-Z]+', inplace, newWord)
    return clword

def is_tam_ya(verbs_data):
    ya_tam = '-yA_'
    if verbs_data != ():
        term = verbs_data[1]
        if ya_tam in term:
            return True
    return False

def has_tam_ya():
    '''Check if USR has verb with TAM "yA".
        It sets the global variable HAS_TAM to true
    '''
    global HAS_TAM
    if HAS_TAM == True:
        return True
    else:
        return False

def getDataByIndex(value: int, searchList: list, index=0):
    '''search and return data by index in an array of tuples.
        Index should be first element of tuples.
        Return False when index not found.'''
    try:
        res = False
        for dataele in searchList:
            if (dataele[(index)]) == value:
                res = dataele
    except IndexError:
        log(f'Index out of range while searching index:{value} in {searchList}', 'WARNING')
        return False
    return res

def findExactMatch(value: int, searchList: list, index=0):
    '''search and return data by index in an array of tuples.
        Index should be first element of tuples.

        Return False when index not found.'''

    try:
        for dataele in searchList:
            if value == dataele[index].strip().split(':')[1]:
                return (True, dataele)
    except IndexError:
        log(f'Index out of range while searching index:{value} in {searchList}', 'WARNING')
        return (False, None)
    return (False, None)

def findValue(value: int, searchList: list, index=0):
    '''search and return data by index in an array of tuples.
        Index should be first element of tuples.

        Return False when index not found.'''

    try:
        for dataele in searchList:
            if value == dataele[index]:
                return (True, dataele)
    except IndexError:
        log(f'Index out of range while searching index:{value} in {searchList}', 'WARNING')
        return (False, None)
    return (False, None)

def getVerbGNP_old(tam, depend_data, processed_nouns, processed_pronouns):
    ''' Return GNP information of processed_noun/processed_pronoun which
    has k1 in dependency row. But if verb has tam = yA , then GNP information
    is given of that processed_noun/processed_pronoun which has k2 in dependency row.
    '''
    k1exists = False
    k2exists = False
    for cases in depend_data:
        if cases == '':
            continue
        k1exists = (depend_data.index(cases) + 1) if 'k1' == cases[-2:] else k1exists
        k2exists = (depend_data.index(cases) + 1) if 'k2' == cases[-2:] else k2exists

    if k1exists == False:
        return 'm', 's', 'a'

    searchIndex = k1exists
    searchList = processed_nouns + processed_pronouns
    if tam == 'yA':
        searchIndex = k2exists if k2exists != False else k1exists

    casedata = getDataByIndex(searchIndex, searchList)

    if (casedata == False):
        log('Something went wrong. Cannot determine GNP for verb.', 'ERROR')
        sys.exit()
    return casedata[4], casedata[5], casedata[6][0]  # only first character of the person - to handle m_hx kind of case

def getComplexPredicateGNP(term):
    CP_term = clean(term.split('+')[0])
    gender = 'm'
    number = 's'
    person = 'a'

    tags = find_tags_from_dix(CP_term)  # getting tags from morph analyzer to assign gender and number for agreement
    if '*' not in tags['form']:
        gender = tags['gen']
        number = tags['num']
    return gender, number, person

def getGNP_using_k2(k2exists, searchList):
    casedata = getDataByIndex(k2exists, searchList)
    if (casedata == False):
        log('Something went wrong. Cannot determine GNP for verb.', 'ERROR')
        sys.exit()
    verb_gender, verb_number, verb_person = casedata[4], casedata[5], casedata[6]
    return verb_gender, verb_number, verb_person[0]
        # if seman_data[k2exists] in ('anim', 'per') and k2_case == 'd' and k1_case == 'o':
        #     casedata = getDataByIndex(k1_case, searchList)
        #     if (casedata == False):
        #         log('Something went wrong. Cannot determine GNP for verb.', 'ERROR')
        #         sys.exit()
        #     verb_gender, verb_number, verb_person = casedata[4], casedata[5], casedata[6]
        #     # verb_gender = 'm'
        #     # verb_number = 's'
        #     # verb_person = 'a'
        #     return verb_gender, verb_number, verb_person[0]

def getGNP_using_k1(k1exists, searchList):
    casedata = getDataByIndex(k1exists, searchList)
    if (casedata == False):
        log('Something went wrong. Cannot determine GNP for verb k1 is missing.', 'ERROR')
        sys.exit()
    verb_gender, verb_number, verb_person = casedata[4], casedata[5], casedata[6]
    return verb_gender, verb_number, verb_person

def getVerbGNP_new(concept_term, full_tam, is_cp, seman_data, depend_data, sentence_type, processed_nouns, processed_pronouns):
    '''
    '''
    #for imperative sentences
    if sentence_type in ('Imperative','imperative') or 'o' in full_tam:
        verb_gender = 'm'
        verb_number = 's'
        verb_person = 'm'
        return verb_gender, verb_number, verb_person

    #for non-imperative sentences
    k1exists = False
    k2exists = False
    k1_case = ''
    k2_case = ''
    verb_gender, verb_number, verb_person, case= get_default_GNP()
    searchList = processed_nouns + processed_pronouns

    for cases in depend_data:
        if cases == '':
            continue
        k1exists = (depend_data.index(cases) + 1) if 'k1' == cases[-2:] else k1exists
        k2exists = (depend_data.index(cases) + 1) if 'k2' == cases[-2:] else k2exists

    if k1exists:
        casedata = getDataByIndex(k1exists, searchList)
        if (casedata == False):
            log('Something went wrong. Cannot determine case for k1.', 'ERROR')
        else:
            k1_case = casedata[3]

    if k2exists:
        casedata = getDataByIndex(k2exists, searchList)
        if (casedata == False):
            log('Something went wrong. Cannot determine case for k2.', 'ERROR')
        else:
            k2_case = casedata[3]

    if is_cp:
        cp_term = concept_term.split('+')[0]
        if not k1exists and not k2exists:
            verb_gender, verb_number, verb_person = getComplexPredicateGNP(cp_term)
        elif k1exists and k1_case == 'd':
            verb_gender, verb_number, verb_person = getGNP_using_k1(k1exists, searchList)
        elif k1exists and k1_case == 'o' and k2exists and k2_case == 'o':
            verb_gender, verb_number, verb_person = getComplexPredicateGNP(cp_term)
        return verb_gender, verb_number, verb_person[0]

    if 'yA' in full_tam:
        if k1exists and k1_case == 'd':
            verb_gender, verb_number, verb_person = getGNP_using_k1(k1exists, searchList)
        elif k1exists and k1_case == 'o' and k2exists and k2_case == 'd':
            verb_gender, verb_number, verb_person = getGNP_using_k2(k2exists, searchList)
        return verb_gender, verb_number, verb_person[0]

    if full_tam in nA_list:
        return verb_gender, verb_number, verb_person[0]

    #tam - gA
    else:
        verb_gender, verb_number, verb_person = getGNP_using_k1(k1exists, searchList)
        return verb_gender, verb_number, verb_person[0]

def getVerbGNP(verbs_data, seman_data, depend_data, sentence_type, processed_nouns, processed_pronouns):
    '''
    '''
    if sentence_type in ('Imperative','imperative'):
        verb_gender = 'm'
        verb_number = 's'
        verb_person = 'm'
        return verb_gender, verb_number, verb_person

    #if non-imperative sentences, then do rest of the processing
    unprocessed_main_verb = verbs_data
    index = verbs_data.index
    #main_verb = identify_main_verb(unprocessed_main_verb)
    is_cp = is_CP(unprocessed_main_verb)
    tam = identify_default_tam_for_main_verb(unprocessed_main_verb)
    k1exists = False
    k2exists = False
    verb_gender, verb_number, verb_person, case = get_default_GNP()
    searchList = processed_nouns + processed_pronouns

    for cases in depend_data:
        if cases == '':
            continue
        k1exists = (depend_data.index(cases) + 1) if 'k1' == cases[-2:] else k1exists
        k2exists = (depend_data.index(cases) + 1) if 'k2' == cases[-2:] else k2exists

    if not k1exists and not k2exists:
        log('Sentence does not contain k1 and k2. Using defualt GNP m,s,a ')
        return verb_gender, verb_number, verb_person

    if tam == 'yA':
        if is_cp:
            verb_gender, verb_number, verb_person = getComplexPredicateGNP(unprocessed_main_verb)
            return verb_gender, verb_number, verb_person[0]
        else:
            if not is_cp and k2exists and seman_data[k2exists] in('anim','per'):
                casedata = getDataByIndex(k2exists, searchList)
                if (casedata == False):
                    log('Something went wrong. Cannot determine GNP for verb.', 'ERROR')
                    sys.exit()
                verb_gender, verb_number, verb_person = casedata[4], casedata[5], casedata[6]
                return verb_gender, verb_number, verb_person[0]
            if not is_cp and k2exists and seman_data[k2exists] in ('anim','per'):
                verb_gender = 'm'
                verb_number = 's'
                verb_person = 'a'
                return verb_gender, verb_number, verb_person[0]

    if tam in ('nA_paDa', 'nA_hE', 'nA_tha', 'nA_thI', 'nA_ho', 'nA_chAhie','nA_chAhiye'):
        verb_gender = 'm'
        verb_number = 's'
        verb_person = 'a'
    else:
        casedata = getDataByIndex(k1exists, searchList)
        if (casedata == False):
            log('Something went wrong. Cannot determine GNP for verb.', 'ERROR')
            sys.exit()
        verb_gender, verb_number, verb_person = casedata[4], casedata[5], casedata[6]

    return verb_gender, verb_number, verb_person[0]


def read_file(file_path):
    '''Returns array of lines for data given in file'''

    log(f'File ~ {file_path}')
    try:
        with open(file_path, 'r') as file:
            lines = file.readlines()
            file_rows = []
            for i in range(len(lines)):
                lineContent = lines[i]
                if i == 10:
                    if lineContent.strip() == '':
                        break
                    else:
                        file_rows.append(lineContent)

            log('File data read.')
    except FileNotFoundError:
        log('No such File found.', 'ERROR')
        sys.exit()
    return lines

def generate_rulesinfo(file_data):
    '''Return list all 10 rules of USR as list of lists'''

    if len(file_data) < 10:
        log('Invalid USR. USR does not contain 10 lines.', 'ERROR')
        sys.exit()

    src_sentence = file_data[0]
    root_words = file_data[1].strip().split(',')
    index_data = file_data[2].strip().split(',')
    seman_data = file_data[3].strip().split(',')
    gnp_data = file_data[4].strip().split(',')
    depend_data = file_data[5].strip().split(',')
    discourse_data = file_data[6].strip().split(',')
    spkview_data = file_data[7].strip().split(',')
    scope_data = file_data[8].strip().split(',')
    sentence_type = file_data[9].strip()
    construction_data = ''
    if len(file_data) > 10:
        construction_data = file_data[10].strip()

    log('Rules Info extracted succesfully fom USR.')
    return [src_sentence, root_words, index_data, seman_data, gnp_data, depend_data, discourse_data, spkview_data,
            scope_data, sentence_type, construction_data]

def check_USR_format(root_words, index_data, seman_data, gnp_data, depend_data, discourse_data, spkview_data,
                      scope_data):
    '''1. To check if root words and their indices are in order
       2. To ensure that all the tuples of the USR have same number of enteries'''
    data = [root_words, index_data, seman_data, gnp_data, depend_data, discourse_data, spkview_data, scope_data]
    len_root = len(root_words)
    len_index = len(index_data)

    if len_root > len_index:
        diff = len_root - len_index
        while diff:
            index_data.append(0)
            diff = diff - 1
            log(f'{USR_row_info[1]} has lesser enteries as compared to {USR_row_info[0]}')

    elif len_root < len_index:
        diff = len_index - len_root
        while diff:
            index_data.pop()
            diff = diff - 1
            log(f'{USR_row_info[1]} has more enteries as compared to {USR_row_info[0]}')

    #once the lengths of root_words and index_data are equal check value of each index
    len_root = len(root_words)
    len_index = len(index_data)
    if len_root == len_index:
        for i in range(1, len_root + 1):
            if index_data[i - 1] == i:
                continue
            else:
                index_data[i - 1] = i
                log(f'{USR_row_info[1]} has wrong entry at position {i}')

    #Checking all tuples have same number of enteries
    max_col = max(index_data)
    i = 0
    for ele in data:
        length = len(ele)
        if length < max_col:
            diff = max_col - length
            while diff:
                ele.append('')
                log(f'Added one entry at the end of {USR_row_info[i]}')
                diff = diff - 1
        elif length > max_col:
            diff = length - max_col
            while diff:
                ele.pop()
                log(f'Removed one entry from the end of {USR_row_info[i]}')
                diff = diff - 1
        i = i + 1

    #Removing spaces if any,before/ after each ele for all rows in USR
    for row in data:
        for i in range(0, len(row)):
            if type(row[i]) != int and row[i] != '':
                temp = row[i].strip()
                row[i] = temp
    print(data)
    return list(
        zip(index_data, root_words, seman_data, gnp_data, depend_data, discourse_data, spkview_data, scope_data))

def generate_wordinfo(root_words, index_data, seman_data, gnp_data, depend_data, discourse_data, spkview_data,
                      scope_data):
    '''Generates an array of tuples comntaining word and its USR info.
        USR info word wise.'''
    return check_USR_format(root_words, index_data, seman_data, gnp_data, depend_data, discourse_data, spkview_data, scope_data)

def extract_tamdict_hin():
    extract_tamdict = []
    try:
        with open(constant.TAM_DICT_FILE, 'r') as tamfile:
            for line in tamfile.readlines():
                hin_tam = line.split('  ')[1].strip()
                extract_tamdict.append(hin_tam)
        return extract_tamdict
    except FileNotFoundError:
        log('TAM Dictionary File not found.', 'ERROR')
        sys.exit()


def auxmap_hin(aux_verb):
    """
    Finds auxillary verb in auxillary mapping file. Returns its root and tam.
    >>> auxmap_hin('sakawA')
    ('saka', 'wA')
    """
    try:
        with open(constant.AUX_MAP_FILE, 'r') as tamfile:
            for line in tamfile.readlines():
                aux_mapping = line.strip().split(',')
                if aux_mapping[0] == aux_verb:
                    return aux_mapping[1], aux_mapping[2]
        log(f'"{aux_verb}" not found in Auxillary mapping.', 'WARNING')
        return None, None       # TODO Figure out the fallback
    except FileNotFoundError:
        log('Auxillary Mapping File not found.', 'ERROR')
        sys.exit()

def check_named_entity(word_data):
    if word_data[2] == 'ne':
        return True
    return False
def check_noun(word_data):
    '''Check if word is a noun by the USR info'''

    try:
        if word_data[2] in ('place','Place','ne','NE'):  # identifying nouns from sem_cat
            return True
        if word_data[3] != '': # GNP present for a concept- but its not one of the
            if word_data[3][1:-1] not in ('superl', 'stative', 'causative', 'double_causative'):
                return True
        return False
    except IndexError:
        log(f'Index Error for GNP Info. Checking noun for {word_data[1]}', 'ERROR')
        sys.exit()


def check_pronoun(word_data):
    '''Check if word is a pronoun by the USR info'''

    try:
        if clean(word_data[1]) in (
                'addressee', 'speaker', 'kyA', 'Apa', 'jo', 'koI', 'kOna', 'mEM', 'saba', 'vaha', 'wU', 'wuma', 'yaha', 'kim'):
            return True
        elif 'coref' in word_data[5]:
            if 'r6' not in word_data[4]: # for words like apanA
                return True
        else:
            return False
    except IndexError:
        log(f'Index Error for GNP Info. Checking pronoun for {word_data[1]}', 'ERROR')
        sys.exit()


def check_adjective(word_data):
    '''Check if word is an adjective by the USR info'''

    if word_data[4] != '':
        rel = word_data[4].strip().split(':')[1]
        if rel in ('card', 'mod', 'meas', 'ord', 'intf'):
            return True

        if rel == 'k1s' and word_data[3] == '': # k1s and no GNP -> adj
            return True

        if word_data[5] != '':
            if ':' in word_data[5]:
                coref = word_data[5].strip().split(':')[1]
                if rel == 'r6' and coref == 'coref': # for words like apanA
                    return True

    return False

def check_nonfinite_verb(word_data):
    '''Check if word is a non-fininte verb by the USR info'''

    if word_data[4] != '':
        rel = word_data[4].strip().split(':')[1]
        if rel in ('rpk','rbk', 'rvks', 'rbks','rsk', 'rbplk'):
            return True
    return False

def check_adverb_old(word_data, verbs_data):
    '''Check if word is an adverb (kriya_visheshan) by using the USR info'''

    if word_data[4] != '':
        concept_index = word_data[4].strip().split(':')[0]
        rel = word_data[4].strip().split(':')[1]
        if rel in ('krvn', 'kr_vn'):
                index = getDataByIndex(int(concept_index), verbs_data)
                if concept_index == index:
                    return True

    return False

def check_verb(word_data):
    '''Check if word is a verb by the USR info. Check for both finite and non-finite verbs.
    nonfinite verbs checked by dependency. main verb identified by - in it. '''

    if '-' in word_data[1]:
        rword = word_data[1].split('-')[0]
        if rword in extract_tamdict_hin():
            return True
        else:
            log(f'Verb "{rword}" not found in TAM dictionary', 'WARNING')
            return True
    else:
        if word_data[4] != '':
            rel = word_data[4].strip().split(':')[1]
            if rel in ('rpk','rbk', 'rvks', 'rbks','rsk', 'rblpk'):
                return True
    return False


def check_adverb(word_data):
    '''Check if word is an adverb by the USR info. Check for kr_vn in dependency row.
    '''
    if word_data[4] != '':
        rel = word_data[4].strip().split(':')[1]
        if rel in ('kr_vn','krvn'):
            return True
    return False

def check_indeclinable(word_data):
    """ Check if word is in indeclinable word list."""
    if word_data[2] == 'unit':
        return True

    units = (
        'semI,kimI,mItara, lItara, kilomItara, kilolItara, '
    )
    unit_list = units.split(",")
    if clean(word_data[1]) in unit_list:
        return True

    indeclinable_words = (
        'aBI,waWA,Ora,paranwu,kinwu,evaM,waWApi,Bale hI,kuCa,'
        'wo,agara,magara,awaH,cUMki,cUzki,jisa waraha,'
        'jisa prakAra,lekina,waba,waBI,yA,varanA,anyaWA,'
        'wAki,baSarweM,jabaki,yaxi,varana,paraMwu,kiMwu,'
        'hAlAzki,hAlAMki,va,Aja,nahIM'  # added nahiM as indec by Kirti.garg@gmail.com Dec 16
    )
    indeclinable_list = indeclinable_words.split(",")
    if clean(word_data[1]) in indeclinable_list:
        return True

    # #Numbers appear without '_' in the USR
    # num = word_data[1]
    # if num.isdigit():
    #     return True
    # else:
    #     try:
    #         float_value = float(num)
    #         return True
    #     except ValueError:
    #         return False

    return False

def check_digit(word_data):
    # Numbers appear without '_' in the USR
    # check for yoc and doy
    # for eg. - 11_1, 1000, 59
    num = word_data[1]
    if '_' in num:
        num = num.strip().split('_')[0]
    if num.isdigit():
        return True
    else:
        try:
            float_value = float(num)
            return True
        except ValueError:
            return False
    return False

def analyse_words(words_list):
    '''Checks word for its type to process accordingly and
    add that word to its corresponnding list.'''

    indeclinables = []
    pronouns = []
    nouns = []
    adjectives = []
    verbs = []
    others = []
    adverbs = []
    nominal_verb = []
    for word_data in words_list:
        if check_indeclinable(word_data):
            log(f'{word_data[1]} identified as indeclinable.')
            indeclinables.append(word_data)
        elif check_digit(word_data):
            log(f'{word_data[1]} identified as noun.')
            nouns.append(word_data)
        elif check_verb(word_data):
            log(f'{word_data[1]} identified as verb.')
            verbs.append(word_data)
        elif check_adjective(word_data):
            log(f'{word_data[1]} identified as adjective.')
            adjectives.append(word_data)
        elif check_pronoun(word_data):
            log(f'{word_data[1]} identified as pronoun.')
            pronouns.append(word_data)
        elif check_adverb(word_data):
            log(f'{word_data[1]} identified as adverb.')
            adverbs.append(word_data)
        elif check_nominal_verb(word_data):
            log(f'{word_data[1]} identified as nominal form.')
            nominal_verb.append(word_data)
        elif check_noun(word_data):
            log(f'{word_data[1]} identified as noun.')
            nouns.append(word_data)
        elif check_named_entity(word_data):
            log(f'{word_data[1]} identified as named entity and processed as other word.')
            others.append(word_data)
        else:
            log(f'{word_data[1]} identified as other word, but processed as noun with default GNP.')  # treating other words as noun
            # others.append(word_data) #modification by Kirti on 12/12 to handle other words
            nouns.append(word_data)
    return indeclinables, pronouns, nouns, adjectives, verbs, adverbs, others, nominal_verb

def check_nominal_verb(word_data):
    rel_list = ['rt', 'rh', 'k7p', 'k7t', 'k2']
    if word_data[4].strip() != '':
        relation = word_data[4].strip().split(':')[1]
        gnp_info = word_data[3]
        if relation in rel_list and gnp_info == '':
            return True
    return False

def process_nominal_verb(nominal_verbs_data, processed_noun, words_info, verbs_data):

   nominal_verbs = []
   for verb in verbs_data:
       if verb[4].strip().split(':')[1] == 'main':
           main_verb = verb
           break

   for nominal_verb in nominal_verbs_data:
        index = nominal_verb[0]
        term = clean(nominal_verb[1])
        gender = 'm'
        number = 's'
        person = 'a'
        category = 'n'
        noun_type = 'common'
        case = 'o'
        postposition = ''
        log_msg = f'{term} identified as nominal, re-identified as other word and processed as common noun with index {index} gen:{gender} num:{number} person:{person} noun_type:{noun_type} case:{case} and postposition:{postposition}'

        relation = ''
        if nominal_verb[4] != '':
            relation = nominal_verb[4].strip().split(':')[1]

        case, postposition = preprocess_postposition_new('noun', nominal_verb, words_info, main_verb)
        tags = find_tags_from_dix_as_list(term)
        for tag in tags:
            if (tag[0] == 'cat' and tag[1] == 'v'):
                noun_type = 'vn'
                if relation in ('k2', 'rt', 'rh'):
                    term = term + 'nA'
                log_msg = f'{term} processed as nominal verb with index {index} gen:{gender} num:{number} person:{person} noun_type:{noun_type} case:{case} and postposition:{postposition}'
                break

        noun = (index, term, category, case, gender, number, person, noun_type, postposition)
        processed_noun.append(noun)
        log(log_msg)

   return nominal_verbs

def process_adverb_as_noun(concept, processed_nouns):
    index = concept[0]
    case = 'd'
    if ('+se_') in concept[1]:
        draft_term = concept[1].strip().split('+')[0]
        term = clean(draft_term)
        case = 'o'
    category = 'n'
    gender = 'm'
    number = 'p'
    person = 'a'
    noun_type = 'abstract'
    postposition = 'se'
    processed_postpositions_dict[index] = postposition
    #index, word, category, case, gender, number, proper / nountype = proper or CP_noun, postposition
    adverb = (index, term, category, case, gender, number, person, noun_type, postposition)
    processed_nouns.append(adverb)
    log(f' Adverb {term} processed as an abstract noun with index {index} gen:{gender} num:{number} case:{case},noun_type:{noun_type} and postposition:{postposition}')
    return

def process_adverb_as_verb(concept, processed_verbs):
    adverb = []
    index = concept[0]
    term = clean(concept[1])
    gender = 'm'
    number = 's'
    person = 'a'
    category = 'v'
    type = 'adverb'
    case = 'd'
    tags = find_tags_from_dix_as_list(term)
    for tag in tags:
        if ( tag[0] =='cat' and tag[1] == 'v' ):
            tam = 'kara'
            adverb = (index, term, category, gender, number, person, tam, case, type)
            processed_verbs.append(to_tuple(adverb))
            log(f'{term} adverb processed as a verb with index {index} gen:{gender} num:{number} person:{person}, and tam:{tam}')
    return

def process_adverbs(adverbs, processed_nouns, processed_verbs, processed_indeclinables, reprocessing):
    for adverb in adverbs:
        if ('+se_') in adverb[1] or adverb[2] == 'abs':  # for jora+se kind of adverbs
                if not reprocessing:
                    process_adverb_as_noun(adverb,processed_nouns)
        else: #check morph tags
            term = clean(adverb[1])
            tags = find_tags_from_dix_as_list(term)
            for tag in tags:
                if (tag[0] == 'cat' and tag[1] == 'v'): # term type is verb in morph dix
                    process_adverb_as_verb(adverb, processed_verbs)

                elif (tag[0] == 'cat' and tag[1] == 'adj'): # term type is adjective in morph dix
                    term = term + 'rUpa se'
                    processed_indeclinables.append((adverb[0], term, 'indec'))
                    log(f'adverb {adverb[1]} processed indeclinable with form {term}')
                else:
                    processed_indeclinables.append((adverb[0], term, 'indec')) #to be updated, when cases arise.
                    log(f'adverb {adverb[1]} processed indeclinable with form {term}, no processing done')
                    return

def has_GNP(gnp_info):
    gnp_data = gnp_info.strip('][').split(' ')
    if len(gnp_data) != 3:
        return False
    return True

def get_root_for_kim(relation, anim, gnp):
    # kOna is root for - kisakA, kisakI, kisake, kinakA, kinake, kinakI, kOna, kisa, kisane, kise, kisako,
    # kisase, kisake, kisameM, kisameM_se, isapara, kina, inhoMne, kinheM, kinako, kinase, kinpara, kinake, kinameM, kinameM_se, kisI, kisa

    # kyA = k1s, gnp, inanimate
    # kyA = k2, non anim
    # kOna = k1s, gnp, animate
    # kEsA = k1s, no gnp, inanimate

    #     elif relation in ('k2p', 'k7p'):
    #     return 'kahAz'
    #
    # elif relation == 'k5':
    # return 'kahAz se'
        #kaba
        #kim + gnp + non anim - > kyA
        #kim + gnp + anim -> kaun

    animate = ['anim', 'per']
    if relation in ('k2p', 'k7p'):
        return 'kahAz'
    elif relation == 'k5' and has_GNP(gnp):
        return 'kahAz'
    elif relation == 'k7t':
        return 'kaba'
    elif relation == 'rh' and not has_GNP(gnp):
        return 'kyoM'
    elif relation == 'rt' and not has_GNP(gnp): #generate kisa
        return 'kOna'
    elif relation == 'krvn': #generate kEse
        return 'kEsA'
    elif relation == 'k1s':
        return 'kEsA'
    elif has_GNP(gnp) and anim not in animate:
        return 'kyA'
    elif has_GNP(gnp) and anim in animate:
        return 'kOna'
    else:
        return 'kim'

    # if relation == 'k1s' and len(gnp) > 0 and anim in animate:
    #     return 'kOna'
    # #generate kisane, kOna
    # elif relation == 'k1':
    #     return 'kOna'
    # #generate kisase, kisako
    # elif relation in ('k2', 'k2g', 'k5', 'k3'):
    #     return 'kOna'
    #
    # elif relation == 'k1s' and len(gnp) > 0 and anim not in animate:
    #     return 'kyA'
    # elif relation == 'k2' and anim not in animate:
    #     return 'kyA'
    #
    # elif relation in ('k2p', 'k7p'):
    #     return 'kahAz'
    # elif relation == 'k5':
    #     return 'kahAz se'
    #
    # elif relation == 'kr_vn':
    #     return 'kEse'
    # elif relation == 'k1s' and len(gnp) == 0 and anim in inanimate:
    #     return 'kEsA'
    # elif relation == 'rt':
    #     return 'kyoM'
    #
    #
    #
    #else:
    #    return 'kim'

def process_indeclinables(indeclinables):
    '''Processes indeclinable words index, word, 'indec'''
    processed_indeclinables = []
    for indec in indeclinables:
        clean_indec = clean(indec[1])
        processed_indeclinables.append((indec[0], clean_indec, 'indec'))
    return processed_indeclinables

def has_ques_mark(sentence_type):
    interrogative_lst = ["yn_interrogative", "yn_interrogative_negative", "pass-yn_interrogative", "interrogative",
                         "Interrogative", "pass-interrogative"]
    for i in interrogative_lst:
        if sentence_type == i:
            return True
    return False
def process_others(other_words):
    '''Process other words. Right now being processed as noun with default gnp'''

    processed_others = []
    for word in other_words:
        gender = 'm'
        number = 's'
        person = 'a'
        processed_others.append((word[0], clean(word[1]), 'other', gender, number, person))
    return processed_others
def extract_gnp_noun(noun_term, gnp_info):
    # For nouns terms with '-' in gender -> fetch gender from dix, if not present set 'm' as default
    # For CN terms -> if '-' in gender -> fetch gender for head term and that will be copied for all the CN terms
    # For numbers default gnp is 'msa'
    gender = 'm'
    number = 's'
    person = 'a'
    if '+' in noun_term:
        cn_terms = noun_term.strip().split('+')
        for i in range(len(cn_terms)):
            if i == len(cn_terms) - 1:
                noun_term = cn_terms[i]

    gnp_data = gnp_info.strip('][').split(' ')
    if len(gnp_data) != 3:
        return 'm', 's', 'a'
    if gnp_data[0].lower() == 'm':
        gender = 'm'
    elif gnp_data[0].lower() == 'f':
        gender = 'f'
    elif gnp_data[0] == '-':
        tags = find_tags_from_dix(noun_term)
        if '*' not in tags['form']:
            gender = tags['gen']
        else:
            gender = 'm'

    number = 's' if gnp_data[1].lower(
    ) == 'sg' else 'p' if gnp_data[1].lower() == 'pl' else 's'
    person = 'a' if gnp_data[2] in ('-', '') else gnp_data[2]

    return gender, number, person
def extract_gnp(gnp_info):
    '''Extract GNP info from string format to tuple (gender,number,person) format.'''
    gender = 'm'
    number = 's'
    person = 'a'

    gnp_data = gnp_info.strip('][').split(' ')
    gnp_data = gnp_info.strip('][').split(' ')
    if len(gnp_data) != 3:
        return 'm', 's', 'a'
    gender = 'm' if gnp_data[0].lower(
    ) == 'm' else 'f' if gnp_data[0].lower() == 'f' else 'm'
    number = 's' if gnp_data[1].lower(
    ) == 'sg' else 'p' if gnp_data[1].lower() == 'pl' else 's'
    person = 'a' if gnp_data[2] in ('-', '') else gnp_data[2]

    return gender, number, person

def is_kim(term):
    if term == 'kim':
        return True
    return False

def process_kim(index, relation, anim, gnp, pronoun, words_info, main_verb, processed_pronouns, processed_indeclinables, processed_nouns):
    term = get_root_for_kim(relation, anim, gnp)
    if term == 'kyoM':
        processed_indeclinables.append((index, term, 'indec'))
    else:
        category = 'p'
        case = 'o'
        parsarg = 0
        case, postposition = preprocess_postposition_new('pronoun', pronoun, words_info, main_verb)
        if postposition != '':
            parsarg = postposition

        fnum = None
        gender, number, person = extract_gnp(pronoun[3])

        if "r6" in pronoun[4]:
            fnoun = int(pronoun[4][0])
            fnoun_data = getDataByIndex(fnoun, processed_nouns, index=0)
            gender = fnoun_data[4]  # To-ask
            fnum = number = fnoun_data[5]
            case = fnoun_data[3]
            if term == 'apanA':
                parsarg = '0'

        if term in ('kahAz'):
            parsarg = 0
        processed_pronouns.append((pronoun[0], term, category, case, gender, number, person, parsarg, fnum))
        log(f'kim processed as pronoun with term: {term} case:{case} par:{parsarg} gen:{gender} num:{number} per:{person} fnum:{fnum}')

    return processed_pronouns, processed_indeclinables

def process_pronouns(pronouns, processed_nouns, processed_indeclinables, words_info, verbs_data):
    '''Process pronouns as (index, word, category, case, gender, number, person, parsarg, fnum)'''
    processed_pronouns = []
    # fetch the main verb
    for verb in verbs_data:
        if verb[4].strip().split(':')[1] == 'main':
            main_verb = verb
            break
    for pronoun in pronouns:
        index = pronoun[0]
        term = clean(pronoun[1])
        relation = pronoun[4].strip().split(':')[1]
        anim = pronoun[2]
        gnp = pronoun[3]
        if is_kim(term):
            # returns a tuple
            # term = get_root_for_kim(relation, anim, gnp)
            # if term == 'kyoM':
            #     processed_indeclinables.append((pronoun[0], term, 'indec'))
            #     continue
            processed_pronouns, processed_indeclinables = process_kim(index, relation, anim, gnp, pronoun, words_info,
                                                                      main_verb, processed_pronouns, processed_indeclinables, processed_nouns)
        else:
            category = 'p'
            case = 'o'
            parsarg = 0

            if term == 'yahAz':
                if pronoun[6] == 'emphasis':
                    term = 'yahIM'
                    category = 'indec'
                    processed_indeclinables.append(index, term, category)
                    break

            if term == 'vahAz':
                if pronoun[6] == 'emphasis':
                    term = 'vahIM'
                    category = 'indec'
                    processed_indeclinables.append((index, term, category))
                    break
            case, postposition = preprocess_postposition_new('pronoun', pronoun, words_info, main_verb)
            if postposition != '':
                parsarg = postposition

            fnum = None
            gender, number, person = extract_gnp(pronoun[3])
            # if "k1" in pronoun[4] or 'dem' in pronoun[4]:
            #     if clean(pronoun[1]) in ('kOna', 'kyA', 'vaha', 'yaha') and pronoun[2] != 'per':
            #         #if findValue('yA', processed_verbs, index=6)[0]: TAM not 'yA'
            #             case = "d"
            # else:
            #if "k2" in pronoun[4] and pronoun[2] in ('anim', 'per'):
            #    case = 'd'

            if pronoun[1] == 'addressee':
                addr_map = {'respect': 'Apa', 'informal': 'wU', '': 'wU'}
                pronoun_per = {'respect': 'm', 'informal': 'm', '': 'm_h1'}
                pronoun_number = {'respect': 'p', 'informal': 's', '': 'p'}
                word = addr_map.get(pronoun[6].strip().lower(), 'wU')
                person = pronoun_per.get(pronoun[6].strip().lower(), 'm_h1')
                number = pronoun_number.get(pronoun[6].strip(), 'p')
            elif pronoun[1] == 'speaker':
                word = 'mEM'
            elif pronoun[1] == 'vaha':
                word = 'vaha'
            else:
                word = term

            # If dependency is r6 then add fnum and take gnp and case from following noun.
            if "r6" in pronoun[4]:
                fnoun = int(pronoun[4][0])
                fnoun_data = getDataByIndex(fnoun, processed_nouns, index=0)
                gender = fnoun_data[4]  # To-ask
                fnum = number = fnoun_data[5]
                case = fnoun_data[3]
                if term == 'apanA':
                    parsarg = '0'

            processed_pronouns.append((pronoun[0], word, category, case, gender, number, person, parsarg, fnum))
            log(f'{pronoun[1]} processed as pronoun with case:{case} par:{parsarg} gen:{gender} num:{number} per:{person} fnum:{fnum}')
    return processed_pronouns

def handle_compound_nouns(noun, processed_nouns, category, case, gender, number, person, postposition):
    dnouns = noun[1].split('+')
    for k in range(len(dnouns)):
        index = noun[0] + (k * 0.1)
        noun_type = 'NC'
        clean_dnouns = clean(dnouns[k])
        if k == len(dnouns) - 1:
            noun_type = 'NC_head'
            dict_index = index
            processed_nouns.append(
                (index, clean_dnouns, category, case, gender, number, person, noun_type, postposition))
        else:
            processed_nouns.append((index, clean_dnouns, category, case, gender, number, person, noun_type, ''))

    if noun[0] in processed_postpositions_dict:
        processed_postpositions_dict[dict_index] = processed_postpositions_dict.pop(noun[0])

    return processed_nouns
def find_exact_dep_info_exists(index, dep_rel, words_info):
    for word in words_info:
        dep = word[4]
        dep_head = word[4].strip().split(':')[0]
        dep_val = word[4].strip().split(':')[1]
        if dep_val == dep_rel and int(dep_head) == index:
            return True
    return False

def process_nouns(nouns, words_info, verbs_data):
    '''Process nouns as Process nouns as (index, word, category, case, gender, number, proper/noun type= proper, common, NC, nominal_verb or CP_noun, postposition)'''
    #noun_attribute dict to store all nouns as keys
    processed_nouns = []
    main_verb = ''
    # fetch the main verb
    for verb in verbs_data:
        if verb[4].strip().split(':')[1] == 'main':
            main_verb = verb
            break

    for noun in nouns:
        category = 'n'
        index = noun[0]
        dependency = noun[4].strip().split(':')[1]
        if check_is_digit(noun[1]):
            gender, number, person =extract_gnp_noun(noun[1], noun[3])
        else:
            gender, number, person = extract_gnp_noun(clean(noun[1]), noun[3])

        #if number == 's' and noun[6] != 'def':
        #    if not find_exact_dep_info_exists(index, 'dem', words_info) and not find_exact_dep_info_exists(index, 'quant', words_info) and not find_exact_dep_info_exists(index, 'card', words_info):
        #        update_additional_words_dict(index, 'before', 'eka')


        if noun[6] == 'respect': # respect for nouns
            number = 'p'
        noun_type = 'common' if '_' in noun[1] else 'proper'

        # to fetch postposition and case logic and update each tuple
        case, postposition = preprocess_postposition_new('noun', noun, words_info, main_verb)

        # For Noun compound words
        if '+' in noun[1]:
            processed_nouns = handle_compound_nouns(noun, processed_nouns, category, case, gender, number, person, postposition)
        else:
            term = noun[1]
            if check_is_digit(term):
                if '_' in term:
                    clean_noun = term.strip().split('_')[0]
                else:
                    clean_noun = term
                noun_type = 'digit'
            else:
                clean_noun = clean(noun[1])

            processed_nouns.append((noun[0], clean_noun, category, case, gender, number, person, noun_type, postposition))
            #noun_attribute[clean_noun] = [[], []]
        log(f'{noun[1]} processed as noun with case:{case} gen:{gender} num:{number} noun_type:{noun_type} postposition: {postposition}.')

    return processed_nouns

def check_is_digit(num):
    if num.isdigit():
        return True
    else:
        try:
            float_value = float(num)
            return True
        except ValueError:
            return False
    return False

def get_default_GNP():
    gender = 'm'
    number = 's'
    person = 'a'
    case  = 'o'
    return gender, number, person, case

def process_adjectives(adjectives, processed_nouns, processed_verbs):
    '''Process adjectives as (index, word, category, case, gender, number)
        '''
    processed_adjectives = []
    gender, number, person, case = get_default_GNP()
    for adjective in adjectives:
        index = adjective[0]
        category = 'adj'
        adj = clean(adjective[1])

        relConcept = int(adjective[4].strip().split(':')[0]) # noun for regular adjcetives, and verb for k1s-samaadhikaran
        relation = adjective[4].strip().split(':')[1]
        if relation == 'k1s':
            if adj =='kim':
                adj = 'kEsA'
            relConcept_data = getDataByIndex(relConcept, processed_verbs)
        else:
            relConcept_data = getDataByIndex(relConcept, processed_nouns)

        if not relConcept_data:
            log(f'Associated noun/verb not found with the adjective {adjective[1]}. Using default m,s,a,o ')
        else:
            gender, number, person, case = get_gnpcase_from_concept(relConcept_data)
            if relation == 'k1s':
                case = 'd'

        # noun = relConcept_data[1]
        # add_adj_to_noun_attribute(noun, adj)
        if adj == 'kim' and relation == 'krvn':
            adj = 'kEsA'
        adjective = (index, adj, category, case, gender, number)
        processed_adjectives.append((index, adj, category, case, gender, number))
        log(f'{adjective[1]} processed as an adjective with case:{case} gen:{gender} num:{number}')
    return processed_adjectives

def process_imp_sentence(words_info, processed_pronouns):
    # check if dependency does not have k1
    # Add wuma postulate [0.9,  addressee, d, m,s,m, ' ' ]
    k1exists = findExactMatch('k1', words_info, index=4)[0]
    if not k1exists:
        temp = (0.9, 'wU', 'p', 'd', 'm', 's', 'm_h1', 0, None)
        processed_pronouns.insert(0, temp)

    return processed_pronouns

def get_gnpcase_from_concept(concept): #computes GNP values from noun or

    if concept[2] == 'v':
        gender = concept[3]
        number= concept[4]
        person = concept[5]
        case =  concept[7]

    elif concept[2] in ('n', 'p'):
        gender = concept[4]
        number= concept[5]
        person = concept[6]
        case = concept[3]
    else:
        gender, number, person, case = get_default_GNP()

    return gender, number, person, case


def is_complex_predicate(concept):
    return "+" in concept


def identify_case(verb, dependency_data, processed_nouns, processed_pronouns):
    return getVerbGNP(verb.term, verb.tam, dependency_data, processed_nouns, processed_pronouns)


def get_TAM(term, tam):
    """
    >>> get_TAM('hE', 'pres')
    'hE'
    >>> get_TAM('hE', 'past')
    'WA'
    >>> get_TAM('asdf', 'gA')
    'gA'
    """
    if term == 'hE' and tam in ('pres', 'past'):
        alt_tam = {'pres': 'hE', 'past': 'WA'}
        return alt_tam[tam]
    else:
        if term == 'jA':
            tam = 'yA1'
            return tam
    return tam


def identify_main_verb(concept_term):
    """
    >>> identify_main_verb("kara_1-wA_hE_1")
    'kara'
    >>> identify_main_verb("varRA+ho_1-gA_1")
    'ho'
    """
    if ("+" in concept_term):
        concept_term = concept_term.split("+")[1]
    return clean(concept_term.split("-")[0])


def identify_default_tam_for_main_verb(concept_term):
    """
    >>> identify_default_tam_for_main_verb("kara_1-wA_hE_1")
    'wA'
    >>> identify_default_tam_for_main_verb("kara_1-0_rahA_hE_1")
    '0'
    """
    return concept_term.split("-")[1].split("_")[0]


def identify_complete_tam_for_verb(concept_term):
    """
    >>> identify_complete_tam_for_verb("kara_1-wA_hE_1")
    'wA_hE'
    >>> identify_complete_tam_for_verb("kara_1-0_rahA_hE_1")
    'rahA_hE'
    >>> identify_complete_tam_for_verb("kara_1-nA_howA_hE_1")
    'nA_howA_hE'
    >>> identify_complete_tam_for_verb("kara_o")
    'o'
    """
    if "-" not in concept_term:
        return concept_term.split("_")[1]
    tmp = concept_term.split("-")[1]
    tokens = tmp.split("_")
    non_digits = filter(lambda x: not x.isdigit(), tokens)
    return "_".join(non_digits)


def identify_auxillary_verb_terms(term):
    """
    >>> identify_auxillary_verb_terms("kara_1-wA_hE_1")
    ['hE']
    >>> identify_auxillary_verb_terms("kara_1-0_rahA_hE_1")
    ['rahA', 'hE']
    """
    aux_verb_terms = term.split("-")[1].split("_")[1:]
    cleaned_terms = map(clean, aux_verb_terms)
    return list(filter(lambda x: x != '', cleaned_terms))           # Remove empty strings after cleaning


def is_CP(term):
    """
    >>> is_CP('varRA+ho_1-gA_1')
    True
    >>> is_CP("kara_1-wA_hE_1")
    False
    """
    return "+" in term


def process_main_CP(index, term):
    """
    >>> process_main_CP(2,'varRA+ho_1-gA_1')
    [1.9, 'varRA', 'n', 'd', 'm', 's', 'a', 'CP_noun', None]
    """
    # index, word, category, case, gender, number, noun_type, postposition
    CP_term = clean(term.split('+')[0])
    CP_index = index - 0.1
    gender = 'm'
    number = 's'
    person = 'a'
    postposition = None
    CP = []
    tags = find_tags_from_dix(CP_term)  # getting tags from morph analyzer to assign gender and number for agreement
    if '*' not in tags['form']:
        gender = tags['gen']
        number = tags['num']
        category = tags['cat']
    # if category == 'adj':
    #     CP = [CP_index, CP_term, 'adj', 'd', gender, number]
    # if category == 'n':
    CP = [CP_index, CP_term, 'n','d', gender, number, person, 'CP_noun', postposition]

    return CP


def verb_agreement_with_CP(verb, CP):
    """
    >>> verb_agreement_with_CP(Verb(index=2, gender='m', number='s', person='a'), [1.9, 'varRA', 'n', 'd', 'f', 's', 'a', 'CP_noun', ''])
    ('f', 's', 'a')
    >>> verb_agreement_with_CP(Verb(index=2, gender='m', number='s', person='a'), [1.9, 'pAnI', 'n', 'd', 'm', 's', 'a', 'CP_noun', ''])
    ('m', 's', 'a')
    """

    if CP != [] and (verb.index - 0.1 == CP[0]) and CP[7] == "CP_noun":  # setting correspondence between CP noun and verb
        return CP[4], CP[5], CP[6]
    else:
        return verb.gender, verb.number, verb.person

def set_gender_make_plural(processed_words, g, num):
    process_data = []
    # for all k1s and main verb change gender to female and number to plural
    for i in range(len(processed_words)):
        word_list = list(processed_words[i])
        if word_list[2] == 'adj':
            # 4th index - gender, 5th index - number
            word_list[4] = g
            word_list[5] = num
        elif word_list[2] == 'v':
            # 3rd index - gender, 4th index - number
            word_list[3] = g
            word_list[4] = num
        process_data.append(tuple(word_list))

    return process_data


def is_update_index_NC(i, processed_words):
    for data in processed_words:
        temp = tuple(data)
        if float(i) == temp[0] and temp[7] == 'NC':
            return True

    return False


def fetch_NC_head(i, processed_words):
    for data in processed_words:
        temp = tuple(data)
        if int(temp[0]) == int(i) and temp[7] == 'NC_head':
            return temp[0]

def process_construction(processed_words, construction_data, depend_data, gnp_data, index_data):
    # Adding Ora or yA as a tuple to be sent to morph/ adding it at join_compounds only
    # if k1 in conj, all k1s and main verb g - m and n - pl
    # if all k1 male or mix - k1s g - male else g - f
    # cons list - can be more than one conj
    # k1 ka m/f/mix nikalkr k1s and verb ko g milega    index dep:gen
    # map to hold conj kaha aega

    construction_dict.clear()
    process_data = processed_words
    dep_gender_dict = {}
    a = 'after'
    b = 'before'
    if gnp_data != []:
        gender = []
        for i in range(len(gnp_data)):
            gnp_info = gnp_data[i]
            gnp_info = gnp_info.strip().strip('][')
            gnp = gnp_info.split(' ')
            gender.append(gnp[0])

    if depend_data != []:
        dependency = []
        for dep in depend_data:
            if dep != '':
                dep_val = dep.strip().split(':')[1]
                dependency.append(dep_val)

    for i, dep, g in zip(index_data, dependency, gender):
        dep_gender_dict[str(i)] = dep + ':' + g

    if construction_data != '' and len(construction_data) > 0:
        construction = construction_data.strip().split(' ')
        for cons in construction:
            conj_type = cons.split(':')[0].strip().lower()
            index = cons.split(':')[1].strip().strip('][').split(',')
            length_index = len(index)
            if conj_type == 'conj' or conj_type == 'disjunct':
                cnt_m = 0
                cnt_f = 0
                PROCESS = False
                for i in index:
                    relation = dep_gender_dict[i]
                    dep = relation.split(':')[0]
                    gen = relation.split(':')[1]

                    if dep == 'k1':
                        PROCESS = True
                        if gen == 'm':
                            cnt_m = cnt_m + 1
                        elif gen == 'f':
                            cnt_f = cnt_f + 1

                if PROCESS:
                    if cnt_f == length_index:
                        g = 'f'
                        num = 'p'
                    else:
                        g = 'm'
                        num = 'p'
                    process_data = set_gender_make_plural(processed_words, g, num)

                update_index = index[length_index - 2]
                # check if update index is NC
                #if true then go till NC_head index update same index in construction dict and remove ppost if any from processed
                for i in index:
                    if i == update_index:
                        if is_update_index_NC(i, processed_words):
                            index_NC_head = fetch_NC_head(i, processed_words)
                            i = index_NC_head
                        if conj_type == 'conj':
                            temp = (a, 'Ora')
                        elif conj_type == 'disjunct':
                            temp = (a, 'yA')
                        break
                    else:
                        temp = (a, ',')
                        if float(i) in construction_dict:
                            construction_dict[float(i)].append(temp)
                        else:
                            construction_dict[float(i)] = [temp]

                        # if i in ppost_dict remove ppost rAma kA Ora SAma kA -> rAma Ora SAma kA
                        if float(i) in processed_postpositions_dict:
                            del processed_postpositions_dict[float(i)]

                if float(i) in construction_dict:
                    construction_dict[float(i)].append(temp)
                else:
                    construction_dict[float(i)] = [temp]

                if float(i) in processed_postpositions_dict:
                    del processed_postpositions_dict[float(i)]

            elif conj_type == 'list':
                length_list = len(index)
                for i in range(len(index)):
                    if i == length_list - 1:
                        break

                    if i == 0:
                        temp = (b, 'jEse')
                        if index[i] in construction_dict:
                            construction_dict[index[i]].append(temp)
                        else:
                            construction_dict[index[i]] = [temp]
                        temp = (a, ',')

                    elif i < length_list - 1:
                        temp = (a, ',')

                    if index[i] in construction_dict:
                        construction_dict[index[i]].append(temp)
                    else:
                        construction_dict[index[i]] = [temp]

    return process_data

def process_main_verb(concept: Concept, seman_data, dependency_data, sentence_type, processed_nouns, processed_pronouns, reprocessing):
    """
    >>> to_tuple(process_main_verb(Concept(index=2, term='varRA+ho_1-gA_1', dependency='0:main'), ['2:k7t', '0:main'], [(1, 'kala', 'n', 'o', 'm', 's', 'a', 'common', None)], [], False))
    [OK] : varRA processed as noun with index 1.9 case:d gen:f num:s per:a, noun_type:CP_noun, default postposition:None.
    (2, 'ho', 'v', 'f', 's', 'a', 'gA')
    >>> to_tuple(process_main_verb(Concept(index=2, term='varRA+ho_1-gA_1', dependency='0:main'), ['2:k7t', '0:main'], [(1, 'kala', 'n', 'o', 'm', 's', 'a', 'common', None)], [], True))
    [OK] : ho reprocessed as verb with index 2 gen:f num:s per:a in agreement with CP
    (2, 'ho', 'v', 'f', 's', 'a', 'gA')
    >>>
    """
    verb = Verb()
    verb.type = "main"
    verb.index = concept.index
    verb.term = identify_main_verb(concept.term)
    full_tam = identify_complete_tam_for_verb(concept.term)
    verb.tam = identify_default_tam_for_main_verb(concept.term)
    if verb.term == 'hE' and verb.tam in ('pres', 'past'):  # process TAM
        alt_tam = {'pres': 'hE', 'past': 'WA'}
        alt_root = {'pres': 'hE', 'past': 'WA'}
        verb.term = alt_root[verb.tam]  # handling past tense by passing correct root WA
        verb.tam = alt_tam[verb.tam]
    if verb.term == 'jA' and verb.tam == 'yA':
        verb.tam = 'yA1'
    is_cp = is_CP(concept.term)
    verb.gender, verb.number, verb.person = getVerbGNP_new(concept.term, full_tam, is_cp, seman_data, dependency_data, sentence_type, processed_nouns, processed_pronouns)
    # if is_CP(concept.term):
    #     if not reprocessing:
    #         CP = process_main_CP(concept.index, concept.term)
    #         if CP != [] and CP[2] == 'n':
    #             log(f'{CP[1]} processed as noun with index {CP[0]} case:d gen:{CP[4]} num:{CP[5]} per:{CP[6]}, noun_type:{CP[7]}, default postposition:{CP[8]}.')
    #             processed_nouns.append(tuple(CP))
            #verb.gender, verb.number, verb.person = verb_agreement_with_CP(verb, CP)
        # elif reprocessing:
        #     if findValue('CP_noun', processed_nouns, index=0)[0]:
        #         tmp = findValue('CP_noun', processed_nouns, index=0)[1]
        #         verb.gender = tmp[4]
        #         log(f'{verb.term} reprocessed as verb with index {verb.index} gen:{verb.gender} num:{verb.number} per:{verb.person} in agreement with CP')
    return verb

#
# def create_auxiliary_verb(index, term, main_verb: Verb):
#     verb = Verb()
#     verb.index = main_verb.index + (index + 1)/10
#     verb.gender, verb.number, verb.person = main_verb.gender, main_verb.number, main_verb.person
#     verb.term, verb.tam = auxmap_hin(term)
#     if verb.term == 'cAha':
#             verb.person = 'm_h'
#     verb.type = 'auxillary'
#     log(f'{verb.term} processed as auxillary verb with index {verb.index} gen:{verb.gender} num:{verb.number} and tam:{verb.tam}')
#     return verb

def create_auxiliary_verb(index, term, tam, main_verb: Verb):
    verb = Verb()
    verb.index = main_verb.index + (index + 1)/10
    verb.gender, verb.number, verb.person = main_verb.gender, main_verb.number, main_verb.person
    verb.term = term
    verb.tam = tam
    if verb.term == 'cAha':
            verb.person = 'm_h'
    verb.type = 'auxillary'
    log(f'{verb.term} processed as auxillary verb with index {verb.index} gen:{verb.gender} num:{verb.number} and tam:{verb.tam}')
    return verb


def to_tuple(verb: Verb):
    return (verb.index, verb.term, verb.category, verb.gender, verb.number, verb.person, verb.tam, verb.case, verb.type)


def set_main_verb_tam_zero(verb: Verb):
    verb.tam = 0
    return verb

def process_auxiliary_verbs(verb: Verb, concept, spkview_data) -> [Verb]:
#def process_auxiliary_verbs(verb: Verb, concept_term: str, spkview_data) -> [Verb]:
    """
    >>> [to_tuple(aux) for aux in process_auxiliary_verbs(Verb(index=4, term = 'kara', gender='m', number='s', person='a', tam='hE', type= 'Auxillary'), concept_term='kara_17-0_sakawA_hE_1')]
    [(4.1, 'saka', 'v', 'm', 's', 'a', 'wA', 'Auxillary'), (4.2, 'hE', 'v', 'm', 's', 'a', 'hE',''Auxillary'')]
    """
    concept_term = concept.term
    concept_index = concept.index
    HAS_SHADE_DATA = False
    auxiliary_term_tam = []
    shade_index = 1
    for data in spkview_data:
        if data != '':
            data = data.strip().strip('][')
            if 'shade' in data and concept_index == shade_index:
                term = clean(data.split(':')[1])
                tam = identify_default_tam_for_main_verb(concept_term)
                HAS_SHADE_DATA = True
                break
        shade_index = shade_index + 1

    if HAS_SHADE_DATA:
        if term == 'jA' and tam == 'yA':
            tam = 'yA1'   # to generate gayA from jA-yA
        temp = (term, tam)
        auxiliary_term_tam.append(temp)
        # set main verb tam to 0
        verb = set_main_verb_tam_zero(verb)

    auxiliary_verb_terms = identify_auxillary_verb_terms(concept_term)
    for v in auxiliary_verb_terms:
        term, tam = auxmap_hin(v)
        temp = (term, tam)
        auxiliary_term_tam.append(temp)

    return [create_auxiliary_verb(index, pair[0], pair[1], verb) for index, pair in enumerate(auxiliary_term_tam)]

# def process_auxiliary_verbs(verb: Verb, concept_term: str) -> [Verb]:
#     """
#     >>> [to_tuple(aux) for aux in process_auxiliary_verbs(Verb(index=4, term = 'kara', gender='m', number='s', person='a', tam='hE', type= 'Auxillary'), concept_term='kara_17-0_sakawA_hE_1')]
#     [(4.1, 'saka', 'v', 'm', 's', 'a', 'wA', 'Auxillary'), (4.2, 'hE', 'v', 'm', 's', 'a', 'hE',''Auxillary'')]
#     """
#     auxiliary_verb_terms = identify_auxillary_verb_terms(concept_term)
#     return [create_auxiliary_verb(index, term, verb) for index, term in enumerate(auxiliary_verb_terms)]


def process_verb(concept: Concept, seman_data, dependency_data, sentence_type, spkview_data, processed_nouns, processed_pronouns, reprocessing):
    """
    concept pattern: 'main_verb' - 'TAM for main verb' _Aux_verb+tam...
    Example 1:
    kara_1-wA_hE_1
    main verb - kara,  main verb tam: wA, Aux -hE with TAM hE (identified from tam mapping file)

    Example 2:
    kara_1-yA_1
    main verb - kara,  main verb tam: yA,

    Example 3:
    kara_1-0_rahA_hE_1
    main verb - kara,  main verb tam: 0, Aux verb -rahA with TAM hE, Aux -hE with TAM hE (identified from tam mapping file)

    Example 4:
    kara_1-0_sakawA_hE_1
    main verb - kara,  main verb tam: 0, Aux verb -saka with TAM wA, Aux -hE with TAM hE (identified from tam mapping file)

    *Aux root and Aux TAM identified from auxillary mapping File
    """
    verb = process_main_verb(concept, seman_data, dependency_data, sentence_type, processed_nouns, processed_pronouns, reprocessing)
    #auxiliary_verbs = process_auxiliary_verbs(verb, concept.term, spkview_data)
    auxiliary_verbs = process_auxiliary_verbs(verb, concept, spkview_data)
    return verb, auxiliary_verbs


def is_nonfinite_verb(concept):
    return concept.type == 'nonfinite'


def set_tam_for_nonfinite(dependency):
    '''
    >>> set_tam_for_nonfinite('rvks')
    'adj_wA_huA'
    >>> set_tam_for_nonfinite('rbks')
    'yA_huA'
    >>> set_tam_for_nonfinite('rsk')
    'wA_huA'
    >>> set_tam_for_nonfinite('rpk')
    'kara'
    '''

    if dependency == 'rvks':
        tam = 'adj_wA_huA'
    elif dependency == 'rpk':
        tam = 'kara'
    elif dependency == 'rsk':
        tam = 'adj_wA_huA'
    else:
        if dependency == 'rbks':
            tam = 'adj_yA_huA'
        if dependency == 'rblpk':
            tam = 'nA'
    return tam


def process_nonfinite_verb(concept, seman_data, depend_data, sentence_type, processed_nouns, processed_pronouns):
    '''
    >>process_nonfinite_verb([], [()],[()])
    '''
    gender = 'm'
    number = 's'
    person = 'a'
    verb = Verb()
    verb.index = concept.index
    is_cp = is_CP(concept.term)
    if is_cp: #only CP_head as nonfinite verb
        draft_concept = concept.term.split('+')[1]
        verb.term  = clean(draft_concept)
    else:
        verb.term = clean(concept.term)

    verb.type = 'nonfinite'
    verb.tam = ''
    #verb.category = 'v'
    relation = concept.dependency.strip().split(':')[1]
    # full_tam = identify_complete_tam_for_verb(concept.term)
    verb.tam = set_tam_for_nonfinite(relation)
    full_tam = verb.tam

    gender, number, person = getVerbGNP_new(verb.term, full_tam, is_cp, seman_data, depend_data, sentence_type, processed_nouns, processed_pronouns)
    verb.gender = gender
    verb.number = number
    verb.person = person
    verb.case = 'o' # to be updated - agreement with following noun
    log(f'{verb.term} processed as nonfinite verb with index {verb.index} gen:{verb.gender} num:{verb.number} case:{verb.case}, and tam:{verb.tam}')
    return verb


def update_additional_words_dict(index, tag, value):
    temp = (tag, value)
    if index in additional_words_dict:
        additional_words_dict[index].append(temp)
    else:
        additional_words_dict[index] = [temp]

def process_verbs(concepts: [tuple], seman_data, depend_data, sentence_type, spkview_data, processed_nouns, processed_pronouns, reprocess=False):
    processed_verbs = []
    processed_auxverbs = []
    for concept in concepts:
        concept_dep_head = concept[4].strip().split(':')[0]
        concept_dep_val = concept[4].strip().split(':')[1]
        concept = Concept(index=concept[0], term=concept[1], dependency=concept[4])
        if(concept_dep_val == 'vk2'):
            update_additional_words_dict(int(concept_dep_head), 'after', 'ki')
        is_cp = is_CP(concept.term)
        if is_cp:
            if not reprocess:
                CP = process_main_CP(concept.index, concept.term)
                if CP != [] and CP[2] == 'n':
                    log(f'{CP[1]} processed as noun with index {CP[0]} case:d gen:{CP[4]} num:{CP[5]} per:{CP[6]}, noun_type:{CP[7]}, default postposition:{CP[8]}.')
                    processed_nouns.append(tuple(CP))
        verb_type = identify_verb_type(concept)
        if verb_type == 'nonfinite':
            verb = process_nonfinite_verb(concept, seman_data, depend_data, sentence_type, processed_nouns, processed_pronouns)
            processed_verbs.append(to_tuple(verb))
        else:
            verb, aux_verbs = process_verb(concept, seman_data, depend_data, sentence_type, spkview_data, processed_nouns, processed_pronouns, reprocess)
            processed_verbs.append(to_tuple(verb))
            log(f'{verb.term} processed as main verb with index {verb.index} gen:{verb.gender} num:{verb.number} case:{verb.case}, and tam:{verb.tam}')
            processed_auxverbs.extend([to_tuple(aux_verb) for aux_verb in aux_verbs])

    return processed_verbs, processed_auxverbs

def identify_verb_type(verb_concept):
    '''
    >>identify_verb_type([])
    '''
    #dep_rel = verb_concept[4].strip().split(':')[1] #if using with non-OO program
    dependency = verb_concept.dependency
    dep_rel = dependency.strip().split(':')[1]
    v_type = ''
    if dep_rel == 'main':
        v_type = "main"
    elif dep_rel in ('rpk', 'rbk', 'rvks', 'rbks', 'rsk', 'rblpk','rblak'):
        v_type = "nonfinite"
    else:
        v_type = "main"
    return v_type


def collect_processed_data(processed_pronouns, processed_nouns, processed_adjectives, processed_verbs,
                           processed_auxverbs, processed_indeclinables, processed_others):
    """collect sort and return processed data."""
    return sorted(
        processed_pronouns + processed_nouns + processed_adjectives + processed_verbs + processed_auxverbs + processed_indeclinables + processed_others)


def generate_input_for_morph_generator(input_data):
    """Process the input and generate the input for morph generator"""
    morph_input_data = []
    for data in input_data:
        if data[2] == 'p':
            if data[8] != None and isinstance(data[8], str):
                morph_data = f'^{data[1]}<cat:{data[2]}><parsarg:{data[7]}><fnum:{data[8]}><case:{data[3]}><gen:{data[4]}><num:{data[5]}><per:{data[6]}>$'
            else:
                morph_data = f'^{data[1]}<cat:{data[2]}><case:{data[3]}><parsarg:{data[7]}><gen:{data[4]}><num:{data[5]}><per:{data[6]}>$'
        elif data[2] == 'n' and data[7] in ('proper', 'digit'):
            morph_data = f'{data[1]}'
        elif data[2] == 'n' and data[7] == 'vn':
            morph_data = f'^{data[1]}<cat:{data[7]}><case:{data[3]}>$'
        elif data[2] == 'n' and data[7] != 'proper':
            morph_data = f'^{data[1]}<cat:{data[2]}><case:{data[3]}><gen:{data[4]}><num:{data[5]}>$'

        elif data[2] == 'v' and data[8] in ('main','auxillary'):
            morph_data = f'^{data[1]}<cat:{data[2]}><gen:{data[3]}><num:{data[4]}><per:{data[5]}><tam:{data[6]}>$'
        elif data[2] == 'v' and data[6] == 'kara' and data[8] in ('nonfinite','adverb') :
            morph_data = f'^{data[1]}<cat:{data[2]}><gen:{data[3]}><num:{data[4]}><per:{data[5]}><tam:{data[6]}>$'
        elif data[2] == 'v' and data[6] != 'kara' and data[8] =='nonfinite':
            morph_data = f'^{data[1]}<cat:{data[2]}><gen:{data[3]}><num:{data[4]}><case:{data[7]}><tam:{data[6]}>$'
        elif data[2] == 'adj':
            morph_data = f'^{data[1]}<cat:{data[2]}><case:{data[3]}><gen:{data[4]}><num:{data[5]}>$'
        elif data[2] == 'indec':
            morph_data = f'{data[1]}'
        elif data[2] == 'other':
            morph_data = f'{data[1]}'
        else:
            morph_data = f'^{data[1]}$'
        morph_input_data.append(morph_data)
    return morph_input_data


def write_data(writedata):
    """Write the Morph Input Data into a file"""
    final_input = " ".join(writedata)
    with open("morph_input.txt", 'w', encoding="utf-8") as file:
        file.write(final_input + "\n")
    return "morph_input.txt"


def run_morph_generator(input_file):
    """ Pass the morph generator through the input file"""
    fname = f'{input_file}-out.txt'
    f = open(fname, 'w')
    subprocess.run(f"sh ./run_morph-generator.sh {input_file}", stdout=f, shell=True)
    return "morph_input.txt-out.txt"


def generate_morph(processed_words):
    """Run Morph generator"""
    morph_input = generate_input_for_morph_generator(processed_words)
    MORPH_INPUT_FILE = write_data(morph_input)
    OUTPUT_FILE = run_morph_generator(MORPH_INPUT_FILE)
    return OUTPUT_FILE


def read_output_data(output_file):
    """Check the output file data for post processing"""

    with open(output_file, 'r') as file:
        data = file.read()
    return data


def analyse_output_data(output_data, morph_input):
    output_data = output_data.strip().split(" ")
    combine_data = []
    print(output_data, morph_input)
    for i in range(len(output_data)):
        morph_input_list = list(morph_input[i])
        morph_input_list[1] = output_data[i]
        combine_data.append(tuple(morph_input_list))
    return combine_data


def change_gender(current_gender):
    """
    >>> change_gender('m')
    'f'
    >>> change_gender('f')
    'm'
    """
    return 'f' if current_gender == 'm' else 'm'


def create_agreement_map(index_row, dependency_data):
    """
    >>> create_agreement_map()

    """


def handle_unprocessed_all(outputData, processed_nouns):
    """swapping gender info that does not exist in dictionary."""
    output_data = outputData.strip().split(" ")
    has_changes = False
    reprocess_list = []
    dataIndex = 0  # temporary [to know index value of generated word from sentence]
    for data in output_data:
        dataIndex = dataIndex + 1
        if data[0] == '#':
            for i in range(len(processed_nouns)):
                if round(processed_nouns[i][0]) == dataIndex:
                        if processed_nouns[i][7] != 'proper':
                            temp = list(processed_nouns[i])
                            temp[4] = change_gender(processed_nouns[i][4])
                            #temp[4] = 'f' if processed_nouns[i][4] == 'm' else 'm'
                            reprocess_list.append(['n', i, processed_nouns[i][0],temp[4], temp[7]])
                            processed_nouns[i] = tuple(temp)
                            has_changes = True
                            log(f'{temp[1]} reprocessed as noun with new gen:{temp[4]}.')
    return has_changes, reprocess_list, processed_nouns


def handle_unprocessed(outputData, processed_nouns):
    """swapping gender info that does not exist in dictionary."""
    output_data = outputData.strip().split(" ")
    has_changes = False
    dataIndex = 0  # temporary [to know index value of generated word from sentence]
    for data in output_data:
        dataIndex = dataIndex + 1
        if data[0] == '#':
            for i in range(len(processed_nouns)):
                ind = round(processed_nouns[i][0])
                if round(processed_nouns[i][0]) == dataIndex:
                    if processed_nouns[i][7] not in ('proper','NC','CP_noun', 'abs', 'vn'):
                    #if not processed_nouns[i][7] == 'proper' and not processed_nouns[i][7] == 'NC' and not processed_nouns[i][7] == 'CP_noun':
                        has_changes = True
                        temp = list(processed_nouns[i])
                        temp[4] = 'f' if processed_nouns[i][4] == 'm' else 'm'
                        processed_nouns[i] = tuple(temp)
                        log(f'{temp[1]} reprocessed as noun with gen:{temp[4]}.')
    return has_changes, processed_nouns


def join_indeclinables(transformed_data, processed_indeclinables, processed_others):
    """Joins Indeclinable data with transformed data and sort it by index number."""
    return sorted(transformed_data + processed_indeclinables + processed_others)

def nextNounData_fromFullData(fromIndex, PP_FullData):
    index = fromIndex
    for data in PP_FullData:
        if data[0] > index:
            if data[2] == 'n':
                return data

    return ()
def nextNounData(fromIndex, word_info):
    #for NC go till NC_head and return that tuple
    index = fromIndex
    for i in range(len(word_info)):
        for data in word_info:
            if index == data[0]:
                if data[3] != '' and index != fromIndex:
                    return data
                if ':' in data[4]:
                    index = int(data[4][0])
    return False

def masked_postposition(processed_words, words_info, processed_verbs):
    '''Calculates masked postposition to words wherever applicable according to rules.'''
    masked_PPdata = {}

    for data in processed_words:
        if data[2] not in ('p', 'n', 'other'):
            continue
        data_info = getDataByIndex(data[0], words_info)
        try:
            data_case = False if data_info == False else data_info[4].split(':')[1].strip()
        except IndexError:
            data_case = False
        ppost = ''
        ppost_value = '<>'
        if data_case in ('k1', 'pk1'):
            if findValue('yA', processed_verbs, index=6)[0]:  # has TAM "yA"
                if findValue('k2', words_info, index=4)[0]: # or findExactMatch('k2p', words_info, index=4)[0]:
                    ppost = ppost_value
        elif data_case in ('r6', 'k3', 'k5', 'k5prk', 'k4', 'k4a', 'k7t', 'jk1','k7', 'k7p','k2g', 'k2','rsk', 'ru' ):
            ppost = ppost_value
        elif data_case == 'krvn' and data_info[2] == 'abs':  #abstract noun as adverb
            ppost = ppost_value
        elif data_case in ('k2g', 'k2') and data_info[2] in ("anim", "per"):
            ppost = ppost_value #'ko'
        elif data_case in ('rsm', 'rsma'):
            ppost = ppost_value+ ' ' + ppost_value #ke pAsa
        elif data_case == 'rt':
            ppost = ppost_value+ ' ' + ppost_value #'ke lie'
        elif data_case == 'rv':
            ppost = ppost_value+ ' ' + ppost_value + ' ' + ppost_value#'kI tulanA meM'
        elif data_case == 'r6':
            ppost = ppost_value # 'kI' if data[4] == 'f' else 'kA'
            nn_data = nextNounData(data[0], words_info)
            if nn_data != False:
                #print('Next Noun data:', nn_data)
                if nn_data[4].split(':')[1] in ('k3', 'k4', 'k5', 'k7', 'k7p', 'k7t', 'mk1', 'jk1', 'rt'):
                    ppost = ppost_value
                elif nn_data[3][1] != 'f' and nn_data[3][3] == 'p':
                    ppost = ppost_value#'ke'
                else:
                    pass
        else:
            pass
        if data[2] == 'p':
            temp = list(data)
            temp[7] = ppost if ppost != '' else 0
            data = tuple(temp)
        if data[2] == 'n' or data[2] == 'other':
            temp = list(data)
            temp[8] = ppost if ppost != '' else None
            data = tuple(temp)
            masked_PPdata[data[0]] = ppost
    return masked_PPdata

def fetchNextWord(index, words_info):
    next_word = ''
    for data in words_info:
        if index == data[0]:
            next_word = clean(data[1])

    return next_word

def process_dep_k2g(data_case, main_verb):
    verb = identify_main_verb(main_verb[1])
    if verb in kisase_k2g_verbs:
        ppost = 'se'
    else:
        ppost = 'ko'
    return ppost

def update_ppost_dict(data_index, param):
    if data_index in processed_postpositions_dict:
        processed_postpositions_dict[data_index] = param

def postposition_finalization(processed_nouns, processed_pronouns, words_info):
    for data in words_info:
        data_index = data[0]
        dep = data[4].strip().split(':')[1]
        head = data[4].strip().split(':')[0]

        if dep == 'r6':
            for noun in processed_nouns:
                index = noun[0]
                case = noun[3]
                if head == str(index) and case == 'o':
                    update_ppost_dict(data_index, 'ke')

            for pronoun in processed_pronouns:
                index = noun[0]
                case = noun[3]
                if head == str(index) and case == 'o':
                    update_ppost_dict(data_index, 'ke')

def get_main_verb(term):
    ''' return main verb from a term'''

    pass

def find_match_with_same_head(term, words_info, data_head, index):
    for dataele in words_info:
        dataele_index = dataele[0]
        dep_head = dataele[index].strip().split(':')[0]
        dep_value = dataele[index].strip().split(':')[1]
        if data_head == dep_head and term == dep_value:
            return True, dataele_index
    return False, -1

def preprocess_postposition_new(concept_type, np_data, words_info, main_verb):
    '''Calculates postposition to words wherever applicable according to rules.'''
    cp_verb_list = ['prayAsa+kara']
    root_main = main_verb[1].strip().split('-')[0].split('_')[0]
    if np_data != ():
        data_case = np_data[4].strip().split(':')[1]
        data_head = np_data[4].strip().split(':')[0]
        data_index = np_data[0]
        data_seman = np_data[2]
    ppost = ''
    new_case = 'o'
    if data_case in ('k1', 'pk1'):
        if is_tam_ya(main_verb): # has TAM "yA" or "yA_hE" or "yA_WA" marA WA
            k2exists, k2_index = find_match_with_same_head('k2', words_info, data_head, index=4) # or if CP_present, then also ne - add #get exact k2, not k2x
            vk2exists, vk2_index = find_match_with_same_head('vk2', words_info, data_head, index=4)
            if k2exists:
                ppost = 'ne'
                if is_CP(main_verb[1]):
                    cp_parts = main_verb[1].strip().split('+')
                    clean_cp_term = ''
                    for part in cp_parts:
                        part = part.split("-")[0]
                        clean_cp_term = clean_cp_term + clean(part) + '+'
                    clean_cp_term = clean_cp_term[0:-1]
                    if clean_cp_term in cp_verb_list:
                        update_additional_words_dict(k2_index, 'after', 'kA')

            elif vk2exists:
                ppost = 'ne'
            else:
                ppost = ''
                log('Karma k2 not found. Output may be incorrect')

        elif identify_complete_tam_for_verb(main_verb[1]) in nA_list:
        #elif findValue('nA', verbs_data, index=6)[0]: #tam in (nA_list):
            ppost = 'ko'
        else:
            log('inside tam ya else')
            #new_case = 'd'

    elif data_case == 'k2g':
        ppost = process_dep_k2g(data_case, main_verb)
    elif data_case == 'k2': #if CP present, and if concept is k2 for verb of CP, and the verb is not in specific list, then kA
        if data_seman in ("anim", "per"):
            if clean(root_main) in kisase_k2_verbs:
                ppost = 'se'
            else:
                ppost = 'ko'
        else:
            new_case = 'd'

    elif data_case == 'k2p':
        ppost = '' # modified from meM 22/06
    elif data_case in ('k3', 'k5', 'k5prk'):
        ppost = 'se'
    elif data_case in ('k4', 'k4a', 'k7t', 'jk1'):
        ppost = 'ko'
    elif data_case == 'k7p':
        ppost = 'meM'
    elif data_case =='k7':
        ppost = 'para'
    elif data_case == 'krvn' and data_seman == 'abs':
        ppost = 'se'
    elif data_case == 'rt':
        ppost = 'ke lie'
    elif data_case in ('rsm', 'rsma'):
        ppost = 'ke pAsa'
    elif data_case == 'rhh':
        ppost = 'ke'
    elif data_case == 'rsk':
        ppost = 'hue'
    elif data_case == 'rn':
        ppost = 'meM'
    elif data_case == 'rib':
        ppost = 'se'
    elif data_case == 'ru':
        # next_word_info = getDataByIndex(data_index+1, words_info)
        # if next_word_info != ():
        #     gnp_info = next_word_info[3].strip().strip('][')
        #     if gnp_info == 'comper_more' or gnp_info == 'comper_less':
        #         ppost = ''
        # else:
        ppost = 'jEsI'
    elif data_case == 'rkl':
        next_word = fetchNextWord(data_index + 1, words_info)
        if next_word == 'bAxa':
            ppost = 'ke'
        elif next_word == 'pahale':
            ppost = 'se'

    elif data_case == 'rdl':
        next_word = fetchNextWord(data_index + 1, words_info)
        if next_word in ('anxara', 'bAhara', 'Age', 'sAmane', 'pICe', 'Upara', 'nIce', 'xAyeM',
                         'bAyeM', 'cAroM ora', 'bIca', 'pAsa'):
            ppost = 'ke'
        elif next_word == 'xUra':
            ppost = 'se'

    elif data_case == 'rv':
        ppost = 'se'
    elif data_case == 'rh':
        ppost = 'ke_kAraNa'
    elif data_case == 'rd':
        ppost = 'kI ora'
    elif 'rask' in data_case:
        ppost = 'ke sAWa'
    elif data_case == 'r6':
        ppost = 'kA' #if data[4] == 'f' else 'kA'
        nn_data = nextNounData(data_index, words_info)
        if nn_data != False:
            #print('Next Noun data:', nn_data)
            if nn_data[4].split(':')[1] in ('k3', 'k4', 'k5', 'k7', 'k7p', 'k7t', 'r6', 'mk1', 'jk1', 'rt'):
                ppost = 'ke'
                if nn_data[3][2] == 's':#agreement with gnp
                    if nn_data[3][1] == 'f':
                        ppost = 'kI'
                    else:
                        ppost = 'kA'
                else:
                    pass
    else:
        pass
    # update postposition and case for the term
    if ppost == '':
        new_case = 'd'

    if concept_type == 'noun':
        if ppost == '':
            ppost = None
        #Update the post position dict for all nouns
        processed_postpositions_dict[data_index] = ppost

    if concept_type == 'pronoun':
        if ppost == '':
            ppost = 0
        # Update the post position dict for all pronouns
        processed_postpositions_dict[data_index] = ppost

    return new_case, ppost

def collect_hindi_output(source_text):
    """Take the output text and find the hindi text from it."""

    hindi_format = WXC(order="wx2utf", lang="hin")
    generate_hindi_text = hindi_format.convert(source_text)
    return generate_hindi_text
#         previndex = data[0]
#         prevword = data[1]
#
#     return resultant_data

def join_compounds(transformed_data, construction_data):
    '''joins compound words without spaces'''
    resultant_data = []
    prevword = ''
    previndex = -1

    for data in sorted(transformed_data):
        if (data[0]) == previndex and data[2] == 'n':
            temp = list(data)
            temp[1] = prevword + ' ' + temp[1]
            data = tuple(temp)
            resultant_data.pop()
        resultant_data.append(data)
        previndex = data[0]
        prevword = data[1]

    return resultant_data

def add_postposition(transformed_fulldata, processed_postpositions):
    '''Adds postposition to words wherever applicable according to rules.'''
    PPFulldata = []

    for data in transformed_fulldata:
        index = data[0]
        if index in processed_postpositions:
            temp = list(data)
            ppost = processed_postpositions[index]
            if ppost != None and (temp[2] == 'n' or temp[2] == 'other'):
                temp[1] = temp[1] + ' ' + ppost
            data = tuple(temp)
        PPFulldata.append(data)

    return PPFulldata

def add_spkview(full_data, spkview_dict):
    transformed_data = []
    for data in full_data:
        index = data[0]
        if index in spkview_dict:
            temp = list(data)
            spkview_info = spkview_dict[index]
            for info in spkview_info:
                tag = info[0]
                val = info[1]
                if tag == 'before':
                    temp[1] = val + ' ' + temp[1]
                elif tag == 'after':
                    temp[1] = temp[1] + ' ' + val
                data = tuple(temp)
        transformed_data.append(data)

    return transformed_data

def add_GNP(full_data, GNP_dict):
    transformed_data = []
    for data in full_data:
        index = data[0]
        if index in GNP_dict:
            temp = list(data)
            term = GNP_dict[index]
            for t in term:
                tag = t[0]
                val = t[1]
                if tag == 'before':
                    temp[1] = val + ' ' + temp[1]
                else:
                    temp[1] = temp[1] + ' ' + val
            data = tuple(temp)
        transformed_data.append(data)

    return transformed_data

def add_construction(transformed_data, construction_dict):
    Constructdata = []

    for data in transformed_data:
        index = data[0]
        if index in construction_dict:
            temp = list(data)
            term = construction_dict[index]
            for t in term:
                tag = t[0]
                val = t[1]
                if tag == 'before':
                    temp[1] = val + ' ' + temp[1]
                else:
                    if val == ',':
                        temp[1] = temp[1] + val
                    else:
                        temp[1] = temp[1] + ' ' +val
            data = tuple(temp)
        Constructdata.append(data)

    return Constructdata

def add_additional_words(additional_words_dict, processed_data):
    additionalData = []

    for data in processed_data:
        index = data[0]
        if index in additional_words_dict:
            temp = list(data)
            term = additional_words_dict[index]
            for t in term:
                tag = t[0]
                val = t[1]
                if tag == 'before':
                    temp[1] = val + ' ' + temp[1]
                else:
                    temp[1] = temp[1] + ' ' + val
            data = tuple(temp)
        additionalData.append(data)

    return additionalData


def rearrange_sentence(fulldata):
    '''Function comments'''
    finalData = sorted(fulldata)
    final_words = [x[1].strip() for x in finalData]
    return " ".join(final_words)


def write_hindi_text(hindi_output, POST_PROCESS_OUTPUT, OUTPUT_FILE):
    """Append the hindi text into the file"""
    with open(OUTPUT_FILE, 'w') as file:
        file.write(POST_PROCESS_OUTPUT)
        file.write('\n')
        file.write(hindi_output)
        log('Output data write successfully')
    return "Output data write successfully"

def write_hindi_test(hindi_output, POST_PROCESS_OUTPUT, src_sentence, OUTPUT_FILE, path):
    """Append the hindi text into the file"""
    OUTPUT_FILE = 'TestResults.csv'# temporary for presenting
    str = path.strip('verified_sent/')
    if str == '1':
        with open(OUTPUT_FILE, 'w') as file:
            file.write("")

    with open(OUTPUT_FILE, 'a') as file:
        file.write(path.strip('../hindi_gen/lion_story') + '\t')
        file.write(src_sentence.strip('"').strip('\n').strip('#') + '\t')
        file.write(POST_PROCESS_OUTPUT + '\t')
        file.write(hindi_output + '\t')
        file.write('\n')
        log('Output data write successfully')
    return "Output data write successfully"

def write_masked_hindi_test(hindi_output, POST_PROCESS_OUTPUT, src_sentence, masked_data, OUTPUT_FILE, path):
    """Append the hindi text into the file"""
    OUTPUT_FILE = 'TestResults_masked.csv'  # temporary for presenting
    with open(OUTPUT_FILE, 'a') as file:
        file.write(path.strip('verified_sent/') + ',')
        file.write(src_sentence.strip('#') + ',')
        file.write(POST_PROCESS_OUTPUT + ',')
        file.write(hindi_output + ',')
        file.write(masked_data)
        file.write('\n')
        log('Output data write successfully')
    return "Output data write successfully"


if __name__ == '__main__':
    import doctest
    doctest.run_docstring_examples(identify_complete_tam_for_verb, globals())
