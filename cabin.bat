@echo off
setlocal
set cabinfile=cabin.pkg
if not exist %cabinfile% goto :missing_file
if not exist Public mkdir Public
for /f "tokens=*" %%i in (%cabinfile%) do call :main "%%i"
goto :eof

:fetch_pkg
set pkg=%1 
set repo=%2
set ver=%3
set url="https://github.com/%repo%"
cd Public
if not exist %pkg% (
	@echo on
	git clone %url: =% %pkg%
	cd %pkg%
	@echo off
) else (
	cd %pkg%
)	
call :checkout_ver %ver%
cd ..
cd ..
goto :eof

:checkout_ver
@echo on
git fetch --tags
git checkout %1
@echo off
goto :eof

:main
@echo off
for /f "tokens=1-3 delims= " %%a in (%1) do call :fetch_pkg %%a %%b %%c
goto :eof

:missing_file
echo Missing file %cabinfile%
exit /b
