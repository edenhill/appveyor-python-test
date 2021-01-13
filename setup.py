from distutils.core import Extension
from setuptools import setup, find_packages
import os

libs = []

if os.name == 'nt':
    libs.append('librdkafka')
else:
    libs.append('rdkafka')

module1 = Extension('chello',
                    sources=['src/hellomodule.c'],
                    include_dirs=os.environ.get('INCLUDE_DIRS', '').split(','),
                    library_dirs=os.environ.get('LIB_DIRS', '').split(','),
                    libraries=libs)

setup(
    name='hello',
    version='1.0',
    packages=find_packages('src'),
    package_dir={'': 'src'},
    ext_modules = [module1],
)

