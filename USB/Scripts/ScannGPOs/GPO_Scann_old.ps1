Import-Module ActiveDirectory
Import-Module GroupPolicy
$domain = Read-Host -prompt "Domain Name"
$dc = Get-ADDomainController -Discover -Service PrimaryDC
Write-Host "Scanning GPOs..."
New-Item "GPOReport" -itemType Directory | Out-Null
Get-GPOReport -All -Domain $domain -Server $dc -ReportType XML -Path ./GPOReport/GPOReportsAll.XML
Get-GPOReport -All -Domain $domain -Server $dc -ReportType html -Path ./GPOReport/GPOReportsAll.html
Read-Host -prompt "Done
Press ENTER to Continue"
ii GPOReport