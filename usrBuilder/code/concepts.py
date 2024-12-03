# import json
# from constants.mappedRel import CNX_MAP
# from constants.tamList import TAM_LIST

# def process_json_data(input_file_path, output_file_path):
   
#     with open(input_file_path, 'r', encoding='utf-8') as file:
#         data = json.load(file)

#     result = {}
#     for filename, entries in data.items():
#         wx_roots = []
#         concepts_data = []
#         relation_count = {}  
        
#         for entry in entries:
#             if entry['wx_root'] != '-' and (not entry['is_indeclinable'] or entry['wx_root'] in ['yaxA', 'waxA']):
#                 wx_roots.append(entry['wx_root'] + '_1')
#                 print(entry['morph_in_context'])


#                 if entry['word'].endswith('-'):
#                     mapped_relation = CNX_MAP.get(entry['dependency_relation'], entry['dependency_relation'])
#                     mapped_relation = str(mapped_relation)

#                     if mapped_relation in relation_count:
#                         relation_count[mapped_relation] += 1
#                     else:
#                         relation_count[mapped_relation] = 1
                   
#                     suffix = f"_{relation_count[mapped_relation]}]"
#                     concepts_data.append('['+mapped_relation + suffix)

#         wx_roots.extend(concepts_data)

 
#         indexed_concepts = {f"{i+1}": wx_root for i, wx_root in enumerate(wx_roots)}
#         result[filename] = indexed_concepts

    
#     with open(output_file_path, 'w', encoding='utf-8') as file:
#         json.dump(result, file, ensure_ascii=False, indent=4)
#     print(f"Processed data saved to ---> {output_file_path}")


# input_file_path = 'jsonIO/combined_data.json'
# output_file_path = 'jsonIO/concepts.json'
# process_json_data(input_file_path, output_file_path)

import json
from constants.mappedRel import CNX_MAP
from constants.tamList import TAM_LIST

def process_json_data(input_file_path, output_file_path):
   
    with open(input_file_path, 'r', encoding='utf-8') as file:
        data = json.load(file)

    result = {}
    for filename, entries in data.items():
        wx_roots = []
        concepts_data = []
        relation_count = {}  
        
        for entry in entries:
            if entry['wx_root'] != '-' and (not entry['is_indeclinable'] or entry['wx_root'] in ['yaxA', 'waxA']):
                # Check for TAM_LIST keys in morph_in_context
                morph_context = entry['morph_in_context']
                for key in TAM_LIST:
                    if all(term in morph_context for term in key):
                        entry['wx_root'] += f"_1-{TAM_LIST[key]}"
                        break
                
                wx_roots.append(entry['wx_root'] + '_1')
                # print(entry['morph_in_context'])

                if entry['word'].endswith('-'):
                    mapped_relation = CNX_MAP.get(entry['dependency_relation'], entry['dependency_relation'])
                    mapped_relation = str(mapped_relation)

                    if mapped_relation in relation_count:
                        relation_count[mapped_relation] += 1
                    else:
                        relation_count[mapped_relation] = 1
                   
                    suffix = f"_{relation_count[mapped_relation]}]"
                    concepts_data.append('['+mapped_relation + suffix)

        wx_roots.extend(concepts_data)

        indexed_concepts = {f"{i+1}": wx_root for i, wx_root in enumerate(wx_roots)}
        result[filename] = indexed_concepts

    with open(output_file_path, 'w', encoding='utf-8') as file:
        json.dump(result, file, ensure_ascii=False, indent=4)
    print(f"Processed data saved to ---> {output_file_path}")

input_file_path = 'jsonIO/combined_data.json'
output_file_path = 'jsonIO/concepts.json'
process_json_data(input_file_path, output_file_path)
