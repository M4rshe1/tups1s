# Import Active Directory module
Import-Module ActiveDirectory
 
# Open file dialog
# Load Windows Forms
[System.Reflection.Assembly]::LoadWithPartialName("System.windows.forms") | Out-Null
 
# Create and show open file dialog
$dialog = New-Object System.Windows.Forms.OpenFileDialog
$dialog.InitialDirectory = $StartDir
$dialog.Filter = "TXT (*.txt)| *.txt"
$dialog.ShowDialog() | Out-Null
 
# Get file path
$TXTFile = $dialog.FileName
 
# Import file into variable
# Lets make sure the file path was valid
# If the file path is not valid, then exit the script
if ([System.IO.File]::Exists($TXTFile)) {
    Write-Host "Importing TXT..."
    Clear-Host
    $CrrentConfigFile = ".\USB\Scripts\!Config\config.json"
    $CurrentConfigFileContent = Get-Content -Raw $CrrentConfigFile -ErrorAction SilentlyContinue | ConvertFrom-Json 
    $UseDefaultDomain = Read-Host "Use Default Domain: $($CurrentConfigFileContent.settings.DefaultDomain) Default [Y], No [N]"
    if ($UseDefaultDomain -ne "n") {
        $Domain = $CurrentConfigFileContent.settings.DefaultDomain
    }
    else {
        $Domain = Read-Host -Prompt 'Domain'
    }
    # $DomainTLD = Read-Host -Prompt 'DomainTLD'
    $SetOUName = Read-Host "Default save OU: NewUsers | Change [Y] Default [N]"
    $OU = "NewUsers"
    if ($SetOUName -eq "Y") {
        $OU = Read-Host -Prompt 'Save User to OU'
    }
    $SetPass = Read-Host "Default Password: Bananen.123 | Change [Y] Default [N]"
    $SecPass = "Bananen.123"
    if ($SetPass -eq "Y") {
        $SecPass = Read-Host -Prompt 'User Default Passwords'
    }


    $Path = "OU=$OU"
    $createPath = ""
    $FullDomain = $Domain
    $Domain = $Domain.Split(".")
    For ($i = 0; $i -lt $Domain.Length; $i++) {
        $Path = $Path + ",DC=" + $Domain[$i]
        $createPath = $createPath + "DC=" + $Domain[$i]
        if ($Domain.Length -ne $i + 1) {
            $createPath = $createPath + ","
        }
    }
    # Write-Host $OU
    # Write-Host $createPath
    # Write-host $Path
    # ÃœberprÃ¼fen, ob die OU bereits vorhanden ist
    $ouExists = Get-ADOrganizationalUnit -Filter { Name -eq $OU }
    
    # Wenn die OU nicht existiert, erstellen Sie sie
    if (-not $ouExists) {
        New-ADOrganizationalUnit -Name $OU -Path $createPath
        # Write-Host "Die OU 'MeineOU' wurde erfolgreich erstellt."
    }
    else {
        # Write-Host "Die OU 'MeineOU' existiert bereits."
    }
    #pause
    # Write-Host $Path
    # Write-Host $Domain

    $SetProfilePath = Read-Host "Set Roming Profile Path Yes [Y], Default [N]"
    if ($SetProfilePath -eq "y") {
        Clear-host
        write-host
        Write-Host "#####################################################################################"
        Write-Host "#                                                                                   #"
        Write-Host "#       Please remember that a file share must already have been created,           #"
        Write-Host "#       in which the security settings are set correctly.                           #"
        Write-Host "#                                                                                   #"
        Write-Host "#####################################################################################"
        write-host
        $ProfilePathOrigin = Read-Host "Profile Path: \\<ComputerName>\<ShareName>"
        $SetSpecificSharePath = Read-Host "Set User Specific Share Yes [Y], Default [N]"
    if ($SetSpecificSharePath -eq "y") {
        write-host
        Write-Host "#####################################################################################"
        Write-Host "#                                                                                   #"
        Write-Host "#       Please remember that a file share must already have been created,           #"
        Write-Host "#       in which the security settings are set correctly.                           #"
        Write-Host "#                                                                                   #"
        Write-Host "#####################################################################################"
        write-host
        $SpecificSharePathOrigin = Read-Host "Share Path: \\<ComputerName>\<ShareName>"
        $SpecificShareLetter = Read-Host "Share Letter "
        
        Get-Content $TXTFile |  
        ForEach-Object {  
            $SecurePassword = ConvertTo-SecureString $SecPass -AsPlainText -Force
            $User = $_.Trim()
            $firstlast = -split $User
            $NotCleanUPNName = $firstlast
            $cleanUPNName = $NotCleanUPNName.Replace("Ã¤", "ae").Replace("Ã¼", "ue").Replace("Ã¶", "oe").Replace("Ã©", "e").Replace("Ãª", "e").Replace("Ã¨", "e").Replace("Ã«", "e").Replace("Ã¢", "a").Replace("Ã ", "a").Replace("Ã¹", "u").Replace("Ã»", "u").Replace("Ï‹", "u").Replace("Ã®", "i").Replace("Ã¯", "i").Replace("Ã´", "o").Replace("Ã§", "c")
            $UPNName = [System.Text.RegularExpressions.Regex]::Replace($cleanUPNName, '[^\u0000-\u007Fa-zA-Z0-9\s]', '')
            $first = $firstlast[0]
            $last = $firstlast[1]
            $NewUPNName = $UPNName.Replace(" ", ".")
            $upn = $NewUPNName + "@" + $FullDomain
            $Username = $User.Replace(" ", ".")
            $ProfilePath = "$ProfilePathOrigin\$Username"
            $SpecificSharePath = "$SpecificSharePathOrigin\$Username"
            New-ADUser -Name $User `
                -GivenName $first `
                -Surname $last `
                -UserPrincipalName $upn `
                -SamAccountName $Username `
                -Path $Path `
                -ChangePasswordAtLogon $true `
                -AccountPassword $SecurePassword `
                -Enabled $true `
                -ProfilePath $ProfilePath `
                -HomeDrive $SpecificShareLetter `
                -HomeDirectory $SpecificSharePath `
                -ErrorAction SilentlyContinue


            # Write to host that we created a new user
            Write-Host "Created $($upn)"
        }
    }
    else {

        Get-Content $TXTFile |  
        ForEach-Object {  
            $SecurePassword = ConvertTo-SecureString $SecPass -AsPlainText -Force
            $User = $_.Trim()
            $firstlast = -split $User
            $NotCleanUPNName = $firstlast
            $cleanUPNName = $NotCleanUPNName.Replace("Ã¤", "ae").Replace("Ã¼", "ue").Replace("Ã¶", "oe").Replace("Ã©", "e").Replace("Ãª", "e").Replace("Ã¨", "e").Replace("Ã«", "e").Replace("Ã¢", "a").Replace("Ã ", "a").Replace("Ã¹", "u").Replace("Ã»", "u").Replace("Ï‹", "u").Replace("Ã®", "i").Replace("Ã¯", "i").Replace("Ã´", "o").Replace("Ã§", "c")
            $UPNName = [System.Text.RegularExpressions.Regex]::Replace($cleanUPNName, '[^\u0000-\u007Fa-zA-Z0-9\s]', '')
            $first = $firstlast[0]
            $last = $firstlast[1]
            $NewUPNName = $UPNName.Replace(" ", ".")
            $upn = $NewUPNName + "@" + $FullDomain
            $Username = $User.Replace(" ", ".")
            $ProfilePath = "$ProfilePathOrigin\$Username"
            New-ADUser -Name $User `
                -GivenName $first `
                -Surname $last `
                -UserPrincipalName $upn `
                -SamAccountName $Username `
                -Path $Path `
                -ChangePasswordAtLogon $true `
                -AccountPassword $SecurePassword `
                -Enabled $true `
                -ProfilePath $ProfilePath `
                -ErrorAction SilentlyContinue

            # Write to host that we created a new user
            Write-Host "Created $($upn)"
        } 
    }
    }
    else {
        $SetSpecificSharePath = Read-Host "Set User Specific Share Yes [Y], Default [N]"
    if ($SetSpecificSharePath -eq "y") {
        write-host
        Write-Host "#####################################################################################"
        Write-Host "#                                                                                   #"
        Write-Host "#       Please remember that a file share must already have been created,           #"
        Write-Host "#       in which the security settings are set correctly.                           #"
        Write-Host "#                                                                                   #"
        Write-Host "#####################################################################################"
        write-host
        $SpecificSharePathOrigin = Read-Host "Share Path: \\<ComputerName>\<ShareName>"
        $SpecificShareLetter = Read-Host "Share Letter "
        
        Get-Content $TXTFile |  
        ForEach-Object {  
            $SecurePassword = ConvertTo-SecureString $SecPass -AsPlainText -Force
            $User = $_.Trim()
            $firstlast = -split $User
            $NotCleanUPNName = $firstlast
            $cleanUPNName = $NotCleanUPNName.Replace("Ã¤", "ae").Replace("Ã¼", "ue").Replace("Ã¶", "oe").Replace("Ã©", "e").Replace("Ãª", "e").Replace("Ã¨", "e").Replace("Ã«", "e").Replace("Ã¢", "a").Replace("Ã ", "a").Replace("Ã¹", "u").Replace("Ã»", "u").Replace("Ï‹", "u").Replace("Ã®", "i").Replace("Ã¯", "i").Replace("Ã´", "o").Replace("Ã§", "c")
            $UPNName = [System.Text.RegularExpressions.Regex]::Replace($cleanUPNName, '[^\u0000-\u007Fa-zA-Z0-9\s]', '')
            $first = $firstlast[0]
            $last = $firstlast[1]
            $NewUPNName = $UPNName.Replace(" ", ".")
            $upn = $NewUPNName + "@" + $FullDomain
            $Username = $User.Replace(" ", ".")
            # $ProfilePath = "$ProfilePathOrigin\$Username"
            $SpecificSharePath = "$SpecificSharePathOrigin\$Username"
            New-ADUser -Name $User `
                -GivenName $first `
                -Surname $last `
                -UserPrincipalName $upn `
                -SamAccountName $Username `
                -Path $Path `
                -ChangePasswordAtLogon $true `
                -AccountPassword $SecurePassword `
                -Enabled $true `
                -HomeDrive $SpecificShareLetter `
                -HomeDirectory $SpecificSharePath `
                -ErrorAction SilentlyContinue

            # Write to host that we created a new user
            Write-Host "Created $($upn)"
        }
    }
    else {

        Get-Content $TXTFile |  
        ForEach-Object {  
            $SecurePassword = ConvertTo-SecureString $SecPass -AsPlainText -Force
            $User = $_.Trim()
            $firstlast = -split $User
            $NotCleanUPNName = $firstlast
            $cleanUPNName = $NotCleanUPNName.Replace("Ã¤", "ae").Replace("Ã¼", "ue").Replace("Ã¶", "oe").Replace("Ã©", "e").Replace("Ãª", "e").Replace("Ã¨", "e").Replace("Ã«", "e").Replace("Ã¢", "a").Replace("Ã ", "a").Replace("Ã¹", "u").Replace("Ã»", "u").Replace("Ï‹", "u").Replace("Ã®", "i").Replace("Ã¯", "i").Replace("Ã´", "o").Replace("Ã§", "c")
            $UPNName = [System.Text.RegularExpressions.Regex]::Replace($cleanUPNName, '[^\u0000-\u007Fa-zA-Z0-9\s]', '')
            $first = $firstlast[0]
            $last = $firstlast[1]
            $NewUPNName = $UPNName.Replace(" ", ".")
            $upn = $NewUPNName + "@" + $FullDomain
            $Username = $User.Replace(" ", ".")
            # $ProfilePath = "$ProfilePathOrigin\$Username"
            New-ADUser -Name $User `
                -GivenName $first `
                -Surname $last `
                -UserPrincipalName $upn `
                -SamAccountName $Username `
                -Path $Path `
                -ChangePasswordAtLogon $true `
                -AccountPassword $SecurePassword `
                -Enabled $true `
                -ErrorAction SilentlyContinue

            # Write to host that we created a new user
            Write-Host "Created $($upn)"
        } 
    }
    }
}
else {
    Write-Host "File path specified was not valid"
    Exit
}
Read-Host -Prompt "Script complete...
Press ENTER to exit"




