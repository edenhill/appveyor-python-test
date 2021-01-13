from hello import _hello

class Bye(object):
	def __init__(self):
		self._hello = _Hello()
	def say_hello(self, name):
		self._hello.say_hello(name)

