import os
import pandas as pd
import json
from wxconv import WXC
from constants.dropColumns import columns_to_drop


def devanagari_to_wx(word):
    wxc = WXC()
    wx_text = wxc.convert(word)
    return wx_text

def convert_tsv_folder_to_json(folder_path, json_file_path):
    try:
        combined_data = {}

        filenames = [filename for filename in os.listdir(folder_path) if filename.endswith(".tsv")]
        filenames.sort()

        # Loop through each file in the sorted list
        for filename in filenames:
            tsv_file_path = os.path.join(folder_path, filename)
                
            data = pd.read_csv(tsv_file_path, delimiter='\t', encoding='utf-8')
            data.dropna(how='all', inplace=True)

            for index, row in data.iterrows():
                if pd.notna(row['morph_in_context']):
                    root = row['morph_in_context'].split('{')[0].strip()
                    data.at[index, 'root'] = root
                    data.at[index, 'wx_root'] = devanagari_to_wx(root)

                    if 'पुं' in row['morph_in_context']:
                        data.at[index, 'gender'] = 'male'
                    elif 'स्त्री' in row['morph_in_context']:
                        data.at[index, 'gender'] = 'female'
                    elif 'नपुं' in row['morph_in_context']:
                        data.at[index, 'gender'] = 'NA'
                    else:
                        data.at[index, 'gender'] = 'NA'

                    if 'बहु' in row['morph_in_context']:
                        data.at[index, 'number'] = 'pl'
                    elif 'द्वि' in row['morph_in_context']:
                        data.at[index, 'number'] = 'dl'
                    elif 'एक' in row['morph_in_context']:
                        data.at[index, 'number'] = 'sg'
                    else:
                        data.at[index, 'number'] = 'NA'

                    if 'सर्वनाम' in row['morph_in_context']:
                        data.at[index, 'is_pronoun'] = True
                    else:
                        data.at[index, 'is_pronoun'] = False

                    if 'मतुप्' in row['morph_in_context'] or isinstance(row['kaaraka_sambandha'], str) and 'विशेषणम्' in row['kaaraka_sambandha'] and \
                   ('वत्' in root or 'मत्' in root):
                        data.at[index, 'is_mawupa'] = True
                    else:
                        data.at[index, 'is_mawupa'] = False
                    
                    if 'णिजन्त' in row['morph_in_context']:
                        data.at[index, 'is_causative'] = True
                    else:
                        data.at[index, 'is_causative'] = False

                    if '{अव्य}' in row['morph_in_context']:
                        data.at[index, 'is_indeclinable'] = True
                    else:
                        data.at[index, 'is_indeclinable'] = False

                else:
                    data.at[index, 'root'] = 'NA'
                    data.at[index, 'wx_root'] = 'NA'
                    data.at[index, 'gender'] = 'NA'
                    data.at[index, 'number'] = 'NA'
                    data.at[index, 'person'] = 'NA'

                if pd.notna(row['kaaraka_sambandha']):
                    if ',' in row['kaaraka_sambandha']:
                        dep_rel = row['kaaraka_sambandha'].split(',', 1)[0]
                        dep_head = row['kaaraka_sambandha'].split(',', 1)[1]
                        data.at[index, 'dependency_relation'] = dep_rel.strip()
                        data.at[index, 'dependency_head'] = dep_head.strip()
                        if ';' in dep_head:
                            data.at[index, 'verb_type'] = dep_head.split(';')[1]
                            data.at[index, 'dependency_head'] = dep_head.split(';')[0]
                        else:
                            data.at[index, 'verb_type'] = 'NA'

            data.drop(columns=columns_to_drop, inplace=True, errors='ignore')

            # Convert the DataFrame to a list of dictionaries
            data_dict = data.to_dict(orient='records')

            # Store data with filename as the key
            combined_data[filename] = data_dict

        # Save the combined data as a JSON file
        with open(json_file_path, 'w', encoding='utf-8') as json_file:
            json.dump(combined_data, json_file, ensure_ascii=False, indent=4)

        print(f"TSV files have been successfully converted to JSON file at {json_file_path}")
    except Exception as e:
        print(f"An error occurred: {e}")

folder_path = 'ramayana/'
json_file_path = 'jsonIO/combined_data.json'

convert_tsv_folder_to_json(folder_path, json_file_path)

