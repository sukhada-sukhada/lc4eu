

word = "gadZa_1"
clean(word)

def clean(word, inplace = ''):
    '''Clean concept words by removing numbers and special characters from it using regex.'''
    if 'dZ' in word:          #handling words with dZ -Kirti - 15/12 
       newWord = word.replace('dZ','d')
    clword = re.sub(r'[^a-zA-Z]+', inplace, newWord)
    return clword