$banner = """
  ____                           _          _ _   _   _ __  __          _____  
 |  __ \                         | |        | | | | \ | |  \/  |   /\   |  __ \ 
 | |__) |____      _____ _ __ ___| |__   ___| | | |  \| | \  / |  /  \  | |__) |
 |  ___/ _ \ \ /\ / / _ \ '__/ __| '_ \ / _ \ | | | . ' | |\/| | / /\ \ |  ___/ 
 | |  | (_) \ V  V /  __/ |  \__ \ | | |  __/ | | | |\  | |  | |/ ____ \| |     
 |_|   \___/ \_/\_/ \___|_|  |___/_| |_|\___|_|_| |_| \_|_|  |_/_/    \_\_|     
                                                                                          
****************************************************************
* Copyright of Colin Heggli $( (Get-Date).Year ))                              *
* https://colin.heggli.dev                                     *
* https://github.com/M4rshe1                                   *
****************************************************************

"""

$banner2 = """
IP: 192.168.1.6 or heggli.dev or 192.168.1.0/24 

Ports: 80 or 1-100 or 80,443,8080 or all

Scann for services: y/n default: n

"""

function Get-Answer($question)
{
    clear-host
    Write-Host $banner
    Write-Host $banner2
    Write-Host $question
    $answer = Read-Host ">>"
    return $answer
}

function Save-Data($data)
{
    $logedin_user = whoami
    $logedin_user = $logedin_user.split("\")[1]
    $datetime = Get-Date -Format "yyyy.MM.dd_HH-mm-ss"
    $name = "powershell_nmap_$( $datetime ).json"
    Set-Location -Path "C:\Users\$( $logedin_user )\Downloads"
    Write-Host "Saved as:"
    Write-Host "$( $name ) in \Users\$( $logedin_user )\Downloads"
    $data | ConvertTo-Json -Depth 100 | Out-File -FilePath $name -Encoding UTF8
}

function Show-FormattedResults($data, $ip)
{
    Write-Host "Interesting ports on $($ip)"
    Write-Host "$('PORT'.PadRight(10))$('STATE'.PadRight(10))$('SERVICE'.PadRight(30))"

    foreach ($item in $data) {
        $port = $item.port
        $status = $item.status
        $service = $item.service

        Write-Host "$port".PadRight(10) -NoNewline
        if ($status -eq "open")
        {
            Write-Host "$status".PadRight(10) -NoNewline -ForegroundColor Green
        }
        else
        {
            Write-Host "$status".PadRight(10) -NoNewline -ForegroundColor Red
        }
        Write-Host "$service".PadRight(10)
    }

    Write-Host ""
}

function Show-Results($data)
{
    Clear-Host
    $settings = $data.settings
    $data = $data.data

    if ($data.Count -eq 0) {
        Write-Host "No open ports found"
        exit
    }

    Write-Host "Started at: $($settings.time.start) - Ended at: $($settings.time.end) - Duration: $($settings.time.duration) seconds"

    foreach ($ip in $data.Keys) {
        Show-FormattedResults $data[$ip] $ip
    }
}

function get-formatedIP($ip)
{
    $range = @()
    if (-not $ip.contains("/"))
    {
        $range += $ip
    }
    elseif ([int]::TryParse($ip.replace(".", "").replace("/", ""), [ref]$null))
    {
        $range += Get-IpRange -Subnets $ip
    }
    return $range
}

function get-formatedPorts($ports_input)
{
    if ($ports_input -eq "all")
    {
        $ports = 1..65535
    }
    elseif ($ports_input.contains("-"))
    {
        $ports = $ports_input.split("-")
        $ports = $ports[0]..$ports[1]
    }
    elseif ($ports_input.contains(","))
    {
        $ports = $ports_input.split(",")
    }
    else
    {
        $ports = @($ports_input)
    }
    $ports = $ports | sort-object -Unique
    $ports = $ports | Where-Object {$_ -ge 1 -and $_ -le 65535}
    return $ports
}
function Get-IpRange
{
    [CmdletBinding(ConfirmImpact = 'None')]
    Param(
        [Parameter(Mandatory, HelpMessage = 'Please enter a subnet in the form a.b.c.d/#', ValueFromPipeline, Position = 0)]
        [string[]] $Subnets
    )

    begin {
        Write-Verbose -Message "Starting [$( $MyInvocation.Mycommand )]"
    }

    process {
        foreach ($subnet in $subnets)
        {
            if ($subnet -match '^\d{1,3}\.\d{1,3}\.\d{1,3}\.\d{1,3}/\d{1,2}$')
            {
                #Split IP and subnet
                $IP = ($Subnet -split '\/')[0]
                [int]$SubnetBits = ($Subnet -split '\/')[1]
                if ($SubnetBits -lt 7 -or $SubnetBits -gt 30)
                {
                    Write-Error -Message 'The number following the / must be between 7 and 30'
                    break
                }
                #Convert IP into binary
                #Split IP into different octects and for each one, figure out the binary with leading zeros and add to the total
                $Octets = $IP -split '\.'
                $IPInBinary = @()
                foreach ($Octet in $Octets)
                {
                    #convert to binary
                    $OctetInBinary = [convert]::ToString($Octet, 2)
                    #get length of binary string add leading zeros to make octet
                    $OctetInBinary = ('0' * (8 - ($OctetInBinary).Length) + $OctetInBinary)
                    $IPInBinary = $IPInBinary + $OctetInBinary
                }
                $IPInBinary = $IPInBinary -join ''
                #Get network ID by subtracting subnet mask
                $HostBits = 32 - $SubnetBits
                $NetworkIDInBinary = $IPInBinary.Substring(0, $SubnetBits)
                #Get host ID and get the first host ID by converting all 1s into 0s
                $HostIDInBinary = $IPInBinary.Substring($SubnetBits, $HostBits)
                $HostIDInBinary = $HostIDInBinary -replace '1', '0'
                #Work out all the host IDs in that subnet by cycling through $i from 1 up to max $HostIDInBinary (i.e. 1s stringed up to $HostBits)
                #Work out max $HostIDInBinary
                $imax = [convert]::ToInt32(('1' * $HostBits), 2) - 1
                $IPs = @()
                #Next ID is first network ID converted to decimal plus $i then converted to binary
                For ($i = 1; $i -le $imax; $i++) {
                    #Convert to decimal and add $i
                    $NextHostIDInDecimal = ([convert]::ToInt32($HostIDInBinary, 2) + $i)
                    #Convert back to binary
                    $NextHostIDInBinary = [convert]::ToString($NextHostIDInDecimal, 2)
                    #Add leading zeros
                    #Number of zeros to add
                    $NoOfZerosToAdd = $HostIDInBinary.Length - $NextHostIDInBinary.Length
                    $NextHostIDInBinary = ('0' * $NoOfZerosToAdd) + $NextHostIDInBinary
                    #Work out next IP
                    #Add networkID to hostID
                    $NextIPInBinary = $NetworkIDInBinary + $NextHostIDInBinary
                    #Split into octets and separate by . then join
                    $IP = @()
                    For ($x = 1; $x -le 4; $x++) {
                        #Work out start character position
                        $StartCharNumber = ($x - 1) * 8
                        #Get octet in binary
                        $IPOctetInBinary = $NextIPInBinary.Substring($StartCharNumber, 8)
                        #Convert octet into decimal
                        $IPOctetInDecimal = [convert]::ToInt32($IPOctetInBinary, 2)
                        #Add octet to IP
                        $IP += $IPOctetInDecimal
                    }
                    #Separate by .
                    $IP = $IP -join '.'
                    $IPs += $IP
                }
                Write-Output -InputObject $IPs
            }
            else
            {
                Write-Error -Message "Subnet [$subnet] is not in a valid format"
            }
        }
    }

    end {
        Write-Verbose -Message "Ending [$( $MyInvocation.Mycommand )]"
    }
}

function scan-ipRange($ipRange, $portList, $services)
{
    $ipRange = get-formatedIP($ipRange)
    $portList = get-formatedPorts($portList)
    $data = @{}
    $max_loops = $ipRange.count * $portList.count
    $counter = 0
    if ($services -eq "n")
    {
        $ipRange | ForEach-Object {
            $ip = $_
            $data.$ip = @()
            $portList | ForEach-Object {
                $counter += 1
                Write-Host "Scanning $ip on port $_ [$counter/$max_loops]" -NoNewline
                $port = $_
                $obj = new-Object system.Net.Sockets.TcpClient
                $connect = $obj.BeginConnect($ip,$port,$null,$null)
                $Wait = $connect.AsyncWaitHandle.WaitOne(100,$false)
                If (-Not $Wait) {
                    $obj.Close()
                    $status = "closed"
                    write-host " - #" -ForegroundColor Red
                }
                else {
                    $obj.EndConnect($connect) | Out-Null
                    $status = "open"
                    write-host " - #" -ForegroundColor Green
                }
#                $result = Test-NetConnection -ComputerName $ip -Port $port -InformationLevel Quiet -ErrorAction Stop -WarningAction SilentlyContinue
#                if ($result -eq $true)
#                {
#                    $status = "open"
#                    write-host " - #" -ForegroundColor Green
#                }
#                else
#                {
#                    $status = "closed"
#                    write-host " - #" -ForegroundColor Red
#                }
                $data.$ip += @{
                    date = Get-Date -Format "yyyy.MM.dd_HH-mm-ss"
                    port = $port
                    status = $status
                    service = ""
                }

            }
        }
    }
    else
    {
        $ipRange | ForEach-Object {
            $ip = $_
            $data.$ip = @()
            $portList | ForEach-Object {
                $counter += 1
                Write-Host "Scanning $ip on port $_ [$counter/$max_loops]" -NoNewline
                $port = $_
#                $result = Test-NetConnection -ComputerName $ip -Port $port -InformationLevel Quiet -ErrorAction Stop -WarningAction SilentlyContinue
#                if ($result -eq $true)
#                {
#                    $status = "open"
#                    write-host " - #" -ForegroundColor Green
#                }
#                else
#                {
#                    $status = "closed"
#                    write-host " - #" -ForegroundColor Red
#                }
                $obj = new-Object system.Net.Sockets.TcpClient
                $connect = $obj.BeginConnect($ip,$port,$null,$null)
                $Wait = $connect.AsyncWaitHandle.WaitOne(100,$false)
                If (-Not $Wait) {
                    $obj.Close()
                    $status = "closed"
                    write-host " - #" -ForegroundColor Red
                }
                else {
                    $obj.EndConnect($connect) | Out-Null
                    $status = "open"
                    write-host " - #" -ForegroundColor Green
                }
                $service = Get-Service -ComputerName $ip -Name $port -ErrorAction SilentlyContinue
                if ($null -eq $service)
                {
                    $service = "unknown"
                }
                else
                {
                    $service = $service.DisplayName
                }
                $date = Get-Date -Format "yyyy.MM.dd_HH-mm-ss"
                $data.$ip += @{
                    date = $date
                    port = $port
                    status = $status
                    service = $service
                }
            }
        }
    }
    Write-Host "Scan finished"
    return $data
}


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

function Select-File()
{
    # Create a File Open dialog box
    $openFileDialog = New-Object System.Windows.Forms.OpenFileDialog
    $openFileDialog.Filter = "Json files (*.json)|*.json|All files (*.*)|*.*"

    # Set the default folder to the user's Downloads folder
    $downloadsFolder = [System.Environment]::GetFolderPath('MyDocuments') + '\Downloads'
    $openFileDialog.InitialDirectory = $downloadsFolder

    # Show the dialog and check if the user selects a file
    $result = $openFileDialog.ShowDialog()

    # Check if the user clicked the OK button in the dialog
    if ($result -eq [System.Windows.Forms.DialogResult]::OK)
    {
        # Get the selected file path
        $selectedFile = $openFileDialog.FileName
        # Now you can do something with the selected file, e.g., open it
        # For example, let's just display the selected file path
        Write-Host "Selected File: $selectedFile"
        $jsonContent = Get-Content -Path $selectedFile -Raw
        $jsonObject = $jsonContent | ConvertFrom-Json
        #        Write-Host $selectedFile
        #        Write-Host $selectedFile.Split("\")[-1].Split(".")[0]
        return $jsonObject,$selectedFile.Split("\")[-1].Replace(".json", "").Replace(".", "")
    }
    else
    {
        Write-Host "No file selected."
        Read-Host "Press Enter to exit..."
        exit
    }
}

function main()
{
    $options = @("New Scan", "Load Scan", "Scann with previous Settings", "Discover", "Exit")
    $selection = Create-Menu -MenuTitle $banner -MenuOptions $options
    $selection = $options[$selection]
    if ($selection -eq "New Scan")
    {
        $ip = Get-Answer "Enter IP or IP range"
        $port = Get-Answer "Enter ports to scan"
        $services = Get-Answer "Should the services be scanned? (y/n)"
        if ($services -eq "y")
        {
            $services = "y"
        }
        else
        {
            $services = "n"
        }
        clear-host
        $start = Get-Date
        $data = scan-ipRange $ip $port $services
        $end = Get-Date
        $duration = [math]::Round($end.Subtract($start).TotalMilliseconds / 1000, 4)
        
        $start = $start.ToString("yyyy.MM.dd_HH-mm-ss")
        $end = $end.ToString("yyyy.MM.dd_HH-mm-ss")
        
        clear-host
        $dict = @{
            "settings" = @{
                "ip" = $ip
                "port" = $port
                "services" = $services
                "time" = @{
                    "start" = $start
                    "end" = $end
                    "duration" = $duration
                }
            }
            "data" = $data
        }
        show-results $dict
        Save-Data $dict
    }
    elseif ($selection -eq "Load Scan")
    {
        $data, $name = Select-File
        Write-Host "Results:"
        show-results $dict
    }
    elseif ("Scann with previous Settings")
    {
        $data, $name = Select-File
        $ip = $data.settings.ip
        $port = $data.settings.port
        $services = $data.settings.services
        clear-host
        $start = Get-Date -Format "yyyy.MM.dd_HH-mm-ss"
        $data = scan-ipRange $ip $port $services
        $end = Get-Date -Format "yyyy.MM.dd_HH-mm-ss"
        $duration = [math]::Round($end.Subtract($start).TotalMilliseconds / 1000, 4)

        $start = $start.ToString("yyyy.MM.dd_HH-mm-ss")
        $end = $end.ToString("yyyy.MM.dd_HH-mm-ss")

        clear-host
        $dict = @{
            "settings" = @{
                "ip" = $ip
                "port" = $port
                "services" = $services
                "time" = @{
                    "start" = $start
                    "end" = $end
                    "duration" = $duration
                }
            }
            "data" = $data
        }
        show-results $dict
        Save-Data $dict
    }
    elseif ($selection -eq "Discover")
    {

    }
    else
    {
        exit
    }
    Read-Host "Press Enter to exit..."
}

main