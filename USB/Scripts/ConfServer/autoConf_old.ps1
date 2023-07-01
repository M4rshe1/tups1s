$ConfigFile1 = ".\USB\Scripts\ConfServer\configProfile1.txt"
$ConfigFile2 = ".\USB\Scripts\ConfServer\configProfile2.txt"
$ConfigFile3 = ".\USB\Scripts\ConfServer\configProfile3.txt"

# $adapter = Get-NetAdapter -Name Ethernet0
# $ConfigFile = Get-Content -Path .\USB\Scripts\ConfServer\config.txt -ErrorAction SilentlyContinue

$fileToCheck1 = ".\USB\Scripts\ConfServer\configProfile1.txt"
if (Test-Path $fileToCheck1 -PathType leaf) {

}
else {
    "0" >> $fileToCheck1
    "0.0.0.0" >> $fileToCheck1
    "(0.0.0.0, 0.0.0.0)" >> $fileToCheck1
    "0.0.xxx.xxx" >> $fileToCheck1
    "domain.local" >> $fileToCheck1
    "Administrator@domain.local" >> $fileToCheck1
}
$fileToCheck2 = ".\USB\Scripts\ConfServer\configProfile2.txt"
if (Test-Path $fileToCheck2 -PathType leaf) {

}
else {
    "0" >> $fileToCheck2
    "0.0.0.0" >> $fileToCheck2
    "(0.0.0.0, 0.0.0.0)" >> $fileToCheck2
    "0.0.xxx.xxx" >> $fileToCheck2
    "domain.local" >> $fileToCheck2
    "Administrator@domain.local" >> $fileToCheck2
}
$fileToCheck3 = ".\USB\Scripts\ConfServer\configProfile3.txt"
if (Test-Path $fileToCheck3 -PathType leaf) {

}
else {
    "0" >> $fileToCheck3
    "0.0.0.0" >> $fileToCheck3
    "(0.0.0.0, 0.0.0.0)" >> $fileToCheck3
    "0.0.xxx.xxx" >> $fileToCheck3
    "domain.local" >> $fileToCheck3
    "Administrator@domain.local" >> $fileToCheck3
}

$ConfigFile1Content = Get-Content -Path .\USB\Scripts\ConfServer\configProfile1.txt -ErrorAction SilentlyContinue
$ConfigFile2Content = Get-Content -Path .\USB\Scripts\ConfServer\configProfile2.txt -ErrorAction SilentlyContinue
$ConfigFile3Content = Get-Content -Path .\USB\Scripts\ConfServer\configProfile3.txt -ErrorAction SilentlyContinue
function loadMenu {

    $MaskBits = Read-Host "Maks Bits                         "
    $loop1 = 1
    while ($loop1) {
        $Gateway = Read-Host "Gateway                           "
        $Gateway2 = $Gateway
        try {
            $Gateway2 = [ipaddress]$Gateway2
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
    $DNS = "($($DNS1), $($DNS2))"
    $IPRange = Read-Host "Range (example: 192.168.69.xxx)   "
    $Domain = Read-Host "Domain                            "
    $DomainUser = "Administrator@" + $Domain

    Write-Host 
    Write-Host "Save config to..."
    Write-Host
    Write-Host "   Profile 1 [D]        (1)"
    Write-Host "    : $($ConfigFile1Content[3])/$($ConfigFile1Content[0])"
    Write-Host
    Write-Host "   Profile 2            (2)"
    Write-Host "    : $($ConfigFile2Content[3])/$($ConfigFile2Content[0])"
    Write-Host
    Write-Host "   Profile 3            (3)"
    Write-Host "    : $($ConfigFile3Content[3])/$($ConfigFile3Content[0])"
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

    $ConfigFile = $ConfigFile1
    saveToConfig
    
}
function saveToConfigProfile2 {

    $ConfigFile = $ConfigFile2
    saveToConfig
    
}
function saveToConfigProfile3 {

    $ConfigFile = $ConfigFile3
    saveToConfig
    
}


function saveToConfig {
    
    Remove-Item $ConfigFile -ErrorAction SilentlyContinue
    
    $TestObjekt = @{
        "MaskBits"   = $MaskBits
        "Gateway"    = $Gateway
        "DNS"        = $DNS
        "IPRange"    = $IPRange
        "Domain"     = $Domain
        "DomainUser" = $DomainUser
    } 
    $TestObjekt | ConvertTo-Json | Out-File ".\USB\Scripts\ConfServer\config.json"

    $MaskBits >> $ConfigFile
    $Gateway >> $ConfigFile
    $DNS >> $ConfigFile
    $IPRange >> $ConfigFile
    $Domain >> $ConfigFile
    $DomainUser >> $ConfigFile
    
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
        "1" { ConfigServerNow }
        default { exit }
    }

}

function ConfigServerNow {

    .\USB\Scripts\ConfServer\start_auto.ps1
    
}

loadMenu