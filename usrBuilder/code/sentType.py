import json
import os

def process_json_file(file_path):
    """
    Process a JSON file to determine the 'sent_type' based on 'morph_in_context'.

    Args:
        file_path (str): Path to the input JSON file.

    Returns:
        dict: A dictionary with sentence types for each key.
    """
    if not os.path.exists(file_path):
        raise FileNotFoundError(f"The file {file_path} does not exist.")
    
    with open(file_path, 'r', encoding='utf-8') as file:
        data = json.load(file)

    result = {}
    for key, value_list in data.items():
        sent_type = 'affirmative'  # Default
        for item in value_list:
            morph_in_context = item.get('morph_in_context', '')
            wx_root = item.get('wx_root', '')

            if 'कर्मणि' in morph_in_context:
                sent_type = 'pass_affirmative'
            if 'किम्' in morph_in_context and 'कर्मणि' in morph_in_context:
                sent_type = 'pass_interrogative'
            if 'किम्' in morph_in_context:
                sent_type = 'interrogative'
            if wx_root == 'na' and 'कर्मणि' in morph_in_context:
                sent_type = 'pass_negative' 
            if wx_root == 'na':
                sent_type = 'negative'
            if any(substring in morph_in_context for substring in ['लिङ्', 'लोट्']):
                sent_type = 'imperative'

        result[key] = {
            'sent_type': sent_type
        }
    return result

def save_to_json(data, output_file_path):
    with open(output_file_path, 'w', encoding='utf-8') as file:
        json.dump(data, file, ensure_ascii=False, indent=4)

def main(input_file_path, output_file_path):
    result = process_json_file(input_file_path)
    save_to_json(result, output_file_path)
    print(f"Sentence types data saved to ---> {output_file_path}")

input_file_path = 'jsonIO/combined_data.json'
output_file_path = 'jsonIO/sentType.json'
main(input_file_path, output_file_path)
