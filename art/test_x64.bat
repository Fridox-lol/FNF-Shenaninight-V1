@echo off
title Compile FNF
cd ..
:Start
echo BUILDING GAME
lime test windows
:Restart
title Recompile FNF
set /p menu="Recompile? [Y/N]"
       if %menu%==Y goto Start
       if %menu%==y goto Start
       if %menu%==N pause
       if %menu%==n pause
       cls