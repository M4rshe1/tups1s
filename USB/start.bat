@echo off
cls
title The Ultimate PS1 Script

for /f "usebackq tokens=*" %%A in (`powershell -command "(Get-Content -Raw '.\USB\Scripts\!config\config.json' | ConvertFrom-Json).settings.color"`) do (
    @REM echo %%A
    color %%A
)


if "%CD%"=="C:\Windows\system32" (
    echo Can't find USB folder. Please provide path.
    set /p "usbPath=USB folder (C:\ not C:\USB): "
    echo %usbPath%
    pause
    cls
)

set "ps1FilePath=.\USB\start.ps1"

if exist ".\USB\Scripts\!assets\ascii.txt" (
    @REM echo Found "%%d:\USB\Scripts\!assets\ascii.txt"
    set ascii=".\USB\Scripts\!assets\ascii.txt"
) else (
    for %%d in (A B C D E F G H I J K L M N O P Q R S T U V W X Y Z) do (
        if exist "%%d:\USB\Scripts\!assets\ascii.txt" (
            @REM echo Found "%%d:\USB\Scripts\!assets\ascii.txt"
            set ascii="%%d:\USB\Scripts\!assets\ascii.txt"
        )
    )
)

type %ascii%
set /p "colorChoice=Press ENTER to Start: "

if "%colorChoice%" neq "" (
    color %colorChoice%
)
powershell.exe -ExecutionPolicy Bypass -File %ps1FilePath%
