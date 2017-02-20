# Copyright 2017 Mario O. Bourgoin


def read_user_input(prompt='> ', end_program='end_program'):
    line_list = []
    line = input(prompt).strip()
    while line != '':
        if line == end_program:
            return end_program
        line_list.append(line)
        line = input(prompt).strip()
    return ' '.join(line_list)


def converse(converse_memory, seed_token='', end_program='end_program'):
    prev_token = seed_token
    while True:
        prev_token, utterance = converse_memory.construct(prev_token)
        print(utterance)
        user_input = read_user_input(end_program=end_program)
        if user_input == end_program:
            break
        prev_token = converse_memory.remember(prev_token, user_input)
    return prev_token
