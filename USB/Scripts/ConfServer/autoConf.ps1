$ConfigFile = ".\USB\Scripts\!Config\config.json"

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

function loadMenu {

    $MaskBits = Read-Host "Maks Bits                         "
    $loop1 = 1
    while ($loop1) {
        $Gateway = Read-Host "Gateway                           "
        $Gateway2Save = $Gateway
        try {
            $Gateway = [ipaddress]$Gateway
        }
        catch {
            Write-Host "Invalid Gateway IP"
            Continue
        }
        $loop1 = 0
    }
    
    $loop2 = 1
    while ($loop2) {
        $DNS1 = Read-Host "DNS 1                             "
    
        try {
            $DNS1 = [ipaddress]$DNS1
        }
        catch {
            Write-Host "Invalid DNS 1 IP"
            Continue
        }
        $loop2 = 0
    }
    
    $loop3 = 1
    while ($loop3) {
        $DNS2 = Read-Host "DNS 2                             "
    
        try {
            $DNS2 = [ipaddress]$DNS2
        }
        catch {
            Write-Host "Invalid DNS 2 IP"
            Continue
        }
        $loop3 = 0
    }
    $DNS = "$($DNS1), $($DNS2)"
    $IPRange = Read-Host "Range (example: 192.168.69.xxx)   "
    $Domain = Read-Host "Domain                            "
    $DomainUser = "Administrator@" + $Domain

    Write-Host 
    Write-Host "Save config to..."
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
    Write-Host "   No, Redo             (4)"
    Write-Host "   Cancel               (0)"
    Write-Host
    $select3_3 = Read-Host "Select"
    
    switch ($select3_3) {
        "0" { exit }
        "1" { saveToConfigProfile1 }
        "2" { saveToConfigProfile2 }
        "3" { saveToConfigProfile3 }
        "4" { loadMenu }
        default { saveToConfigProfile1 }
    }
}

function saveToConfigProfile1 {

    $SetProfileNum = 0
    Show-saveToConfig
    
}
function saveToConfigProfile2 {

    $SetProfileNum = 1
    Show-saveToConfig
    
}
function saveToConfigProfile3 {

    $SetProfileNum = 2
    Show-saveToConfig
    
}


function Show-saveToConfig {

    $EditedProfile = [PSCustomObject]@{
        "Gateway"    = $Gateway2Save
        "Domain"     = $Domain
        "DomainUser" = $DomainUser
        "DNS"        = $DNS
        "IPRange"    = $IPRange
        "MaskBits"   = $MaskBits
    }
    $ConfigFileContent.ConfigServerProfiles[$SetProfileNum] = $EditedProfile 
    $ConfigFileContent | ConvertTo-Json -Depth 10 | Out-File -Encoding UTF8 -FilePath $ConfigFile -Force
    Clear-Host
    Write-Host 
    Write-Host "Configure a Server NOW"
    Write-Host
    Write-Host "   YES          (1)"
    Write-Host "   NO [D]       (0)"
    Write-Host
    $selectx = Read-Host "Select"
    
    switch ($selectx) {
        "0" { exit }
        "1" { Show-ConfigServerNow }
        default { exit }
    }

}

function Show-ConfigServerNow {

    .\Scripts\ConfServer\start_auto.ps1
    
}

loadMenu
pause