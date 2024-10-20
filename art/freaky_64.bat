@echo off
title 𝓯𝓻𝓮𝓪𝓴𝔂 𝓕𝓝𝓕
cd ..
:Start
color 0a
echo 𝓯𝓻𝓮𝓪𝓴𝔂 𝓰𝓪𝓶𝓮
haxelib run lime test windows
:Restart
color 0c
title 𝓯𝓻𝓮𝓪𝓴𝔂 𝓕𝓝𝓕
set /p menu="𝓯𝓻𝓮𝓪𝓴𝔂? [Y/N]"
       if %menu%==Y goto Start
       if %menu%==y goto Start
       if %menu%==N pause
       if %menu%==n pause
       cls