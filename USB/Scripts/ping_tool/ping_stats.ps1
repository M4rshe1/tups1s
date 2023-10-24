# ------------------------------------------------------- #
#                   Settings / Variables                  #
# ------------------------------------------------------- #

$DEFAULT_DEVICE = "google.com"
$DEFAULT_PING_DURATION = "20"
$BASE_API_URL = "https://api.heggli.dev/u/ping_graph"

# ------------------------------------------------------- #
#                        Functions                        #
# ------------------------------------------------------- #

function ping-device($dtp, $pd) {
    clear-host
    $StartTime = Get-Date
    $EndTime = $StartTime.AddSeconds($pd)

    Write-Host "Pinging $dtp for $pd seconds"
    Write-Host ""

    $ping_results = @{
        "req"   = 0
        "res"   = 0
        "lost"  = 0
        "loss"  = 0
        "min"   = 0
        "max"   = 0
        "times" = @()
        "device" = $dtp
        "starttime" = Get-Date -Format "yyyy.MM.dd HH:mm:ss"
        "timestamps" = @()
        "endtime" = ""
        "pingtime" = $pd
        "avg" = 0
    }

    Write-Host ""
    $i = 0
    $startTimeStamp = Get-Date
    While ($EndTime -gt (Get-Date)) {

        $nowTime = Get-Date
        $datetimeDifference = $nowTime - $startTimeStamp
        $ping_results["timestamps"] += $datetimeDifference.TotalSeconds

        [int]$ping_results["req"] += 1
        $ping_result = ping $dtp -n 1
        $lines = $ping_result -split "`r`n"
        $all_results_time = $lines[-1] -Split "Maximum = "
        $ms_result = $all_results_time[-1].split("ms")[0].ToString().trim()
        if ($ms_result -eq "<1") {
            $ms_result = 1
        }
        elseif (-not [int]::TryParse($ms_result, [ref]$null)) {
            $ping_results["times"] += 0
        }
        else {
            $ping_results["times"] += [int]$ms_result
        }







        $totalLength = [math]::round(($EndTime - $StartTime).TotalMilliseconds / 1000, 0)
        $completedLength = [math]::round(((Get-Date) - $StartTime).TotalMilliseconds / 1000 / $totalLength * 50, 0)
        $remainingLength = [math]::round(($EndTime - (Get-Date)).TotalMilliseconds / 1000 / $totalLength * 50, 0)

        $rcompletedLength = [math]::round(((Get-Date) - $StartTime).TotalSeconds)
#        Write-Host $completedLength
        if ($completedLength -gt 50) {
            $completedLength = 50
            $remainingLength = 0
        }
        $progressBar = ('#' * ($completedLength)) + ('.' * $remainingLength)

        Write-Host "`r" -NoNewline

        Write-Host $progressBar -NoNewline
        Write-Host "| " -NoNewline
        Write-Host ([math]::Round(($rcompletedLength / $totalLength * 100), 0).ToString().PadLeft(4) + "% /") -NoNewline
        Write-Host ([math]::Round((($EndTime - (Get-Date)).TotalMilliseconds / 1000), 0).ToString().PadLeft(4) + "s ") -NoNewline
        if ($ping_result -match "Antwort von") {
            Write-Host "0 " -NoNewline -ForegroundColor Green
            [int]$ping_results["res"] += 1
            Write-Host ([math]::round($ping_results["times"][$i], 2)).ToString().PadLeft(5) -NoNewline -ForegroundColor Yellow
            Write-Host "ms " -NoNewline -ForegroundColor Yellow
        }
        else {
            Write-Host "1 " -NoNewline -ForegroundColor Red
            [int]$ping_results["lost"] += 1
            Write-Host "None ".PadLeft(8) -NoNewline -ForegroundColor Yellow
        }

        Write-Host $ping_results["req"] -NoNewline -ForegroundColor Cyan
        Write-Host "          " -NoNewline
        Start-Sleep 1
        $i += 1
    }
    Write-Host ""

    $ping_results["loss"] = [math]::Round($ping_results["lost"] / $ping_results["req"] * 100)
    $ping_results["min"] = $ping_results["times"] | Measure-Object -Minimum | Select-Object -ExpandProperty Minimum
    $ping_results["max"] = $ping_results["times"] | Where-Object { $_ -ne 0 } |  Measure-Object -Maximum | Select-Object -ExpandProperty Maximum
    $ping_results["endtime"] = Get-Date -Format "yyyy.MM.dd HH:mm:ss"
    $ping_results["avg"] = $ping_results["times"] | Where-Object { $_ -ne 0 } | Measure-Object -Average | Select-Object -ExpandProperty Average
    $ping_results["avg"] = [math]::Round($ping_results["avg"])
    return $ping_results
}

# ------------------------------------------------------- #
#                          Load                           #
# ------------------------------------------------------- #

function Show-Resultload($all_results) {
    # $all_results | ConvertTo-Json | Out-File -FilePath "all_ping_results.json" -Encoding UTF8
    # $all_results[0]["loss"] | Out-String
    clear-host
    $longest = $all_results[0]
    foreach ($i in $all_results) {
        if ($i.times.Length -gt $longest.times.Length) {
            $longest = $i
        }
    }


    #    $response_graph = @()
    #    ForEach-Object $longest["times"] { $response_graph += "" }
    Write-Host "`nResponse Graph ((" -NoNewline
    Write-Host "0 " -NoNewline -ForegroundColor Red
    Write-Host " <10"  -NoNewline -ForegroundColor Green
    Write-Host ") " -NoNewline
    Write-Host "<25" -NoNewline -ForegroundColor Green
    Write-Host " <40 <60" -NoNewline -ForegroundColor Yellow
    Write-Host " <120 <" -NoNewline -ForegroundColor Red
    Write-Host ")"


    for ($i = 0; $i -lt $longest.times.Length; $i++) {
        foreach ($res in $all_results) {
            if ($res.times.Length -le $i) {
                Write-Host " ".PadRight(7) -NoNewline
                Write-Host " ".PadRight(8) -NoNewline
                if ($all_results[-1] -ne $res) {
                    Write-Host " | " -NoNewline
                }
                continue
            }
            if ($res.times[$i] -eq 0) {
                Write-Host "0".PadRight(7) -NoNewline -ForegroundColor Red
                Write-Host ": $( $res.times[$i] )ms".PadRight(8) -NoNewline
            }
            elseif ($res.times[$i] -lt 10) {
                Write-Host "#".PadRight(7)  -NoNewline -ForegroundColor Green
                if ($res.times[$i] -eq 0) {
                    Write-Host ": <$( $res["times"][$i] )ms".PadRight(8) -NoNewline
                }
                else {
                    Write-Host ": $( $res.times[$i] )ms".PadRight(8) -NoNewline
                }

            }
            elseif ($res.times[$i] -lt 25) {
                Write-Host "##".PadRight(7)  -NoNewline -ForegroundColor Green
                Write-Host ": $( $res.times[$i] )ms".PadRight(8) -NoNewline
            }
            elseif ($res.times[$i] -lt 40) {
                Write-Host "###".PadRight(7)  -NoNewline -ForegroundColor Yellow
                Write-Host ": $( $res.times[$i] )ms".PadRight(8) -NoNewline
            }
            elseif ($res.times[$i] -lt 60) {
                Write-Host "####".PadRight(7)  -NoNewline -ForegroundColor Yellow
                Write-Host ": $( $res.times[$i] )ms".PadRight(8) -NoNewline
            }
            elseif ($res.times[$i] -lt 120) {
                Write-Host "#####".PadRight(7)  -NoNewline -ForegroundColor Red
                Write-Host ": $( $res.times[$i] )ms".PadRight(8) -NoNewline
            }
            else {
                Write-Host "######".PadRight(7)  -NoNewline -ForegroundColor Red
                Write-Host ": $( $res.times[$i] )ms".PadRight(8) -NoNewline
            }
            if ($all_results[-1] -ne $res) {
                Write-Host " | " -NoNewline
            }
        }
        Write-Host ""
    }

    Write-Host "`nResponse Graph in Real Time:`n(+/- 1000ms = 1 x #)"
    foreach ($res in $all_results) {
        foreach ($i in $res.times) {
            if ($i -eq 0) {
                Write-Host "0000" -NoNewline -ForegroundColor Red
            }
            elseif ($i -lt 25) {
                Write-Host "#" -NoNewline -ForegroundColor Green
            }
            elseif ($i -lt 60) {
                Write-Host "#" -NoNewline -ForegroundColor Yellow
            }
            elseif ($i -lt 1000) {
                Write-Host "#" -NoNewline -ForegroundColor Red
            }
            elseif ($i -gt 1500) {
                Write-Host "##" -NoNewline -ForegroundColor Red
            }
            elseif ($i -lt 2500) {
                Write-Host "###" -NoNewline -ForegroundColor Red
            }
            else {
                Write-Host "####" -NoNewline -ForegroundColor Yellow
            }
        }
        Write-Host ""
    }
    Write-Host ""


    $summary = @(
        "  Requests   : "
        "  Responses  : "
        "  Lost       : "
        "  Loss       : "
        "  Min        : "
        "  Max        : "
        "  Avg        : "
    )

    # $all_results | out-string
    foreach ($i in $all_results) {
        $summary[0] += $i.req.ToString().PadRight(6)
        $summary[1] += $i.res.ToString().PadRight(6)
        $summary[2] += $i.lost.ToString().PadRight(6)
        $summary[3] += ($i.loss.ToString() + "% ").PadRight(6)
        $summary[4] += ($i.min.ToString() + "ms ").PadRight(6)
        $summary[5] += ($i.max.ToString() + "ms ").PadRight(6)
        $summary[6] += ($i.avg.ToString() + "ms ").PadRight(6)

        if ($all_results[-1] -ne $i) {
            $summary[0] += " : "
            $summary[1] += " : "
            $summary[2] += " : "
            $summary[3] += " : "
            $summary[4] += " : "
            $summary[5] += " : "
            $summary[6] += " : "
        }
    }
    Write-Host "Ping results for $($all_results[0].device):"
    foreach ($i in $summary) {
        Write-Host $i
    }
    Write-host ""
    $datetime1 = [datetime]::ParseExact($all_results[0].starttime, "yyyy.MM.dd HH:mm:ss", $null)
    $datetime2 = [datetime]::ParseExact($all_results[-1].endtime, "yyyy.MM.dd HH:mm:ss", $null)
    
    $datetimeDifference = $datetime2 - $datetime1
    if ($datetimeDifference -is [System.TimeSpan]) {
        $days = $datetimeDifference.Days
        $hours = $datetimeDifference.Hours
        $minutes = $datetimeDifference.Minutes
        $seconds = $datetimeDifference.Seconds
    
        $resultDatetimeString = "{0:D2}.{1:D2}:{2:D2}:{3:D2}" -f $days, $hours, $minutes, $seconds
    } else {
        Write-Host "Die Variable `$datetimeDifference enthält keine gültige TimeSpan."
    }
    Write-Host "  Start Time : $($all_results[0].starttime)"
    Write-Host "  End Time   : $($all_results[-1].endtime)"
    Write-Host "  Time       : $($resultDatetimeString)"
    Write-Host "  Device     : $($all_results[0].device)"
    Write-Host "  Ping Time  : $($all_results[0].pingtime) seconds"
}

# ------------------------------------------------------- #
#                          Main                           #
# ------------------------------------------------------- #
$logedin_user = whoami
$logedin_user = $logedin_user.split("\")[1]
Set-Location -Path "C:\Users\$($logedin_user)\Downloads"
Clear-Host
Write-Host @'
  _____ _               _______          _ 
 |  __ (_)             |__   __|        | |
 | |__) | _ __   __ _     | | ___   ___ | |
 |  ___/ | '_ \ / _' |    | |/ _ \ / _ \| |
 | |   | | | | | (_| |    | | (_) | (_) | |
 |_|   |_|_| |_|\__, |    |_|\___/ \___/|_|
                 __/ |                     
                |___/                      
'@
Write-Host ""
Write-Host "****************************************************************"
Write-Host "* Copyright of Colin Heggli 2023                               *"
Write-Host "* https://colin.heggli.dev                                     *"
Write-Host "* https://github.com/M4rshe1                                   *"
Write-Host "****************************************************************"
Write-Host ""
Write-Host ""
Write-Host "What would you like to do?"
Write-Host "  l - load ping results from file"
Write-Host "  p - ping device"
Write-Host "  g - generate graph"
$load_file = Read-Host ">> "

if ($load_file -eq "l") {
    # Load the Windows Forms assembly
    Add-Type -AssemblyName System.Windows.Forms

    # Create a File Open dialog box
    $openFileDialog = New-Object System.Windows.Forms.OpenFileDialog
    $openFileDialog.Filter = "Json files (*.json)|*.json|All files (*.*)|*.*"

    # Set the default folder to the user's Downloads folder
    $downloadsFolder = [System.Environment]::GetFolderPath('MyDocuments') + '\Downloads'
    $openFileDialog.InitialDirectory = $downloadsFolder

    # Show the dialog and check if the user selects a file
    $result = $openFileDialog.ShowDialog()

    # Check if the user clicked the OK button in the dialog
    if ($result -eq [System.Windows.Forms.DialogResult]::OK) {
        # Get the selected file path
        $selectedFile = $openFileDialog.FileName
        # Now you can do something with the selected file, e.g., open it
        # For example, let's just display the selected file path
        Write-Host "Selected File: $selectedFile"
        $jsonContent = Get-Content -Path $selectedFile -Raw
        $jsonObject = $jsonContent | ConvertFrom-Json
#        $jsonObject | ConvertTo-Json | Out-File -FilePath "test_output.json" -Encoding UTF8
        Show-Resultload -all_results $jsonObject
        $gengraph = Read-Host "Enter g to generate graph.`n>> "
        if ($gengraph -eq "g") {
            Start-Process "$($BASE_API_URL)"
        }

        exit
    }
    else {
        Write-Host "No file selected."
        Read-Host "Press Enter to exit..."
        exit
    }
}
elseif ($load_file -eq "g") {
    Start-Process "$($BASE_API_URL)"
    exit
}

$all_ping_results = @()
$device_to_ping = Read-Host "Enter device to ping (default: $DEFAULT_DEVICE)`n>> "
if ($device_to_ping -eq "") {
    $device_to_ping = $DEFAULT_DEVICE
}
$ping_duration = Read-Host "Enter ping duration X, Xs or Xm (default: $DEFAULT_PING_DURATION)`n>> "
if ($ping_duration -eq "") {
    $ping_duration = $DEFAULT_PING_DURATION
}
if ($ping_duration -match "^\d+s$") {
    $ping_duration = $ping_duration -replace "s", ""
    $ping_duration = [int]$ping_duration
}elseif ($ping_duration -match "^\d+m$") {
    $ping_duration = $ping_duration -replace "m", ""
    $ping_duration = [int]$ping_duration * 60
}elseif ([int]::TryParse($ping_duration, [ref]$null)) {
    $ping_duration = [int]$ping_duration
}else {
    Write-Host "Invalid ping duration: $ping_duration"
    exit
}

Clear-Host
while ($true) {
    $all_pings = ping-device $device_to_ping $ping_duration
    $all_ping_results += $all_pings
    Clear-Host
    #    Write-Host $all_ping_results
    Show-Resultload -all_results $all_ping_results
    $redo = Read-Host "Defaul: [y] for redo, [n] for save and exit`n>> "
    if ($redo -eq "n") {
        $datetime = Get-Date -Format "yyyy.MM.dd_HH-mm-ss"
        $all_ping_results | ConvertTo-Json | Out-File -FilePath "ping_results_$( $datetime ).json" -Encoding UTF8
        break
    }

    Clear-Host
}
