# VPN Connection Details
$vpnServer = "heggli.internet-box.ch"
$preSharedKey = "Heimnetzwerk.2020"
$username = "admin2"
$password = "Bananen.123"
$ConnectionName = "Home"
# $rememberCredentials = $true

# Installing modules
Install-Module -Name VPNCredentialsHelper -Force 


# Get-VpnConnection | Out-File -FilePath .\test.txt

# Check if VPN already exists
$existingVpn = Get-VpnConnection | Where-Object { $_.Name -eq $ConnectionName }

if ($existingVpn) {
    Write-Host "Deleting existing VPN connection..."
    Remove-VpnConnection -Name $existingVpn.Name -Force
    Write-Host "Existing VPN connection deleted successfully."
}


# Add VPN Connection
Write-Host "Creating new VPN connection..."
Add-VpnConnection -Name $ConnectionName -ServerAddress $vpnServer -TunnelType "L2tp" -EncryptionLevel "Required" -AuthenticationMethod Eap -SplitTunneling -AllUserConnection -L2tpPsk $preSharedKey -Force -RememberCredential:$true -PassThru


# Add Credentials
Set-VpnConnectionUsernamePassword -connectionname $ConnectionName -username $username -password $password | Out-Null


# $vpnConnection = Get-VpnConnection -Name $ConnectionName
# Write-Host "VPN Connection Details:"

# Get-VpnConnection | Where-Object { $_.Name -eq $ConnectionName }
# Write-Host "Pre-Shared Key: $preSharedKey"
# Write-Host "Username: $username"
# Write-Host "Password: $password"
# Write-Host "Name: $ConnectionName"
clear-Host


Read-Host "Finisched. Press ENTER to continue"

ncpa.cpl

# Systemsteuerung\Netzwerk und Internet\Netzwerkverbindungen