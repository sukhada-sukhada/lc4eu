import json

def process_json_file(file_path):
    """
    Process a JSON file to combine hyphenated words into full words.

    Args:
        file_path (str): Path to the input JSON file.

    Returns:
        dict: A dictionary with combined words for each key.
    """
    with open(file_path, 'r', encoding='utf-8') as file:
        data = json.load(file)

    result = {}
    for key, value_list in data.items():
        words = []
        for item in value_list:
            word = item['word']
            if words and words[-1].endswith('-'):
                words[-1] = words[-1] + word
            else:
                words.append(word)
        result[key] = ' '.join(words)
    
    return result

def save_to_json(data, output_file_path):
    """
    Save the processed data to a JSON file.

    Args:
        data (dict): The data to be saved.
        output_file_path (str): Path to the output JSON file.
    """
    with open(output_file_path, 'w', encoding='utf-8') as file:
        json.dump(data, file, ensure_ascii=False, indent=4)

def main(input_file_path, output_file_path):
    """
    Main function to process a JSON file and save the results.

    Args:
        input_file_path (str): Path to the input JSON file.
        output_file_path (str): Path to the output JSON file.
    """
    result = process_json_file(input_file_path)
    
    final_result = {key: {'original_sent': words} for key, words in result.items()}
    
    save_to_json(final_result, output_file_path)
    
    print(f"Original sentences data created ---> {output_file_path}")

# Example usage
input_file_path = 'jsonIO/combined_data.json'
output_file_path = 'jsonIO/originalSent.json'
main(input_file_path, output_file_path)
