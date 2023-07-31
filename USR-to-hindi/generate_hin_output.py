from common import *
HAS_CONSTRUCTION_DATA = False
HAS_SPKVIEW_DATA = False
ADD_GNP_DATA = False
HAS_DISCOURSE_DATA = False
HAS_ADDITIONAL_WORDS = False


if __name__ == "__main__":
    log("Program Started", "START")

    # Reading filename as command-line argument
    try:
        path = sys.argv[1]
    except IndexError:
        log("No argument given. Please provide path for input file as an argument.", "ERROR")
        sys.exit()


    file_data = read_file(path) #Reading USR
    rules_info = generate_rulesinfo(file_data) #Extracting Rules from each row of USR

    # Extracting Information
    src_sentence = rules_info[0]
    root_words = rules_info[1]
    index_data = [int(x) for x in rules_info[2]]
    seman_data = rules_info[3]
    gnp_data = rules_info[4]
    depend_data = rules_info[5]
    discourse_data = rules_info[6]
    spkview_data = rules_info[7]
    scope_data = rules_info[8]
    sentence_type = rules_info[9]
    construction_data = ''
    if len(rules_info) > 10 and rules_info[10] != '':
        if 'speaker not found in dictionary' in rules_info[10]:
            construction_data = ''
        else:
            HAS_CONSTRUCTION_DATA = True
            construction_data = rules_info[10]

    if spkview_data != [] or len(spkview_data) > 0:
        HAS_SPKVIEW_DATA = populate_spkview_dict(spkview_data)

    if discourse_data != [] or len(discourse_data) > 0:
        HAS_DISCOURSE_DATA = True


    # Making a collection of words and its rules as a list of tuples.
    words_info = generate_wordinfo(root_words, index_data, seman_data,
                                   gnp_data, depend_data, discourse_data, spkview_data, scope_data)

    # Categorising words as Nouns/Pronouns/Adjectives/..etc.
    indeclinables_data, pronouns_data, nouns_data, adjectives_data, verbs_data, adverbs_data, others_data, nominal_forms_data = analyse_words(
        words_info)
    #  Processing Stage
    processed_indeclinables = process_indeclinables(indeclinables_data)
    processed_nouns = process_nouns(nouns_data, words_info, verbs_data)
    processed_pronouns = process_pronouns(pronouns_data, processed_nouns, processed_indeclinables, words_info,
                                          verbs_data)
    # if sentence_type in ('imperative', 'Imperative', 'neg-imperative'):
    #     processed_pronouns = process_imp_sentence(words_info, processed_pronouns)

    processed_others = process_others(others_data)
    processed_verbs, processed_auxverbs = process_verbs(verbs_data, seman_data, depend_data, sentence_type, spkview_data,processed_nouns, processed_pronouns, False)
    processed_adjectives = process_adjectives(adjectives_data, processed_nouns, processed_verbs)
    process_adverbs(adverbs_data, processed_nouns, processed_verbs, processed_others, reprocessing=False)
    process_nominal_form = process_nominal_verb(nominal_forms_data, processed_nouns, words_info, verbs_data)
    postposition_finalization(processed_nouns, processed_pronouns, words_info)
    if len(additional_words_dict) > 0:
        HAS_ADDITIONAL_WORDS = True

    # Todo : extract nouns / adjectives from Compound verbs with +
    # Todo : process nouns / adjectives got from verbs and add to processed_noun / processed_adjectives

    # processing postpositions for pronouns and nouns only
    # processed_pronouns, pp_pronouns = preprocess_postposition_new(processed_pronouns, words_info, processed_verbs) # to get parsarg
    # positions = pp_nouns | pp_pronouns #merging postpositions of nouns and pronouns in single dict

    # Every word is collected into one and sorted by index number.
    processed_words = collect_processed_data(processed_pronouns,processed_nouns,processed_adjectives,
                                            processed_verbs, processed_auxverbs,processed_indeclinables, processed_others)


    # calculating postpositions for words if applicable.
    # processed_words, processed_postpositions = preprocess_postposition_new(processed_words, words_info,processed_verbs)
    if HAS_CONSTRUCTION_DATA:
        processed_words = process_construction(processed_words, construction_data, depend_data, gnp_data, index_data)

    # Input for morph generator is generated and fed into it.
    # Generator outputs the result in a file named morph_input.txt-out.txt
    OUTPUT_FILE = generate_morph(processed_words)

    # Re-processing Stage
    # Output from morph generator is read.
    outputData = read_output_data(OUTPUT_FILE)
    # Check for any non-generated words (mainly noun) & change the gender for non-generated words
    #has_changes, reprocess_list, processed_nouns = handle_unprocessed_all(outputData, processed_nouns)
    #print(reprocess_list)
    has_changes, processed_nouns = handle_unprocessed(outputData, processed_nouns)

    # handle unprocessed_verbs also with verb agreement
    # If any changes is done in gender for any word.
    # Adjectives and verbs are re-processed as they might be dependent on it.
    if has_changes:
        # Reprocessing adjectives and verbs based on new noun info
        processed_verbs, processed_auxverbs = process_verbs(verbs_data, seman_data, depend_data, sentence_type, spkview_data, processed_nouns, processed_pronouns, True)
        processed_adjectives = process_adjectives(adjectives_data, processed_nouns, processed_verbs)
        process_adverbs(adverbs_data, processed_nouns, processed_verbs, processed_others, reprocessing=True)

        # Sentence is generated again
        processed_words = collect_processed_data(processed_pronouns, processed_nouns,  processed_adjectives, processed_verbs,processed_auxverbs,processed_indeclinables,processed_others)
        if HAS_CONSTRUCTION_DATA:
            processed_words = process_construction(processed_words, construction_data, depend_data, gnp_data,index_data)
        OUTPUT_FILE = generate_morph(processed_words)

    # Post-Processing Stage
    outputData = read_output_data(OUTPUT_FILE)
    # generated words and word-info data is combined #pp data not yet added
    transformed_data = analyse_output_data(outputData, processed_words)

    # compound words and post-positions are joined.
    transformed_data = join_compounds(transformed_data, construction_data)

    #post-positions are joined.
    PP_fulldata = add_postposition(transformed_data, processed_postpositions_dict)
    #construction data is joined
    if HAS_CONSTRUCTION_DATA:
        PP_fulldata = add_construction(PP_fulldata, construction_dict)

    if HAS_SPKVIEW_DATA:
        PP_fulldata = add_spkview(PP_fulldata, spkview_dict)

    ADD_GNP_DATA = populate_GNP_dict(gnp_data, PP_fulldata)
    if ADD_GNP_DATA:
        PP_fulldata = add_GNP(PP_fulldata, GNP_dict)

    if HAS_ADDITIONAL_WORDS:
        PP_fulldata = add_additional_words(additional_words_dict, PP_fulldata)

    POST_PROCESS_OUTPUT = rearrange_sentence(PP_fulldata)  # reaarange by index number

    if has_ques_mark(sentence_type):
        POST_PROCESS_OUTPUT = POST_PROCESS_OUTPUT + ' ?'

    if HAS_DISCOURSE_DATA:
        POST_PROCESS_OUTPUT = add_discourse_elements(discourse_data, POST_PROCESS_OUTPUT)

    # for yn_interrogative add kya in the beginning
    if sentence_type in ("yn_interrogative","yn_interrogative_negative", "pass-yn_interrogative"):
        POST_PROCESS_OUTPUT = 'kyA ' + POST_PROCESS_OUTPUT

    if sentence_type in ('affirmative', 'Affirmative', 'negative', 'Negative', 'imperative', 'Imperative'):
        POST_PROCESS_OUTPUT = POST_PROCESS_OUTPUT + ' |'

    hindi_output = collect_hindi_output(POST_PROCESS_OUTPUT)
    #next line for single line input
    write_hindi_text(hindi_output, POST_PROCESS_OUTPUT, OUTPUT_FILE)

    # next line code for bulk generation of results. All results are collated in test.csv. Run sh test.sh
    #write_hindi_test(hindi_output, POST_PROCESS_OUTPUT, src_sentence, OUTPUT_FILE, path)

    #for masked input -uncomment the following:
    masked_pup_list = masked_postposition(processed_words, words_info, processed_verbs)
    masked_pp_fulldata = add_postposition(transformed_data, masked_pup_list)
    arranged_masked_output = rearrange_sentence(masked_pp_fulldata)
    masked_hindi_data = collect_hindi_output(arranged_masked_output)
    write_masked_hindi_test(hindi_output, POST_PROCESS_OUTPUT, src_sentence, masked_hindi_data, OUTPUT_FILE, path)