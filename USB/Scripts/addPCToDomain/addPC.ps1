$CrrentConfigFile = ".\USB\Scripts\!Config\config.json"
$CurrentConfigFileContent = Get-Content -Raw $CrrentConfigFile -ErrorAction SilentlyContinue | ConvertFrom-Json 
$UseDefaultDomain = Read-Host "Use Default Domain: $($CurrentConfigFileContent.settings.DefaultDomain) Default [Y], No [N]"
if ($UseDefaultDomain -ne "n") {
    $Domain = $CurrentConfigFileContent.settings.DefaultDomain
}
else {
    $Domain = Read-Host -Prompt 'Domain'
}
$DomainUser = "Administrator@" + $Domain
$PcName = Read-Host "PC Name"

Rename-Computer -NewName $PcName
pause | Write-Host "Renamed PC. Press ENTER to Continue"
Add-Computer -DomainName $Domain -Credential $DomainUser -Force
pause | Write-Host "Added Server to Domain. Press ENTER to Restart"
Shutdown -r -t 0