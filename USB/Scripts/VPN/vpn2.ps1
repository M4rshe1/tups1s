# VPN Connection Details
$vpnServer = "heggli.internet-box.ch"
$preSharedKey = "Heimnetzwerk.2020"
$username = "admin2"
$password = "Bananen.123"
$ConnectionName = "Home VPN"
$rememberCredentials = $true

# Check if VPN connection already exists
$existingVpn = Get-VpnConnection | Where-Object { $_.Name -eq $ConnectionName }

if ($existingVpn) {
    Write-Host "Deleting existing VPN connection..."
    Remove-VpnConnection -Name $existingVpn.Name -Force
}

# Create VPN connection
Write-Host "Creating new VPN connection..."
Add-VpnConnection -Name $ConnectionName -ServerAddress $vpnServer -TunnelType L2tp -L2tpPsk $preSharedKey -AuthenticationMethod Pap -RememberCredential:$rememberCredentials -Force

# Set VPN connection credentials
$vpnConnection = Get-VpnConnection -Name $ConnectionName
Add-VpnConnectionTrigger -Name $ConnectionName -PasswordCredential (New-Object -TypeName System.Management.Automation.PSCredential -ArgumentList $username, (ConvertTo-SecureString -String $password -AsPlainText -Force))

# Display VPN connection details
$vpnConnection = Get-VpnConnection -Name $ConnectionName

Write-Host "VPN Connection Details:"
Write-Host
Write-Host "Name: $($vpnConnection.Name)"
Write-Host "Server Address: $($vpnConnection.ServerAddress)"
Write-Host "Type: $($vpnConnection.VpnType)"
Write-Host "Encryption Level: $($vpnConnection.EncryptionLevel)"
Write-Host "Authentication Method: $($vpnConnection.AuthenticationMethod)"
Write-Host "Pre-Shared Key: $preSharedKey"
Write-Host "Username: $username"
Write-Host "Password: $password"
Write-Host "Remember Credentials: $rememberCredentials"
Write-Host
Read-Host "Finished. Press ENTER to continue"




powershell.exe -ExecutionPolicy Bypass -File .\vpn2.ps1
