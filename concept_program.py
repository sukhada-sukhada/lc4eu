import os
import csv

def read_second_line_from_csv_files('home/sanju/paper_2/nios_1ch'):
    # Iterate through files in the folder
    for filename in os.listdir('home/sanju/paper_2/nios_1ch'):
        file_path = os.path.join('home/sanju/paper_2/nios_1ch', filename)
        # Check if the file is a regular file
        if os.path.isfile(file_path):
            try:
                with open(file_path, 'r', newline='') as file:
                    csv_reader = csv.reader(file)
                    # Skip the first line
                    next(csv_reader)
                    # Read the second line
                    second_line = next(csv_reader)
                    # Check if the second line contains comma-separated values
                    if len(second_line) > 1:
                        print(f"Second line of '{filename}': {second_line[1]}")
                    else:
                        print(f"File '{filename}' does not contain comma-separated values in the second line.")
            except (csv.Error, IndexError) as e:
                print(f"Error reading file '{filename}': {e}")

# Example usage:
folder_path = 'home/sanju/paper_2/nios_1ch'
read_second_line_from_csv_files('home/sanju/paper_2/nios_1ch')

