$banner = """
  _____ _               _______          _
 |  __ (_)             |__   __|        | |
 | |__) | _ __   __ _     | | ___   ___ | |
 |  ___/ | '_ \ / _' |    | |/ _ \ / _ \| |
 | |   | | | | | (_| |    | | (_) | (_) | |
 |_|   |_|_| |_|\__, |    |_|\___/ \___/|_|
                 __/ |
                |___/
                
****************************************************************
* Copyright of Colin Heggli $( $CURRENT_YEAR ))                               *    
* https://colin.heggli.dev                                     *
* https://github.com/M4rshe1                                   *
****************************************************************

"""
Function Create-Menu()
{

    Param(
        [Parameter(Mandatory = $True)][String]$MenuTitle,
        [Parameter(Mandatory = $True)][array]$MenuOptions
    )

    $MaxValue = $MenuOptions.count - 1
    $Selection = 0
    $EnterPressed = $False

    Clear-Host

    While ($EnterPressed -eq $False)
    {

        Write-Host "$MenuTitle"

        For ($i = 0; $i -le $MaxValue; $i++){

            If ($i -eq $Selection)
            {
                Write-Host -BackgroundColor DarkGray -ForegroundColor White "[ $( $MenuOptions[$i] ) ]"
            }
            Else
            {
                Write-Host "  $( $MenuOptions[$i] )  "
            }

        }

        $KeyInput = $host.ui.rawui.readkey("NoEcho,IncludeKeyDown").virtualkeycode

        Switch ($KeyInput)
        {
            13{
                $EnterPressed = $True
                Return $Selection
                Clear-Host
                break
            }

            38{
                If ($Selection -eq 0)
                {
                    $Selection = $MaxValue
                }
                Else
                {
                    $Selection -= 1
                }
                Clear-Host
                break
            }

            40{
                If ($Selection -eq $MaxValue)
                {
                    $Selection = 0
                }
                Else
                {
                    $Selection += 1
                }
                Clear-Host
                break
            }
            Default{
                Clear-Host
            }
        }
    }
}
Function main()
{
    $options = @("Ping Tool", "Powershell NMAP", "Connection Status", "Exit")
    $selection = Create-Menu -MenuTitle $banner -MenuOptions $options
    switch ($selection)
    {
        0 {
            Clear-Host
            irm "https://raw.githubusercontent.com/M4rshe1/tups1s/master/USB/Scripts/ping_tool/ping_tool.ps1" | iex
            main
        }
        1 {
            Clear-Host
            irm "https://raw.githubusercontent.com/M4rshe1/tups1s/master/USB/Scripts/ping_tool/powershell_nmap.ps1" | iex
            main
        }
        2 {
            Clear-Host
            irm "https://raw.githubusercontent.com/M4rshe1/tups1s/master/USB/Scripts/ping_tool/connection_status.ps1" | iex
            main
        }
        3 {
            Clear-Host
            Write-Host "Exit"
            exit
        }
    }
}

main