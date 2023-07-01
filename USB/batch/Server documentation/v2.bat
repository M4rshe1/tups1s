@echo off
set /p output_type=Enter output file type (csv/xml/html/txt/all):

if /i "%output_type%"=="csv" (
powershell.exe -Command "Get-WindowsFeature | Export-Csv -Path 'C:\roles.csv' -NoTypeInformation"
) else if /i "%output_type%"=="xml" (
powershell.exe -Command "Get-WindowsFeature | Export-Clixml -Path 'C:\roles.xml'"
) else if /i "%output_type%"=="html" (
powershell.exe -Command "Get-WindowsFeature | ConvertTo-Html | Out-File -FilePath 'C:\roles.html'"
) else if /i "%output_type%"=="txt" (
powershell.exe -Command "Get-WindowsFeature | Out-File -FilePath 'C:\roles.txt'"
) else if /i "%output_type%"=="all" (
powershell.exe -Command "Get-WindowsFeature | Export-Csv -Path 'C:\roles.csv' -NoTypeInformation; Get-WindowsFeature | Export-Clixml -Path 'C:\roles.xml'; Get-WindowsFeature | ConvertTo-Html | Out-File -FilePath 'C:\roles.html'; Get-WindowsFeature | Out-File -FilePath 'C:\roles.txt'"
) else (
echo Invalid output file type. Please enter 'csv', 'xml', 'html', 'txt', or 'all'.
)