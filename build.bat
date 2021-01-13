SETLOCAL ENABLEEXTENSIONS

echo on

echo go

set CIBW_BUILD=cp39-win_amd64
set CIBW_SKIP=cp27-*
set CIBW_BEFORE_BUILD=python -m pip install delvewheel==0.0.6
set CIBW_TEST_COMMAND={project}\test.bat {project}
set CIBW_BUILD_VERBOSITY=3
set INCLUDE_DIRS=%cd%\inst\build\native\include
set DLL_DIR=%cd%\inst\runtimes\win-x64\native
set LIB_DIRS=%cd%\inst\build\native\lib\win\x64\win-x64-Release\v120
set CIBW_REPAIR_WHEEL_COMMAND=python -m delvewheel repair --add-path %cd%\inst\runtimes\win-x64\native -w {dest_dir} {wheel}

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


