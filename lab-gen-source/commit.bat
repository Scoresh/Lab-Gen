@echo off
git add *
git commit -m "Made changes on %date% at %time%"
@echo on
git push
@echo off
git pull