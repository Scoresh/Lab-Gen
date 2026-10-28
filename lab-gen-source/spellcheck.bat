@ECHO OFF
setlocal ENABLEDELAYEDEXPANSION

::Main Method. Makes a call to main()
call :main %*

::Exit Header
EXIT /B %ERRORLEVEL%


::-------------------------:
:: Main function.
::-------------------------:
:main
  SET "file="
  call :parseflags %*

  :: Default to the demo file if no -file flag was provided.
  if "!file!" == "" (
    SET "file=text"
  )

  call :compileJava

  echo Running spell check on !file!.md ...
  java -cp java_util SpellChecker ../projects/projects_markdown/!file!.md
EXIT /B 0


::-------------------------:
:: Compile java
::-------------------------:
:compileJava
  echo Compiling Java...
  javac java_util/KeyStore.java java_util/SpellChecker.java
  echo Java compilation finished.
EXIT /B 0


::-------------------------:
:: Parses Flags
::-------------------------:
:parseflags
IF "%~1"=="" GOTO :endOfParseFlagsFunc

:: Check for -h (Help)
IF /I "%~1"=="-h" (
    call :help
    GOTO :endOfParseFlagsFunc
)

:: Check for -file VALUE
IF /I "%~1"=="-file" (
    IF NOT "%~2"=="" (
        SET "file=%~2"
        ECHO File set to: !file!
        SHIFT
        SHIFT
        GOTO :parseflags
    ) ELSE (
        ECHO Error: -file requires a value. Defaulting to text
        SET "file=text"
        SHIFT
        GOTO :parseflags
    )
)

:: Unknown flag
ECHO Unknown flag: %1
SHIFT
GOTO :parseflags

:endOfParseFlagsFunc
EXIT /B 0


::====================:
:: Help Flag
::====================:
:help
  echo spellcheck.bat - run a spelling/grammar check on a markdown project
  echo   -file VALUE   Name (without extension) of the file in projects/projects_markdown
  echo   -h            Show this help
EXIT /B 0
