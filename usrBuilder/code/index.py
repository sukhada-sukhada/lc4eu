
# import json

# def process_json_data(input_file_path, output_file_path):
#     """
#     Process JSON data from the input file to filter wx_root values based on specific criteria,
#     handle special cases where word ends with a hyphen, and index each concept.

#     Args:
#         input_file_path (str): Path to the input JSON file.
#         output_file_path (str): Path to the output JSON file.
#     """
#     # Load JSON data from file
#     with open(input_file_path, 'r', encoding='utf-8') as file:
#         data = json.load(file)

#     # Process each file's data
#     result = {}
    
#     for filename, entries in data.items():
#         wx_roots = []
#         dependency_relations = []
        
#         for entry in entries:
#             # Check the criteria for wx_root
#             if entry['wx_root'] != '-' and (not entry['is_indeclinable'] or entry['wx_root'] in ['yaxA', 'waxA']):
#                 wx_roots.append(entry['index'])
                
#                 # If the word ends with a hyphen, store the dependency_relation to be added later
#                 if entry['word'].endswith('-'):
#                     dependency_relations.append('-')
        
#         # Append all dependency_relation values at the end of wx_roots
#         wx_roots.extend(dependency_relations)

#         # Index the concepts
#         indexed_concepts = {f"{i+1}": wx_root for i, wx_root in enumerate(wx_roots)}
#         # indexed_concepts = {wx_root: i + 1 for i, wx_root in enumerate(wx_roots)}

#         result[filename] = indexed_concepts

#     # Save the processed data to a new JSON file
#     with open(output_file_path, 'w', encoding='utf-8') as file:
#         json.dump(result, file, ensure_ascii=False, indent=4)

#     print(f"Processed data saved to ---> {output_file_path}")

# # Example usage
# input_file_path = 'jsonIO/combined_data.json'
# output_file_path = 'jsonIO/indexes.json'
# process_json_data(input_file_path, output_file_path)


import json

def process_json_data(input_file_path, output_file_path):
    """
    Process JSON data from the input file to filter wx_root values based on specific criteria,
    handle special cases where word ends with a hyphen, and index each concept.

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
        wx_roots = []
        dependency_relations = []
        hyphen_count = 1
        
        for entry in entries:
            # Check the criteria for wx_root
            if entry['wx_root'] != '-' and (not entry['is_indeclinable'] or entry['wx_root'] in ['yaxA', 'waxA']):
                wx_roots.append(entry['index'])
                
                # If the word ends with a hyphen, store a sequential number
                if entry['word'].endswith('-'):
                    dependency_relations.append(hyphen_count)
                    hyphen_count += 1
        
        # Append all dependency_relation values at the end of wx_roots
        wx_roots.extend(dependency_relations)

        # Index the concepts
        indexed_concepts = {f"{i+1}": wx_root for i, wx_root in enumerate(wx_roots)}
        # indexed_concepts = {wx_root: i + 1 for i, wx_root in enumerate(wx_roots)}
        result[filename] = indexed_concepts

    # Save the processed data to a new JSON file
    with open(output_file_path, 'w', encoding='utf-8') as file:
        json.dump(result, file, ensure_ascii=False, indent=4)

    print(f"Processed data saved to ---> {output_file_path}")

# Example usage
input_file_path = 'jsonIO/combined_data.json'
output_file_path = 'jsonIO/indexes.json'
process_json_data(input_file_path, output_file_path)
