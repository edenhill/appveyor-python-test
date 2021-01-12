from distutils.core import setup, Extension

module1 = Extension('hello',
                    sources=['hellomodule.c'])

setup(
    name='hello',
    version='1.0',
    ext_modules = [module1],
)

