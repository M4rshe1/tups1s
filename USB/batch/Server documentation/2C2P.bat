@echo off

if not exist "C:\installed rolles" mkdir "C:\installed rolles"
powershell.exe -Command "Get-WindowsFeature | Export-Clixml -Path 'C:\installed rolles\roles.xml'"
powershell.exe -Command "Get-WindowsFeature | ConvertTo-Html | Out-File -FilePath 'C:\inetpub\wwwroot\wiki.html'"
powershell.exe -Command "Get-WindowsFeature | Out-File -FilePath 'C:\installed rolles\roles.txt'"
start http://127.69.69.69/wiki.html
%SystemRoot%\explorer.exe "C:\installed rolles\roles.xml"
%SystemRoot%\explorer.exe "C:\installed rolles\roles.txt"