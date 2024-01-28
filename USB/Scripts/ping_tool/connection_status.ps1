$pingip = 'none'
$status = 'no'
$statusState = 0
$csvPath = "connection_status"
# get the location of the scriüt file
$scriptPath = Split-Path -Parent $MyInvocation.MyCommand.Definition
# combine the script path with the relative path to the csv file
$csvPath = Join-Path $scriptPath $csvPath
$BallonText = 'no Connection to:'
$BallonTitle = 'Warning'
$result = 0

Function BalloonTooltip
{
    [system.Reflection.Assembly]::LoadWithPartialName('System.Windows.Forms') | Out-Null
    $balloon = New-Object System.Windows.Forms.NotifyIcon
    $path = Get-Process -id $pid | Select-Object -ExpandProperty Path
    $icon = [System.Drawing.Icon]::ExtractAssociatedIcon($path)
    $balloon.Icon = $icon
    $balloon.BalloonTipIcon = $BallonTitle
    $balloon.BalloonTipText = $BallonText + $pingip
    $balloon.BalloonTipTitle = $BallonTitle
    $balloon.Visible = $true
    $balloon.ShowBalloonTip(10000)
}

function show-monitor
{
    Write-Host "Monitoring $pingip"
    while ($true)
    {
        $result = Show-ping
        if ($result -gt 0)
        {
            $BallonText = 'Connection established: '
            $BallonTitle = 'Info'
            if ($status -ne 'connected')
            {
                BalloonTooltip
            }
            $status = 'connected'
            Show-print-status
        }
        else
        {
            $BallonText = 'no Connection to: '
            $BallonTitle = 'Warning'
            if ($status -ne 'lost')
            {
                BalloonTooltip
            }
            $status = 'lost'
            Show-print-status
        }
        write-toCSV
    }
}

function write-toCSV()
{
    $data = [PSCustomObject]@{
        Date = Get-Date
        IP = $pingip
        Status = $status
        Ping = $result
    }
    $csvPath = $csvPath + "_($pingip).csv"
    if (-not(Test-Path $csvPath))
    {
        $header = "Date", "IP", "Status", "Ping"
        $header -join ";" | Out-File $csvPath -Encoding ascii
    }
    $data | Export-Csv -Path $csvPath -Append -NoTypeInformation -Delimiter ";" -Encoding ascii -Force
}

function Show-ping
{
    start-sleep 1
    $ping_result = ping $pingip -n 1
    $lines = $ping_result -split "`r`n"
    $all_results_time = $lines[-1] -Split "Maximum = "
    $ms_result = $all_results_time[-1].split("ms")[0].ToString().trim()
    if ($ms_result -eq "<1")
    {
        return 1
    }
    elseif (-not [int]::TryParse($ms_result, [ref]$null))
    {
        return 0
    }
    else
    {
        return [int]$ms_result
    }
}

function Show-print-status
{
    $statusStates = @('/', '-', '\', '|')
    Write-Host "`r$( Get-Date ) : " -NoNewline
    if ($status -eq 'connected')
    {
        Write-Host "$status " -NoNewline -ForegroundColor Green
    }
    else
    {
        Write-Host "$status " -NoNewline -ForegroundColor Red
    }
    Write-Host "$pingip $( $result )ms   $( $statusStates[$statusState] )            " -NoNewline
    $global:statusState = ($global:statusState + 1) % $statusStates.Length
}

$banner = """
   _____                            _   _                _____ _        _             
  / ____|                          | | (_)              / ____| |      | |            
 | |     ___  _ __  _ __   ___  ___| |_ _  ___  _ __   | (___ | |_ __ _| |_ _   _ ___ 
 | |    / _ \| '_ \| '_ \ / _ \/ __| __| |/ _ \| '_ \   \___ \| __/ _' | __| | | / __|
 | |___| (_) | | | | | | |  __/ (__| |_| | (_) | | | |  ____) | || (_| | |_| |_| \__ \
  \_____\___/|_| |_|_| |_|\___|\___|\__|_|\___/|_| |_| |_____/ \__\__,_|\__|\__,_|___/
        
****************************************************************
* Copyright of Colin Heggli $((Get-Date).Year))                             *
* https://colin.heggli.dev                                     *
* https://github.com/M4rshe1                                   *
****************************************************************
                                                                              
"""
Write-Host $banner
Write-Host "Which IP should be monitored?"
$pingip = Read-Host ">>"
show-monitor
