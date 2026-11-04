@ECHO OFF
:: Runs the Lab-Gen test suites (Java utilities + Lua filters).
:: Run from anywhere; the script moves to its own folder first.
:: Requires: javac/java and pandoc on PATH.
setlocal
cd /d "%~dp0"

set "RESULT=0"

echo === Java tests ===
if not exist tests\out mkdir tests\out
javac -d tests\out java_util\KeyStore.java java_util\SpellChecker.java tests\JavaTests.java
if errorlevel 1 (
  echo Java compilation failed.
  set "RESULT=1"
) else (
  java -cp tests\out JavaTests
  if errorlevel 1 set "RESULT=1"
)

echo.
echo === Lua tests ===
pandoc lua tests\test_lua_filters.lua
if errorlevel 1 set "RESULT=1"

echo.
if "%RESULT%"=="0" (echo ALL TESTS PASSED) else (echo SOME TESTS FAILED)
exit /b %RESULT%
