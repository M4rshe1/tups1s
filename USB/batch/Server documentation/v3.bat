@echo off

set /p output_type=Enter output file type (csv/xml/html/txt/all): 

set "export_dir=%~dp0\installed roles"


if /i "%output_type%"=="csv" (
if not exist "%export_dir%" mkdir "%export_dir%"
   powershell.exe -Command "Get-WindowsFeature | Export-Csv -Path '%export_dir%\roles.csv' -NoTypeInformation"
) else if /i "%output_type%"=="xml" (
if not exist "%export_dir%" mkdir "%export_dir%"
   powershell.exe -Command "Get-WindowsFeature | Export-Clixml -Path '%export_dir%\roles.xml'"
) else if /i "%output_type%"=="html" (
   choice /c yn /m "Do you want to save the HTML file in the root directory of the IIS service?"
   if "%errorlevel%"=="1" (
      if not exist "%export_dir%" mkdir "%export_dir%"
      powershell.exe -Command "Get-WindowsFeature | ConvertTo-Html | Out-File -FilePath '%export_dir%\roles.html'"
   ) else (
      powershell.exe -Command "Get-WindowsFeature | ConvertTo-Html | Out-File -FilePath 'C:\inetpub\wwwroot\wiki.html'"
   )
) else if /i "%output_type%"=="txt" (
   if not exist "%export_dir%" mkdir "%export_dir%"
   powershell.exe -Command "Get-WindowsFeature | Out-File -FilePath '%export_dir%\roles.txt'"
) else if /i "%output_type%"=="all" (
   if not exist "%export_dir%" mkdir "%export_dir%"
   powershell.exe -Command "Get-WindowsFeature | Export-Csv -Path '%export_dir%\roles.csv' -NoTypeInformation; Get-WindowsFeature | Export-Clixml -Path '%export_dir%\roles.xml'; Get-WindowsFeature | ConvertTo-Html | Out-File -FilePath '%export_dir%\roles.html'; Get-WindowsFeature | Out-File -FilePath '%export_dir%\roles.txt'"
) else (
   echo Invalid output file type. Please enter 'csv', 'xml', 'html', 'txt', or 'all'.
)
