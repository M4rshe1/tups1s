@echo off
cls
title The Ultimate PS1 Script

cd /d "%~dp0"

for /f "usebackq tokens=*" %%A in (`powershell -command "(Get-Content -Raw '.\USB\Scripts\!config\config.json' | ConvertFrom-Json).settings.color"`) do (
    @REM echo %%A
    color %%A
)

set "ps1FilePath=.\USB\start.ps1"

if exist ".\USB\Scripts\!assets\ascii.txt" (
    @REM echo Found "%%d:\USB\Scripts\!assets\ascii.txt"
    set ascii=".\USB\Scripts\!assets\ascii.txt"
)

type %ascii%
echo.
echo ****************************************************************
echo * Copyright of Colin Heggli 2023                               *
echo * https://colin.heggli.dev                                     *
echo * https://github.com/M4rshe1                                   *
echo ****************************************************************
echo.
echo.
set /p "colorChoice=Press ENTER to Start: "

if "%colorChoice%" neq "" (
    color %colorChoice%
)
powershell.exe -ExecutionPolicy Bypass -File %ps1FilePath%
