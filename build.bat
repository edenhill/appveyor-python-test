SETLOCAL ENABLEEXTENSIONS

rem x86 or x64
set ARCH=%1
rem win32 or win_amd64
set BW_ARCH=%2

echo on

echo go

set CIBW_BUILD=cp27-%BW_ARCH% cp36-%BW_ARCH% cp37-%BW_ARCH% cp38-%BW_ARCH% cp39-%BW_WARCH%
set CIBW_BEFORE_BUILD=python -m pip install delvewheel==0.0.6
set xCIBW_TEST_COMMAND={project}\test.bat {project}
set CIBW_TEST_COMMAND=python {project}\test.py
set CIBW_BUILD_VERBOSITY=3
set INCLUDE_DIRS=%cd%\inst\build\native\include
set DLL_DIR=%cd%\inst\runtimes\win-%ARCH%\native
set LIB_DIRS=%cd%\inst\build\native\lib\win\%ARCH%\win-%ARCH%-Release\v120
set CIBW_REPAIR_WHEEL_COMMAND=python -m delvewheel repair --add-path %DLL_DIR% -w {dest_dir} {wheel}

echo go2

set PATH=%PATH%;c:\Program Files\Git\bin\

echo go3

bash install-librdkafka.sh inst

echo go4

python -m pip install cibuildwheel==1.7.4

echo go5

python -m cibuildwheel --output-dir wheelhouse --platform windows

echo go6

dir wheelhouse

echo go7


