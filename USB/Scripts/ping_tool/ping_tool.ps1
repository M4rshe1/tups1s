# ------------------------------------------------------- #
#                   Settings / Variables                  #
# ------------------------------------------------------- #

# Load the Windows Forms assembly
Add-Type -AssemblyName System.Windows.Forms

$DEFAULT_DEVICE = "google.com"
$DEFAULT_PING_DURATION = "20"
$BASE_API_URL = "https://api.heggli.dev/u/ping_graph"

# ------------------------------------------------------- #
#                        Functions                        #
# ------------------------------------------------------- #

function ping-device($dtp, $pd)
{
    Clear-Host
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
        "avg" = 0
        "device" = $dtp
        "starttime" = Get-Date -Format "yyyy.MM.dd HH:mm:ss"
        "endtime" = ""
        "pingtime" = $pd
        "times" = @()
        "timestamps" = @()
    }

    Write-Host ""
    $i = 0
    $startTimeStamp = Get-Date
    While ($EndTime -gt (Get-Date))
    {

        $nowTime = Get-Date
        $datetimeDifference = $nowTime - $startTimeStamp
        $ping_results["timestamps"] += $datetimeDifference.TotalSeconds

        $ping_result = ping $dtp -n 1
        $lines = $ping_result -split "`r`n"
        $all_results_time = $lines[-1] -Split "Maximum = "
        $ms_result = $all_results_time[-1].split("ms")[0].ToString().trim()
        if ($ms_result -eq "<1")
        {
            $ms_result = 1
        }
        elseif (-not [int]::TryParse($ms_result, [ref]$null))
        {
            $ping_results["times"] += 0
        }
        else
        {
            $ping_results["times"] += [int]$ms_result
        }







        $totalLength = [math]::round(($EndTime - $StartTime).TotalMilliseconds / 1000, 0)
        $completedLength = [math]::round(((Get-Date) - $StartTime).TotalMilliseconds / 1000 / $totalLength * 50, 0)
        $remainingLength = [math]::round(($EndTime - (Get-Date)).TotalMilliseconds / 1000 / $totalLength * 50, 0)

        $rcompletedLength = [math]::round(((Get-Date) - $StartTime).TotalSeconds)
        #        Write-Host $completedLength
        if ($completedLength -gt 50)
        {
            $completedLength = 50
            $remainingLength = 0
        }
        $progressBar = ('#' * ($completedLength)) + ('.' * $remainingLength)

        Write-Host "`r" -NoNewline

        Write-Host $progressBar -NoNewline
        Write-Host "| " -NoNewline
        Write-Host ([math]::Round(($rcompletedLength / $totalLength * 100), 0).ToString().PadLeft(4) + "% /") -NoNewline
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
        [int]$ping_results["req"] += 1
    }
    Write-Host ""

    $ping_results["loss"] = [math]::Round($ping_results["lost"] / $ping_results["req"] * 100)
    $ping_results["min"] = $ping_results["times"] | Where-Object { $_ -ne 0 } | Measure-Object -Minimum | Select-Object -ExpandProperty Minimum
    $ping_results["max"] = $ping_results["times"] | Where-Object { $_ -ne 0 } |  Measure-Object -Maximum | Select-Object -ExpandProperty Maximum
    $ping_results["endtime"] = Get-Date -Format "yyyy.MM.dd HH:mm:ss"
    $ping_results["avg"] = $ping_results["times"] | Where-Object { $_ -ne 0 } | Measure-Object -Average | Select-Object -ExpandProperty Average
    $ping_results["avg"] = [math]::Round($ping_results["avg"])
    return $ping_results
}

# ------------------------------------------------------- #
#                          Load                           #
# ------------------------------------------------------- #

function Show-Resultload($all_results)
{
    # $all_results | ConvertTo-Json | Out-File -FilePath "all_ping_results.json" -Encoding UTF8
    # $all_results[0]["loss"] | Out-String
    Clear-Host
    $longest = $all_results[0]
    foreach ($i in $all_results)
    {
        if ($i.times.Length -gt $longest.times.Length)
        {
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
        foreach ($res in $all_results)
        {
            if ($res.times.Length -le $i)
            {
                Write-Host " ".PadRight(7) -NoNewline
                Write-Host " ".PadRight(8) -NoNewline
                if ($all_results[-1] -ne $res)
                {
                    Write-Host " | " -NoNewline
                }
                continue
            }
            if ($res.times[$i] -eq 0)
            {
                Write-Host "0".PadRight(7) -NoNewline -ForegroundColor Red
                Write-Host ": $( $res.times[$i] )ms".PadRight(8) -NoNewline
            }
            elseif ($res.times[$i] -lt 10)
            {
                Write-Host "#".PadRight(7) -NoNewline -ForegroundColor Green
                Write-Host ": $( $res.times[$i] )ms".PadRight(8) -NoNewline


            }
            elseif ($res.times[$i] -lt 25)
            {
                Write-Host "##".PadRight(7) -NoNewline -ForegroundColor Green
                Write-Host ": $( $res.times[$i] )ms".PadRight(8) -NoNewline
            }
            elseif ($res.times[$i] -lt 40)
            {
                Write-Host "###".PadRight(7) -NoNewline -ForegroundColor Yellow
                Write-Host ": $( $res.times[$i] )ms".PadRight(8) -NoNewline
            }
            elseif ($res.times[$i] -lt 60)
            {
                Write-Host "####".PadRight(7) -NoNewline -ForegroundColor Yellow
                Write-Host ": $( $res.times[$i] )ms".PadRight(8) -NoNewline
            }
            elseif ($res.times[$i] -lt 120)
            {
                Write-Host "#####".PadRight(7) -NoNewline -ForegroundColor Red
                Write-Host ": $( $res.times[$i] )ms".PadRight(8) -NoNewline
            }
            else
            {
                Write-Host "######".PadRight(7) -NoNewline -ForegroundColor Red
                Write-Host ": $( $res.times[$i] )ms".PadRight(8) -NoNewline
            }
            if ($all_results[-1] -ne $res)
            {
                Write-Host " | " -NoNewline
            }
        }
        Write-Host ""
    }

    Write-Host "`nResponse Graph in Real Time:`n(+/- 1000ms = 1 x #)"
    foreach ($res in $all_results)
    {
        foreach ($i in $res.times)
        {
            if ($i -eq 0)
            {
                Write-Host "0000" -NoNewline -ForegroundColor Red
            }
            elseif ($i -lt 25)
            {
                Write-Host "#" -NoNewline -ForegroundColor Green
            }
            elseif ($i -lt 60)
            {
                Write-Host "#" -NoNewline -ForegroundColor Yellow
            }
            elseif ($i -lt 1000)
            {
                Write-Host "#" -NoNewline -ForegroundColor Red
            }
            elseif ($i -gt 1500)
            {
                Write-Host "##" -NoNewline -ForegroundColor Red
            }
            elseif ($i -lt 2500)
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
    Write-Host ""

    Write-Host "Ping results for $( $all_results[0].device ):"
    Write-Host ""
    #    $summary = @(
    #        "  Requests   : "
    #        "  Responses  : "
    #        "  Lost       : "
    #        "  Loss       : "
    #        "  Min        : "
    #        "  Max        : "
    #        "  Avg        : "
    #    )
    #    $overall_summary_lost = @()
    #    $overall_summary_req = @()
    #    $overall_summary_res = @()
    #    $overall_summary_times = @()
    #    $overall_summary_loss = @()
    #
    #    # $all_results | out-string
    #    foreach ($i in $all_results)
    #    {
    #        $summary[0] += $i.req.ToString().PadRight(6)
    #        $summary[1] += $i.res.ToString().PadRight(6)
    #        $summary[2] += $i.lost.ToString().PadRight(6)
    #        $summary[3] += ($i.loss.ToString() + "% ").PadRight(6)
    #        $summary[4] += ($i.min.ToString() + "ms ").PadRight(6)
    #        $summary[5] += ($i.max.ToString() + "ms ").PadRight(6)
    #        $summary[6] += ($i.avg.ToString() + "ms ").PadRight(6)
    #
    #        $overall_summary_req += $i.req
    #        $overall_summary_res += $i.res
    #        $overall_summary_lost += $i.lost
    #        $overall_summary_times += $i.times
    #        $overall_summary_loss += $i.loss
    #
    #        if ($all_results[-1] -ne $i)
    #        {
    #            $summary[0] += " : "
    #            $summary[1] += " : "
    #            $summary[2] += " : "
    #            $summary[3] += " : "
    #            $summary[4] += " : "
    #            $summary[5] += " : "
    #            $summary[6] += " : "
    #        }
    #        else
    #        {
    #            if ($overall_summary_req.count -eq 1)
    #            {
    #                $sum_req = $overall_summary_req[0]
    #            }
    #            else
    #            {
    #                $sum_req = $overall_summary_req | Measure-Object -Sum | Select-Object -ExpandProperty Sum
    #            }
    #
    #            if ($overall_summary_res.count -eq 1)
    #            {
    #                $sum_res = $overall_summary_res[0]
    #            }
    #            else
    #            {
    #                $sum_res = $overall_summary_res | Measure-Object -Sum | Select-Object -ExpandProperty Sum
    #            }
    #
    #            if ($overall_summary_lost.count -eq 1)
    #            {
    #                $sum_lost = $overall_summary_lost[0]
    #            }
    #            else
    #            {
    #                $sum_lost = $overall_summary_lost | Measure-Object -Sum | Select-Object -ExpandProperty Sum
    #            }
    #            if ($overall_summary_loss.count -eq 0)
    #            {
    #                $overall_summary_loss = 0
    #            }
    #            else
    #            {
    #                $overall_summary_loss = $overall_summary_loss | Measure-Object -Average | Select-Object -ExpandProperty Average
    #            }
    #
    #
    #            $loss = $sum_lost / $sum_req * 100
    #            $summary[0] += "  | AVG : $([math]::Round($sum_req / $overall_summary_req.count, 1) )".PadRight(15) + "  | SUM : $( $sum_req )"
    #            $summary[1] += "  | AVG : $([math]::Round($sum_res / $overall_summary_res.count, 1) )".PadRight(15) + "  | SUM : $( $sum_res )"
    #            $summary[2] += "  | AVG : $([math]::Round($sum_lost / $overall_summary_lost.count, 1) )".PadRight(15) + "  | SUM : $( $sum_lost )"
    #            $summary[3] += "  | AVG : $([math]::Round($sum_lost / $overall_summary_loss.count, 1) )%".PadRight(15) + "  | SUM : $([math]::Round($loss, 1).ToString() )%"
    #            $summary[4] += "  | MIN : $( $overall_summary_times | Where-Object { $_ -ne 0 } | Measure-Object -Minimum | Select-Object -ExpandProperty Minimum )ms"
    #            $summary[5] += "  | MAX : $( $overall_summary_times | Where-Object { $_ -ne 0 } | Measure-Object -Maximum | Select-Object -ExpandProperty Maximum )ms"
    #            $avg = $overall_summary_times | Where-Object { $_ -ne 0 } | Measure-Object -Average | Select-Object -ExpandProperty Average
    #            $avg = [math]::Round($avg)
    #            $summary[6] += "  | AVG : $( $avg )ms"
    #        }
    #    }
    Write-Host "                Requests  : Respones  : Lost  : Loss  : Min     : Max     : Avg     : Start     : End        "
    Write-Host "------------------------------------------------------------------------------------------------------------"
    $count = 0
    $table = @{
        "req" = @()
        "res" = @()
        "lost" = @()
        "loss" = @()
        "min" = @()
        "max" = @()
        "avg" = @()
        "times" = @()
    }
    $table_sum = @{
        "req" = 0
        "res" = 0
        "lost" = 0
        "loss" = 0
        "lossloss" = 0
        "min" = 0
        "minmin" = 0
        "max" = 0
        "maxmax" = 0
        "avg" = 0
    }
    foreach ($i in $all_results)
    {
        if ($count % 2 -eq 0)
        {
            Write-Host "  Session $($count.ToString().PadRight(3) ) : $($i.req.ToString().PadRight(6) )    : $($i.res.ToString().PadRight(6) )    : $($i.lost.ToString().PadRight(6) ): $(($i.loss.ToString() + "%").PadRight(6) ): $(($i.min.ToString() + "ms").PadRight(8) ): $(($i.max.ToString() + "ms").PadRight(8) ): $(($i.avg.ToString() + "ms").PadRight(8) ): $($i.starttime.split(" ")[-1].PadRight(10) ): $($i.endtime.split(" ")[-1].PadRight(10) ) "
        }
        else
        {
            Write-Host "  Session $($count.ToString().PadRight(3) ) : $($i.req.ToString().PadRight(6) )    : $($i.res.ToString().PadRight(6) )    : $($i.lost.ToString().PadRight(6) ): $(($i.loss.ToString() + "%").PadRight(6) ): $(($i.min.ToString() + "ms").PadRight(8) ): $(($i.max.ToString() + "ms").PadRight(8) ): $(($i.avg.ToString() + "ms").PadRight(8) ): $($i.starttime.split(" ")[-1].PadRight(10) ): $($i.endtime.split(" ")[-1].PadRight(10) ) " -ForegroundColor DarkGray
        }

        $count += 1
        $table["req"] += $i.req
        $table["res"] += $i.res
        $table["lost"] += $i.lost
        $table["loss"] += $i.loss
        $table["min"] += $i.min
        $table["max"] += $i.max
        $table["avg"] += $i.avg
        $table["times"] += $i.times
    }

    $table_sum["req"] = $table["req"] | Measure-Object -Sum | Select-Object -ExpandProperty Sum
    $table_sum["res"] = $table["res"] | Measure-Object -Sum | Select-Object -ExpandProperty Sum
    $table_sum["lost"] = $table["lost"] | Measure-Object -Sum | Select-Object -ExpandProperty Sum
    $table_sum["loss"] = $table["loss"] | Measure-Object -Average | Select-Object -ExpandProperty Average
    $table_sum["loss"] = $table_sum["loss"] | Measure-Object -Sum | Select-Object -ExpandProperty Sum
    $table_sum["loss"] = [math]::Round($table_sum["loss"])
    $table_sum["lossloss"] = [math]::Round($table_sum["lost"] / $table_sum["req"] * 100)
    $table_sum["min"] = $table["min"] | Measure-Object -Sum | Select-Object -ExpandProperty Sum
    $table_sum["minmin"] = $table["min"] | Measure-Object -Minimum | Select-Object -ExpandProperty Minimum
    $table_sum["max"] = $table["max"] | Measure-Object -Sum | Select-Object -ExpandProperty Sum
    $table_sum["maxmax"] = $table["max"] | Measure-Object -Maximum | Select-Object -ExpandProperty Maximum
    $table_sum["avg"] = $table["avg"] | Measure-Object -Sum | Select-Object -ExpandProperty Sum
    $str = "  AVG        " +
            " : $([math]::Round($table_sum['req'] / $table['req'].Count).ToString() )".PadRight(12) +
            " : $([math]::Round($table_sum['res'] / $table['res'].Count).ToString() )".PadRight(12) +
            " : $([math]::Round($table_sum['lost'] / $table['lost'].Count).ToString() )".PadRight(8) +
            " : $($table_sum['lossloss'] )%".PadRight(8) +
            " : $([math]::Round($table_sum['min'] / $table['min'].Count) )ms".PadRight(10) +
            " : $([math]::Round($table_sum['max'] / $table['max'].Count) )ms".PadRight(10) +
            " : $([math]::Round($table_sum['avg'] / $table['avg'].Count) )ms".PadRight(6)
    Write-Host "------------------------------------------------------------------------------------------------------------"
    Write-Host $str
    Write-Host "  SUM/MIN/MAX : $($table_sum["req"].ToString().PadRight(7) )   : $($table_sum["res"].ToString().PadRight(6) )    : $($table_sum["lost"].ToString().PadRight(6) ): $(($table_sum["loss"].ToString() + "%").PadRight(6) ): $(($table_sum["minmin"].ToString() + "ms").PadRight(6) )  : $(($table_sum["maxmax"].ToString() + "ms").PadRight(6) )  : "
    Write-Host "------------------------------------------------------------------------------------------------------------"
    Write-Host ""

    foreach ($i in $summary)
    {
        Write-Host $i
    }
    $datetime1 = [datetime]::ParseExact($all_results[0].starttime, "yyyy.MM.dd HH:mm:ss", $null)
    $datetime2 = [datetime]::ParseExact($all_results[-1].endtime, "yyyy.MM.dd HH:mm:ss", $null)

    $datetimeDifference = $datetime2 - $datetime1
    if ($datetimeDifference -is [System.TimeSpan])
    {
        $days = $datetimeDifference.Days
        $hours = $datetimeDifference.Hours
        $minutes = $datetimeDifference.Minutes
        $seconds = $datetimeDifference.Seconds

        $resultDatetimeString = "{0:D2}.{1:D2}:{2:D2}:{3:D2}" -f $days, $hours, $minutes, $seconds
    }
    else
    {
        Write-Host "Die Variable `$datetimeDifference enthält keine gültige TimeSpan."
    }
    Write-Host "  Start Time : $( $all_results[0].starttime )"
    Write-Host "  End Time   : $( $all_results[-1].endtime )"
    Write-Host "  Time       : $( $resultDatetimeString )"
    Write-Host "  Device     : $( $all_results[0].device )"
    Write-Host "  Ping Time  : $( $all_results[0].pingtime ) seconds"
    Write-Host ""
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


function Select-Files()
{
    # Create a File Open dialog box
    $openFileDialog = New-Object System.Windows.Forms.OpenFileDialog
    $openFileDialog.Filter = "Json files (*.json)|*.json|All files (*.*)|*.*"

    # Set the default folder to the user's Downloads folder
    $downloadsFolder = [System.Environment]::GetFolderPath('MyDocuments') + '\Downloads'
    $openFileDialog.InitialDirectory = $downloadsFolder

    # Allow the user to select multiple files
    $openFileDialog.Multiselect = $true

    # Show the dialog and check if the user selects a file
    $result = $openFileDialog.ShowDialog()

    # Check if the user clicked the OK button in the dialog
    if ($result -eq [System.Windows.Forms.DialogResult]::OK)
    {
        # Get the selected file paths
        $selectedFiles = $openFileDialog.FileNames
        # Now you can do something with the selected file paths, e.g., open them
        # For example, let's just display the selected file paths
        Write-Host "Selected Files:"
        foreach ($file in $selectedFiles)
        {
            Write-Host $file
        }
        return $selectedFiles
    }
    else
    {
        Write-Host "No file selected."
    }
}

function Show-Merge($files)
{
    # reverse array
    $files = $files | Sort-Object -Descending

    foreach ($file in $files)
    {
        # convert to json
        $file_data = Get-Content -Path $file -Raw | ConvertFrom-Json
        # add to array
        $all_ping_results += $file_data
    }
    Show-Resultload -all_results $all_ping_results
    $datetime = Get-Date -Format "yyyy.MM.dd_HH-mm-ss"
    $all_ping_results | ConvertTo-Json | Out-File -FilePath "ping_merged_results_$( $datetime ).json" -Encoding UTF8
    Write-Host "Merged as:"
    Write-Host "ping_merged_results_$( $datetime ).json"
}

function Show-Split($file, $oldFilename)
{
    Write-Host $oldFilename
    $j = 0
    $f = @()

    $logedin_user = whoami
    $logedin_user = $logedin_user.split("\")[1]
    $downloadFolder = "C:\Users\$( $logedin_user )\Downloads\$( $oldFilename )"

    Write-Host "Splitted files:"
    foreach ($i in $file)
    {
        $f += $i
        $name = "split_ping_results_$($i.starttime.replace(":", " ").replace(' ', '_') ).json"
        $filename = Join-Path $downloadFolder $name
        # validat the path
        if (-not(Test-Path $filename))
        {
            New-Item -Path $filename -ItemType File -Force | Out-Null
        }
        Write-Host $filename
        #    $f | Out-String
        $f | ConvertTo-Json | Out-File -FilePath $filename -Encoding UTF8
        $j += 1
        $f = @()
        $jsonContent = Get-Content -Path $filename | Out-String
        $modifiedContent = "[" + $jsonContent + "]"
        $modifiedContent | Set-Content -Path $filename
    }
}



# ------------------------------------------------------- #
#                          Main                           #
# ------------------------------------------------------- #
$logedin_user = whoami
$logedin_user = $logedin_user.split("\")[1]
Set-Location -Path "C:\Users\$( $logedin_user )\Downloads"
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
Write-Host "  p - ping device"
Write-Host "  l - load ping results from file"
Write-Host "  c - continue to ping"
Write-Host "  g - generate graph"
Write-Host "  m - merge ping results"
Write-Host "  s - split results"
$load_file = Read-Host ">> "
$all_ping_results = @()
if ($load_file -eq "l")
{
    $file, $old_file_name = Select-File
    $all_ping_results += $file
    Clear-Host
    Show-Resultload -all_results $all_ping_results
    Read-Host "Press enter to exit"
}
elseif ($load_file -eq "g")
{
    Start-Process "$( $BASE_API_URL )"
}
elseif ($load_file -eq "c")
{
    $file, $old_file_name = Select-File
    Clear-Host
    $all_ping_results += $file
    Read-Host "Press enter to continue"
    while ($true)
    {
        $all_pings = ping-device $all_ping_results[0].device $all_ping_results[0].pingtime
        $all_ping_results += $all_pings
        Clear-Host
        #    Write-Host $all_ping_results
        Show-Resultload -all_results $all_ping_results
        $redo = Read-Host "Defaul: [y] for redo, [n] for save and exit`n>> "
        if ($redo -eq "n")
        {
            $datetime = Get-Date -Format "yyyy.MM.dd_HH-mm-ss"
            Write-Host "Saved as:"
            Write-Host "ping_results_$( $datetime ).json"
            $name = "ping_results_$( $datetime ).json"
            $all_ping_results | ConvertTo-Json | Out-File -FilePath $name -Encoding UTF8
            if ($all_ping_results.count -eq 1)
            {
                $jsonContent = Get-Content -Path $name | Out-String
                $modifiedContent = "[" + $jsonContent + "]"
                $modifiedContent | Set-Content -Path $name
            }
            break
        }
        Clear-Host
    }
}
elseif (($load_file -eq "p") -or ($load_file -eq ""))
{

    $device_to_ping = Read-Host "Enter device to ping (default: $DEFAULT_DEVICE)`n>> "
    if ($device_to_ping -eq "")
    {
        $device_to_ping = $DEFAULT_DEVICE
    }
    $ping_duration = Read-Host "Enter ping duration X, Xs or Xm (default: $DEFAULT_PING_DURATION)`n>> "
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
        Show-Resultload -all_results $all_ping_results
        $redo = Read-Host "Defaul: [y] for redo, [n] for save and exit`n>> "
        if ($redo -eq "n")
        {
            $datetime = Get-Date -Format "yyyy.MM.dd_HH-mm-ss"
            $name = "ping_results_$( $datetime ).json"
            $all_ping_results | ConvertTo-Json | Out-File -FilePath $name -Encoding UTF8
            if ($all_ping_results.count -eq 1)
            {
                $jsonContent = Get-Content -Path $name | Out-String
                $modifiedContent = "[" + $jsonContent + "]"
                $modifiedContent | Set-Content -Path $name
            }
            break
        }

        Clear-Host
    }
}
elseif ($load_file -eq "m")
{
    Write-Host "Select files to merge"
    Write-Host "*************************************"
    Write-Host "* The sequence of the files matters *"
    Write-Host "*************************************"
    $files = Select-Files
    Show-Merge -files $files
}
elseif ($load_file -eq "s")
{
    $file, $old_file_name = Select-File
    Show-Split -file $file -oldFilename $old_file_name
}

