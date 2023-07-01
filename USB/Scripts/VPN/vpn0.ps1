# VPN Connection Details
$vpnServer = "heggli.internet.box.ch"
$preSharedKey = "schlüssel"
$username = "admin"
$password = "12345678"
$rememberCredentials = $true

# Check if VPN connection already exists
$existingVpn = Get-VpnConnection | Where-Object { $_.ServerAddress -eq $vpnServer }

if ($existingVpn) {
    Write-Host "Deleting existing VPN connection..."
    Remove-VpnConnection -Name $existingVpn.Name -Force
}

# Create VPN connection
Write-Host "Creating new VPN connection..."
Add-VpnConnection -Name "My VPN Connection" -ServerAddress $vpnServer -TunnelType Sstp -EncryptionLevel Optional -AuthenticationMethod Eap -RememberCredential:$rememberCredentials -Force

# Set VPN connection credentials
$vpnCredentials = [PSCredential]::new($username, (ConvertTo-SecureString -String $password -AsPlainText -Force))
Set-VpnConnection -Name "My VPN Connection" -Username $vpnCredentials.UserName -Password $vpnCredentials.Password

# Display VPN connection details
$vpnConnection = Get-VpnConnection -Name "My VPN Connection"

Write-Host "VPN connection added successfully!"
Write-Host "VPN Connection Details:"
Write-Host "Name: $($vpnConnection.Name)"
Write-Host "Server Address: $($vpnConnection.ServerAddress)"
Write-Host "Type: $($vpnConnection.VpnType)"
Write-Host "Encryption Level: $($vpnConnection.EncryptionLevel)"
Write-Host "Authentication Method: $($vpnConnection.AuthenticationMethod)"
Write-Host "Pre-Shared Key: $preSharedKey"
Write-Host "Username: $($vpnCredentials.UserName)"
Write-Host "Remember Credentials: $rememberCredentials"




Read-Host Finished. Press ENTER to continue

powershell.exe -ExecutionPolicy Bypass -File .\vpn.ps1
