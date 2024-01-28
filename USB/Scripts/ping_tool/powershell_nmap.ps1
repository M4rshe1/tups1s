$banner = """
  ____                           _          _ _   _   _ __  __          _____  
 |  __ \                         | |        | | | | \ | |  \/  |   /\   |  __ \ 
 | |__) |____      _____ _ __ ___| |__   ___| | | |  \| | \  / |  /  \  | |__) |
 |  ___/ _ \ \ /\ / / _ \ '__/ __| '_ \ / _ \ | | | . ` | |\/| | / /\ \ |  ___/ 
 | |  | (_) \ V  V /  __/ |  \__ \ | | |  __/ | | | |\  | |  | |/ ____ \| |     
 |_|   \___/ \_/\_/ \___|_|  |___/_| |_|\___|_|_| |_| \_|_|  |_/_/    \_\_|     
                                                                                          
****************************************************************
* Copyright of Colin Heggli $( (Get-Date).Year ))                              *
* https://colin.heggli.dev                                     *
* https://github.com/M4rshe1                                   *
****************************************************************

Single IP: 192.168.1.6 or heggli.dev or 192.168.1.0/24 

Ports: 80 or 1-100 or 80,443,8080 or all

Scann for services: y/n default: n

"""

function Get-Answer($question)
{
    clear-host
    Write-Host $banner
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
    $all_ping_results | ConvertTo-Json | Out-File -FilePath $name -Encoding UTF8
}

function show-results($data)
{
    $data | Format-Table -AutoSize
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
        $ports = $ports | sort-object -Unique -Descending
    }
    elseif ($ports_input.contains(","))
    {
        $ports = $ports_input.split(",")
    }
    else
    {
        $ports = @($ports_input)
    }
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
    $data = @()
    if ($services -eq "n")
    {
        $ipRange | ForEach-Object {
            $ip = $_
            $portList | ForEach-Object {
                $port = $_
#                Write-Host "Scanning $ip on port $port"
                $result = Test-NetConnection -ComputerName $ip -Port $port -InformationLevel Quiet -WarningAction SilentlyContinue
                if ($result -eq $true)
                {
                    $status = "open"
                }
                else
                {
                    #                    $status = "closed"
                    continue
                }
                $data += @{
                    Date = Get-Date -Format "yyyy.MM.dd_HH-mm-ss"
                    IP = $ip
                    Port = $port
                    Status = $status
                }
            }
        }
    }
    else
    {
        $ipRange | ForEach-Object {
            $ip = $_
            $portList | ForEach-Object {
                $port = $_
                $result = Test-NetConnection -ComputerName $ip -Port $port -InformationLevel Quiet -WarningAction SilentlyContinue
                if ($result -eq $true)
                {
                    $status = "open"
                }
                else
                {
                    #                    $status = "closed"
                    continue
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

                $data += @{
                    Date = Get-Date -Format "yyyy.MM.dd_HH-mm-ss"
                    IP = $ip
                    Port = $port
                    Status = $status
                    Service = $service
                }
            }
        }
    }
    return $data
}

function main()
{
    $ip = Get-Answer "Which IP or IP range should be scanned?"
    $port = Get-Answer "Which port(s) should be scanned?"
    $services = Get-Answer "Should the services be scanned? (y/n)"
    if ($services -eq "y")
    {
        $services = "y"
    }
    else
    {
        $services = "n"
    }
    $data = scan-ipRange $ip $port $services
    Write-Host "Results:"
    show-results $data
    $dict = @{
        "settings" = @{
            "ip" = $ip
            "port" = $port
            "services" = $services
        }
        "data" = $data
    }
    Save-Data $dict
}

main