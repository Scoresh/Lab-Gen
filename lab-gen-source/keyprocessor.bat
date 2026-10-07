@echo OFF

:main
    call:compileJava
    :: Run the Java program and capture its output into a variable
    @echo off
    for /f "delims=" %%i in ('java -cp java_util KeyProcessorFile') do set "JAVA_OUTPUT=%%i"
    echo The batch script received: %JAVA_OUTPUT%
EXIT /B 0



::-------------------------:
:: Compile java 
::-------------------------:
:compileJava
  @echo on
  echo Compiling Java...
  javac java_util/KeyProcessorFile.java
  echo Java compilation finished.
  @echo off
EXIT /B 0



call:main