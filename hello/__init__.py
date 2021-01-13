import chello

class Hello(object):
	def __init__(self):
		self._chello = chello()
	def say_hello(self, name):
		self._chello.say_hello(name)

