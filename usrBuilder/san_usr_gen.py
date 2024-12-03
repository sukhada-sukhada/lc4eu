import re, os, math
import pandas as pd
import json
from wxconv import WXC
from constants.relation_map import RELATION_MAP
from constants.non_concept import drop_list, dependency_drop_list 
from constants.sanskrit_to_wx import SANSKRIT_TO_WX
from constants.tam_list import TAM_LIST, name_list

class SanskritToWX:
    def __init__(self, lang='hin'):
        self.lang = lang
        self.sanskrit_format = WXC(order="utf2wx", lang=self.lang)

    def get_wx_notations(self, morph_data, drop_list):
        cleaned_words_list = []
        gender_list = []
        number_list = []
        include_combinations = [("अव्य", "क्त्वा"), ("अव्य", "ल्यप्"), ("अव्य", "तुमुन्")]

        for entry in morph_data:
            if isinstance(entry, float):  # Skip NaN entries
                continue
            words = entry.split()
            for word in words:
                gender = ''
                number = ''
                if '{' in word:  
                    base, annotation = word.split('{', 1)  
                    # base = base.replace('_', '~')
                    annotation = annotation.rstrip('}')  
                    # print(annotation)
                    drop_word_found = any(drop_word in annotation for drop_word in drop_list)

                    
                    include_combination_found = any(all(inc in annotation for inc in combo) for combo in include_combinations)
                    # print('include_combination_found-->', include_combination_found)
                    # print('base-->', base)
                    if drop_word_found and not include_combination_found:
                        continue   
                    
                    # if "कर्तरि" in annotation and "लिट्" in annotation and "परस्मैपदी" in annotation:
                    #     print(base)
                    #     base += "-a"
                    # for key, value in TAM_LIST.items():
                    #     key_check = [k in annotation for k in key]
                    #     if all(key_check):
                    #         base += f"-{value}"
                    #         break

                    gender = self.get_gender_info(annotation)  
                    number = self.get_number_info(annotation)  
                else:
                    base = word  

                if base == 'nan':
                    print(type(base))
                    continue
                else:
                    cleaned_words_list.append(base)  
                gender_list.append(gender) 
                number_list.append(number) 

        wx_notation_list = [
            self.sanskrit_format.convert(word) for word in cleaned_words_list 
        ]

        wx_notation_list = [word if word != "-" else None for word in wx_notation_list]
        wx_notation_list = [word for word in wx_notation_list if word is not None]
        wx_notation_list = [word if word in SANSKRIT_TO_WX or word in name_list else word + "_1" for word in wx_notation_list]
        modified_wx_notation_list = [SANSKRIT_TO_WX.get(word, word) for word in wx_notation_list]


        filtered_gender_list = [gender for word, gender in zip(wx_notation_list, gender_list) if word not in drop_list]
        filtered_number_list = [number for word, number in zip(wx_notation_list, number_list) if word not in drop_list]

        return modified_wx_notation_list, cleaned_words_list, filtered_gender_list, filtered_number_list

       

    def get_gender_info(self, annotation):
        if "पुं;" in annotation:
            return 'male'
        elif "स्त्री;" in annotation:
            return 'female'
        else:
            return ''

    def get_number_info(self, annotation):
        if "बहु" in annotation:
            return 'pl'
        elif "द्वि" in annotation:
            return 'dl'
        else:
            return ''
        

    def gen_dependency_row(self, kaaraka_sambandha_data, index_morph_map, word_index_map, dependency_drop_list, kaaraka_sambandha_morph_dict):
        associated_indices_map = []
        for sambandha in kaaraka_sambandha_data:
            if isinstance(sambandha, str):
                matches = re.findall(r'\d+\.\d+', sambandha)
                if matches:  # If matches is not empty
                    for match in matches:
                        # print(match)
                        match_value = kaaraka_sambandha_morph_dict.get(sambandha, "")
                        extracted_word = re.search(r'\{(.*?)\}', match_value)
                        if extracted_word:
                            extracted_word = extracted_word.group(1)
                            if extracted_word == "अव्य":
                                continue
                        before_word = re.split(r'\d+\.\d+', sambandha)[0].strip().rstrip(',')
                        sambandha_key = sambandha.split('_')[0]
                        # print(sambandha_key)
                        if sambandha_key in dependency_drop_list:  
                            index = "0"
                            before_word = "main"
                        elif not before_word:  # Check if before_word is empty
                            index = "0"
                            before_word = "main"
                        else:
                            base_word = index_morph_map.get(match, "")
                            index = word_index_map.get(base_word, "")
                            before_word = RELATION_MAP.get(before_word, before_word)

                        associated_indices_map.append(f"{index}:{before_word}")
                else:
                    # Handle the case when matches is empty
                    # For example, you might want to assign default values to before_word and index
                    index = "0"
                    before_word = "main"
                    associated_indices_map.append(f"{index}:{before_word}")

        return associated_indices_map
    
    def get_blank_row(self, modified_wx_notation_list):
        return [""] * len(modified_wx_notation_list)

class JSONCreator:
    def __init__(self):
        self.sanskrit_to_wx = SanskritToWX()
    
    def create_json(self, file_path, drop_list, dependency_drop_list):
        df = pd.read_csv(file_path, sep='\t', encoding='utf-8')
        df = df.dropna(subset=['word'])

        morph_data = df['morph_in_context'].tolist()
        original_word = df['word'].tolist()
        modified_wx_notation_list, cleaned_words_list, gender_list, number_list = self.sanskrit_to_wx.get_wx_notations(morph_data, drop_list)
        index_morph_map = dict(zip(df['index'].astype(str), df['morph_in_context'].str.split('{').str[0].str.rstrip()))
        kaaraka_sambandha_data = df['kaaraka_sambandha'].tolist()
        if kaaraka_sambandha_data and kaaraka_sambandha_data[-1] == "-":
            kaaraka_sambandha_data = kaaraka_sambandha_data[:-1]

        #dictionary between kaaraka_sambandha_data and morph_in_context data
        kaaraka_sambandha_morph_dict = dict(zip(df['kaaraka_sambandha'], df['morph_in_context']))
        # print("dict: ",kaaraka_sambandha_morph_dict)

        processed_kaaraka_sambandha = [item.split(';')[0] if pd.notna(item) else '' for item in kaaraka_sambandha_data]

        index_row = [str(i) for i in range(1, len(modified_wx_notation_list) + 1)]
        word_index_map = {word: index for index, word in zip(index_row, cleaned_words_list)}

        associated_indices = self.sanskrit_to_wx.gen_dependency_row(processed_kaaraka_sambandha, index_morph_map, word_index_map, dependency_drop_list, kaaraka_sambandha_morph_dict)
        original_line = '#' + ' '.join(original_word)

        blank_row = self.sanskrit_to_wx.get_blank_row(modified_wx_notation_list)
        modified_wx_notation_list = [re.sub(r'_(?=\D)', '~', word) for word in modified_wx_notation_list]
        
        print(original_line)
        print(','.join(modified_wx_notation_list))
        print(','.join(index_row))
        print(','.join(gender_list))
        print(','.join(number_list))
        print(','.join(associated_indices))
        print(','.join(blank_row))
        print(','.join(blank_row))
        print(','.join(blank_row))
        print('affirmative')

# if __name__ == "__main__":
#     file_path = 'data/016_2.tsv'
#     json_creator = JSONCreator()
#     output_json = json_creator.create_json(file_path, drop_list, dependency_drop_list)
#     print(output_json)

# if __name__ == "__main__":
#     folder_path = 'ramayana/'  
#     output_file_path = 'output'  

#     filenames = sorted(os.listdir(folder_path))
#     # with open(output_file_path, 'w', encoding='utf-8') as output_file:
#     json_creator = JSONCreator()
    
#     for filename in filenames:
#         if filename.endswith(".tsv"):
#             print('\n\n')
#             print('filename: ', filename)
#             file_path = os.path.join(folder_path, filename)
#             try:
#                 output_file.write(f"# Processing file: {filename}\n")
#                 output_json = json_creator.create_json(file_path, drop_list, dependency_drop_list)
#                 output_file.write(json.dumps(output_json) + '\n')
#                 output_file.write('\n')
#             except Exception as e:
#                 output_file.write(f"# Error occurred while processing {filename}: {e}\n")
#                 continue
    
#         with open(output_file_path, 'w', encoding='utf-8') as output_file:
#             output_file.write()


if __name__ == "__main__":
    folder_path = 'data/'  
    output_file_path = 'output'  

    filenames = sorted(os.listdir(folder_path))
    with open(output_file_path, 'w', encoding='utf-8') as output_file:
        json_creator = JSONCreator()
        
        for filename in filenames:
            if filename.endswith(".tsv"):
                print('\n\n')
                print('filename: ', filename)
                file_path = os.path.join(folder_path, filename)
                try:
                    output_file.write(f"# Processing file: {filename}\n")
                    output_lines = json_creator.create_json(file_path, drop_list, dependency_drop_list)
                    output_file.write('\n'.join(output_lines) + '\n\n')
                except Exception as e:
                    output_file.write(f"# Error occurred while processing {filename}: {e}\n")
