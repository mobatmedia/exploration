# Copyright 2017 Mario O. Bourgoin

import pickle


class Pickling(object):
    """Ancillary mix-in class to get a pickling class."""

    def __init__(self, **kwargs):
        self.description = "Ancillary mix-in class to get a pickling class."
        self.author = "Mario O. Bourgoin"
        self.__version__ = "0.0.1"
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
