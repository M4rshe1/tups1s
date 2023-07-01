@echo off
powershell.exe -Command "Get-WindowsFeature | Out-File -FilePath 'C:\info.txt'"
