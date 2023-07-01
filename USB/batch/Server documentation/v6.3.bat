@echo off

set /p "output_types=Enter output file type(s) separated by space (csv/xml/html/txt/json) [komp/all]: " || set "output_types=all"
if /i "%output_types%"=="all" set "output_types=csv xml html txt json"

if /i "%output_types%"=="komp" (
    set "folder_name=installed roles"
    set "export_dir=%~dp0%folder_name%"
) else (
    set /p "folder_name=Enter name for output folder [installed roles]: " || set "folder_name=installed roles"
    set "export_dir=%~dp0%folder_name%"
    if not exist "%export_dir%" mkdir "%export_dir%"
)



for %%i in (%output_types%) do (
    if /i "%%i"=="csv" (
        powershell.exe -Command "Get-WindowsFeature | Export-Csv -Path '%export_dir%\installed.csv' -NoTypeInformation"
    ) else if /i "%%i"=="xml" (
        powershell.exe -Command "Get-WindowsFeature | Export-Clixml -Path '%export_dir%\installed.xml'"
    ) else if /i "%%i"=="html" (
        set /p "save_html=Do you want to save the HTML file in the root directory of the IIS service? (y/n) [y]: " || set "save_html=y"
        if /i "%save_html%"=="y" (
            powershell.exe -Command "Get-WindowsFeature | ConvertTo-Html | Out-File -FilePath 'C:\inetpub\wwwroot\wiki.html'"
        ) else (
            powershell.exe -Command "Get-WindowsFeature | ConvertTo-Html | Out-File -FilePath '%export_dir%\installed.html'"
        )
    ) else if /i "%%i"=="txt" (
        powershell.exe -Command "Get-WindowsFeature | Out-File -FilePath '%export_dir%\installed.txt'"
    ) else if /i "%%i"=="json" (
        powershell.exe -Command "Get-WindowsFeature | ConvertTo-Json | Out-File -FilePath '%export_dir%\installed.json'"
    ) else if /i "%%i"=="komp" (
	    if not exist "C:\installed\" mkdir "C:\installed"
        powershell.exe -Command "Get-WindowsFeature | ConvertTo-Html | Out-File -FilePath 'C:\inetpub\wwwroot\wiki.html'"
        powershell.exe -Command "Get-WindowsFeature | Out-File -FilePath 'C:\installed\installed.txt'"
        powershell.exe -Command "Get-WindowsFeature | Export-Clixml -Path 'C:\installed\installed.xml'"
        start http://127.69.69.69/wiki.html
        start "" "%SystemRoot%\explorer.exe" "C:\installed\installed.xml"
        start "" "%SystemRoot%\explorer.exe" "C:\installed\installed.txt"
    ) else (
        echo Invalid output file type: %%i. Skipping...
    )
)
