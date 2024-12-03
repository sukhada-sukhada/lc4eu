import os
import pandas as pd

# Path to the folder containing the TSV files
folder_path = 'ramayana/'  # Update this path if necessary

# Output file path
output_file = os.path.join(folder_path, 'combined_output.tsv')

# List to store data from all files
data_list = []

# Process each TSV file in the folder
for file_name in os.listdir(folder_path):
    if file_name.endswith('.tsv'):
        file_path = os.path.join(folder_path, file_name)
        filename = os.path.basename(file_path).replace('.tsv', '')

        # Read the TSV file
        df = pd.read_csv(file_path, sep='\t')

        # Check if the required columns are present
        if all(col in df.columns for col in ['index', 'word', 'hindi_meaning']):
            # Drop rows where 'index' is NaN
            df = df.dropna(subset=['index'])
            
            # Convert the 'index' column to a string and handle non-numeric values safely
            df['index'] = df['index'].astype(str)

            # Try to split the index for sorting; handle errors gracefully
            try:
                df = df.sort_values(by='index', key=lambda x: x.str.split('.').map(lambda y: list(map(int, y))))
            except ValueError as e:
                print(f"Skipping sorting for {file_name} due to error: {e}")
            
            # Store the filename and dataframe in the list
            data_list.append((filename, df[['index', 'word', 'hindi_meaning']]))
        else:
            print(f'File {file_path} does not contain the required columns.')

# Sort the data list by filename (sent_id)
data_list.sort(key=lambda x: x[0])

# Open the output file in write mode
with open(output_file, 'w') as output:
    for filename, df in data_list:
        # Add the <sent_id=filename> tag
        output.write(f'<sent_id={filename}>\n')

        # Write the sorted and extracted columns to the output file
        df.to_csv(output, sep='\t', index=False, header=True)

        # Add the closing </sent_id> tag
        output.write('</sent_id>\n\n')

print(f'Combined and correctly sorted data saved to {output_file}')
