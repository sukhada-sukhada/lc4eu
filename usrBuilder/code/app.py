import os
from flask import Flask, request, jsonify
from werkzeug.utils import secure_filename
import pandas as pd
import json
from tsv2json import convert_tsv_folder_to_json  # Import your function

app = Flask(__name__)

# Configure the folder for uploaded files
UPLOAD_FOLDER = 'uploads/'
os.makedirs(UPLOAD_FOLDER, exist_ok=True)
app.config['UPLOAD_FOLDER'] = UPLOAD_FOLDER

@app.route('/convert', methods=['POST'])
def convert_tsv_to_json():
    try:
        # Check if the post request has the file part
        if 'file' not in request.files:
            return jsonify({"error": "No file part in the request"}), 400

        file = request.files['file']

        # If the user does not select a file, the browser submits an empty file without a filename
        if file.filename == '':
            return jsonify({"error": "No selected file"}), 400

        if file and file.filename.endswith('.tsv'):
            filename = secure_filename(file.filename)
            file_path = os.path.join(app.config['UPLOAD_FOLDER', filename])
            file.save(file_path)

            # Assuming the function 'convert_tsv_folder_to_json' is adjusted to handle single files
            convert_tsv_folder_to_json(app.config['UPLOAD_FOLDER'], 'output.json')

            # Read the output JSON file and return its contents
            with open('output.json', 'r', encoding='utf-8') as json_file:
                output_data = json.load(json_file)

            return jsonify(output_data)

        return jsonify({"error": "File is not in TSV format"}), 400

    except Exception as e:
        return jsonify({"error": str(e)}), 500

if __name__ == '__main__':
    app.run(debug=True)
