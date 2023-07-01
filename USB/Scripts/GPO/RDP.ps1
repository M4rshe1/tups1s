# Import the GroupPolicy module
Import-Module GroupPolicy

# Create a new GPO
$GPOName = "Enable RDP"
New-GPO -Name $GPOName

# Enable Network Level Authentication (NLA)
$RdpTcpKey = "HKLM\SOFTWARE\Policies\Microsoft\Windows NT\Terminal Services"
Set-GPRegistryValue -Name $GPOName -Key $RdpTcpKey -ValueName "UserAuthentication" -Type DWORD -Value 1

# Enable Remote Desktop
$RemoteDesktopKey = "HKLM\SOFTWARE\Policies\Microsoft\Windows NT\Terminal Services"
Set-GPRegistryValue -Name $GPOName -Key $RemoteDesktopKey -ValueName "fDenyTSConnections" -Type DWORD -Value 0

# Configure firewall port 3389
$FirewallRule = "Remote Desktop (TCP-In)"
$FirewallRulePath = "Software\Policies\Microsoft\WindowsFirewall\FirewallRules"

Set-GPRegistryValue -Name $GPOName -Key "HKLM\$FirewallRulePath" -ValueName $FirewallRule -Type STRING -Value "v2.0|Action=Allow|Active=TRUE|Dir=In|Protocol=6|LPort=3389|App=%SystemRoot%\system32\svchost.exe|Svc=termservice|Name=@FirewallAPI.dll,-28779|EmbedCtxt=@FirewallAPI.dll,-28752|"

# Save the GPO
# $GPO.PSBase.CommitChanges()

pause