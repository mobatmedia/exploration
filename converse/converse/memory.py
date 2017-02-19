# Copyright 2017 Mario O. Bourgoin
from collections import defaultdict
import random
from pickleable import Pickleable

def defaultdict_int():
    return defaultdict(int)

class Memory(Pickleable):
    """Remember text as token chains for use in reconstruction."""

    def __init__(self, **kwargs):
        self.description = "Remember text as token chains to later use in reconstruction."
        self.author = "Mario O. Bourgoin"
        self.__version__ = 0.1
        self.n = 3
        self.memory = defaultdict(defaultdict_int)
        self.baton_token = 'baton_token'
        return super().__init__(**kwargs)
    
    def clear(self):
        self.memory.clear()
        return

    def remember(self, seed_token, text):
        tokens = text.split()
        if len(tokens)==0:
            return ''
        prev_token = tokens[len(tokens)-1]
        tokens = [seed_token, self.baton_token]+tokens+[self.baton_token]
        for ngram in [tokens[i : i+self.n] for i in range(len(tokens)-self.n+1)]:
            self.memory[' '.join(ngram[0 : self.n-1]).strip()][ngram[self.n-1]] += 1
        return prev_token

    def read(self, seed_token, path):
        prev_token = seed_token
        with open(path) as fp:
            line = fp.readline()
            while line!='':
                line = line.strip()
                if len(line)>0:
                    prev_token = self.remember(prev_token, line)
                else:
                    prev_token = ''
                line = fp.readline()
        return prev_token
    
    def construct(self, seed_token):
        tokens = []
        prev_token = seed_token
        this_token = self.baton_token
        while True:
            this_index = ' '.join([prev_token, this_token]).strip()
            if this_index not in self.memory:
                this_index = random.sample(self.memory.keys(), 1)[0]
            next_token_dict = self.memory[this_index]
            next_token = random.sample(next_token_dict.keys(), 1)[0]
            if next_token==self.baton_token:
                break
            tokens.append(next_token)
            prev_token = this_token
            this_token = next_token
        return (this_token, ' '.join(tokens[0:len(tokens)]))
