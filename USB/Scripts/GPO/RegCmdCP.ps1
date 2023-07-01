Import-Module GroupPolicy

$RegistryPath1 = "HKCU\Software\Policies\Microsoft\Windows\System"
$RegistryPath2 = "HKCU\Software\Microsoft\Windows\CurrentVersion\Policies\System"
$RegistryPath3 = "HKCU\Software\Microsoft\Windows\CurrentVersion\Policies\Explorer"
$RegistryPath4 = "HKCU\Software\Microsoft\Windows\CurrentVersion\Policies\System"

if ($args[0] -eq 1) {
    $GPOName = "Prohibit CMD"
    New-GPO -Name $GPOName
    Set-GPRegistryValue -Name $GPOName -Key $RegistryPath1 -ValueName "DisableCMD" -Type DWord -Value 1
}
elseif ($args[0] -eq 2) {
    $GPOName = "Prohibit RegEdit"
    New-GPO -Name $GPOName
    Set-GPRegistryValue -Name $GPOName -Key $RegistryPath2 -ValueName "DisableRegistryTools" -Type DWord -Value 1     
}
elseif ($args[0] -eq 3) {
    $GPOName = "Prohibit Control Panel"
    New-GPO -Name $GPOName
    Set-GPRegistryValue -Name $GPOName -Key $RegistryPath3 -ValueName "NoControlPanel" -Type DWord -Value 1    
}
elseif ($args[0] -eq 4) {
    $GPOName = "Prohibit Task Manager"
    New-GPO -Name $GPOName
    Set-GPRegistryValue -Name $GPOName -Key $RegistryPath4 -ValueName "DisableTaskMgr" -Type DWord -Value 1     
}
elseif ($args[0] -eq 5) {
        
    $GPOName = "Prohibit RegEdit, CMD, Control Panel and Task Manager"
            
    New-GPO -Name $GPOName
            
    # Configure policy settings to disable Terminal, Regedit, and Control Panel
            
    Set-GPRegistryValue -Name $GPOName -Key $RegistryPath1 -ValueName "DisableCMD" -Type DWord -Value 1
    Set-GPRegistryValue -Name $GPOName -Key $RegistryPath2 -ValueName "DisableRegistryTools" -Type DWord -Value 1
    Set-GPRegistryValue -Name $GPOName -Key $RegistryPath3 -ValueName "NoControlPanel" -Type DWord -Value 1
    Set-GPRegistryValue -Name $GPOName -Key $RegistryPath4 -ValueName "DisableTaskMgr" -Type DWord -Value 1
}
