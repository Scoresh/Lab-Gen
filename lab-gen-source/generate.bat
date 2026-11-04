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
  SET "file="
  SET "spell="
  SET "helponly="
  call :parseflags %*

  ::-h only prints help; do not render anything.
  if "!helponly!" == "1" EXIT /B 0

  ::Compiled .class files are not tracked in git, so build ColoredText on first run.
  if not exist java_util\ColoredText.class call :compileJava

  ::important: once flags are parsed, note that we must check that flags exist so we don't have any goofy java error codes. 
  ::No need to give warnings.
  if "!color!" == "" (
    @REM call :warning The -color flag is missing. Defaulting to RED
    SET "color=red")
  if "!text!" == "" (
    @REM call :warning The -text flag is missing. Defaulting to DEFAULT
    SET "text=default")
  if "!file!" == "" (
    @REM call :warning The -file flag is missing. Defaulting to text
    SET "file=text"
  )
  call :generateTitle "!color!" "!text!"

  ::Run spell check before rendering if the -spell flag was provided.
  if /I "!spell!" == "1" (
    call :generateSpell "!file!"
  )

  call :generatePDF "!file!"


  call :generateTEX "!file!"
EXIT /B 0

::-------------------------:
:: Generate title 
::-------------------------:
:generateTitle
  java -cp java_util ColoredText %1 %2
EXIT /B 0




::-------------------------:
:: Runs the spell checker on the markdown file before rendering.
::-------------------------:
:generateSpell
  echo Compiling spell checker...
  javac java_util/KeyStore.java java_util/SpellChecker.java
  echo Running spell check...
  java -cp java_util SpellChecker ../projects/projects_markdown/%1.md
EXIT /B 0


::-------------------------:
:: Compile java 
::-------------------------:
:compileJava
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
  --wrap preserve^
  --from markdown-smart-smart ../projects/projects_markdown/%1.md -o ../projects/projects_rendered/%1.pdf^
  --pdf-engine=lualatex^
  --lua-filter=lua_filters/preprocess.lua^
  --lua-filter=lua_filters/process.lua
  
EXIT /B 0

:generateTEX
  echo Generating LaTeX...
  pandoc ^
  --template=latex_templates/basetemplate.tex^
  --wrap preserve^
  --from markdown-smart-smart ../projects/projects_markdown/%1.md -o ../projects/projects_debug/%1.tex^
  --pdf-engine=lualatex^
  --lua-filter=lua_filters/preprocess.lua^
  --lua-filter=lua_filters/process.lua
EXIT /B 0

:convertDOCXtoMARKDOWN
  if not exist "../projects/projects_docx/%~1.docx" (
    call :warning Error: ../projects/projects_docx/%~1.docx was not found. Put the .docx in projects/projects_docx.
    EXIT /B 1
  )
  echo Converting from DOCX to MARKDOWN...
  pandoc "../projects/projects_docx/%~1.docx" -o "../projects/projects_markdown/%~1.md"
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
    SET "helponly=1"
    GOTO :endOfParseFlagsFunc
)






:: Check for -cj (Compile java)
IF /I "%~1"=="-cj" (
    ECHO Compile flag detected.
    call :compileJava
    SHIFT
    GOTO :parseflags
)


:: Check for -debug (verbose Lua filter output; sets LABGEN_DEBUG for pandoc)
IF /I "%~1"=="-debug" (
    ECHO Debug flag detected.
    SET "LABGEN_DEBUG=1"
    SHIFT
    GOTO :parseflags
)


:: Check for -spell (Run spell check before rendering)
IF /I "%~1"=="-spell" (
    ECHO Spell check flag detected.
    SET "spell=1"
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

:: Check for -file VALUE
IF /I "%~1"=="-file" (
    IF NOT "%~2"=="" (
        SET "file=%~2"
        ECHO File set to: !file!
        SHIFT
        SHIFT
        GOTO :parseflags
    ) ELSE (
        call:warning Error: -file requires a value. Defaulting to ^file TEXT
        SET "file=text"
        EXIT /B 1
    )
)

:: Check for -docx VALUE
IF /I "%~1"=="-docx" (
    IF NOT "%~2"=="" (
        call :convertDOCXtoMARKDOWN %2
        SHIFT
        SHIFT
        GOTO :parseflags
    ) ELSE (
        call:warning Error: -Docx requires a value. Defaulting to ^docx TEXT
        call :convertDOCXtoMARKDOWN text
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
  echo Usage: generate.bat [flags]   (run from the repository root)
  echo   -file NAME    Markdown file in projects/projects_markdown, without extension. Default: text
  echo   -color NAME   Banner color: red, green, yellow, blue, purple, cyan, white, black. Default: red
  echo   -text TEXT    Banner text. Default: the Lab-Gen logo
  echo   -cj           Recompile the Java helpers
  echo   -spell        Run a spelling/grammar check on the markdown file before rendering
  echo   -docx NAME    Convert projects/projects_docx/NAME.docx to markdown first
  echo   -debug        Print verbose debug output from the Lua filters
  echo   -h            Show this help
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
