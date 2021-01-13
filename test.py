#!/usr/bin/env python
#

import sys

print("Importing hello")

# importing the extension like a standart python module
try:
    import hello
except Exception as e:
    print("Failed to import hello:\n", str(e))
    raise(e)

print("Successfully imported:")
print(hello.__name__, hello.__doc__)
print(dir(hello))

h = hello.Hello()
h.say_hello("Magnus")
