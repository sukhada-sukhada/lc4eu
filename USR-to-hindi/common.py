import os
import sys
import re
import subprocess
import constant
from wxconv import WXC

from verb import Verb
from concept import Concept


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


# function to run morph analyzer and get gnp
def find_tags_from_dix(word):
    """
    >>> find_tags_from_dix("mAz")
    {'cat': 'n', 'case': 'd', 'gen': 'f', 'num': 'p', 'form': 'mA'}
    """
    dix_command = "echo {} | apertium-destxt | lt-proc -ac hi.morfLC.bin | apertium-retxt".format(word)
    morph_forms = os.popen(dix_command).read()
    return parse_morph_tags(get_first_form(morph_forms))


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
        Index should be first elememt of tuples.
        Return False when index not found.'''
    try:
        res = False
        for dataele in searchList:
            if int(dataele[index]) == value:
                res = dataele
    except IndexError:
        log(f'Index out of range while searching index:{value} in {searchList}', 'WARNING')
        return False
    return res


def findValue(value: int, searchList: list, index=0):
    '''search and return data by index in an array of tuples.
        Index should be first element of tuples.

        Return False when index not found.'''

    try:
        for dataele in searchList:
            if value in dataele[index]:
                return (True, dataele)
    except IndexError:
        log(f'Index out of range while searching index:{value} in {searchList}', 'WARNING')
        return (False, None)
    return (False, None)


def getVerbGNP(tam, depend_data, processed_nouns, processed_pronouns):
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


def verb_agreement(concept, verb):
    """
    get index of verb from processed verb list
    get index of corresponding
    """
    concept[4] = verb[4]
    concept[4] = verb[4]
    concept[4] = verb[4]
    return concept, verb  # not sure what to return


def setGNP(concept, verb):# returns GNP only if Complex predicate found
    if concept[7] == 'CP_noun':
        return list(verb[:4]) + concept[4:7] + ['']


def read_file(file_path):
    '''Returns array of lines for data given in file'''

    log(f'File ~ {file_path}')
    try:
        with open(file_path, 'r') as file:
            data = file.read().splitlines()
            log('File data read.')
    except FileNotFoundError:
        log('No such File found.', 'ERROR')
        sys.exit()
    return data


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

    log('Rules Info extracted succesfully fom USR.')
    return [src_sentence, root_words, index_data, seman_data, gnp_data, depend_data, discourse_data, spkview_data,
            scope_data, sentence_type]


def generate_wordinfo(root_words, index_data, seman_data, gnp_data, depend_data, discourse_data, spkview_data,
                      scope_data):
    '''Generates an array of tuples comntaining word and its USR info.
        USR info word wise.'''
    return list(
        zip(index_data, root_words, seman_data, gnp_data, depend_data, discourse_data, spkview_data, scope_data))


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


def check_noun(word_data):
    '''Check if word is a noun by the USR info'''

    try:
        if word_data[3] != '':
            if word_data[3][1:-1] not in ('superl', 'stative', 'causative'):
                return True
        return False
    except IndexError:
        log(f'Index Error for GNP Info. Checking noun for {word_data[1]}', 'ERROR')
        sys.exit()


def check_pronoun(word_data):
    '''Check if word is a pronoun by the USR info'''

    try:
        if clean(word_data[1]) in (
                'addressee', 'speaker', 'kyA', 'Apa', 'jo', 'koI', 'kOna', 'mEM', 'saba', 'vaha', 'wU', 'wuma', 'yaha'):
            return True
        elif 'coref' in word_data[5]:
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
    return False


def check_nonfinite_verb(word_data):
    '''Check if word is a non-fininte verb by the USR info'''

    if word_data[4] != '':
        rel = word_data[4].strip().split(':')[1]
        if rel in ('rpk','rbk'):
            return True
    return False


def check_verb(word_data): #update
    '''Check if word is a verb by the USR info'''
    #
    if '-' in word_data[1]:
        rword = word_data[1].split('-')[0]
        if rword in extract_tamdict_hin():
            return True
        else:
            log(f'Verb "{rword}" not found in TAM dictionary', 'WARNING')
            return True
    return False


def check_indeclinable(word_data):
    """ Check if word is in indeclinable word list."""

    indeclinable_words = (
        'aBI,waWA,Ora,paranwu,kinwu,evaM,waWApi,Bale hI,'
        'wo,agara,magara,awaH,cUMki,cUzki,jisa waraha,'
        'jisa prakAra,lekina,waba,waBI,yA,varanA,anyaWA,'
        'wAki,baSarweM,jabaki,yaxi,varana,paraMwu,kiMwu,'
        'hAlAzki,hAlAMki,va,Aja,nahIM'  # added nahiM as indec by Kirti.garg@gmail.com Dec 16
    )
    indeclinable_list = indeclinable_words.split(",")
    if clean(word_data[1]) in indeclinable_list:
        return True
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
    nonfinite = []
    for word_data in words_list:
        if check_indeclinable(word_data):
            log(f'{word_data[1]} identified as indiclinable.')
            indeclinables.append(word_data)
        elif check_pronoun(word_data):
            log(f'{word_data[1]} identified as pronoun.')
            pronouns.append(word_data)
        elif check_noun(word_data):
            log(f'{word_data[1]} identified as noun.')
            nouns.append(word_data)
        elif check_adjective(word_data):
            log(f'{word_data[1]} identified as adjective.')
            adjectives.append(word_data)
        elif check_nonfinite_verb(word_data):  # will behave like indeclinable. So add verb+kara and add to nonfinite list
            log(f'{word_data[1]} identified as non-finite verb.')
            nonfinite.append(word_data)
        elif check_verb(word_data):
            log(f'{word_data[1]} identified as verb.')
            verbs.append(word_data)
        else:
            log(f'{word_data[1]} identified as other word, but processed as noun with default GNP.')  # treating other words as noun
            # others.append(word_data) #modification by Kirti on 12/12 to handle other words
            nouns.append(word_data)
    return indeclinables, pronouns, nouns, adjectives, verbs, nonfinite, others

def process_nonfinite_verbs(nonfinite_list):
    '''
    >>> process_nonfinite_verbs([(3, 'jA_1', '', '', '5:rpk', '', '', '')])
    ('3, jAkara', 'nonfinite')
    '''
    processed_nonfinite_verbs = []
    for nonfinite in nonfinite_list:
        nonfinite_form = clean(nonfinite[1]) + 'kara'
        processed_nonfinite_verbs.append((nonfinite[0], nonfinite_form, 'nonfinite'))
        log(f'{nonfinite[1]} processed as nonfinite verb with form:{nonfinite_form} ')
    return processed_nonfinite_verbs

def process_indeclinables(indeclinables):
    '''Processes indeclinable words'''

    processed_indeclinables = []
    for indec in indeclinables:
        processed_indeclinables.append((indec[0], clean(indec[1]), 'indec'))
    return processed_indeclinables


def process_others(other_words):
    '''Process other words. Right now being processed as noun with default gnp'''

    processed_others = []
    for word in other_words:
        gender = 'm'
        number = 's'
        person = 'a'
        processed_others.append((word[0], clean(word[1]), 'other', gender, number, person))
    return processed_others


def extract_gnp(gnp_info):
    '''Extract GNP info from string format to tuple (gender,number,person) format.'''
    gnp_data = gnp_info.strip('][').split(' ')
    if len(gnp_data) != 3:
        return 'm', 's', 'a'
    gender = 'm' if gnp_data[0].lower(
    ) == 'm' else 'f' if gnp_data[0].lower() == 'f' else 'm'
    number = 's' if gnp_data[1].lower(
    ) == 'sg' else 'p' if gnp_data[1].lower() == 'pl' else 's'
    person = 'a' if gnp_data[2] in ('-', '') else gnp_data[2]

    return gender, number, person


def process_pronouns(pronouns, processed_nouns):
    '''Process pronouns as (index, word, category, case, gender, number, person, parsarg, fnum)'''
    processed_pronouns = []
    for pronoun in pronouns:
        category = 'p'
        case = 'o'
        parsarg = 0
        fnum = None
        gender, number, person = extract_gnp(pronoun[3])
        if "k1" in pronoun[4] or 'dem' in pronoun[4]:
            if clean(pronoun[1]) in ('kOna', 'kyA', 'vaha', 'yaha') and pronoun[2] != 'per':
                #if findValue('yA', processed_verbs, index=6)[0]: TAM not 'yA'
                    case = "d"
        else:
            if "k2" in pronoun[4] and pronoun[2] in ('anim', 'per'):
                case = 'd'

        if pronoun[1] == 'addressee':
            addr_map = {'respect': 'Apa', 'informal': 'wU', '': 'wU'}
            pronoun_per = {'respect': 'm', 'informal': 'm_h0', '': 'm_h1'}
            word = addr_map.get(pronoun[6].strip().lower(), 'wU')
            person = pronoun_per.get(pronoun[6].strip().lower(), 'm_h1')
        elif pronoun[1] == 'speaker':
            word = 'mEM'
        elif pronoun[1] == 'vaha':
            word = 'vaha'
        else:
            word = clean(pronoun[1])

        # If dependency is r6 then add fnum and take gnp and case from following noun.
        if "r6" in pronoun[4]:
            fnoun = int(pronoun[4][0])
            fnoun_data = getDataByIndex(fnoun, processed_nouns, index=0)
            gender = fnoun_data[4]  # To-ask
            fnum = number = fnoun_data[5]
            case = fnoun_data[3]
        processed_pronouns.append((pronoun[0], word, category, case, gender, number, person, parsarg, fnum))
        log(f'{pronoun[1]} processed as pronoun with case:{case} par:{parsarg} gen:{gender} num:{number} per:{person} fnum:{fnum}')
    return processed_pronouns


def process_nouns(nouns):
    '''Process nouns as (index, word, category, case, gender, number, proper/noun type= proper or CP_noun, postposition)'''
    processed_nouns = []
    for noun in nouns:
        category = 'n'
        case = 'o'
        postposition = None
        gender, number, person = extract_gnp(noun[3])
        noun_type = 'common' if '_' in noun[1] else 'proper'
        proper = False if '_' in noun[1] else True
        if "k1" in noun[4]:
            case = "d"
        else:
            if "k2" in noun[4] and 'anim' not in noun[2]:
                case = 'd'

        # For Noun compound words
        if '+' in noun[1]:
            dnouns = noun[1].split('+')
            for k in range(len(dnouns)):
                index = noun[0] + (k * 0.1)
                noun_type = 'NC'
                processed_nouns.append((index, clean(dnouns[k]), category, case, gender, number, person, noun_type, postposition))
        else:
            processed_nouns.append((noun[0], clean(noun[1]), category, case, gender, number, person, noun_type, postposition))
        log(f'{noun[1]} processed as noun with case:{case} gen:{gender} num:{number} noun_type:{noun_type} postposition: {postposition}.')
    return processed_nouns


def process_adjectives(adjectives, processed_nouns):
    '''Process adjectives as (index, word, category, case, gender, number)
    '''
    processed_adjectives = []

    for adjective in adjectives:
        relnoun = int(adjective[4].strip().split(':')[0])
        relnoun_data = getDataByIndex(relnoun, processed_nouns)
        category = 'adj'
        if relnoun_data == False:
            log(f'Associated Noun not found for adjective {adjective[1]}.', 'ERROR')
            sys.exit()
        case = relnoun_data[3]
        gender = relnoun_data[4]
        number = relnoun_data[5]

        processed_adjectives.append((adjective[0], clean(adjective[1]), category, case, gender, number))
        log(f'{adjective[1]} processed as an adjective with case:{case} gen:{gender} num:{number}')
    return processed_adjectives

def is_complex_predicate(concept):
    return "+" in concept


def identify_case(verb, dependency_data, processed_nouns, processed_pronouns):
    return getVerbGNP(verb.tam, dependency_data, processed_nouns, processed_pronouns)


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

    tags = find_tags_from_dix(CP_term)  # getting tags from morph analyzer to assign gender and number for agreement
    if '*' not in tags['form']:
        gender = tags['gen']
        number = tags['num']

    #CP_noun = [CP_index, CP_term, 'n', 'd', 'm', 's', 'a', 'CP_noun', postposition]
    CP_noun = [CP_index, CP_term, 'n','d', gender, number, person, 'CP_noun', postposition]
    return CP_noun


def verb_agreement_with_CP(verb, CP):
    """
    >>> verb_agreement_with_CP(Verb(index=2, gender='m', number='s', person='a'), [1.9, 'varRA', 'n', 'd', 'f', 's', 'a', 'CP_noun', ''])
    ('f', 's', 'a')
    >>> verb_agreement_with_CP(Verb(index=2, gender='m', number='s', person='a'), [1.9, 'pAnI', 'n', 'd', 'm', 's', 'a', 'CP_noun', ''])
    ('m', 's', 'a')
    """
    if (verb.index - 0.1 == CP[0]) and CP[7] == "CP_noun":  # setting correspondence between CP noun and verb
        return CP[4], CP[5], CP[6]
    else:
        return verb.gender, verb.number, verb.person


def process_main_verb(concept: Concept, dependency_data, processed_nouns, processed_pronouns, reprocessing):
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
    verb.type = "main" if "main:0" in concept.dependency else "regular"
    verb.term = identify_main_verb(concept.term)
    verb.index = concept.index
    verb.tam = identify_default_tam_for_main_verb(concept.term)
    verb.tam = get_TAM(verb.term, verb.tam)
    verb.gender, verb.number, verb.person = getVerbGNP(verb.tam, dependency_data, processed_nouns, processed_pronouns)
    if reprocessing:
        verb.gender = 'm' if verb.gender == 'f' else 'f'
        log(f'{verb.term} reprocessed as verb with index {verb.index} gen:{verb.gender} num:{verb.number} per:{verb.person} in agreement with CP')
    elif is_CP(concept.term):
        CP = process_main_CP(concept.index, concept.term)
        log(f'{CP[1]} processed as noun with index {CP[0]} case:d gen:{CP[4]} num:{CP[5]} per:{CP[6]}, noun_type:{CP[7]}, default postposition:{CP[8]}.')
        processed_nouns.append(tuple(CP))
        verb.gender, verb.number, verb.person = verb_agreement_with_CP(verb, CP)
    return verb


def create_auxiliary_verb(index, term, main_verb: Verb):
    verb = Verb()
    verb.index = main_verb.index + (index + 1)/10
    verb.gender, verb.number, verb.person = main_verb.gender, main_verb.number, main_verb.person
    verb.term, verb.tam = auxmap_hin(term)
    return verb


def to_tuple(verb: Verb):
    return (verb.index, verb.term, verb.category, verb.gender, verb.number, verb.person, verb.tam)


def process_auxiliary_verbs(verb: Verb, concept_term: str) -> [Verb]:
    """
    >>> [to_tuple(aux) for aux in process_auxiliary_verbs(Verb(index=4, term = 'kara', gender='m', number='s', person='a', tam='hE'), concept_term='kara_17-0_sakawA_hE_1')]
    [(4.1, 'saka', 'v', 'm', 's', 'a', 'wA'), (4.2, 'hE', 'v', 'm', 's', 'a', 'hE')]
    """
    auxiliary_verb_terms = identify_auxillary_verb_terms(concept_term)
    return [create_auxiliary_verb(index, term, verb) for index, term in enumerate(auxiliary_verb_terms)]


def process_verb(concept: Concept, dependency_data, processed_nouns, processed_pronouns, reprocessing):
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
    verb = process_main_verb(concept, dependency_data, processed_nouns, processed_pronouns, reprocessing)
    auxiliary_verbs = process_auxiliary_verbs(verb, concept.term)
    return verb, auxiliary_verbs


def process_verbs_new(concepts: [tuple], depend_data, processed_nouns, processed_pronouns, processed_others, sentence_type, reprocess=False):
    processed_verbs = []
    processed_auxverbs = []
    for concept in concepts:
        concept = Concept(index=concept[0], term=concept[1], dependency=concept[5])
        verb, aux_verbs = process_verb(concept, depend_data, processed_nouns, processed_pronouns, reprocess)
        processed_verbs.append(to_tuple(verb))
        processed_auxverbs.extend([to_tuple(aux_verb) for aux_verb in aux_verbs])
    return processed_verbs, processed_auxverbs, []


def process_verbs(verbs, depend_data, processed_nouns, processed_pronouns, processed_others, sentence_type, reprocess=False):
    '''Process verbs as (index, word, category, gender, number, person, tam)'''
    processed_verbs = []
    processed_auxverbs = []
    aux_verbs = []
    is_GNP_identified = False
    for verb in verbs:
        if is_complex_predicate(verb[1]):
            exp_v = verb[1].split('+')
            if not reprocess:
                cp_word = clean(exp_v[0])  # handle CP
                processed_nouns.append(tuple([verb[0] - 0.1, cp_word, 'n', 'd', 'm','s','a', "CP_noun", '']))
                log(f'{cp_word} from CP, processed as noun with {verb[4]}, {verb[5]}, {verb[6]} after agreement')
            temp = list(verb)
            temp[1] = exp_v[1]
            verb = tuple(temp)
            gender = 'm'
            number = 's'
            person = 'a'
            is_GNP_identified = True  # CP_Noun verb agreement


        category = 'v'

        v = verb[1].split('-')
        root = clean(v[0])

        w = v[1].split('_')
        tam = w[0]

        for aux in w[1:]:
            if aux.isalpha():
                aux_verbs.append(aux)

        if not is_GNP_identified:
            gender, number, person = getVerbGNP(tam, depend_data, processed_nouns, processed_pronouns)
        if root == 'hE' and tam in ('pres', 'past'):  # process TAM
            alt_tam = {'pres': 'hE', 'past': 'WA'}
            alt_root = {'pres': 'hE', 'past': 'WA'}
            root = alt_root[tam]  # handling past tense by passing correct root WA
            tam = alt_tam[tam]
        # if sentence_type == 'imperative':   #added by Kirti to address imperative tams like KAo
        #    tam = 'imper'
        #    person = 'm_h1'
        # if depend_data[indexno] =='rsv'
        #    tam = 'we_huye'

        processed_verbs.append((verb[0], root, category, gender, number, person, tam))
        log(f'{root} processed as verb with gen:{gender} num:{number} per:{person} tam:{tam}')

        # Processing Auxillary verbs
        for i in range(len(aux_verbs)):
            aux_info = auxmap_hin(aux_verbs[i])
            if aux_info != False:
                aroot, atam = aux_info
                gender, number, person = getVerbGNP(tam, depend_data, processed_nouns, processed_pronouns)
                aindex = verb[0] + ((i + 1) * 0.1)
                processed_auxverbs.append((aindex, clean(aroot), category, gender, number, person, atam))
                log(f'{aroot} processed as auxillary verb with gen:{gender} num:{number} per:{person} tam:{atam}')

    return processed_verbs, processed_auxverbs, processed_others


def collect_processed_data(processed_pronouns, processed_nouns, processed_adjectives, processed_verbs,
                           processed_auxverbs, processed_indeclinables, processed_nonfinites,  processed_others):
    '''collect sort and return processed data.'''
    return sorted(
        processed_pronouns + processed_nouns + processed_adjectives + processed_verbs + processed_auxverbs + processed_indeclinables + processed_nonfinites+ processed_others)


def generate_input_for_morph_generator(input_data):
    """Process the input and generate the input for morph generator"""
    morph_input_data = []
    for data in input_data:
        if data[2] == 'p':
            if data[8] != None and isinstance(data[8], str):
                morph_data = f'^{data[1]}<cat:{data[2]}><parsarg:{data[7]}><fnum:{data[8]}><case:{data[3]}><gen:{data[4]}><num:{data[5]}><per:{data[6]}>$'
            else:
                morph_data = f'^{data[1]}<cat:{data[2]}><case:{data[3]}><parsarg:{data[7]}><gen:{data[4]}><num:{data[5]}><per:{data[6]}>$'
        elif data[2] == 'n' and data[7] == True:
            morph_data = f'{data[1]}'
        elif data[2] == 'n':
            morph_data = f'^{data[1]}<cat:{data[2]}><case:{data[3]}><gen:{data[4]}><num:{data[5]}>$'
        elif data[2] == 'v':
            morph_data = f'^{data[1]}<cat:{data[2]}><gen:{data[3]}><num:{data[4]}><per:{data[5]}><tam:{data[6]}>$'
        elif data[2] == 'adj':
            morph_data = f'^{data[1]}<cat:{data[2]}><case:{data[3]}><gen:{data[4]}><num:{data[5]}>$'
        elif data[2] == 'indec':
            morph_data = f'{data[1]}'
        elif data[2] == 'nonfinite':
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
    '''Run Morph generator'''
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
    new_gender = 'f' if current_gender == 'm' else 'm'
    return new_gender

def handle_unprocessed_all(outputData, processed_nouns):
    '''swapping gender info that does not exist in dictionary.'''
    output_data = outputData.strip().split(" ")
    has_changes = False
    reprocess_list = []
    dataIndex = 0  # temporary [to know index value of generated word from sentence]
    for data in output_data:
        dataIndex = dataIndex + 1
        if data[0] == '#':
            for i in range(len(processed_nouns)):
                if round(processed_nouns[i][0]) == dataIndex:
                    temp = list(processed_nouns[i])
                    temp[4] = change_gender(processed_nouns[i][4])
                    #temp[4] = 'f' if processed_nouns[i][4] == 'm' else 'm'
                    reprocess_list.append(['n', i, processed_nouns[i][0],temp[4], temp[7]])
                    processed_nouns[i] = tuple(temp)
                    has_changes = True
                    log(f'{temp[1]} reprocessed as noun with new gen:{temp[4]}.')
    return has_changes, reprocess_list, processed_nouns
def handle_unprocessed(outputData, processed_nouns):
    '''swapping gender info that does not exist in dictionary.'''
    output_data = outputData.strip().split(" ")
    has_changes = False
    dataIndex = 0  # temporary [to know index value of generated word from sentence]
    for data in output_data:
        dataIndex = dataIndex + 1
        if data[0] == '#':
            for i in range(len(processed_nouns)):
                if round(processed_nouns[i][0]) == dataIndex:
                    has_changes = True
                    temp = list(processed_nouns[i])
                    temp[4] = 'f' if processed_nouns[i][4] == 'm' else 'm'
                    processed_nouns[i] = tuple(temp)
                    log(f'{temp[1]} reprocessed as noun with gen:{temp[4]}.')
    return has_changes, processed_nouns


def join_indeclinables(transformed_data, processed_indeclinables, processed_others):
    '''Joins Indeclinable data with transformed data and sort it by index number.'''
    return sorted(transformed_data + processed_indeclinables + processed_others)


def nextNounData(fromIndex, word_info):
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
    #new_processed_words = []

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
                if findValue('k2', words_info, index=4)[0]: # or findValue('k2p', words_info, index=4)[0]:
                    ppost = ppost_value
        elif data_case in ('r6', 'k3', 'k5', 'K5prk', 'k4', 'k4a', 'k7t', 'jk1','k7', 'k7p' ,'k2g', 'k2','rsk', 'ru' ):
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
                if nn_data[4].split(':')[1] in ('k3', 'k4', 'k5', 'k7', 'k7p', 'k7t', 'r6', 'mk1', 'jk1', 'rt'):
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
    return  masked_PPdata

def preprocess_postposition(processed_words, words_info, processed_verbs):
    '''Calculates postposition to words wherever applicable according to rules.'''
    PPdata = {}
    new_processed_words = []
    for data in processed_words:
        if data[2] not in ('p', 'n', 'other'):
            new_processed_words.append(data)
            continue
        data_info = getDataByIndex(data[0], words_info)
        try:
            data_case = False if data_info == False else data_info[4].split(':')[1].strip()
        except IndexError:
            data_case = False
        ppost = ''
        if data_case in ('k1', 'pk1'):
            if findValue('yA', processed_verbs, index=6)[0]:  # has TAM "yA"
                if findValue('k2', words_info, index=4)[0]: # or findValue('k2p', words_info, index=4)[0]:
                    ppost = 'ne'
                    if data[2] != 'other':
                        temp = list(data)
                        temp[3] = 'o'
                        data = tuple(temp)
        elif data_case in ('k3', 'k5', 'K5prk'):
            ppost = 'se'
        elif data_case in ('k4', 'k4a', 'k7t', 'jk1'):
            ppost = 'ko'
        elif data_case in ('k7', 'k7p'):
            ppost = 'meM'
        elif data_case in 'k2' and data_info[2] in ("anim", "per"):
            ppost = 'ko'
        elif data_case == 'k2g' and data_info[2] == 'anim':
            ppost = 'se'
        elif data_case == 'rt':
            ppost = 'ke lie'
        elif data_case in ('rsm', 'rsma'):
            ppost = 'ke pAsa'
        elif data_case == 'rsk':
            ppost = 'hue'
        elif data_case == 'ru':
            ppost = 'jEsI'
        elif data_case == 'rv':
            ppost = 'kI tulanA meM'
        elif data_case == 'r6':
            ppost = 'kI' if data[4] == 'f' else 'kA'
            nn_data = nextNounData(data[0], words_info)
            if nn_data != False:
                print('Next Noun data:', nn_data)
                if nn_data[4].split(':')[1] in ('k3', 'k4', 'k5', 'k7', 'k7p', 'k7t', 'r6', 'mk1', 'jk1', 'rt'):
                    ppost = 'ke'
                elif nn_data[3][1] != 'f' and nn_data[3][3] == 'p':
                    ppost = 'ke'
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
            PPdata[data[0]] = ppost
        new_processed_words.append(data)
    return new_processed_words, PPdata


def process_postposition(transformed_fulldata, words_info, processed_verbs):
    '''Adds postposition to words wherever applicable according to rules.'''
    PPFulldata = []

    for data in transformed_fulldata:
        if data[2] not in ('p', 'n', 'other'):
            PPFulldata.append(data)
            continue
        data_info = getDataByIndex(data[0], words_info)
        try:
            data_case = False if data_info == False else data_info[4].split(':')[1].strip()
        except IndexError:
            data_case = False
        data = list(data)
        ppost = ''
        if data_case in ('k1', 'pk1'):
            if findValue('yA', processed_verbs, index=6)[0]:  # has TAM "yA"
                if findValue('k2', words_info, index=4)[0] or findValue('k2p', words_info, index=4)[0]:
                    ppost = 'ne'
        elif data_case in ('k3', 'k5'):
            ppost = 'se'
        elif data_case in ('k4', 'k7t', 'jk1'):
            ppost = 'ko'
        elif data_case in ('k7', 'k7p'):
            ppost = 'meM'
        elif (data_case == 'k2') and data_info[2] in ("anim", "per"):
            ppost = 'ko'
        elif data_case == 'rt':
            ppost = 'ke lie'
        elif data_case == 'r6':
            ppost = 'kI' if data[4] == 'f' else 'kA'
        else:
            pass
        if data[2] == 'p':
            data[7] = ppost if ppost != '' else 0
        if data[2] == 'n' or data[2] == 'other':
            data[1] = data[1] + ' ' + ppost
        PPFulldata.append(tuple(data))
    return PPFulldata


def join_compounds(transformed_data):
    '''joins compound words without spaces'''
    resultant_data = []
    prevword = ''
    previndex = -1
    for data in sorted(transformed_data):
        if int(data[0]) == previndex and data[2] == 'n':
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
            if temp[2] == 'n' or temp[2] == 'other':
                temp[1] = temp[1] + ' ' + ppost
            data = tuple(temp)
        PPFulldata.append(data)

    return PPFulldata


def rearrange_sentence(fulldata):
    '''Function comments'''
    finalData = sorted(fulldata)
    final_words = [x[1].strip() for x in finalData]
    return " ".join(final_words)


def collect_hindi_output(source_text):
    """Take the output text and find the hindi text from it."""

    hindi_format = WXC(order="wx2utf", lang="hin")
    generate_hindi_text = hindi_format.convert(source_text)
    return generate_hindi_text


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
    OUTPUT_FILE = 'TestResults.csv'  # temporary for presenting
    with open(OUTPUT_FILE, 'a') as file:
        file.write(path.strip('verified_sent/') + ',')
        file.write(src_sentence.strip('#') + ',')
        file.write(POST_PROCESS_OUTPUT + ',')
        #file.write(hindi_output)
        file.write(hindi_output + ',')
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
