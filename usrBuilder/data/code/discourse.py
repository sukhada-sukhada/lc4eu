import json
from constants.discourseConnectives import DIS_CON_LIST

def process_json_data(input_file_path, output_file_path):
    with open(input_file_path, 'r', encoding='utf-8') as file:
        data = json.load(file)
        print(data)

        for key, value in data.items():
            # print(f'{key}--->{value}')
            original_sent = value['original_sent']
            # print('sent-->', original_sent)
            for connective, category in DIS_CON_LIST.items():
                connectives = connective if isinstance(connective, tuple) else (connective,)
                print("con--->", connectives)
            

    
    print(f"Processed data saved to ---> {output_file_path}")

input_file_path = 'jsonIO/originalSent.json'
output_file_path = 'jsonIO/discourseConnective.json'
process_json_data(input_file_path, output_file_path)

if any word from connectives present in original_sent then print