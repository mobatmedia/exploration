# Copyright 2017 Mario O. Bourgoin

def read_user_input(prompt='> ', stop='stop'):
    line_list = []
    line = input(prompt).strip()
    while line!='':
        if line==stop:
            return stop
        line_list.append(line)
        line = input(prompt).strip()
    return ' '.join(line_list)

def converse(converse_memory, seed_token='', stop='stop'):
    prev_token = seed_token
    while True:
        prev_token, utterance = converse_memory.construct(prev_token)
        print(utterance)
        user_input = read_user_input(stop=stop)
        if user_input==stop:
            break
        prev_token = converse_memory.remember(prev_token, user_input)
    return prev_token
