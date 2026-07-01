@ECHO OFF
setlocal ENABLEDELAYEDEXPANSION

call myvars.txt
call :main %*

::Exit Header
EXIT /B %ERRORLEVEL%

::-------------------------:
:: Main function.
::-------------------------:
:main
    SET "src="
    SET "file="
    call :parseflags %*
    SET "ogsrc=%~dp0"

    ::important: once flags are parsed, note that we must check that flags exist
    if "!file!" == "" (
        call :warning The -file flag is missing. DUMPING to avoid accidental creation of directory
        EXIT /B 0
    )

    cd !src!


    @ECHO OFF

    :: modify date
    set "modified_date=%date%"
    set "modified_date=%modified_date:/=.%"
    set "modified_date=%modified_date: =_%"
    set "modified_time=%time%"
    set "modified_time=%modified_time::=.%"
    mkdir "%modified_date%_at_%modified_time%_---_!file!"
    copy /y "!ogsrc:\lab-gen-source=!projects\projects_debug\!file!.tex" "!src!\%modified_date%_at_%modified_time%_---_!file!/"
    copy /y "!ogsrc:\lab-gen-source=!projects\projects_markdown\!file!.md" "!src!\%modified_date%_at_%modified_time%_---_!file!/"
    copy /y "!ogsrc:\lab-gen-source=!projects\projects_rendered\!file!.pdf" "!src!\%modified_date%_at_%modified_time%_---_!file!/"
    
    call :warning Success!
EXIT /B 0





::-------------------------:
:: Parses Flags
::-------------------------:
:parseflags
IF "%~1"=="" GOTO :endOfParseFlagsFunc

:: Check for -text VALUE
IF /I "%~1"=="-src" (
    IF NOT "%~2"=="" (
        SET "src=%~2"
        ECHO Text set to: !src!
        SHIFT
        SHIFT
        GOTO :parseflags
    ) ELSE (
        call:warning Error: -src requires a value. Defaulting to default text
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

:: Check and Print Unknown flag(s)
ECHO Unknown flag: %1
SHIFT
GOTO :parseflags

:endOfParseFlagsFunc
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



