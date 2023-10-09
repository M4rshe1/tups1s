# ------------------------------------------------------- #
#                   Settings / Variables                  #
# ------------------------------------------------------- #

$DEFAULT_DEVICE = "google.com"
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
        $all_results_time = $lines[-2] -Split "Maximum = " | Select-Object -Last 1
        $all_results_time = $all_results_time -Split "ms" | Select-Object -First 1

        #        Write-Host $encoded_ping_result.split("Maximum = ")[1].split("ms")[0] -NoNewline
        if (-not [int]::TryParse($all_results_time, [ref]$null))
        {
            $ping_results["times"] += 0
        }
        else
        {
            $ping_results["times"] += [int]$all_results_time
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

function Show-Result($all_results, $device)
{
    $longest = $all_results[0]
    foreach ($i in $all_results)
    {
        if ($i["times"].Length -gt $longest["times"].Length)
        {
            $longest = $i
        }
    }


    #    $response_graph = @()
    #    ForEach-Object $longest["times"] { $response_graph += "" }
    Write-Host "`nResponse Graph ((0 <10) <20 <30 <60 <120 <):"

    for ($i = 0; $i -lt $longest["times"].Length; $i++)
    {
        foreach ($res in $all_results)
        {
            if ($res["times"][$i] -eq 0)
            {
                Write-Host "#".PadRight(7) -NoNewline -ForegroundColor Red
                Write-Host ": $( $res["times"][$i] )ms".PadRight(8) -NoNewline
            }
            elseif ($res["times"][$i] -lt 10)
            {
                Write-Host "#".PadRight(7)  -NoNewline -ForegroundColor Green
                Write-Host ": $( $res["times"][$i] )ms".PadRight(8) -NoNewline

            }
            elseif ($res["times"][$i] -lt 20)
            {
                Write-Host "#".PadRight(7)  -NoNewline -ForegroundColor Green
                Write-Host ": $( $res["times"][$i] )ms".PadRight(8) -NoNewline
            }
            elseif ($res["times"][$i] -lt 30)
            {
                Write-Host "#".PadRight(7)  -NoNewline -ForegroundColor Green
                Write-Host ": $( $res["times"][$i] )ms".PadRight(8) -NoNewline
            }
            elseif ($res["times"][$i] -lt 60)
            {
                Write-Host "#".PadRight(7)  -NoNewline -ForegroundColor Yellow
                Write-Host ": $( $res["times"][$i] )ms".PadRight(8) -NoNewline
            }
            elseif ($res["times"][$i] -lt 120)
            {
                Write-Host "#".PadRight(7)  -NoNewline -ForegroundColor Red
                Write-Host ": $( $res["times"][$i] )ms".PadRight(8) -NoNewline
            }
            else
            {
                Write-Host "#".PadRight(7)  -NoNewline -ForegroundColor Red
                Write-Host ": $( $res["times"][$i] )ms".PadRight(8) -NoNewline
            }
            if ($all_results[-1] -ne $res)
            {
                Write-Host " | " -NoNewline
            }
        }
        Write-Host ""
    }

    Write-Host "`nResponse Graph in Real Time:`n(1000ms = 1 x #)"
    foreach ($res in $all_results)
    {
        foreach ($i in $res["times"])
        {
            if ($i -eq 0)
            {
                Write-Host "####" -NoNewline -ForegroundColor Red
            }
            elseif ($i -lt 30)
            {
                Write-Host "#" -NoNewline -ForegroundColor Green
            }
            elseif ($i -lt 60)
            {
                Write-Host "#" -NoNewline -ForegroundColor Yellow
            }
            elseif ($i -lt 120)
            {
                Write-Host "#" -NoNewline -ForegroundColor Yellow
            }
            elseif ($i -lt 1000)
            {
                Write-Host "#" -NoNewline -ForegroundColor Red
            }
            elseif ($i -lt 2000)
            {
                Write-Host "##" -NoNewline -ForegroundColor Red
            }
            elseif ($i -lt 3000)
            {
                Write-Host "###" -NoNewline -ForegroundColor Red
            }
            else
            {
                Write-Host "####" -NoNewline -ForegroundColor Yellow
            }
        }
        Write-Host ""
    }
    Write-Host "`n"


    $summary = @(
        "Requests   : "
        "Responses  : "
        "Lost       : "
        "Loss       : "
        "Min        : "
        "Max        : "
    )

    foreach ($i in $all_results)
    {
        $summary[0] += $i["req"].ToString().PadRight(6)
        $summary[1] += $i["res"].ToString().PadRight(6)
        $summary[2] += $i["lost"].ToString().PadRight(6)
        $summary[3] += ($i["loss"].ToString() + "% ").PadRight(6)
        $summary[4] += ($i["min"].ToString() + "ms ").PadRight(6)
        $summary[5] += ($i["max"].ToString() + "ms ").PadRight(6)
        if ($all_results[-1] -ne $i)
        {
            $summary[0] += " : "
            $summary[1] += " : "
            $summary[2] += " : "
            $summary[3] += " : "
            $summary[4] += " : "
            $summary[5] += " : "
        }
    }
    Write-Host "Ping results for $( $device ):"
    foreach ($i in $summary)
    {
        Write-Host $i
    }
}





# ------------------------------------------------------- #
#                          Main                           #
# ------------------------------------------------------- #
$all_ping_results = @()
$device_to_ping = Read-Host "Enter device to ping (default: $DEFAULT_DEVICE)`n>> "
if ($device_to_ping -eq "")
{
    $device_to_ping = $DEFAULT_DEVICE
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
while ($true)
{
    $all_pings = ping-device $device_to_ping $ping_duration
    $all_ping_results += $all_pings
    Clear-Host
    #    Write-Host $all_ping_results
    Show-Result -all_results $all_ping_results -device $device_to_ping
    $redo = Read-Host "Redo? (y/n)`n>> "
    if ($redo -eq "n")
    {
        $datetime = Get-Date -Format "yyyy.MM.dd_HH-mm-ss"
        $all_ping_results | ConvertTo-Json | Out-File -FilePath "ping_results_$( $datetime ).json" -Encoding UTF8
        break
    }

    Clear-Host
}




