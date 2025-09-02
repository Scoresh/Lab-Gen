@ECHO OFF
setlocal ENABLEDELAYEDEXPANSION
cd lab-gen-source
::Main Method. Makes a call to main()
call :main %*

::Exit Header
EXIT /B %ERRORLEVEL%


::-------------------------:
:: Main function.
::-------------------------:
:main
  SET "color="
  SET "text="
  SET "template="
  call :parseflags %*

  ::important: once flags are parsed, note that we must check that flags exist so we don't have any goofy java error codes. 
  ::No need to give warnings.
  if "!color!" == "" (
    @REM call :warning The -color flag is missing. Defaulting to RED
    SET "color=red")
  if "!text!" == "" (
    @REM call :warning The -text flag is missing. Defaulting to DEFAULT
    SET "text=default")

  call :generateTitle "!color!" "!text!"


  call :generatePDF
  ::call :generateTEX
EXIT /B 0

::-------------------------:
:: Generate title 
::-------------------------:
:generateTitle
  java -cp java_util ColoredText %1 %2
EXIT /B 0


::-------------------------:
:: Compile java 
::-------------------------:
:compileJava
  @echo on
  echo Compiling Java...
  javac java_util/ColoredText.java
  echo Java compilation finished.
EXIT /B 0



::-------------------------:
:: Generates PDF using pandoc; 
::-------------------------:
:generatePDF
  echo Generating PDF...
  pandoc ^
  --template=latex_templates/basetemplate.tex^
  --from markdown-smart-smart ../text.md -o ../text.pdf^
  --pdf-engine=lualatex^
  --lua-filter=lua_filters/preprocess.lua^
  --lua-filter=lua_filters/command.lua
  
EXIT /B 0

:generateTEX
  echo Generating LaTeX...
  pandoc ^
  --template=latex_templates/basetemplate.tex^
  --from markdown ../text.md -o ../text.tex^
  --pdf-engine=lualatex^
  --lua-filter=lua_filters/preprocess.lua^
  --lua-filter=lua_filters/command.lua
EXIT /B 0

::-------------------------:
:: Parses Flags; 
::-------------------------:
:parseflags
IF "%~1"=="" GOTO :endOfParseFlagsFunc

:: Check for -h (Help)
IF /I "%~1"=="-h" (
    ECHO Help flag detected.
    call :help
    GOTO :endOfParseFlagsFunc
)







:: Check for -cj (Compile java)
IF /I "%~1"=="-cj" (
    ECHO Compile flag detected.
    call :compileJava
    SHIFT
    GOTO :parseflags
)


:: Check for -color VALUE
IF /I "%~1"=="-color" (
    IF NOT "%~2"=="" (
        SET "color=%~2"
        ECHO Color set to: !color!
        SHIFT
        SHIFT
        GOTO :parseflags
    ) ELSE (
        call:warning Error: -color requires a value. Defaulting to ^color RED
        SET "color=RED"
        EXIT /B 1
    )
)

:: Check for -text VALUE
IF /I "%~1"=="-text" (
    IF NOT "%~2"=="" (
        SET "text=%~2"
        ECHO Text set to: !text!
        SHIFT
        SHIFT
        GOTO :parseflags
    ) ELSE (
        call:warning Error: -text requires a value. Defaulting to text DEFAULT
        set "text=default"
        EXIT /B 1
    )
)

:: Check and Print Unknown flag(s)
ECHO Unknown flag: %1
SHIFT
GOTO :parseflags

:endOfParseFlagsFunc
EXIT /B 0


::====================:
:: Help Flag
::====================:
:help 
  echo -color: Set color of default text. Defaults to RED
  echo -jc: Compile Java 
EXIT /B 0
::====================:
:: Colored Text (CLI)
::====================:
:warning
  if "%~1"=="" GOTO :endofwarningFunc
  <nul set /p =[93m%1 [0m
  SHIFT
  GOTO :warning
  :endofwarningFunc
  echo.
EXIT /B 0

:error 
  if "%~1"=="" GOTO :endoferrorFunc
  <nul set /p =[91m%1[0m
  SHIFT
  GOTO :error
  :endoferrorFunc
  echo.
EXIT /B 0

PAUSE