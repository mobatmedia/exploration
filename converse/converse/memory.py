# Copyright 2017 Mario O. Bourgoin
from collections import defaultdict
import random
from pickling import Pickling


def defaultdict_int():
    """Factory for defaultdict(int)"""
    return defaultdict(int)


class Memory(Pickling):
    """Store text as ngram chains for use in construction."""

    def __init__(self, n=3, weight=1, baton_token='baton_token', **kwargs):
        self.description = "Store text as ngram chains for use in construction."
        self.author = "Mario O. Bourgoin"
        self.__version__ = "0.0.1"
        self.memory = defaultdict(defaultdict_int)
        self.baton_token = baton_token
        self.weight = weight
        self.n = n
        return super().__init__(**kwargs)

    def __len__(self):
        return len(self.memory)

    def clear(self):
        """Forget all text."""
        self.memory.clear()
        return

    def remember(self, text, seed_index=''):
        """Add tokens from text to memory led by seed_index."""
        prev_index = seed_index.strip()
        text_tokens = text.split()
        if len(text_tokens) == 0:
            return ''
        prev_tokens = prev_index.split()
        tokens = ['']*(self.n-len(prev_tokens)-1)+prev_tokens+[self.baton_token]+text_tokens+[self.baton_token]
        ngrams = [tokens[i: i+self.n] for i in range(len(tokens)-self.n+1)]
        for *head_tokens, next_token in ngrams:
            prev_index = ' '.join(head_tokens).strip()
            self.memory[prev_index][next_token] += self.weight
        return prev_index

    def read(self, path, seed_index=''):
        """Add texts from path to memory led by seed_index."""
        prev_index = seed_index.strip()
        with open(path) as fp:
            line = fp.readline()
            while line != '':
                line = line.strip()
                if len(line) > 0:
                    prev_index = self.remember(line, prev_index)
                else:
                    prev_index = ''
                line = fp.readline()
        return prev_index

    def construct(self, seed_index=''):
        """Generate texts from memory led by seed_index."""
        prev_index = seed_index.strip()
        this_token = self.baton_token
        tokens = []
        while True:
            this_index = ' '.join([prev_index, this_token]).strip()
            if this_index not in self.memory:
                this_token = self.baton_token
                this_index = self.baton_token
            next_token_dict = self.memory[this_index]
            next_token = random.sample(next_token_dict.keys(), 1)[0]
            if next_token == self.baton_token:
                break
            tokens.append(next_token)
            prev_index = this_token
            this_token = next_token
        return this_token, ' '.join(tokens[0:len(tokens)])
