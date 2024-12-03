import json
import re

# Define the DIS_CON_LIST dictionary
DIS_CON_LIST = {
    ('यदि', 'तर्हि'): 'आवश्यकतापरिणाम',
    ('किन्तु', 'परन्तु'): 'विरोधी',
    ('च', 'अपि च', 'अथ च', 'किंच'): 'समुच्चय',
    ('अथवा', 'वा'): 'अन्यत्र',
    ('यद्यपि-तथापि', 'यद्यपि पुनरपि'): 'व्यभिचार',
    ('ततः', 'अनन्तरम्', 'तदनन्तरम्', 'अथ'): 'उत्तरकाल',
    ('इति कारणेन', 'यतोहि', 'यतः'): 'कार्यकारण',
    ('अतः', 'परिणामस्वरूपम्', 'तस्मात् कारणात्', 'एतस्मात् कारणात्'): 'परिणाम',
    ('अतिरिक्तम्', 'एतद् अतिरिक्तम्', 'एतद् अतिरिच्य'): 'समुच्चय.अतिरिक्त',
    ('अतिरिक्तम्',): 'समुच्चय.अलावा',
    ('न केवलम् अपितु',): 'समुच्चय.भी',
    ('सह एव', 'अनेन सह एव', 'तेन सह एव', 'एतेन सह एव'): 'समुच्चय.समावेशी',
    ('यदा तु',): 'विरोध.द्योतक',
    ('येन', 'यतः', 'यस्मात्', 'यस्मात् कारणात्'): 'कार्य.द्योतक',
    ('अन्येषु शब्देषु', 'अन्यशब्देषु', 'शब्दान्तरेषु'): 'अर्थात',
    ('यथा', 'उदाहरणस्वरूपम्', 'उदाहरणार्थम्'): 'उदाहरणस्वरूप',
}

# Input data
input_data = {
    "001_1.tsv": {
        "original_sent": "तपः-स्वाध्याय-निरतम् तपस्वी वाक्-विदाम् वरम् नारदम् परिपप्रच्छ वाल्मीकिः मुनि-पुङ्गवम् ."
    },
    "002_1.tsv": {
        "original_sent": "कः नु अस्मिन् साम्प्रतम् लोके गुणवान् अस्ति ."
    },
    "002_2.tsv": {
        "original_sent": "कः च वीर्यवान् अस्ति ."
    },
    "002_3.tsv": {
        "original_sent": "कः च धर्मज्ञः अस्ति ."
    },
    "002_4.tsv": {
        "original_sent": "कः च कृतज्ञः सत्य-वाक्यः दृढ-व्रतः च अस्ति ."
    },
    "003_1.tsv": {
        "original_sent": " वा कः युक्तः अस्ति ."
    },
}

# Output JSON structure
output_data = {}

# Iterate through the input data
for key, value in input_data.items():
    original_sent = value['original_sent']
    discourse_values = []  # To collect all matching discourse values

    # Check each tuple in DIS_CON_LIST
    for words_tuple, discourse_value in DIS_CON_LIST.items():
        # Check if any word from the tuple matches exactly as a whole word in the sentence
        for word in words_tuple:
            # Match word boundaries to avoid partial matches
            if re.search(rf'\b{re.escape(word)}\b', original_sent):
                discourse_values.append(discourse_value)
                break  # Stop checking other words in the same tuple once one is matched

    # Add the original data to the output, with the discourse values if found
    output_data[key] = {
        "original_sent": original_sent,
    }
    if discourse_values:
        output_data[key]['discourse'] = discourse_values

# Print the output JSON (you can also save this to a file if needed)
print(json.dumps(output_data, ensure_ascii=False, indent=4))
