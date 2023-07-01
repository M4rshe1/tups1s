$OutputTypes = Read-Host "Enter output file type(s) separated by space (csv/xml/html/txt/json) [all] "
if ([string]::IsNullOrEmpty($OutputTypes)) {
    $OutputTypes = "all"
}

if ($OutputTypes -eq "all") {
    $OutputTypes = "csv xml html txt json"
}



$CrrentConfigFile = ".\USB\Scripts\!Config\config.json"
$CurrentConfigFileContent = Get-Content -Raw $CrrentConfigFile -ErrorAction SilentlyContinue | ConvertFrom-Json 

$UseDefaultDomain = Read-Host "Use Default Domain: ($($CurrentConfigFileContent.settings.DefaultDomain)) NO [N], Default [Y]"

if ($UseDefaultDomain -eq "N") {
    $domain = Read-Host -Prompt "Domain Name"
}
else {
    $domain = $CurrentConfigFileContent.settings.DefaultDomain
}

$computerName = $env:COMPUTERNAME
$Datum = Get-Date -Format "dd.MM.yyyy"
New-Item -Path ".\SAVES\$Domain - $Datum\Installed Roles - $computerName" -ItemType Directory -ErrorAction SilentlyContinue -Force | Out-Null
$ExportDir = ".\SAVES\$Domain - $Datum\Installed Roles - $computerName"
# New-Item -ItemType Directory -Path $ExportDir | Out-Null

foreach ($OutputType in $OutputTypes -split ' ') {
    if ($OutputType -eq "csv") {
        Get-WindowsFeature | Export-Csv -Path "$ExportDir\installed.csv" -NoTypeInformation
    }
    elseif ($OutputType -eq "xml") {
        Get-WindowsFeature | Export-Clixml -Path "$ExportDir\installed.xml"
    }
    elseif ($OutputType -eq "html") {
        # $SaveHtml = Read-Host "Do you want to save the HTML file in the root directory of the IIS service? (y/n) [y]: "
        # if ([string]::IsNullOrEmpty($SaveHtml)) {
        #     $SaveHtml = "y"
        # }
        # if ($SaveHtml -eq "y") {
        #     Get-WindowsFeature | ConvertTo-Html | Out-File -FilePath 'C:\inetpub\wwwroot\wiki.html'
        # }
        # else {
        Get-WindowsFeature | ConvertTo-Html | Out-File -FilePath "$ExportDir\installed.html"
        # }
    }
    elseif ($OutputType -eq "txt") {
        Get-WindowsFeature | Out-File -FilePath "$ExportDir\installed.txt"
    }
    elseif ($OutputType -eq "json") {
        Get-WindowsFeature | ConvertTo-Json | Out-File -FilePath "$ExportDir\installed.json"
    }
    # elseif ($OutputType -eq "komp") {
    #     $InstalledDir = "C:\installed"
    #     if (!(Test-Path $InstalledDir)) {
    #         New-Item -ItemType Directory -Path $InstalledDir | Out-Null
    #     }
    #     Get-WindowsFeature | ConvertTo-Html | Out-File -FilePath 'C:\inetpub\wwwroot\wiki.html'
    #     Get-WindowsFeature | Out-File -FilePath "$InstalledDir\installed.txt"
    #     Get-WindowsFeature | Export-Clixml -Path "$InstalledDir\installed.xml"
    #     Start-Process http://127.69.69.69/wiki.html
    #     Start-Process "$env:SystemRoot\explorer.exe" "$InstalledDir\installed.xml"
    #     Start-Process "$env:SystemRoot\explorer.exe" "$InstalledDir\installed.txt"
    # }
    else {
        Write-Host "Invalid output file type: $OutputType. Skipping..."
    }
}
Invoke-Item $ExportDir