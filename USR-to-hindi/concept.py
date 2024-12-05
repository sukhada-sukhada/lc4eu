class Concept:
    def __init__(self, term=None, index=None, semantic_cat=None, GNP=None, dependency=None, discourse_info=None,
                 speaker_view=None, scope=None, sentence_type=None):
        self.term = term
        self.index = index
        self.semantic_cat = semantic_cat
        self.GNP = GNP
        self.dependency = dependency
        self.discourse_info = discourse_info
        self.speaker_view = speaker_view
        self.scope = scope
        self.sentence_type = sentence_type
