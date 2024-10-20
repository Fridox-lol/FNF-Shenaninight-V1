@echo off
color 5b
cd ..
echo BUILDING GAME
haxelib run lime run windows -debug
echo.
echo done.
pause