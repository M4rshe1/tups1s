# ------------------------------------------------------- #
#                   Settings / Variables                  #
# ------------------------------------------------------- #

$DEFAULR_DEVICE = "google.com"
$DEFAULT_PING_DURATION = "20"

# ------------------------------------------------------- #
#                        Functions                        #
# ------------------------------------------------------- #

function ping-device($dtp, $pd)
{
    $StartTime = Get-Date
    $EndTime = $StartTime.AddSeconds($pd)

    Write-Host "Pinging $dtp for $pd seconds"
    Write-Host ""

    $ping_results = @{
        "req" = 0
        "res" = 0
        "lost" = 0
        "loss" = 0
        "min" = 0
        "max" = 0
        "times" = @()
        "timestamps" = @()
    }

    Write-Host ""
    $i = 0
    While ($EndTime -gt (Get-Date))
    {
        [int]$ping_results["req"] += 1
        $ping_result = ping $dtp -n 1
        $ping_result | Out-File -FilePath "output.txt" -Encoding UTF8
        $encoded_ping_result = [System.Text.Encoding]::UTF8.GetString([System.IO.File]::ReadAllBytes("output.txt"))
        $lines = $encoded_ping_result -split "`r`n"
        $res_time = $lines[-2] -Split "Maximum = " | Select-Object -Last 1
        $res_time = $res_time -Split "ms" | Select-Object -First 1

        #        Write-Host $encoded_ping_result.split("Maximum = ")[1].split("ms")[0] -NoNewline
        if (-not [int]::TryParse($res_time, [ref]$null))
        {
            $ping_results["times"] += 0
        } else {
            $ping_results["times"] += [int]$res_time
        }
        $ping_results["timestamps"] += $ping_time

        $totalLength = [math]::round(($EndTime - $StartTime).TotalMilliseconds / 1000, 0)
        $completedLength = [math]::round(((Get-Date) - $StartTime).TotalMilliseconds / 1000 / $totalLength * 50, 0)
        $remainingLength = [math]::round(($EndTime - (Get-Date)).TotalMilliseconds / 1000 / $totalLength * 50, 0)

        $rcompletedLength = [math]::round(((Get-Date) - $StartTime).TotalMilliseconds / 1000, 0)

        $progressBar = ('#' * ($completedLength)) + ('.' * $remainingLength)

        Write-Host "`r" -NoNewline
        Write-Host $progressBar -NoNewline
        Write-Host "| " -NoNewline
        Write-Host ([math]::Round(($rcompletedLength / $totalLength * 100), 0).ToString().PadLeft(4) + "% / ") -NoNewline
        Write-Host ([math]::Round((($EndTime - (Get-Date)).TotalMilliseconds / 1000), 0).ToString().PadLeft(4) + "s ") -NoNewline
        if ($ping_result -match "Antwort von")
        {
            Write-Host "0 " -NoNewline -ForegroundColor Green
            [int]$ping_results["res"] += 1
            Write-Host ([math]::round($ping_results["times"][$i], 2)).ToString().PadLeft(5) -NoNewline -ForegroundColor Yellow
            Write-Host "ms " -NoNewline -ForegroundColor Yellow
        }
        else
        {
            Write-Host "1 " -NoNewline -ForegroundColor Red
            [int]$ping_results["lost"] += 1
            Write-Host "None ".PadLeft(8) -NoNewline -ForegroundColor Yellow
        }

        Write-Host $ping_results["req"] -NoNewline -ForegroundColor Blue
        Write-Host "          " -NoNewline
        Start-Sleep 1
        $i += 1
    }
    Write-Host ""

    $ping_results["loss"] = [math]::Round($ping_results["lost"] / $ping_results["req"] * 100)
    $ping_results["min"] = $ping_results["times"] | Measure-Object -Minimum | Select-Object -ExpandProperty Minimum
    $ping_results["max"] = $ping_results["times"] | Measure-Object -Maximum | Select-Object -ExpandProperty Maximum
    return $ping_results
}

function Show-Result($res, $device)
{
    $times = $res['times'] | Where-Object { $_ -gt 0 }

    if ($times.Count -gt 0) {
        $averageTime = [math]::round(($times | Measure-Object -Average).Average, 2)
    } else {
        $averageTime = 0
    }
    Write-Host ""
    Write-Host "  " -NoNewline

    # Calculate the average time
    $averageTime = [math]::round(($res['times'] | Measure-Object -Average).Average, 2)
    Write-Host "`nResponse Graph ((0 <10) <20 <30 <60 <120 <):"

    for ($i = 0; $i -lt $res['times'].Count; $i++) {
        if ($res['times'][$i] -eq 0) {
            Write-Host -NoNewline "  0".PadRight(8) -ForegroundColor Red
        }
        elseif ($res['times'][$i] -lt 10) {
            Write-Host -NoNewline "  #".PadRight(8) -ForegroundColor Green
        }
        elseif ($res['times'][$i] -lt 20) {
            Write-Host -NoNewline "  ##".PadRight(8) -ForegroundColor Green
        }
        elseif ($res['times'][$i] -lt 30) {
            Write-Host -NoNewline "  ###".PadRight(8) -ForegroundColor Green
        }
        elseif ($res['times'][$i] -lt 60) {
            Write-Host -NoNewline "  ####".PadRight(8) -ForegroundColor Yellow
        }
        elseif ($res['times'][$i] -lt 120) {
            Write-Host -NoNewline "  #####".PadRight(8) -ForegroundColor Yellow
        }
        else {
            Write-Host -NoNewline "  ######".PadRight(8) -ForegroundColor Red
        }
        Write-Host " : " ($res['times'][$i]).ToString().PadLeft(4) "ms" -Separator ""
    }

    Write-Host "`nResponse Graph in Real Time:`n(1000ms = 1 x #)`n   "

    # Loop through the response times
    foreach ($i in $res["times"]) {
        if ($i -lt 1) {
            Write-Host -NoNewline -ForegroundColor Red "0000"
        }
        elseif ($i -lt 30) {
            Write-Host -NoNewline -ForegroundColor Green "#"
        }
        elseif ($i -lt 120) {
            Write-Host -NoNewline -ForegroundColor Yellow "#"
        }
        elseif ($i -lt 1000) {
            Write-Host -NoNewline -ForegroundColor Red "#"
        }
        elseif ($i -lt 2000) {
            Write-Host -NoNewline -ForegroundColor Red "##"
        }
        elseif ($i -lt 3000) {
            Write-Host -NoNewline -ForegroundColor Red "###"
        }
        else {
            Write-Host -NoNewline -ForegroundColor Yellow "####"
        }
    }

    Write-Host ""

    Write-Host ""
    Write-Host "Ping results for $( $device ):"
    Write-Host "  Total requests    : $( $res['req'] )"
    Write-Host "  Received packets  : $( $res['res'] )"
    Write-Host "  Lost packets      : $( $res['lost'] )"
    Write-Host "  Packet loss       : $( $res['loss'] -f 'P2' )%"
    Write-Host "  Minimum           : $( $res['min'] )ms"
    Write-Host "  Average           : $( $averageTime -f 'F2' )ms"
    Write-Host "  Maximum           : $( $res['max'] )ms"
    Write-Host ""
    Write-Host ""
}






# ------------------------------------------------------- #
#                          Main                           #
# ------------------------------------------------------- #

    $device_to_ping = Read-Host "Enter device to ping (default: $DEFAULR_DEVICE)`n>> "
    if ($device_to_ping -eq "")
    {
        $device_to_ping = $DEFAULR_DEVICE
    }
    $ping_duration = Read-Host "Enter ping duration Xm or Xs (default: $DEFAULT_PING_DURATION)`n>> "
    if ($ping_duration -eq "")
    {
        $ping_duration = $DEFAULT_PING_DURATION
    }
    if ($ping_duration -match "^\d+s$")
    {
        $ping_duration = $ping_duration -replace "s", ""
        $ping_duration = [int]$ping_duration
    }
    elseif ($ping_duration -match "^\d+m$")
    {
        $ping_duration = $ping_duration -replace "m", ""
        $ping_duration = [int]$ping_duration * 60
    }
    elseif ([int]::TryParse($ping_duration, [ref]$null))
    {
        $ping_duration = [int]$ping_duration
    }
    else
    {
        Write-Host "Invalid ping duration: $ping_duration"
        exit
    }

    Clear-Host
while ($true) {
    $results = ping-device $device_to_ping $ping_duration
    Clear-Host
    Show-Result -res $results -device $device_to_ping
    $redo = Read-Host "Redo? (y/n)`n>> "
    if ($redo -eq "n")
    {
        break
    }
    Clear-Host
}




