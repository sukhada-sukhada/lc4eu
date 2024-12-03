import json
from constants.nameEntity import name_entity_list

def process_json_data(input_file_path, output_file_path):
    """
    Process JSON data from the input file to filter wx_root values based on specific criteria,
    handle special cases where word ends with a hyphen, and add semantic categories.

    Args:
        input_file_path (str): Path to the input JSON file.
        output_file_path (str): Path to the output JSON file.
    """
    # Load JSON data from file
    with open(input_file_path, 'r', encoding='utf-8') as file:
        data = json.load(file)

    # Process each file's data
    result = {}

    for filename, entries in data.items():
        sem_cat = []
        
        for entry in entries:
            # Determine the semantic category based on name entity and gender
            if entry['wx_root'] != '-' and (not entry['is_indeclinable'] or entry['wx_root'] in ['yaxA', 'waxA']):
                if entry['wx_root'] in name_entity_list:
                    sem_cat.append(f"per/{entry['gender']}")
                else:
                    sem_cat.append('-')
        
        # Check if the word ends with a hyphen and append hyphen in the end if true
        for entry in entries:
            if entry['word'].endswith('-'):
                sem_cat.append('-')

        indexed_sem_cat = {f"{i+1}": wx_root for i, wx_root in enumerate(sem_cat)}

        result[filename] = indexed_sem_cat

    # Save the processed data to a new JSON file
    with open(output_file_path, 'w', encoding='utf-8') as file:
        json.dump(result, file, ensure_ascii=False, indent=4)
    print(f"Processed data saved to ---> {output_file_path}")


input_file_path = 'jsonIO/combined_data.json'
output_file_path = 'jsonIO/semCat.json'
process_json_data(input_file_path, output_file_path)
