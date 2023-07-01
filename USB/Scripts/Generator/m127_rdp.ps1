
Import-Module ps2exe

[System.Reflection.Assembly]::LoadWithPartialName("System.windows.forms") | Out-Null
 
# Create and show open file dialog
$dialog = New-Object System.Windows.Forms.OpenFileDialog
$dialog.InitialDirectory = $StartDir
$dialog.Filter = "TXT (*.txt)| *.txt"
$dialog.ShowDialog() | Out-Null


$TXTFile = $dialog.FileName
 
# Import file into variable
# Lets make sure the file path was valid
# If the file path is not valid, then exit the script
if ([System.IO.File]::Exists($TXTFile)) {
    Write-Host "Importing TXT..."
    Clear-Host
    $HowManyFilesQ = Read-Host "Use one Connection File | No, use two [N] Default [Y]"
    $HowManyFiles = 0
    if ($HowManyFilesQ -eq "N") {
        $HowManyFiles = 1
    }
    $UseDefaultPort = Read-Host "Default client RDP Port: 3390 Default [Y], No [N]"
    if ($UseDefaultPort -ne "n") {
        $Port = 3390
    }
    else {
        $Port = Read-Host "Port for client RDP"
    }
    $CrrentConfigFile = ".\USB\Scripts\!Config\config.json"
    $CurrentConfigFileContent = Get-Content -Raw $CrrentConfigFile -ErrorAction SilentlyContinue | ConvertFrom-Json
    $UseDefaultDomain = Read-Host "Use Default Domain: $($CurrentConfigFileContent.settings.DefaultDomain) Default [Y], No [N]"
    if ($UseDefaultDomain -ne "n") {
        $domain = $CurrentConfigFileContent.settings.DefaultDomain
    }
    else {
        $domain = Read-Host -Prompt 'Domain'
    }
    $SetPass = Read-Host "Default Password: Bananen.123 | Change [N] Default [Y]"
    $Password = "Bananen.123"
    if ($SetPass -eq "N") {
        $Password = Read-Host -Prompt 'Server Passwords'
    }
    New-Item -Path ".\USB\Scripts\!files\M127" -Name "INFO.txt" -ItemType "file" -force -ErrorAction SilentlyContinue  | Out-Null
    $TeilnehmerNum = 0
    # "Teilnehmer         IP Address" | Out-File ".\USB\Scripts\!files\M127\INFO.txt" -Append
    # "----------      ----------" | Out-File ".\USB\Scripts\!files\M127\INFO.txt" -Append
    $FileContentLength = Get-Content $TXTFile
    Clear-Host
    Write-Host "Search for disruptive processes..."
    Get-Process | Where-Object { $_.Modules.ModuleName -like ".\USB\Scripts\!files\M127\*" } | Stop-Process -Force
    Remove-Item -Path ".\USB\Scripts\!files\M127" -Recurse -force -ErrorAction SilentlyContinue
    Get-Content $TXTFile |
    ForEach-Object {
        $TeilnehmerNum++
        Clear-Host
        Write-Host "$TeilnehmerNum of $($FileContentLength.length) Files"
        if ($TeilnehmerNum.tostring().length -eq 1) {
            $TNNum = "00$TeilnehmerNum"
            
        }
        elseif ($TeilnehmerNum.tostring().length -eq 2) {
            $TNNum = "0$TeilnehmerNum"
        }
        else {
            $TNNum = $TeilnehmerNum
        }
        $filePath = ".\USB\Scripts\!files\M127\TN-$TNNum"
        New-Item -ItemType "directory" -Path $filePath -ErrorAction SilentlyContinue | Out-Null
        # New-Item -Path $filePath -Name "server.bat" -ItemType "file" -Value "@echo off`ncmdkey /generic:'$($_)' /user:'administrator@$domain /pass:'$($Password)' > NULL`nmstsc /v:$($_) > NULL`ncmdkey /delete:TERMSRV/$($_) > NULL" | Out-Null
        # New-Item -Path $filePath -Name "client.bat" -ItemType "file" -Value "@echo off`nset /p User=Username without domain: `nset /p Pass=Password: `ncmdkey /generic:'$($_):$Port' /user:'%User%@$domain' /pass:%Pass% > nul`nmstsc /v:$($_):$Port > nul`ncmdkey /delete:TERMSRV/$($_):$Port > nul" | Out-Null
        # New-Item -Path $filePath -Name "connect.ps1" -ItemType "file" -Value  | Out-Null
        # New-Item -Path $filePath -Name "client.ps1" -ItemType "file" -Value "$username = Read-HostUsername without domain `n''$Pass'' = Read-Host Password `ncmdkey /generic:'172.16.0.11:3390' /user:'$($username)@KMU-one.local' /pass:$Pass | Out-Null`nmstsc /v:$($_):$Port | Out-Null`ncmdkey /delete:TERMSRV/$($_):$Port | Out-Null" | Out-Null
        if ($HowManyFiles) {
            New-Item -Path $filePath -Name "server.ps1" -ItemType "file" -Value "cmdkey /generic:'$($_)' /user:'administrator@$domain' /pass:'$($Password)' | Out-Null`nmstsc /v:$($_)`ncmdkey /delete:TERMSRV/$($_) | Out-Null" | Out-Null
            $Content = '$username = Read-Host "Username without domain"
                    $Pass = Read-Host "Password"
                    cmdkey /generic:' + $($_) + ' /user:"$($username)@' + $($domain) + '" /pass:$Pass | Out-Null
                    mstsc /v:' + $($_) + ':' + $Port + ' | Out-Null
                    cmdkey /delete:TERMSRV/' + $($_) + ':' + $Port + ' | Out-Null'

            New-Item -Path $filePath -Name "client.ps1" -ItemType "file" -Value $Content | Out-Null
            # Get-Content -Path ".\USB\Scripts\!files\M127\TN-$TNNum\server.bat" -Raw | Out-File -FilePath ".\USB\Scripts\!files\M127\TN-$TNNum\server.exe" -Encoding ASCII
            # Get-Content -Path ".\USB\Scripts\!files\M127\TN-$TNNum\client.bat" -Raw | Out-File -FilePath ".\USB\Scripts\!files\M127\TN-$TNNum\client.bat" -Encoding ASCII
            # ConvertTo-Exe -InputScript ".\USB\Scripts\!files\M127\TN-$TNNum\server.ps1" -OutputFileName ".\USB\Scripts\!files\M127\TN-$TNNum\server.exe"
            # ConvertTo-Exe -InputScript ".\USB\Scripts\!files\M127\TN-$TNNum\client.ps1" -OutputFileName ".\USB\Scripts\!files\M127\TN-$TNNum\client.exe"
            Invoke-ps2exe ".\USB\Scripts\!files\M127\TN-$TNNum\server.ps1" ".\USB\Scripts\!files\M127\TN-$TNNum\server.exe" -noConsole | Out-Null
            Invoke-ps2exe ".\USB\Scripts\!files\M127\TN-$TNNum\client.ps1" ".\USB\Scripts\!files\M127\TN-$TNNum\client.exe" -noConsole | Out-Null
            Remove-Item -Path ".\USB\Scripts\!files\M127\TN-$TNNum\server.ps1" -Recurse -force -ErrorAction SilentlyContinue
            Remove-Item -Path ".\USB\Scripts\!files\M127\TN-$TNNum\client.ps1" -Recurse -force -ErrorAction SilentlyContinue
        }
        else {
            $Content = '

    function Get-MainMenu {
    $select = Read-Host "Connect to:
    Server [1]
    Client   [2]
    "
    
    switch ($select) {
        "1" { Get-Server }
        "2" { Get-Client }
        default { Get-MiainMenu }
    }
    
}

        function Get-Client {

        $username = Read-Host "Username without domain"
                    $Pass = Read-Host "Password"
                    cmdkey /generic:' + $($_) + ' /user:"$($username)@' + $($domain) + '" /pass:$Pass | Out-Null
                    mstsc /v:' + $($_) + ':' + $Port + ' | Out-Null
                    cmdkey /delete:TERMSRV/' + $($_) + ':' + $Port + ' | Out-Null
        }
                function Get-Server { 
        cmdkey /generic:' + $($_) + ' /user:"administrator@' + $($domain) + '" /pass:"' + $($Password) + '" | Out-Null
        mstsc /v:' + $($_) + '
        cmdkey /delete:TERMSRV/' + $($_) + ' | Out-Null}
        Get-MainMenu'
                    
                    

            New-Item -Path $filePath -Name "connect.ps1" -ItemType "file" -Value $Content | Out-Null
            # Get-Content -Path ".\USB\Scripts\!files\M127\TN-$TNNum\server.bat" -Raw | Out-File -FilePath ".\USB\Scripts\!files\M127\TN-$TNNum\server.exe" -Encoding ASCII
            # Get-Content -Path ".\USB\Scripts\!files\M127\TN-$TNNum\client.bat" -Raw | Out-File -FilePath ".\USB\Scripts\!files\M127\TN-$TNNum\client.bat" -Encoding ASCII
            # ConvertTo-Exe -InputScript ".\USB\Scripts\!files\M127\TN-$TNNum\server.ps1" -OutputFileName ".\USB\Scripts\!files\M127\TN-$TNNum\server.exe"
            # ConvertTo-Exe -InputScript ".\USB\Scripts\!files\M127\TN-$TNNum\client.ps1" -OutputFileName ".\USB\Scripts\!files\M127\TN-$TNNum\client.exe"
            Invoke-ps2exe ".\USB\Scripts\!files\M127\TN-$TNNum\connect.ps1" ".\USB\Scripts\!files\M127\TN-$TNNum\connect.exe" -noConsole | Out-Null
            Remove-Item -Path ".\USB\Scripts\!files\M127\TN-$TNNum\connect.ps1" -Recurse -force -ErrorAction SilentlyContinue
            # pause 
        }
       
        "TN-$TNNum          : $($_)" | Out-File ".\USB\Scripts\!files\M127\INFO.txt" -Append
    }
    "`n`nCL RDP Port     : $Port" | Out-File ".\USB\Scripts\!files\M127\INFO.txt" -Append
    "Domain          : $domain" | Out-File ".\USB\Scripts\!files\M127\INFO.txt" -Append
    "Password        : $Password" | Out-File ".\USB\Scripts\!files\M127\INFO.txt" -Append
    "Participants    : $TeilnehmerNum" | Out-File ".\USB\Scripts\!files\M127\INFO.txt" -Append
    Invoke-Item ".\USB\Scripts\!files\M127"
}