import re
import sys
from typing import List,Type

class USR:

    @classmethod
    def read_usr(cls,filename):
        '''Returns array of lines for data given in file'''

        try:
            with open(filename, 'r') as file:
                data = file.read().splitlines()
        except FileNotFoundError:
            sys.exit()
        return USR(data)
    
    def __init__(self,data) -> None:
        self.rules_info = []
        self.words_info = []
        self.data = data
    
    def generate_rulesinfo(self):
        '''Return list all 10 rules of USR as list of lists'''
        file_data = self.data
        if len(file_data) < 10 :
            sys.exit()
        
        src_sentence = file_data[0]
        root_words = file_data[1].strip().split(',')
        index_data = file_data[2].strip().split(',')
        seman_data = file_data[3].strip().split(',')
        gnp_data = file_data[4].strip().split(',')
        depend_data = file_data[5].strip().split(',')
        discourse_data = file_data[6].strip().split(',')
        spkview_data = file_data[7].strip().split(',')
        scope_data = file_data[8].strip().split(',')
        sentence_type = file_data[9].strip()

        self.rules_info = [src_sentence, root_words, index_data, seman_data, gnp_data, depend_data, discourse_data, spkview_data, scope_data, sentence_type]
        return self.rules_info
    
    def generate_wordinfo(self):
        '''Generates an array of tuples comntaining word and its USR info.
            USR info word wise.'''
        if len(self.rules_info) != 10:
            return False
        self.words_info = list(zip(self.rules_info[1],self.rules_info[2],self.rules_info[3],self.rules_info[4],self.rules_info[5], self.rules_info[6], self.rules_info[7], self.rules_info[8]))
        return self.words_info
    
    def get_type(self):
        if len(self.rules_info) > 9:
            return self.rules_info[9]
        #log : warning generate rules info first

class Dependence:
    def __init__(self,depStr):
        assert ':' in depStr, 'Parameter given is not properly formatted.'

        d = depStr.split(':')
        self.atIndex = d[0]
        self.name = d[1]
        self.sentence = None
    
    def default_postposition(self):
        d_postpos = {'k1':0, 'pk1':0, 'k2':0, 'k3':'se', 'k4':'ko', 'k5':'se','k7':'meM','k7p':'meM','k7t':'ko',
                        'jk1':'ko', 'rt':'ke liye'}
        return d_postpos.get(self.name,0)

    def get_postposition(self, mypos):
        pp = self.default_postposition()
        if pp != 0 :
            return pp
        if self.name in ('k1','pk1'):
            if self.sentence == None :
                return 0
            if self.sentence.hasTAM('yA'):
                if self.sentence.hasDependency('k2') or self.sentence.hasDependency('k2p'):
                    pp = 'ne'
                    mypos.case = 'o'
                    return pp
        if self.name == 'k2' and mypos.semantic in ('anim','per'):
            pp = 'ko'
            return pp
        if self.name == 'r6' :
            if self.sentence == None :
                return 0
            nextnoun = self.sentence.nextNoun(mypos.index)
            if nextnoun == None:
                return 0
            if nextnoun.gender == 'f':
                pp = 'kI'
                return pp
            elif nextnoun.number == 'p':
                pp = 'ke'
                return pp
            elif nextnoun.postposition != None or nextnoun.postposition != 0:
                pp = 'ke'
                return pp
            else:
                pp = 'kA'
                return pp

        return 0
    
    def set_sentence(self, sent):
        assert isinstance(sent,Sentence), 'Object is not of type : Sentence'
        self.sentence = sent
    
    def get_sentence(self):
        return self.sentence

class DiscourseElement:
    def __init__(self, disstr):
        assert ':' in disstr, 'Parameter given is not properly formatted.'

        d = disstr.strip().split(':')
        self.name = d[1]
        self.atIndex = d[0]

class POS:

    @classmethod
    def clean(cls,rawword):
        w = re.sub(r'[^a-zA-Z]+','', rawword)
        return w
    
    @classmethod
    def create_pos(cls,word_data:List):
        raw_pos = POS(word_data)
        if Indeclinables.check(raw_pos) :
            return Indeclinables(word_data)
        elif Pronoun.check(raw_pos):
            return Pronoun(word_data)
        elif Noun.check(raw_pos):
            return Noun(word_data)
        elif Adjective.check(raw_pos):
            return Adjective(word_data)
        elif Verb.check(raw_pos):
            return Verb(word_data)
        else:
            return Other(word_data)

    def __init__(self,word_data:List):
        self.raw_concept = word_data[0]
        self.concept = POS.clean(word_data[0])
        self.index = int(word_data[1])
        self.semantic = word_data[2]
        gnp_info = word_data[3].strip('][').split(' ') if word_data[3] != '' else None
        if gnp_info != None and len(gnp_info) == 3 :
            self.gender = gnp_info[0]
            self.number = gnp_info[1]
            self.person = gnp_info[2]
        else:
            self.gender = self.number = self.person = None
        self.dependency = Dependence(word_data[4]) if word_data[4] != '' else None
        if word_data[5] != '':
            self.discourse = DiscourseElement(word_data[5])
        else:
            self.discourse = None
        self.spk_view = word_data[6] if word_data[6] != '' else None
    
    def generate_morph_input(self):
        return f"{self.concept}"

class Sentence:

    def __init__(self,type="affirmative"):
        self.type = type
        self.words = []
    
    # def __init__(self,pos:Type[POS],type="affirmative"):
    #     self.__init__(self,type)
    #     pos.dependency.set_sentence(self)
    #     self.words = [pos]
    
    # def __init__(self,pos_list:List[POS],type="affirmative"):
    #     self.__init__(self,type)
    #     self.words = pos_list
    #     for word in self.words:
    #         word.dependency.set_sentence(self)
    #     self.sort()
    
    def getwordByIndex(self,index:int):
        for word in self.words :
            if word.index == index :
                return word
        return None

    def sort(self):
        #sort words according to index number
        pass

    def add_word(self,new_pos:Type[POS]):
        new_pos.dependency.set_sentence(self)
        self.words.append(new_pos)
        self.sort()
    
    def hasTAM(self,tam):
        for word in self.words:
            if word.category == 'v':
                if word.tam == 'yA' :
                    return True
        return False
    
    def hasDependency(self,depen):
        for word in self.words:
            if word.dependency.name == depen :
                return True
        return False
    
    def getWordByDependency(self,depen):
        for word in self.words:
            if word.dependency.name == depen:
                return word
        return False
    
    def nextNoun(self,index) -> Type[POS]:
        lookup = {}
        look = 0
        for word in self.words:
            if word.index == index :
                look = word.dependency.atIndex if word.dependency != None else 0
            lookup[word.index] = word
        while look != index and look != 0 :
            next = look.get(look,0)
            if next == 0:
                return False
            if next.category == 'n' :
                return next
            else :
                look = next.dependency.atIndex if next.dependency != None else 0
    
    def process(self):
        if len(self.words) == 0:
            print('Cannot process sentence. Sentence is empty.')
            return
        for pos in self.words:
            pos.process()
    
    def generate_morph(self):
        if len(self.words) == 0:
            print('Cannot genrate morph. Sentence is empty.')
            return
        morph_in = []
        for pos in self.words:
            morph_in.append(pos.generate_morph_input())
        return " ".join(morph_in)

    @classmethod
    def AlphaPattern(cls,num,sym1,sym2):
        pattern = []
        iters = 2**num
        fspec = 'm>'+str(num)+'b'
        for i in range(iters):
            alphabin = format(i,fspec)
            alphabin = alphabin.replace('0',sym1)
            alphabin = alphabin.replace('1',sym2)
            pattern.append(alphabin)
        return pattern

    def generate_input(self):#Incomplete
        if len(self.words) == 0:
            print('Sentence is empty.')
        amb_np = []
        for pos in self.words:
            if pos.category in ('n','p') and pos.gender == '-':
                amb_np.append(pos)
        if len(amb_np) > 0 :
            pattern = Sentence.AlphaPattern(len(amb_np),'m','f')
            for patt in pattern:
                for i in range(len(amb_np)):
                    amb_np[i].gender = patt[i]
                self.process()
                morph_in = self.generate_morph()
                print(morph_in)

        else:
            self.process()
            morph_in = self.generate_morph()
            print(morph_in)

class Noun(POS):

    @classmethod
    def check(cls,posobj:POS):
        '''Check if word is a noun by the USR info'''
        if posobj.gender != None or posobj.number != None or posobj.person != None :
            return True
        else:
            return False

    def __init__(self,word_data:Type[List]):
        super().__init__(word_data)
        self.category = "n"
        self.IsProperNoun = False
        self.case = 'o'
        self.postposition = None
        if re.search("_[0-9]",self.raw_concept) is None :
            self.IsProperNoun = True
    
    def process_case(self):
        if self.dependency.name == 'k1':
            self.case = 'd'
        elif self.dependency.name == 'k2' and self.semantic != 'anim' :
            self.case = 'd'
        else:
            self.case = 'o'

    def process(self):
        self.process_case()
        self.process_postposition()

    def process_postposition(self):
        ''' NOTE: Add words to sentence and process them before calculating postposition.'''
        self.postposition = self.dependency.get_postposition(self)
        return self.postposition

    def generate_morph_input(self):
        if self.IsProperNoun:
            instr = f"{self.concept}"
        else:
            instr = f"^{self.concept}<cat:{self.category}><case:{self.case}><gen:{self.gender}><num:{self.number}>$"
        if self.postposition != None and self.postposition != 0 :
            instr = instr + ' ' + self.postposition
        return instr

class Pronoun(POS):

    @classmethod
    def check(cls,posobj:POS):
        '''check if word is a pronoun by the USR info.'''
        if posobj.concept in ('addressee', 'speaker','kyA', 'Apa', 'jo', 'koI', 'kOna', 'mEM', 'saba', 'vaha', 'wU', 'wuma', 'yaha'):
            return True
        elif posobj.discourse != None:
            if posobj.discourse.name == 'coref' :
                return True
        else:
            return False
    
    def __init__(self,word_data):
        super().__init__(word_data)
        self.category = "p"
        self.fnum = None
        self.case = 'o'
    
    def process_concept(self):
        if self.raw_concept == 'speaker' :
            self.concept = 'mEM'
        elif self.raw_concept == 'addressee':
            addr_map = {'respect':'Apa', 'informal':'wU'}
            self.concept = addr_map.get(self.spk_view, 'wuma')
        elif self.raw_concept == 'vaha' :
            self.concept = 'vaha'
        else:
            self.concept = POS.clean(self.raw_concept)

    def process_case(self):
        if self.dependency.name == 'k1':
            if self.concept in ('kOna','kyA') and self.semantic not in ('anim','per'):
                self.case = "d"
        if self.dependency.name == "k2" and self.semantic in ('anim','per'):
            self.case = "d"

    def process_fnum(self):
        if self.dependency.name == 'r6' :
            thisSentence = self.dependency.get_sentence()
            if thisSentence == None:
                return
            next_noun = thisSentence.nextNoun(self.index)
            if next_noun == None:
                return
            else:
                self.gender = next_noun.gender
                self.number = next_noun.number
                self.fnum = next_noun.number
                self.case = next_noun.case


    def process(self):
        self.process_concept()
        self.process_case()
        self.process_fnum()
    
    def process_postposition(self):
        ''' NOTE: Add words to sentence and process them before calculating postposition.'''

        self.postposition = self.dependency.get_postposition(self)
        return self.postposition
    
    def generate_morph_input(self):
        if self.fnum != None :
            instr = f"^{self.concept}<cat:{self.category}><parsarg:{self.parsarg}><fnum:{self.fnum}><case:{self.case}><gen:{self.gender}><num:{self.number}><per:{self.number}>$"
        else:
            instr = f"^{self.concept}<cat:{self.category}><case:{self.case}><parsarg:{self.dependency.get_postposition(self)}><gen:{self.gender}><num:{self.number}><per:{self.number}>$"
        
        return instr

class Adjective(POS):

    @classmethod
    def check(cls,posobj:POS):
        if posobj.dependency.name in ('card','mod','meas','ord','intf'):
            return True
        return False

    def __init__(self,word_data):
        super().__init__(word_data)
        self.category = "adj"
    
    def process(self):
        thisSentence = self.dependency.get_sentence()
        if thisSentence == None:
            return
        next_noun = thisSentence.nextNoun(self.index)
        if next_noun == None:
            return
        else:
            self.gender = next_noun.gender
            self.number = next_noun.number
            self.case = next_noun.case
    
    def generate_morph_input(self):
        return f"^{self.concept}<cat:{self.case}><case:{self.case}><gen:{self.gender}><num:{self.number}>$"

class AuxVerb():
    AUX_MAP_FILE = 'auxillary_mapping.txt'
    @classmethod
    def auxmap_hin(cls,aux_verb):
        try:
            with open(AuxVerb.AUX_MAP_FILE,'r') as tamfile:
                for line in tamfile.readlines():
                    aux_mapping = line.strip().split(',')
                    if aux_mapping[0] == aux_verb :
                        return aux_mapping[1], aux_mapping[2]
            # log(f'"{aux_verb}" not found in Auxillary mapping.', 'WARNING')
            return False
        except FileNotFoundError:
            # log('Auxillary Mapping File not found.', 'ERROR')
            sys.exit()

    def __init__(self,name:str,verbObj:Type[POS]):
        self.concept = name
        self.root = None
        self.tam = None
        self.mainVerb = verbObj
        self.calculateRootTAM()
    
    def calculateRootTAM(self):
        root_tam = AuxVerb.auxmap_hin(self.concept)
        if root_tam != False :
            self.root, self.tam = root_tam

class Verb(POS):
    
    @classmethod
    def check(cls,posobj:POS):
        if '-' in posobj.raw_concept:
            #Check root word in TAM dictionary
            return True
        return False

    def __init__(self,word_data):
        super().__init__(word_data)
        self.category = "v"
        self.root = self.calculateRoot()
        self.tam = self.calculateTAM()
        self.auxillary_verbs = self.calculateAuxillary()
    
    def calculateRoot(self):
        root = self.raw_concept.split('-')[0]
        return POS.clean(root)
    
    def calculateTAM(self):
        tam = self.raw_concept.split('-')[1].split('_')[0]
        if self.root == 'hE' and tam in ('pres','past'):
            alt_tam = {'pres':'hE', 'past':'WA'}
            tam = alt_tam[tam]
        return tam
     
    def calculateAuxillary(self):
        vsplit = self.raw_concept.split('_')
        aux = []
        for v in vsplit[2:] :
            if v.isdigit():
                continue
            else:
                aux.append(AuxVerb(v,self))
        return aux
    
    def set_default_gender(self):
        self.gender = 'm'
        return 'm'
    
    def set_default_number(self):
        self.number = 's'
        return 's'
    
    def set_default_person(self):
        self.person = 'a'
        return 'a'
    
    def set_default_gnp(self):
        self.set_default_gender()
        self.set_default_number()
        self.set_default_person
    
    def process_gnp(self):
        thisSentence = self.dependency.get_sentence()
        if thisSentence == None :
            self.set_default_gnp()
            return
        if self.tam == 'yA' and self.dependency != None:
            fword = self.dependency.get_sentence().getWordByDependency('k2')
            if fword != False:
                self.gender = fword.gender if fword.gender != None else self.set_default_gender()
                self.number = fword.number if fword.number != None else self.set_default_number()
                self.person = fword.person if fword.person != None else self.set_default_person()
                return
        fword = self.dependency.get_sentence().getWordByDependency('k1')
        if fword != False:
            self.gender = fword.gender if fword.gender != None else self.set_default_gender()
            self.number = fword.number if fword.number != None else self.set_default_number()
            self.person = fword.person if fword.person != None else self.set_default_person()
            return
        else:
            self.set_default_gnp()

    def process(self):
        self.process_gnp()

    def generate_morph_input(self):
        morph_input =  f'^{self.root}<cat:{self.category}><gen:{self.gender}><num:{self.number}><per:{self.person}><tam:{self.tam}>$'
        for auxverb in self.auxillary_verbs:
            aux_morph = f'^{auxverb.root}<cat:{self.category}><gen:{self.gender}><num:{self.number}><per:{self.person}><tam:{auxverb.tam}>$'
            morph_input = morph_input + ' ' + aux_morph
        return morph_input

class Other(POS):

    @classmethod
    def check(cls,raw_pos:POS):
        if Indeclinables.check(raw_pos) :
            return False
        elif Pronoun.check(raw_pos):
            return False
        elif Noun.check(raw_pos):
            return False
        elif Adjective.check(raw_pos):
            return False
        elif Verb.check(raw_pos):
            return False
        else:
            return True

    def __init__(self,word_data):
        super().__init__(word_data)
        self.category = "other"
    
    def process(self):
        pass

    def generate_morph_input(self):
        return f"{self.concept}" 

class Indeclinables(POS):

    @classmethod
    def check(cls,posobj:POS):
        indeclinable_words = (
            'waWA,Ora,paranwu,kinwu,evaM,waWApi,Bale hI,'
            'wo,agara,magara,awaH,cUMki,cUzki,jisa waraha,'
            'jisa prakAra,lekina,waba,waBI,yA,varanA,anyaWA,'
            'wAki,baSarweM,jabaki,yaxi,varana,paraMwu,kiMwu,'
            'hAlAzki,hAlAMki,va,Aja'
        )
        indeclinable_list = indeclinable_words.split(",")
        if posobj.concept in indeclinable_list :
            return True
        return False

    def __init__(self,word_data:List):
        super().__init__(word_data)
        self.category = "indec"
    
    def process(self):
        pass

    def generate_morph_input(self):
        return f"{self.concept}" 

class Compounds(POS):
    pass


print("program start")
myusr = USR.read_usr("verified_sent/1")
myusr.generate_rulesinfo()
myusr.generate_wordinfo()
mysen = Sentence(myusr.get_type())
for word_data in myusr.words_info:
    mypos = POS.create_pos(word_data)
    mysen.add_word(mypos)

mysen.generate_input()