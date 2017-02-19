# Copyright 2017 Mario O. Bourgoin

from memory import Memory
from converse_definitions import converse

if __name__=="__main__":
    converse_memory = Memory()
    converse_memory.read('', '../data/converse_preload.txt')
    prev_token = converse(converse_memory, '')
    converse_memory.save('../data/converse_memory.pkl')
