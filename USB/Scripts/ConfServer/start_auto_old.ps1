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

$ConfigFile1 = Get-Content -Path .\USB\Scripts\ConfServer\configProfile1.txt -ErrorAction SilentlyContinue
$ConfigFile2 = Get-Content -Path .\USB\Scripts\ConfServer\configProfile2.txt -ErrorAction SilentlyContinue
$ConfigFile3 = Get-Content -Path .\USB\Scripts\ConfServer\configProfile3.txt -ErrorAction SilentlyContinue



if (($ConfigFile1[0] -eq 0 ) -and ($ConfigFile2[0] -eq 0 ) -and ($ConfigFile3[0] -eq 0 )) {
    Write-Host "No Config File available."
    $confNow = Read-Host "Configure it Now? Yes [Y] No [N]"
    if ($confNow -eq "y") {
        Clear-Host
        .\USB\Scripts\ConfServer\autoConf.ps1
    }
}
else {

    Write-Host 
    Write-Host "Configure with..."
    Write-Host
    Write-Host "   Profile 1 [D]        (1)"
    Write-Host "    : $($ConfigFile1[3])/$($ConfigFile1[0])"
    Write-Host "   Profile 2            (2)"
    Write-Host "    : $($ConfigFile2[3])/$($ConfigFile2[0])"
    Write-Host "   Profile 3            (3)"
    Write-Host "    : $($ConfigFile3[3])/$($ConfigFile3[0])"
    Write-Host
    Write-Host "   Cancel               (0)"
    Write-Host
    $select3_3 = Read-Host "Select"
    
    switch ($select3_3) {
        "0" { exit }
        "1" { chosseProfile1 }
        "2" { chosseProfile3 }
        "3" { chosseProfile2 }
        default { chosseProfile1 }
    }
}



function chosseProfile1 {

    $ConfigFile = $ConfigFile1
    
}
function chosseProfile2 {

    $ConfigFile = $ConfigFile2
    
}
function chosseProfile2 {

    $ConfigFile = $ConfigFile3
    
}

function ConfigServerAdapterDomain {
    $adapter = Get-NetAdapter -Name Ethernet0

    $MaskBits = $ConfigFile[0]
    $Gateway = $ConfigFile[1]
    $DNS = $ConfigFile[2]
    $IPRange = "$($ConfigFile[3])/$($ConfigFile[0])"
    $IPType = "IPv4"
    $Domain = $ConfigFile[4]
    $DomainUser = $ConfigFile[5]
    $PcName = Read-Host "PC-NAME"

    $loop = 1
    while ($loop) {
        $IP = Read-Host "IP Range ($($IPRange))"
        $IP = $IPRange + $IP
        try {
            $IP = [ipaddress]$IP
        }
        catch {
            Write-Host "Invalid IP"
            Continue
        }
        $loop = 0
    }
    pause

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
    $adapter | Set-DnsClientServerAddress -ServerAddresses $DNS

    $out = "`n`n" + (Get-Date -Format HH:mm:ss.fff) + ":  IP Configured"
    Write-Host $out

    Rename-Computer -NewName $PcName
    pause | Write-Host "Renamed PC. Press ENTER to Continue"
    Add-Computer -DomainName $Domain -Credential $DomainUser -Force
    pause | Write-Host "Added Server to Domain. Press ENTER to Restart"
    Shutdown -r -t 0
    
}