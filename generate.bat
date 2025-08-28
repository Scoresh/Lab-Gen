@ECHO OFF
SETLOCAL EnableDelayedExpansion
for /F "tokens=1,2 delims=#" %%a in ('"prompt #$H#$E# & echo on & for %%b in (1) do     rem"') do (
  set "DEL=%%a"
)
::Main Method. Makes a call to main()
call:main

::Exit Header
EXIT /B %ERRORLEVEL%

::Functions

:main

call "batch_util/color.bat" "red" "title" 


EXIT /B 0


:red
echo off
<nul set /p ".=%DEL%" > "%~1"
findstr /v /a:4c /R "^$" "%~1" nul
del "%~1" > nul 2>&1i
EXIT /B 0
