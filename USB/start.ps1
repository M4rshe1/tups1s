# Set-ExecutionPolicy RemoteSigned

# whoami.exe
# pause
$ErrorActionPreference = 'Stop'
function Show-Menu {

    Clear-Host
    Write-Host "What would you like to do?"
    Write-Host
    Write-Host " * Update USB       (1)"
    Write-Host " + Windows          (2)"
    Write-Host " + Windows Server   (3)"
    Write-Host " + Games            (4)"
    Write-Host " + Script Generator (5)"
    Write-Host " + Network          (6)"
    Write-Host " + Remote           (7)"
    Write-Host " + Settings         (8)"
    Write-Host " - Exit             (0)"
    Write-Host
    $select = Read-Host "Select"
    
    switch ($select) {
        "0" { Exit }
        "1" { Update-USB }
        "2" { Show-WindowsMenu }
        "3" { Show-WindowsServerMenu }
        "4" { Show-GamesMenu }
        "5" { Show-GeneratorMenu }
        "6" { Show-NetworkMenu }
        "7" { Show-RemoteMenu }
        "8" { Show-SettingMenu }
        default { Show-Menu }
    }
}

# -------------------------------------------------- #
#                   Update USB                       #
# -------------------------------------------------- #

#update with git
function CheckGit {
    Clear-Host
    Write-Host "Checking Git..."
    if (!(Get-Command git -ErrorAction SilentlyContinue)) {
        $installGit = Read-Host "Git not found. Install Git? (Y/N)"
        if ($installGit -eq "Y") {
            if (!(Get-Command winget -ErrorAction SilentlyContinue)) {
                Write-Host "Winget is not installed. You can install it from the Microsoft Store or by enabling it in Windows Features."
                Write-Host "It also possible to install Git manually " start "https://git-scm.com/download/win" from https://git-scm.com/download/win
                exit 1
            }

            Write-Host "Installing Git..."
            winget install Git -e
            if (!(Get-Command git -ErrorAction SilentlyContinue)) {
                Write-Host "Git installation failed."
                exit 1
            }

            Write-Host "Git has been installed successfully."
            exit 0
        } else {
            Write-Host "Git not found. Please install Git."
            pause
            exit 1
        }
    } else {
        Write-Host "Git found"
        return 0
    }
}



function Update-USB {
    Clear-Host
    if (CheckGit -eq 1) {
        return
    }
    Write-Host "Updating USB..."
    git pull
    Read-Host "USB updated. Press any key to continue..."
    Show-Menu
}





# -------------------------------------------------- #
#                   Windows Menu                     #
# -------------------------------------------------- #

function Show-WindowsMenu {
    Clear-Host
    Write-Host "What would you like to do?"
    Write-Host
    Write-Host " + Hack Windows    (1)"
    Write-Host " + Regedit         (2)"
    Write-Host " * Use CTT Tool    (3)"
    Write-Host " - Back            (0)"
    Write-Host
    $select5 = Read-Host "Select"
    
    switch ($select5) {
        "0" { Show-Menu }
        "1" { Show-HackWindows }
        "2" { Show-RegEdit }
        "3" { Show-CTT }
        default { Show-WindowsMenu }
    }
}


function Show-HackWindows {
    Clear-Host
    Write-Host "What would you like to Hack?"
    Write-Host
    Write-Host " * Windows Login   (1)"
    Write-Host " - Back            (0)"
    Write-Host
    $select2 = Read-Host "Select"
    
    switch ($select2) {
        "0" { Show-Menu }
        "1" { WindowsLogin }
        default { Show-WindowsMenu }
    }
}

function WindowsLogin {
    Clear-Host
    .\USB\Scripts\hackWinLogin\hack.ps1

}


function Show-RegEdit {
    Clear-Host
    Write-Host "What would you like to do?"
    Write-Host
    Write-Host " * Clock with Sec       (1)"
    Write-Host " * Clock without Sec    (2)"
    Write-Host " * Win 10 Kontext Menu  (3)"
    Write-Host " - Back                 (0)"
    Write-Host
    $select2 = Read-Host "Select"
    
    switch ($select2) {
        "0" { Show-Menu }
        "1" { ClockWithSeconds }
        "2" { ClockWithoutSeconds }
        "3" { Win10KontextMenu }
        default { Show-WindowsMenu }
    }
}

function ClockWithSeconds {
    Clear-Host
    Invoke-Item ".\USB\PC Hacks\add_sec.reg"
    pause
}

function ClockWithoutSeconds {
    Clear-Host
    Invoke-Item ".\USB\PC Hacks\rm_sec.reg"
    pause
}

function Win10KontextMenu {
    Clear-Host
    cmd.exe ".\USB\PC Hacks\kontexmenu.bat"
    pause
}

function Show-CTT {
    Invoke-RestMethod christitus.com/win | Invoke-Expression
}


# -------------------------------------------------- #
#               Windows Server Menu                  #
# -------------------------------------------------- #
function Show-WindowsServerMenu {
    Clear-Host
    Write-Host "What would you like to do?"
    Write-Host
    Write-Host " * Document Roles       (1)"
    Write-Host " * Document GPO         (2)"
    Write-Host
    Write-Host " + Add Domain Users     (3)"
    Write-Host " + Add SV to Domain     (4)"
    Write-Host " * Add PC to Domain     (5)"
    Write-Host " + Add GPOs to Domain   (6)"
    Write-Host
    Write-Host " - Back                 (0)"
    Write-Host
    $select3 = Read-Host "Select"
    
    switch ($select3) {
        "0" { Show-Menu }
        "1" { DocumentRoles }
        "2" { DocumentGPO }
        "3" { Add-DomainUser }
        "4" { ConfigServer }
        "5" { Add-PCToDomain }
        "6" { Add-GPOsToDomain }
        default { Show-WindowsServerMenu }
    }
}

function DocumentRoles {
    Clear-Host
    # Write-Host "Scanning Roles..."
    .\USB\Scripts\ScannRoles\roles.ps1
    Show-WindowsServerMenu
}

function Add-PCToDomain {
    Clear-Host
    .\USB\Scripts\addPCToDomain\addPC.ps1
    Show-WindowsServerMenu
}

function DocumentGPO {
    Clear-Host
    # Write-Host "Scanning GPOs..."
    .\USB\Scripts\ScannGPOs\GPO_Scann.ps1
    Show-WindowsServerMenu
}
function ConfigServer {
    Clear-Host
    Write-Host "Add Server to Domain"
    Write-Host
    Write-Host " * Auto         (1)"
    Write-Host " * Config Auto  (2)"
    Write-Host " * Manuall      (3)"
    Write-Host " - Back         (0)"
    Write-Host
    $select6 = Read-Host "Select"
    
    switch ($select6) {
        "0" { Show-WindowsServerMenu }
        "1" { ServerAutoConfig }
        "2" { ConfigAuto }
        "3" { ServerManuallConfig }
        default { ConfigServer }
    }
}

function ServerAutoConfig {
    Clear-Host
    .\USB\Scripts\ConfServer\start_auto.ps1
    ConfigServer
}
function ConfigAuto {
    Clear-Host
    .\USB\Scripts\ConfServer\autoConf.ps1
    ConfigServer
}
function ServerManuallConfig {
    Clear-Host
    .\USB\Scripts\ConfServer\start.ps1
    Show-WindowsServerMenu
}

function Add-DomainUser {
    Clear-Host
    Write-Host "Import Users from..."
    Write-Host
    Write-Host " * TXT      (1)"
    Write-Host " * CSV      (2)"
    Write-Host " - Back     (0)"
    Write-Host
    $select3_3 = Read-Host "Select"
    
    switch ($select3_3) {
        "0" { Show-WindowsServerMenu }
        "1" { Add-UsersFromTXT }
        "2" { Add-UsersFromCSV }
        default { Add-DomainUser }
    }
}

function Add-UsersFromTXT {
    Clear-Host
    Write-Host "Importing users from TXT..."
    .\USB\Scripts\AddUsersToDomain\TXT\adduser.ps1
    Show-WindowsServerMenu
}

function Add-UsersFromCSV {
    Clear-Host
    Write-Host "Importing users from CSV..."
    .\USB\Scripts\AddUsersToDomain\CSV\CustomUserAdd.ps1
    
    Show-WindowsServerMenu
}

function Add-GPOsToDomain {
    # $CrrentConfigFile = ".\USB\Scripts\!Config\config.json"
    # $CurrentConfigFileContent = Get-Content -Raw $CrrentConfigFile -ErrorAction SilentlyContinue | ConvertFrom-Json 
    Clear-Host
    Write-Host
    Write-Host "#################################################################################"
    Write-Host "#                                                                               #"
    Write-Host "#   After completing the configuration,                                         #"
    Write-Host "#   a GPO scan is recommended to check whether the settings are correct.        #"
    Write-Host "#                                                                               #"
    Write-Host "#   The GPOs are also not yet linked,                                           #"
    Write-Host "#   so the links still have to be created manually.                             #"
    Write-Host "#                                                                               #"
    Write-Host "#################################################################################`n"
    Write-Host "Choose GPOs"
    Write-Host
    # Write-Host " * Set Domain                               (1)"
    # Write-Host "   Domain:" $CurrentConfigFileContent.settings.DefaultDomain
    # Write-Host 
    Write-Host " * Enable RDP                               (1)"
    Write-Host
    Write-Host " * Prohibi all                              (2)"
    Write-Host "    * Prohibit CMD                          (2.1)"
    Write-Host "    * Prohibit RegEdit                      (2.2)"
    Write-Host "    * Prohibit Control Panel                (2.3)"
    Write-Host "    * Prohibit Task Manager                 (2.4)"
    Write-Host
    Write-Host " * Set Wallpaper                            (3)"
    Write-Host
    Write-Host " - Back                                     (0)"
    Write-Host
    $select3_3 = Read-Host "Select"
    
    switch ($select3_3) {
        "0" { Show-WindowsServerMenu }
        # "1" { SetDomainName }
        "1" { Set-GPO_RDP }
        "2" { Set-GPO_CMDRegCLP }
        "2.1" { Set-GPO_CMD }
        "2.2" { Set-GPO_Reg }
        "2.3" { Set-GPO_CLP }
        "2.4" { Set-GPO_TM }
        "3" { Set-GPO_SetWallpaper }
        default { Add-GPOsToDomain }
    }
    Add-GPOsToDomain
}
function SetDomainName {
    Clear-Host
    .\USB\Scripts\Games\DefaultDomain.ps1
    
}
function Set-GPO_CMDRegCLP {
    Clear-Host
    .\USB\Scripts\GPO\RegCmdCP.ps1 5
    
}
function Set-GPO_CMD {
    Clear-Host
    .\USB\Scripts\GPO\RegCmdCP.ps1 1
    
}
function Set-GPO_Reg {
    Clear-Host
    .\USB\Scripts\GPO\RegCmdCP.ps1 2
    
}
function Set-GPO_CLP {
    Clear-Host
    .\USB\Scripts\GPO\RegCmdCP.ps1 3
    
}
function Set-GPO_TM {
    Clear-Host
    .\USB\Scripts\GPO\RegCmdCP.ps1 4
    
}
function Set-GPO_RDP {
    Clear-Host
    .\USB\Scripts\GPO\RDP.ps1
    
}
function Set-GPO_SetWallpaper {
    Clear-Host
    .\USB\Scripts\GPO\wallpaper.ps1
    
}





# -------------------------------------------------- #
#                   Games Menu                       #
# -------------------------------------------------- #

function Show-GamesMenu {
    Clear-Host
    Write-Host "Play A Game?"
    Write-Host
    Write-Host " * ps1 Snake         (1)"
    Write-Host " * TIC TAC TOE       (2)"
    Write-Host " * Guess Number      (3)"
    Write-Host " - back              (0)"
    Write-Host
    $select4 = Read-Host "Select"
    
    switch ($select4) {
        "0" { Show-Menu }
        "1" { PlaySnake }
        "2" { PlayTTT }
        "3" { PlayGuessNum }
        default { Show-GamesMenu }
    }
}

function PlaySnake {
    Clear-Host
    # Write-Host "Launching Snake game..."
    Clear-Host
    .\USB\Scripts\Games\Snake.ps1
    Clear-Host
    Show-GamesMenu
}
function PlayTTT {
    Clear-Host
    # Write-Host "Launching Snake game..."
    # Start-Process -filepath ".\USB\Scripts\Games\ttt.bat" -NoNewWindow
    .\USB\Scripts\Games\ttt.ps1
    Clear-Host
    Show-GamesMenu
}
function PlayGuessNum {
    Clear-Host
    # Write-Host "Launching Snake game..."
    # Start-Process -filepath ".\USB\Scripts\Games\ttt.bat" -NoNewWindow
    .\USB\Scripts\Games\guessNum.ps1
    Clear-Host
    Show-GamesMenu
}

# -------------------------------------------------- #
#                  Settings Menu                     #
# -------------------------------------------------- #
function Show-SettingMenu {
    $CrrentConfigFile = ".\USB\Scripts\!Config\config.json"
    $CurrentConfigFileContent = Get-Content -Raw $CrrentConfigFile -ErrorAction SilentlyContinue | ConvertFrom-Json 
    Clear-Host
    Write-Host "Settings"
    Write-Host
    Write-Host " * Manuall config           (1)"
    Write-Host " * Change Default Domain    (2)"
    Write-Host "   Domain:" $CurrentConfigFileContent.settings.DefaultDomain
    Write-Host 
    Write-Host " * Default color            (3)"
    Write-Host
    Write-Host " - Reset Settings           (R)"
    Write-Host " - back                     (0)"
    Write-Host
    $select4 = Read-Host "Select"
    
    switch ($select4) {
        "0" { Show-Menu }
        "1" { Show-SettingManuall }
        "2" { Show-SettingMenuDefaultDomain }
        "3" { Show-SettingDefaultColor }
        "R" { Show-SettingReset }
        default { Show-SettingMenu }
    }
    
}
function Show-SettingMenuDefaultDomain {
    
    .\USB\Scripts\Settings\DefaultDomain.ps1
    Clear-Host
    Show-SettingMenu
}
function Show-SettingDefaultColor {
    
    .\USB\Scripts\Settings\DefaultColor.ps1
    Clear-Host
    Show-SettingMenu
}
function Show-SettingManuall {
    
    Invoke-Item ".\USB\Scripts\!config\config.json"
    Clear-Host
    Show-SettingMenu
}
function Show-SettingReset {
    
    .\USB\Scripts\Settings\Default.ps1
    Clear-Host
    Show-SettingMenu
}




# -------------------------------------------------- #
#                  generator Menu                    #
# -------------------------------------------------- #
function Show-GeneratorMenu {
    Clear-Host
    Write-Host "Script Generator"
    Write-Host
    Write-Host " * Net Mapper       (1)"
    Write-Host " * RDP M127 Gen     (2)"
    Write-Host " * ps2exe           (3)"
    Write-Host
    Write-Host " - back             (0)"
    Write-Host
    $select4 = Read-Host "Select"
    
    switch ($select4) {
        "0" { Show-Menu }
        "1" { Show-GeneratorNetMapper }
        "2" { Show-GeneratorRDPm127 }
        "3" { Show-Generatorps2exe }
        default { Show-GeneratorMenu }
    }
    
}
function Show-GeneratorNetMapper {
    Clear-Host
    .\USB\Scripts\Generator\netmapper.ps1
    Clear-Host
    Show-GeneratorMenu
}
function Show-GeneratorRDPm127 {
    Clear-Host
    .\USB\Scripts\Generator\m127_rdp.ps1
    Clear-Host
    Show-GeneratorMenu
}

function Show-Generatorps2exe {
    Clear-Host
    .\USB\Scripts\Generator\ps2exe.ps1
    Clear-Host
    Show-GeneratorMenu
}

# -------------------------------------------------- #
#                  Network Menu                      #
# -------------------------------------------------- #

function Show-NetworkMenu {
    Clear-Host
    Write-Host "Network"
    Write-Host
    Write-Host " * Ping Tool        (1)"
    Write-Host
    Write-Host " - back             (0)"
    Write-Host
    $select4 = Read-Host "Select"

    switch ($select4) {
        "0" { Show-Menu }
        "1" { ping-tool }
        default { Show-NetworkMenu }
    }
}

function ping-tool {
    Clear-Host
    $currentPath = Get-Location
    .\USB\Scripts\ping_tool\ping_tool.ps1
    Set-Location $currentPath
    Clear-Host
    Show-NetworkMenu
}


function Show-RmoteMenu {
    Clear-Host
    Write-Host "Remote"
    Write-Host
    Write-Host " * add Public SSH Key to Server        (1)"
    Write-Host
    Write-Host " - back             (0)"
    Write-Host
    $select4 = Read-Host "Select"
    
switch ($select4) {
        "0" { Show-Menu }
        "1" { add-ssh-key }
        default { Show-RmoteMenu }
    }
}


function add-ssh-key {
    clear-host
    .\USB\Scripts\remote\add-ssh-key.bat
    Clear-Host
    Show-RmoteMenu
}






Show-Menu
