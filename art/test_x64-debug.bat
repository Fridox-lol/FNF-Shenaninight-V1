@echo off
color 1b
cd ..
echo BUILDING GAME (DEBUG)
haxelib run lime test windows -debug
echo.
echo done.
pause