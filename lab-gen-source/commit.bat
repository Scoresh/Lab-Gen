@echo off
:: Commits and pushes local changes.
::   commit.bat ["optional commit message"]
:: Shows what will be committed first, refuses to commit secrets, and syncs
:: with the remote BEFORE pushing so the push is not rejected.
setlocal
cd /d "%~dp0\.."

:: Never let the personal key file get committed, even if .gitignore is edited.
git ls-files --error-unmatch key.loc >nul 2>&1
if not errorlevel 1 (
  echo ERROR: key.loc is tracked by git. Run: git rm --cached key.loc
  exit /b 1
)

set "MSG=%~1"
if "%MSG%"=="" set "MSG=Made changes on %date% at %time%"

:: Respects .gitignore; stages new, modified and deleted files in the repo.
git add -A
echo.
echo Changes to be committed:
git status --short
echo.

git diff --cached --quiet
if not errorlevel 1 (
  echo Nothing to commit.
  exit /b 0
)

set /p "CONFIRM=Commit and push with message '%MSG%'? [y/N] "
if /i not "%CONFIRM%"=="y" (
  git reset -q
  echo Cancelled. Nothing was committed.
  exit /b 1
)

git commit -m "%MSG%" || exit /b 1
git pull --rebase || (echo Pull/rebase failed - resolve it, then run git push. & exit /b 1)
git push
