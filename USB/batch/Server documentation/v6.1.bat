@echo off

set /p output_types=Enter output file type(s) separated by space (csv/xml/html/txt/json/all): 
if /i "%output_types%"=="all" set "output_types=csv xml html txt json"
set /p folder_name=Enter name for output folder: 

set "export_dir=%~dp0\%folder_name%"

for %%i in (%output_types%) do (
    if /i "%%i"=="csv" (
        if not exist "%export_dir%" mkdir "%export_dir%"
        powershell.exe -Command "Get-WindowsFeature | Export-Csv -Path '%export_dir%\installed.csv' -NoTypeInformation"
    ) else if /i "%%i"=="xml" (
        if not exist "%export_dir%" mkdir "%export_dir%"
        powershell.exe -Command "Get-WindowsFeature | Export-Clixml -Path '%export_dir%\installed.xml'"
    ) else if /i "%%i"=="html" (
        choice /c yn /m "Do you want to save the HTML file in the root directory of the IIS service?"
 	if "%errorlevel%"=="1" (
                      powershell.exe -Command "Get-WindowsFeature | ConvertTo-Html | Out-File -FilePath 'C:\inetpub\wwwroot\wiki.html'" 
        ) else (
             if not exist "%export_dir%" mkdir "%export_dir%"
            powershell.exe -Command "Get-WindowsFeature | ConvertTo-Html | Out-File -FilePath '%export_dir%\installed.html'"

        )
    ) else if /i "%%i"=="txt" (
        if not exist "%export_dir%" mkdir "%export_dir%"
        powershell.exe -Command "Get-WindowsFeature | Out-File -FilePath '%export_dir%\installed.txt'"
    ) else if /i "%%i"=="json" (
        if not exist "%export_dir%" mkdir "%export_dir%"
        powershell.exe -Command "Get-WindowsFeature | ConvertTo-Json | Out-File -FilePath '%export_dir%\installed.json'"
    ) else (
        echo Invalid output file type: %%i. Skipping...
    )
)
