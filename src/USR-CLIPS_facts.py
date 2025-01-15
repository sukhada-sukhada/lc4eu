import sys

fr = open(sys.argv[1], 'r')
hinUsrCsv = list(fr)
ans = open(sys.argv[2], 'w+')

# Split the rows into lists by commas
concept_label = hinUsrCsv[2].strip().split(',')
indexing = hinUsrCsv[3].strip().split(',')
sem_cat = hinUsrCsv[4].strip().split(',')
morpho_semcat = hinUsrCsv[5].strip().split(',')
dependency = hinUsrCsv[6].strip().split(',')
discourse = hinUsrCsv[7].strip().split(',')
speakers_view = hinUsrCsv[8].strip().split(',')
scope = hinUsrCsv[9].strip().split(',')
sentence_type = hinUsrCsv[11].strip()  # Sentence type information.
if len(hinUsrCsv) > 10:
    construction = hinUsrCsv[10].strip().split(',')

# Check if concept_label and indexing lists have the same length
if len(concept_label) == len(indexing):
    for i in range(len(concept_label)):
        # Extract TAM if hyphen is in concept_label
        if '-' in concept_label[i]:
            TAM = concept_label[i].split('-')[1]
            ans.write(f"(kriyA-TAM\t {indexing[i]+'0000'}\t {TAM})\n")
            concepts_without_TAM = concept_label[i].split('-')[0]
        else:
            concepts_without_TAM = concept_label[i]
        
        ans.write(f"(id-cl\t {indexing[i]+'0000'}\t {concepts_without_TAM})\n")

    # Process Semantic Category (sem_cat)
    for i in range(len(sem_cat)):
        if sem_cat[i]:
            Sem_Cat = [item.strip() for item in sem_cat[i].replace('/', ' ').split()]
            for category in Sem_Cat:
                ans.write(f"(id-{category}\t {indexing[i]+'0000'}\t yes)\n")

    # Process Morphological Semantic Category (morpho_semcat)
    for i in range(len(morpho_semcat)):
        if morpho_semcat[i]:
            morph_sem = morpho_semcat[i].split()
            for sem in morph_sem:
                ans.write(f"(id-morph_sem\t {indexing[i]+'0000'}\t {sem})\n")


    # Process Dependency Relations (dependency)
    for i in range(len(dependency)):
        if dependency[i]:
            dep_row = dependency[i].split(':')
            value1, value2 = dep_row[0], dep_row[1]
            ans.write(f"(rel-ids\t {value2}\t {value1+'0000' if value1 != '0' else value1}\t {indexing[i]+'0000'})\n")


    # Process Discourse Relations (discourse)
    for i in range(len(discourse)):
        if discourse[i]:
            dep_row = discourse[i].split(':')
            value1, value2 = dep_row[0], dep_row[1]
            ans.write(f"(rel-ids\t {value2}\t {value1+'0000'}\t {indexing[i]+'0000'})\n")

    # Process Speaker's View (speakers_view)
    for i in range(len(speakers_view)):
        if speakers_view[i]:
            word = speakers_view[i].strip('[]')
            if "shade:" in word:
                shade_value = word.split(":")[1]
                ans.write(f"(id-shade\t {indexing[i]+'0000'}\t {shade_value})\n")
            elif "_" in word and ":" not in word:
                ans.write(f"(id-dis_part\t {indexing[i]+'0000'}\t {word})\n")
            else:
                ans.write(f"(id-speakers_view\t {indexing[i]+'0000'}\t {word})\n")
                
    # Process Construction Information (construction)
    cxn_values_map = {}
    for i in range(len(concept_label)):
        if '[' in concept_label[i] and ']' in concept_label[i]:
            cxnlbl = concept_label[i]#.strip('[]')
            if cxnlbl not in cxn_values_map:
                cxn_values_map[cxnlbl] = {'index': indexing[i] + '0000', 'values': [], 'indices': []}
            for j in range(len(construction)):
                if ':' in construction[j] and construction[j].startswith(f"{indexing[i]}:"):
                    value = construction[j].split(":")[1]
                    cxn_values_map[cxnlbl]['values'].append(value)
                    cxn_values_map[cxnlbl]['indices'].append(indexing[j] + '0000')
              #  else: 
              #      continue
              
    for label, data in cxn_values_map.items():
        values_str = ' '.join(data['values'])
        indices_str = ' '.join(data['indices'])
        ans.write(f"(cxnlbl-id-values {label} {data['index']} {values_str})\n")
        ans.write(f"(cxnlbl-id-val_ids {label} {data['index']} {indices_str})\n")
        
    # Process construction relations like dependency relations
    for i in range(len(construction)):
        if construction[i]:
            cxn_row = construction[i].split(':')
            value1, value2 = cxn_row[0], cxn_row[1]
            ans.write(f"(cxn_rel-ids\t {value2}\t {value1+'0000' if value1 != '0' else value1}\t {indexing[i]+'0000'})\n")
   

    # Print Sentence Type as final fact
    ans.write(f"(sent_type\t {sentence_type.strip()})\n")


