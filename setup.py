from setuptools import setup, find_packages, Extension
import os

libs = []

if os.name == 'nt':
    libs.append('librdkafka')
else:
    libs.append('rdkafka')

print("INCLUDE_DIRS IS: ", os.environ.get('INCLUDE_DIRS', 'NADA'))
print("LIB_DIRS IS: ", os.environ.get('LIB_DIRS', 'FADA'))

module1 = Extension('hello.chello',
                    sources=['src/hello/hellomodule.c'],
                    include_dirs=os.environ.get('INCLUDE_DIRS', '').split(','),
                    library_dirs=os.environ.get('LIB_DIRS', '').split(','),
                    libraries=libs)

setup(
    name='hello',
    version='1.0.2',
    packages=find_packages('src'),
    package_dir={'': 'src'},
    ext_modules = [module1],
)

