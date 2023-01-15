from common import *

if __name__ == "__main__":
    log("Program Started", "START")

    # Reading filename as command-line argument
    try:
        path = sys.argv[1]
    except IndexError:
        log("No argument given. Please provide path for input file as an argument.", "ERROR")
        sys.exit()
    
    file_data = read_file(path) #Reading USR
    rules_info = generate_rulesinfo(file_data)    #Extracting Rules from each row of USR
    
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
    
    # Making a collection of words and its rules as a list of tuples.
    words_info = generate_wordinfo(root_words, index_data, seman_data, 
                    gnp_data, depend_data, discourse_data, spkview_data, scope_data)
    
    # Categorising words as Nound/Pronouns/Adjectives/..etc.
    indeclinables_data, pronouns_data, nouns_data, adjectives_data, verbs_data, nonfiniteverbs_data, others_data = analyse_words(words_info)
    
    #  Processing Stage
    processed_indeclinables = process_indeclinables(indeclinables_data)
    processed_nonfinites = process_nonfinite_verbs(nonfiniteverbs_data)
    processed_nouns = process_nouns(nouns_data)
    processed_pronouns = process_pronouns(pronouns_data,processed_nouns)
    processed_adjectives = process_adjectives(adjectives_data, processed_nouns)
    processed_others = process_others(others_data)
    processed_verbs, processed_auxverbs, processed_others = process_verbs(verbs_data, depend_data, processed_nouns, processed_pronouns, processed_others, sentence_type, False)
    
    # Todo : extract nouns / adjectives from Compound verbs with +
    # Todo : process nouns / adjectives got from verbs and add to processed_noun / processed_adjectives

    # processing postposition for pronouns only as it is required for parsarg info.
    processed_pronouns,_ = preprocess_postposition(processed_pronouns, words_info, processed_verbs) # to get parsarg

    # Every word is collected into one and sorted by index number.
    processed_words = collect_processed_data(processed_pronouns,processed_nouns,processed_adjectives,
                                            processed_verbs, processed_auxverbs,processed_indeclinables, processed_nonfinites, processed_others)
    
    # calculating postpositions for words if applicable.
    processed_words, processed_postpositions = preprocess_postposition(processed_words, words_info,processed_verbs)

    # Input for morph generator is generated and fed into it.
    # Generator outputs the result in a file named morph_input.txt-out.txt
    OUTPUT_FILE = generate_morph(processed_words)

    # Re-processing Stage
    # Output from morph generator is read.
    outputData = read_output_data(OUTPUT_FILE)
    # Check for any non-generated words (mainly noun) & change the gender for non-generated words
    has_changes, reprocess_list, processed_nouns = handle_unprocessed_all(outputData, processed_nouns)
    print(reprocess_list)
    #has_changes, processed_nouns = handle_unprocessed(outputData, processed_nouns)

    # handle unprocessed_verbs also with verb agreement
    
    # If any changes is done in gender for any word.
    # Adjectives and verbs are re-processed as they might be dependent on it.
    if has_changes:
        # Reprocessing adjectives and verbs based on new noun info
        processed_adjectives = process_adjectives(adjectives_data, processed_nouns)
        processed_verbs, processed_auxverbs, processed_others = process_verbs(verbs_data, depend_data, processed_nouns, processed_pronouns, processed_others, sentence_type, True)
        
        # Sentence is generated again
        processed_words = collect_processed_data(processed_pronouns,processed_nouns,processed_adjectives,processed_verbs,processed_auxverbs,processed_indeclinables,processed_nonfinites, processed_others)
        OUTPUT_FILE = generate_morph(processed_words)

    
    # Post-Processing Stage
    outputData = read_output_data(OUTPUT_FILE)
    # generated words and word-info data is combined #pp data not yet added
    transformed_data = analyse_output_data(outputData, processed_words)

    # compound words and post-positions are joined.
    transformed_data = join_compounds(transformed_data)

    #post-positions are joined.
    PP_fulldata = add_postposition(transformed_data,processed_postpositions)
    
    POST_PROCESS_OUTPUT = rearrange_sentence(PP_fulldata)  # reaarange by index number

    # for yn_interrogative add kya in the beginning
    if sentence_type == "yn_interrogative":
        POST_PROCESS_OUTPUT = 'kyA ' + POST_PROCESS_OUTPUT + '?'

    hindi_output = collect_hindi_output(POST_PROCESS_OUTPUT)
    write_hindi_text(hindi_output, POST_PROCESS_OUTPUT, OUTPUT_FILE)

    # if testing use the next line code and all results are collated in test.csv
    # write_hindi_test(hindi_output, POST_PROCESS_OUTPUT, src_sentence, OUTPUT_FILE)

    # for masked input -uncomment the following:
    # masked_pp_list = masked_postposition(processed_words, words_info, processed_verbs)
    # masked_pp_fulldata = add_postposition(transformed_data, masked_pp_list)
    # arranged_masked_output = rearrange_sentence(masked_pp_fulldata)
    # masked_hindi_data = collect_hindi_output(arranged_masked_output)
    # write_masked_hindi_test(hindi_output, POST_PROCESS_OUTPUT, src_sentence, masked_hindi_data, OUTPUT_FILE, path)

