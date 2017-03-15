# Copyright 2017 Mario O. Bourgoin

from memory import Memory
from textwrap import TextWrapper


def read_user_input(prompt='> ', end_program='end_program'):
    line_list = []
    line = input(prompt).strip()
    while line != '':
        if line == end_program:
            return end_program
        line_list.append(line)
        line = input(prompt).strip()
    return ' '.join(line_list)


def converse(converse_memory, seed_index='', end_program='end_program',
             wrapper = TextWrapper()):
    prev_index = seed_index.strip()
    while True:
        utterance, prev_index = converse_memory.construct(prev_index)
        for fragment in wrapper.wrap(utterance):
            print(fragment)
        user_input = read_user_input(end_program=end_program)
        if user_input == end_program:
            break
        prev_index = converse_memory.remember(user_input, prev_index)
    return prev_index

if __name__ == "__main__":
    converse_memory = Memory()
    converse_memory.read('../data/converse_preload.txt', '')
    prev_index = converse(converse_memory, '')
    converse_memory.save('../data/converse_memory.pkl')
