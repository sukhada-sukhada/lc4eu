import sys

def print_usage_and_exit():
    #print("Usage: python3 code.py <language>")
    #print("Available languages: eng, skt, hin")
    sys.exit(1)

def process_search_words(third_line):
    search_words = third_line.split(',')
    processed_search_words = []
    parts_list = [] 

    for word in search_words:
        if '-' in word:
            parts = word.split('-')
            processed_search_words.append(parts[0])
            if len(parts) > 1: 
                parts_list.append(parts[1])
        processed_search_words.append(word)

    return processed_search_words, parts_list

def search_in_files(processed_search_words, parts_list, valid_languages, language):
    with open(sys.argv[3], "w") as output_file:   # Compiled Dictionary(Acc. to selected language)

        with open("/home/lc4eu/lc4eu/dictionaries/concept-to-mrs-rels.dat", "r") as file2:   # Reading the multi-lingual concept dictionary
            for line in file2:
                columns = line.strip().split(' ')

                # Check if the language column matches any of the processed search words
                if len(columns) > valid_languages[language]:
                    lang_column_value = columns[valid_languages[language]]
                    if lang_column_value in processed_search_words:
                        output_file.write(f"(cl-ls-mrs {columns[0]} {lang_column_value} {columns[-1]})\n")
                        
    with open(sys.argv[4], "w") as tam_out_file:   # Compiled Dictionary(Acc. to selected language)

        with open("/home/lc4eu/lc4eu/dictionaries/tam_mapping.dat", "r") as tam_file:  # Reading the multi-lingual TAM dictionary
            for tam_line in tam_file:
                tam_columns = tam_line.strip().split(' ')
                # print(tam_columns, '=================')
                lang_column_tam = tam_columns[valid_languages[language]]
                if lang_column_tam in parts_list:
                    tam_out_file.write(f"(U_TAM-LS_TAM-Perfective_Aspect-Progressive_Aspect-Tense-Modal {tam_columns[0]} {lang_column_tam} {' '.join(tam_columns[-4:])})\n")




def main():
    # Check if a language argument is provided
    if len(sys.argv) != 5:
        print_usage_and_exit()

    # Get the language argument
    language = sys.argv[1]
    valid_languages = {"hin": 1, "skt": 2, "eng": 3}  # Language-to-column mapping

    if language not in valid_languages:
        print(f"Invalid language: {language}.\nChoose from: eng, skt, hin.")
        sys.exit(1)

    # Read the first file (usr.txt) and get the third line
    try:
        with open(sys.argv[2], "r") as file1:
            lines = file1.readlines()
            if len(lines) >= 3:
                third_line = lines[2].strip()
            else:
                print("The file has less than three lines.")
                sys.exit(1)
    except FileNotFoundError:
        print("usr.txt file not found.")
        sys.exit(1)


    processed_search_words, parts_list = process_search_words(third_line)
    search_in_files(processed_search_words, parts_list, valid_languages, language)

if __name__ == "__main__":
    main()
