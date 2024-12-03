import json
from constants.mappedRel import RELATION_MAP

def process_json_data(input_file_path, output_file_path, mapping_file_path):
    # Load the input data
    with open(input_file_path, 'r', encoding='utf-8') as file:
        data = json.load(file)
    
    # Load the mapping data
    with open(mapping_file_path, 'r', encoding='utf-8') as file:
        mapping_data = json.load(file)

    result = {}
    for filename, entries in data.items():
        dep_rel = []
        dependency_relations = []
        hyphen_count = 1

        # Load the appropriate mapping for the current file
        current_mapping = mapping_data.get(filename, {})

        # for entry in entries:
        for i, entry in enumerate(entries):
            # Get the dependency head
            dependency_head = entry['dependency_head']
            
            # Replace the dependency head using the mapping if it exists
            mapped_head = next((key for key, value in current_mapping.items() if str(value) == str(dependency_head)), dependency_head)
            
            # Map the dependency_relation using RELATION_MAP
            mapped_relation = RELATION_MAP.get(entry['dependency_relation'], entry['dependency_relation'])

            if mapped_relation == "main":
                mapped_head = "0"
            
            if entry['word'].endswith('-'):
                dep_rel.append(('-', '-'))

            if entry['wx_root'] != '-' and not entry['word'].endswith('-') and (not entry['is_indeclinable'] or entry['wx_root'] in ['yaxA', 'waxA']):
                # Combine mapped_head and the mapped_relation into a tuple
                dep_rel.append((mapped_head, mapped_relation))

            if entry['word'].endswith('-'):
                # Combine hyphen_count and the mapped_relation into a tuple and append to dependency_relations
                dependency_relations.append(('-', '-'))
                hyphen_count += 1

                next_word_printed = False  # Reset flag when a hyphenated word is encountered

                # Look ahead to find the next word that does not end with a hyphen
                for next_entry in entries[i+1:]:
                    if not next_entry['word'].endswith('-'):
                        if not next_word_printed:
                            # print("next_word_printed-->", next_entry['word'])
                            # print(f"Next word after hyphen: {next_entry['word']}")
                            next_word_printed = True  # Set the flag to True after printing
                        break
                           

        # Append all dependency_relation values at the end of dep_rel
        dep_rel.extend(dependency_relations)

        # Index the concepts, using a string representation of the tuple as the value
        indexed_concepts = {f"{i+1}": f"{wx_root[0]}:{wx_root[1]}" for i, wx_root in enumerate(dep_rel)}

        result[filename] = indexed_concepts

    # Save the processed data to a new JSON file
    with open(output_file_path, 'w', encoding='utf-8') as file:
        json.dump(result, file, ensure_ascii=False, indent=4)

    print(f"Processed data saved to ---> {output_file_path}")

# Example usage
input_file_path = 'jsonIO/combined_data.json'
output_file_path = 'jsonIO/depRel.json'
mapping_file_path = 'jsonIO/indexes.json'
process_json_data(input_file_path, output_file_path, mapping_file_path)

