Clear-Host

$ConfigFile = ".\USB\Scripts\!Config\config.json"
$ConfigFileContent = Get-Content -Raw $ConfigFile -ErrorAction SilentlyContinue | ConvertFrom-Json 


$DomainName = Read-Host Domain

$ConfigFileContent.settings.DefaultDomain = $DomainName

# Save the modified content back to the JSON file with UTF-8 encoding
$ConfigFileContent | ConvertTo-Json -Depth 10 | Out-File -Encoding UTF8 -FilePath $ConfigFile -Force
