@echo off
title Shenani Night Console
cd ..

:Menu
set /p menu="What do you want to do? "
	if %menu%==releaseSN goto ReleaseSN
	if %menu%==test goto Compile
:ReleaseSN
echo Are you sure you want to do this? This action cannot be undone.
pause
echo Done. Check Game Jolt and Gamebanana.

goto Menu

:Compile
echo BUILDING GAME
lime test windows
goto Menu