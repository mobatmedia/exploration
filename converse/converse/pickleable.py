# Copyright 2017 Mario O. Bourgoin

import pickle

class Pickleable(object):
    """Class for subclassing to create pickleable classes"""

    def __init__(self, **kwargs):
        return super().__init__(**kwargs)

    @classmethod
    def load(self, path):
        obj = self.__new__(self)
        with open(path, 'rb') as fp:
            obj.__dict__.update(pickle.load(fp))
        return obj
    
    def save(self, path):
        with open(path, 'wb') as fp:
            pickle.dump(self.__dict__, fp, pickle.DEFAULT_PROTOCOL)
        return
