import json
from constants.discourseParticles import DIS_PART

def process_json_data(input_file_path, output_file_path, concept_file_path):
    # Load input data and concept data
    with open(input_file_path, 'r', encoding='utf-8') as file:
        data = json.load(file)
    
    with open(concept_file_path, 'r', encoding='utf-8') as file:
        concept_data = json.load(file)

    result = {}
    for filename, entries in data.items():
        spk_view_list = []
        
        # Process each entry
        for entry in entries:
            dependency_head = str(entry.get('dependency_head'))
         
            if entry['is_indeclinable'] and entry['root'] in DIS_PART:
                discourse_particle_root = entry['wx_root']
                # print(discourse_particle_root)
                
                # Find the corresponding entry to replace
                for sub_entry in entries:
                    if dependency_head == str(sub_entry["index"]):
                        dis_part_root = sub_entry['wx_root']
                        # print(dis_part_root)
                        
                        # Initialize spk_view_dict for this filename if it doesn't exist
                        if filename not in result:
                            result[filename] = {}
                        
                        # Check for matches in concept_data
                        if filename in concept_data:
                            # print('true')
                            for k, v in concept_data[filename].items():
                                # print(v)
                                if v.strip('_1') == dis_part_root:
                                    # print(discourse_particle_root)
                                    result[filename][k] = discourse_particle_root + '_1'
                                else:
                                    result[filename][k] = "-"
        
        # If no changes were made to the result, initialize with hyphens
        if filename not in result:
            result[filename] = {k: "-" for k in concept_data.get(filename, {}).keys()}
    
    # Save processed result to spkView.json
    with open(output_file_path, 'w', encoding='utf-8') as file:
        json.dump(result, file, ensure_ascii=False, indent=4)

    print(f"Processed data saved to ---> {output_file_path}")

input_file_path = 'jsonIO/combined_data.json'
output_file_path = 'jsonIO/spkView.json'
concept_file_path = 'jsonIO/concepts.json'

process_json_data(input_file_path, output_file_path, concept_file_path)
