Import-Module ActiveDirectory
Import-Module GroupPolicy

$CrrentConfigFile = ".\USB\Scripts\!Config\config.json"
$CurrentConfigFileContent = Get-Content -Raw $CrrentConfigFile -ErrorAction SilentlyContinue | ConvertFrom-Json 

$UseDefaultDomain = Read-Host "Use Default Domain: ($($CurrentConfigFileContent.settings.DefaultDomain)) NO [N], Default [Y]"

if ($UseDefaultDomain -eq "N") {
    $domain = Read-Host -Prompt "Domain Name"
}
else {
    $domain = $CurrentConfigFileContent.settings.DefaultDomain
}

$dc = Get-ADDomainController -Discover -Service PrimaryDC
$Datum = Get-Date -Format "dd.MM.yyyy"
$reportPath = ".\SAVES\$Domain - $Datum\GPO Reports\"
Clear-Host
if (-not (Test-Path -Path $reportPath)) {
    New-Item -Path $reportPath -ItemType Directory | Out-Null
}

$gpos = Get-GPO -All -Domain $domain -Server $dc
$totalGPOs = $gpos.Count
$progress = 0

foreach ($gpo in $gpos) {
    $progress++
    $percentComplete = ($progress / $totalGPOs) * 100
    $status = "Processing GPO $progress of $totalGPOs"

    Write-Progress -Activity "Generating GPO Reports" -Status $status -PercentComplete $percentComplete

    $gpoReportXMLPath = Join-Path -Path $reportPath -ChildPath ($gpo.DisplayName + ".xml")
    $gpoReportHTMLPath = Join-Path -Path $reportPath -ChildPath ($gpo.DisplayName + ".html")

    try {
        Get-GPOReport -Name $gpo.DisplayName -ReportType XML -Path $gpoReportXMLPath -Domain $domain -Server $dc -ErrorAction Stop
        Get-GPOReport -Name $gpo.DisplayName -ReportType HTML -Path $gpoReportHTMLPath -Domain $domain -Server $dc -ErrorAction Stop
    }
    catch {
        Write-Warning "Error generating report for GPO $($gpo.DisplayName): $_"
    }
}

Write-Progress -Activity "Generating GPO Reports" -Status "Completed" -Completed

Invoke-Item $reportPath
