$adapter = Get-NetAdapter -Name Ethernet0
$Domain = Read-Host "Domain"
$DomainUser = "Administrator" + $Domain
$PcName = Read-Host "PC Name"
function Set-AdapterData {
    Clear-Host

    $MaskBits = Read-Host "Mask Bits"
    $loop = 1
    while ($loop) {
        $IP = Read-Host "IP Address"
    
        try {
            $IP = [ipaddress]$IP
        }
        catch {
            Write-Host "Invalid IP"
            Continue
        }
        $loop = 0
    }
    $loop1 = 1
    while ($loop1) {
        $Gateway = Read-Host "Gateway"
    
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
        $DNS1 = Read-Host "DNS 1"
    
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
        $DNS2 = Read-Host "DNS 2"
    
        try {
            $DNS2 = [ipaddress]$DNS2
        }
        catch {
            Write-Host "Invalid DNS 2 IP"
            Continue
        }
        $loop3 = 0
    }
    $DNS = ("$($DNS1)", "$($DNS2)")
    $IPType = "IPv4"
    
    Show-WindowsMenu
}

function Show-WindowsMenu {
    Clear-Host
    Write-Host
    Write-Host "IP Type : $IPType"
    Write-Host "IP      : $IP/$MaskBits"
    Write-Host "Gateway : $Gateway"
    Write-Host "DNS 1   : $DNS1"
    Write-Host "DNS 2   : $DNS2"
    Write-Host
    Write-Host "What would you like to do?"
    Write-Host "   Configure Adapter [Default]  (1)"
    Write-Host "   Redo Confuration             (2)"
    Write-Host "   Cancle                       (0)"
    $select5 = Read-Host "Select"
        
    switch ($select5) {
        "0" { exit }
        "1" { Conf-Adapter }
        "2" { Set-AdapterData }
        default { Conf-Adapter }
    }
}

function Conf-Adapter {
    
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

    Rename-Computer -NewName $PcName -ErrorAction SilentlyContinue | Out-Null
    pause | Out-Null
    Write-Host "Renamed PC. Press ENTER to Continue"
    Add-Computer -DomainName $Domain -Credential $DomainUser -Force | Out-Null
    pause | Out-Null
    Write-Host "Added Server to Domain. Press ENTER to Restart"
    Shutdown -r -t 0
}

Set-AdapterData

