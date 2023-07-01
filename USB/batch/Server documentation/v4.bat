@echo off

set /p output_type=Enter output file type (csv/xml/html/txt/json/all): 
set /p folder_name=Enter name for output folder: 

set "export_dir=%~dp0\%folder_name%"

if /i "%output_type%"=="csv" (
   if not exist "%export_dir%" mkdir "%export_dir%"
   powershell.exe -Command "Get-WindowsFeature | Export-Csv -Path '%export_dir%\installed.csv' -NoTypeInformation"
) else if /i "%output_type%"=="xml" (
   if not exist "%export_dir%" mkdir "%export_dir%"
   powershell.exe -Command "Get-WindowsFeature | Export-Clixml -Path '%export_dir%\installed.xml'"
) else if /i "%output_type%"=="html" (
   choice /c yn /m "Do you want to save the HTML file in the root directory of the IIS service?"
   if "%errorlevel%"=="1" (
      powershell.exe -Command "Get-WindowsFeature | ConvertTo-Html | Out-File -FilePath 'C:\inetpub\wwwroot\wiki.html'"
   ) else (
      if not exist "%export_dir%" mkdir "%export_dir%"
      powershell.exe -Command "Get-WindowsFeature | ConvertTo-Html | Out-File -FilePath '%export_dir%\installed.html'"
   )
) else if /i "%output_type%"=="txt" (
   if not exist "%export_dir%" mkdir "%export_dir%"
   powershell.exe -Command "Get-WindowsFeature | Out-File -FilePath '%export_dir%\installed.txt'"
) else if /i "%output_type%"=="all" (
   if not exist "%export_dir%" mkdir "%export_dir%"
   powershell.exe -Command "Get-WindowsFeature | Export-Csv -Path '%export_dir%\installed.csv' -NoTypeInformation; Get-WindowsFeature | Export-Clixml -Path '%export_dir%\installed.xml'; Get-WindowsFeature | ConvertTo-Html | Out-File -FilePath '%export_dir%\installed.html'; Get-WindowsFeature | Out-File -FilePath '%export_dir%\installed.txt'; Get-WindowsFeature | ConvertTo-Json | Out-File -FilePath '%export_dir%\installed.json'"
) else if /i "%output_type%"=="json" (
   if not exist "%export_dir%" mkdir "%export_dir%"
   powershell.exe -Command "Get-WindowsFeature | ConvertTo-Json | Out-File -FilePath '%export_dir%\installed.json'"
) else (
   echo Invalid output file type. Please enter 'csv', 'xml', 'html', 'txt' or 'json'.
)
