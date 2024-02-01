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


function main()
{
    $banner = """
              _     _    _____ _____ _    _   _  __          
     /\      | |   | |  / ____/ ____| |  | | | |/ /          
    /  \   __| | __| | | (___| (___ | |__| | | ' / ___ _   _ 
   / /\ \ / _' |/ _' |  \___ \\___ \|  __  | |  < / _ \ | | |
  / ____ \ (_| | (_| |  ____) |___) | |  | | | . \  __/ |_| |
 /_/    \_\__,_|\__,_| |_____/_____/|_|  |_| |_|\_\___|\__, |
                                                        __/ |
                                                       |___/
                                                                                                                                                 
****************************************************************
* Copyright of Colin Heggli $( (Get-Date).Year ))                              *
* https://colin.heggli.dev                                     *
* https://github.com/M4rshe1                                   *
****************************************************************

Select the remote host OS:
"""
    $options = @("Linux", "Windows", "Exit" )
    $selection = Create-Menu -MenuTitle $banner -MenuOptions $options
    clear-host
    write-host "Remote host IP/Hostname:"
    $remote_host = read-host ">> "
    clear-host
    write-host "Remote host username:"
    $remote_user = read-host ">> "
    clear-host
    write-host "Remote host Port:"
    $remote_port = read-host ">> "
    clear-host
    $ssh_key = "$HOME/.ssh/id_rsa.pub"
    if (Test-Path $ssh_key)
    {
        Write-Host "SSH key already exists at $ssh_key"
    }
    else
    {
        Write-Host "No SSH key found, generating one now..."
        generate_key
    }
    add_ssh_key $selection $remote_host $remote_user $remote_port

}

function add_ssh_key($selection, $remote_host, $remote_user, $remote_port)
{
    $ssh_key = "$HOME/.ssh/id_rsa.pub"
    $ssh_key = Get-Content $ssh_key
    if ($selection -eq 0)
    {
        Out-String -InputObject $ssh_key | ssh $remote_user@$remote_host -p $remote_port "mkdir -p ~/.ssh && echo $( $ssh_key ) >> ~/.ssh/authorized_keys"
        Read-Host "Added SSH key to $remote_host, press enter to continue..."
    }
    elseif ($selection -eq 1)
    {
        Out-String | ssh $remote_user@$remote_host -p $remote_port "mkdir -f C:\Users\$remote_user\.ssh && echo $( $ssh_key ) >> C:\Users\$remote_user\.ssh\authorized_keys"
        Read-Host "Added SSH key to $remote_host, press enter to continue..."
    }
    else
    {
        exit
    }
}




function generate_key()
{
    $logedin_user = whoami
    $user = $logedin_user.split("\")[1]
    $pc_name = $env:COMPUTERNAME

    # Generate a new SSH key
    ssh-keygen -t rsa -b 4096 -C "$user@$pc_name" -f $HOME/.ssh/id_rsa
    Write-Host "SSH key generated at $HOME/.ssh/id_rsa"
}


main
