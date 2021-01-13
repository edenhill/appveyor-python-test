from distutils.core import setup, Extension
import os

libs = []

if os.name == 'nt':
    libs.append('librdkafka')
else:
    libs.append('rdkafka')

module1 = Extension('_hello',
                    sources=['hellomodule.c'],
                    include_dirs=os.environ.get('INCLUDE_DIRS', '').split(','),
                    library_dirs=os.environ.get('LIB_DIRS', '').split(','),
                    libraries=libs)

setup(
    name='hello',
    version='1.0',
    packages=['bye'],
    ext_modules = [module1],
)

