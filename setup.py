from distutils.core import setup, Extension
from os import environ

module1 = Extension('hello',
                    sources=['hellomodule.c'],
                    include_dirs=environ.get('INCLUDE_DIRS', '').split(','),
                    library_dirs=environ.get('LIB_DIRS', '').split(','),
                    libraries=['rdkafka'])

setup(
    name='hello',
    version='1.0',
    ext_modules = [module1],
)

