$ConfigFile = ".\USB\Scripts\!Config\config.json"


function Get-Profile1 {

    $SetProfileNum = 0
    ConfigServerAdapterDomain
    
}
function Get-Profile2 {

    $SetProfileNum = 1
    ConfigServerAdapterDomain
    
}
function Get-Profile2 {

    $SetProfileNum = 2
    ConfigServerAdapterDomain
    
}
function ConfigServerAdapterDomain {
    $adapter = Get-NetAdapter -Name Ethernet0

    $MaskBits = $ConfigFileContent.ConfigServerProfiles[$SetProfileNum].MaskBits
    $Gateway = $ConfigFileContent.ConfigServerProfiles[$SetProfileNum].Gateway
    $DNS = $ConfigFileContent.ConfigServerProfiles[$SetProfileNum].DNS
    $IPRange = $ConfigFileContent.ConfigServerProfiles[$SetProfileNum].IPRange
    $IPType = "IPv4"
    $Domain = $ConfigFileContent.ConfigServerProfiles[$SetProfileNum].Domain
    $DomainUser = $ConfigFileContent.ConfigServerProfiles[$SetProfileNum].DomainUser
    $PcName = Read-Host "PC-NAME"

    $loop = 1
    while ($loop) {
        $IP = Read-Host "IP Range ($($IPRange))"

        try {
            $IP = [ipaddress]$IP
        }
        catch {
            Write-Host "Invalid IP"
            Continue
        }
        $loop = 0
    }
    # pause

    If (($adapter | Get-NetIPConfiguration).IPv4Address.IPAddress) {
        $adapter | Remove-NetIPAddress -AddressFamily $IPType -Confirm:$false
    }
    If (($adapter | Get-NetIPConfiguration).Ipv4DefaultGateway) {
        $adapter | Remove-NetRoute -AddressFamily $IPType -Confirm:$false
    }


    $adapter | New-NetIPAddress `
        -AddressFamily $IPType `
        -IPAddress $IP `
        -PrefixLength $MaskBits `
        -DefaultGateway $Gateway > $null
    # Configure the DNS client server IP addresses
    Set-DnsClientServerAddress -InterfaceAlias "Ethernet0" -ServerAddresses $DNS

    $out = "`n`n" + (Get-Date -Format HH:mm:ss.fff) + ":  IP Configured"
    Write-Host $out

    Rename-Computer -NewName $PcName -ErrorAction SilentlyContinue | pause | Write-Host "Renamed PC. Press ENTER to Continue"
    
    Add-Computer -DomainName $Domain -Credential $DomainUser -Force | pause | Write-Host "Added Server to Domain. Press ENTER to Restart"
    
    Shutdown -r -t 0 
}
# $adapter = Get-NetAdapter -Name Ethernet0
# $ConfigFile = Get-Content -Path .\Scripts\ConfServer\config.txt -ErrorAction SilentlyContinue


if (Test-Path $ConfigFile -PathType leaf) {
    $ConfigFileContent = Get-Content -Raw $ConfigFile -ErrorAction SilentlyContinue | ConvertFrom-Json 

    # Add missing objects to the "ConfigServerProfiles" array
    for ($i = 0; $i -lt 3; $i++) {
        if ($null -eq $ConfigFileContent.ConfigServerProfiles[$i]) {
            $newProfile = [PSCustomObject]@{
                "Gateway"    = "0.0.0.0"
                "Domain"     = "domain.local"
                "DomainUser" = "Administrator@domain.local"
                "DNS"        = "0.0.0.0"
                "IPRange"    = "0.0.0.0"
                "MaskBits"   = 0
            }
            $ConfigFileContent.ConfigServerProfiles += $newProfile
        }
    }

    # Save the modified content back to the JSON file with UTF-8 encoding
    $ConfigFileContent | ConvertTo-Json -Depth 10 | Out-File -Encoding UTF8 -FilePath $ConfigFile -Force
}
$ConfigFileContent = Get-Content -Raw $ConfigFile -ErrorAction SilentlyContinue | ConvertFrom-Json 




if (($ConfigFileContent.ConfigServerProfiles[0].MaskBits -eq 0 ) -and ($ConfigFileContent.ConfigServerProfiles[1].MaskBits -eq 0 ) -and ($ConfigFileContent.ConfigServerProfiles[2].MaskBits -eq 0 )) {
    Write-Host "No Config File available."
    $confNow = Read-Host "Configure it Now? Yes [Y] No [N]"
    if ($confNow -eq "y") {
        Clear-Host
        .\Scripts\ConfServer\autoConf.ps1
    }
}
else {

    Write-Host 
    Write-Host "Configure with..."
    Write-Host
    Write-Host "   Profile 1 [D]        (1)"
    Write-Host "    : $($ConfigFileContent.ConfigServerProfiles[0].IPRange)/$($ConfigFileContent.ConfigServerProfiles[0].MaskBits)"
    Write-Host "    : $($ConfigFileContent.ConfigServerProfiles[0].Domain)"
    Write-Host
    Write-Host "   Profile 2            (2)"
    Write-Host "    : $($ConfigFileContent.ConfigServerProfiles[1].IPRange)/$($ConfigFileContent.ConfigServerProfiles[1].MaskBits)"
    Write-Host "    : $($ConfigFileContent.ConfigServerProfiles[1].Domain)"
    Write-Host
    Write-Host "   Profile 3            (3)"
    Write-Host "    : $($ConfigFileContent.ConfigServerProfiles[2].IPRange)/$($ConfigFileContent.ConfigServerProfiles[2].MaskBits)"
    Write-Host "    : $($ConfigFileContent.ConfigServerProfiles[2].Domain)"
    Write-Host
    Write-Host "   Cancel               (0)"
    Write-Host
    $select3_3 = Read-Host "Select"
    
    switch ($select3_3) {
        "0" { exit }
        "1" { Get-Profile1 }
        "2" { Get-Profile2 }
        "3" { Get-Profile3 }
        default { Get-Profile1 }
    }
}



