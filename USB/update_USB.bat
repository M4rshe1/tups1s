@echo off
setlocal

set "source=C:\Users\Colin\OneDrive - Berufsbildungszentrum Schaffhausen\Privat\USB"


echo Do you really want to update the USB directory? [Y/N]
set /p "confirm="


if /i "%confirm%"=="Y" (
    robocopy "%source%" %~d0\USB /S /Z /TEE /PURGE
    copy .\USB\start.bat \start.bat
    echo Copied USB
) else (
    if /i "%confirm%"=="o" (
        robocopy "%source%" %~d0\USB /S /Z /TEE /PURGE
        copy .\USB\start.bat \start.bat
        rmdir /s /q .\USB\PW\
        rmdir /s /q .\USB\Scripts\VPN\
        echo Copied USB
    ) else (
        echo Copy operation canceled.
    )
    
)



endlocal


