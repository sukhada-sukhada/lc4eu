import sys

if len(sys.argv) < 2:
    print("Usage: python script.py <filename>")
    sys.exit(1)

filename = sys.argv[1]
head = ''
with open(filename, 'r', encoding='utf8') as parserfile:
    pf = parserfile.readlines()
    for item in pf:
        columns = item.split('\t')
        rel = columns[4].strip()
        if rel == 'pof__cn':
            print(f'{columns[0]}\t{columns[1]}\t{columns[2]}\t{columns[3]}\t{columns[4]}')
            head = columns[3]
        if columns[0] ==  head:
            print(f'{columns[0]}\t{columns[1]}\t{columns[2]}\t{columns[3]}\t{columns[4]}\n')
