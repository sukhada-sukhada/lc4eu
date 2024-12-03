import json

def process_json_data(input_file_path, output_file_path):
    """
    Process JSON data from the input file to filter wx_root values based on specific criteria,
    and replace certain number values with an empty string where necessary.

    Args:
        input_file_path (str): Path to the input JSON file.
        output_file_path (str): Path to the output JSON file.
    """
    # Load JSON data from file
    with open(input_file_path, 'r', encoding='utf-8') as file:
        data = json.load(file)

    # Initialize a dictionary to store the processed data
    result = {}
    
    for filename, entries in data.items():
        # Initialize a list to hold processed number values for this filename
        number_list = []
        
        for entry in entries:
            # Filter wx_root and replace 'NA' or 'sg' with an empty string
            if entry['wx_root'] != '-' and (not entry['is_indeclinable'] or entry['wx_root'] in ['yaxA', 'waxA']):
                number = '-' if entry['number'] in ['NA', 'sg'] else entry['number']
                if entry.get('is_mawupa', False):
                    number = 'mawupa'
                if entry.get('is_causative', False):
                    number = 'causative'
                number_list.append(number)
         
        # Check if any word in entries ends with a hyphen and add '-' to the list if true
        for entry in entries:
            if entry['word'].endswith('-'):
                number_list.append('-')
        
        number_final_list = {f"{i+1}": wx_root for i, wx_root in enumerate(number_list)}
        result[filename] = number_final_list
    
    # Save the processed data to a new JSON file
    with open(output_file_path, 'w', encoding='utf-8') as file:
        json.dump(result, file, ensure_ascii=False, indent=4)

    print(f"Processed data saved to ---> {output_file_path}")

# Example usage
input_file_path = 'jsonIO/combined_data.json'
output_file_path = 'jsonIO/morhoSem.json'
process_json_data(input_file_path, output_file_path)
