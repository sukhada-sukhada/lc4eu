import json

# Define the input and output file names
concepts_filename = 'jsonIO/concepts.json'
sentences_filename = 'jsonIO/original_sent.json'
index_filename = 'jsonIO/indexes.json'  
sem_cat_filename = 'jsonIO/semCat.json'  
morpho_sem_filename = 'jsonIO/morhoSem.json'  
sent_type_filename = 'jsonIO/sentType.json'
dep_rel_filename = 'jsonIO/depRel.json'  # New JSON file
speaker_view_filename = 'jsonIO/spkView.json'  # New JSON file for speaker view info
output_filename = 'output.txt'

# Read the JSON data from the concepts file
with open(concepts_filename, 'r') as infile:
    concepts_data = json.load(infile)

# Read the JSON data from the sentences file
with open(sentences_filename, 'r') as infile:
    sentences_data = json.load(infile)

# Read the JSON data from the new index file
with open(index_filename, 'r') as infile:
    index_data = json.load(infile)

# Read the additional JSON data with "-" values
with open(sem_cat_filename, 'r') as infile:
    additional_data = json.load(infile)

# Read another JSON data file
with open(morpho_sem_filename, 'r') as infile:
    another_data = json.load(infile)

# Read the sentence type JSON data
with open(sent_type_filename, 'r') as infile:
    sent_type_data = json.load(infile)

# Read the new dependency relation JSON data
with open(dep_rel_filename, 'r') as infile:
    dep_rel_data = json.load(infile)

# Read the speaker view JSON data
with open(speaker_view_filename, 'r') as infile:
    speaker_view_data = json.load(infile)

# Prepare the output content
output_content = []

for key, value in concepts_data.items():
    # Extract the sentence ID from the filename
    sent_id = key.split('.')[0]
    
    # Write the sentence ID and the original sentence
    original_sentence = sentences_data.get(f'{sent_id}.tsv', {}).get('original_sent', '')
    output_content.append(f"<sent_id={sent_id}>\n")
    output_content.append(f"#{original_sentence}\n")
    
    # Get the corresponding index data for the sentence
    index_entries = index_data.get(f'{sent_id}.tsv', {})

    # Get the corresponding additional data for the sentence
    additional_entries = additional_data.get(f'{sent_id}.tsv', {})

    # Get the corresponding data from the another JSON file
    another_entries = another_data.get(f'{sent_id}.tsv', {})

    # Get the corresponding data from the new JSON file
    new_entries = dep_rel_data.get(f'{sent_id}.tsv', {})

    # Get the speaker view data for the sentence
    speaker_view_entries = speaker_view_data.get(f'{sent_id}.tsv', {})

    # Handle both cases: if value is a list or a dictionary
    if isinstance(value, dict):
        for concept_key, concept_value in value.items():
            # Extract the relevant data for each concept key
            index_key = concept_key if concept_key in index_entries else ""
            sem_cat_value = additional_entries.get(concept_key, "")
            morpho_sem_value = another_entries.get(concept_key, "")
            new_value = new_entries.get(concept_key, "")
            speaker_view_value = speaker_view_entries.get(concept_key, "")

            # Append the concept followed by the matching values with tabs
            output_content.append(
                f"{concept_value}\t{index_key}\t{sem_cat_value}\t{morpho_sem_value}\t{new_value}\t{speaker_view_value}\n"
            )
            
    elif isinstance(value, list):
        for concept in value:
            # Extract the relevant data for each concept in the list
            index_value = index_entries.get(concept, "")
            sem_cat_value = additional_entries.get(concept, "")
            morpho_sem_value = another_entries.get(concept, "")
            new_value = new_entries.get(concept, "")
            speaker_view_value = speaker_view_entries.get(concept, "")

            # Append the concept followed by the matching values with tabs
            output_content.append(
                f"{concept}\t{index_value}\t{sem_cat_value}\t{morpho_sem_value}\t{new_value}\t{speaker_view_value}\n"
            )
            
    else:
        raise ValueError("Unexpected data format in concepts JSON.")
    
    # Append the sentence type
    sent_type_value = sent_type_data.get(f'{sent_id}.tsv', {}).get('sent_type', '')
    output_content.append(f"%{sent_type_value}\n")
    
    output_content.append(f"</sent_id>\n\n\n")

# Write all content to the output file in one go
with open(output_filename, 'w') as outfile:
    outfile.writelines(output_content)
