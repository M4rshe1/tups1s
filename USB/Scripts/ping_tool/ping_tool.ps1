# ------------------------------------------------------- #
#                   Settings / Variables                  #
# ------------------------------------------------------- #

# Load the Windows Forms assembly
Add-Type -AssemblyName System.Windows.Forms

$DEFAULT_DEVICE = "google.com"
$DEFAULT_PING_DURATION = "20"

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
        "median" = 0
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
    $ping_results["median"] = Get-Median $ping_results["times"]
    return $ping_results
}

# ------------------------------------------------------- #
#                       Median                            #
# ------------------------------------------------------- #

function Get-Median($data)
{
    $data = $data | Where-Object { $_ -ne 0 }  | Sort-Object -Descending
    if ($data.count -eq 0)
    {
        return 0
    }

    if ($data.count -eq 1)
    {
        return $data[0]
    }

    if ($data.count%2)
    {
        #odd
        $medianvalue = $data[[math]::Floor($data.count/2)]
    }
    else
    {
        #even
        $medianValue = ($data[$data.Count/2], $data[$data.count/2 - 1] |Measure-Object -Average).average
    }
    return $medianValue
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
    Write-Host "Ping results for $( $all_results[0].device ):"

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

    Write-Host ""
    Write-Host ""
    Write-Host "  Session     : Requests  : Respones  : Lost  : Loss  : Min     : Max     : Avg     : Median  : Start     : End       "
    Write-Host "----------------------------------------------------------------------------------------------------------------------"
    $count = 0
    $table = @{
        "req" = @()
        "res" = @()
        "lost" = @()
        "loss" = @()
        "min" = @()
        "max" = @()
        "avg" = @()
        "median" = @()
        "times" = @()
    }
    $table_sum = @{
        "req" = 0
        "minreq" = 0
        "maxreq" = 0
        "res" = 0
        "minres" = 0
        "maxres" = 0
        "lost" = 0
        "minlost" = 0
        "maxlost" = 0
        "loss" = 0
        "minloss" = 0
        "maxloss" = 0
        "sumloss" = 0
        "min" = 0
        "summin" = 0
        "minmin" = 0
        "maxmin" = 0
        "max" = 0
        "summax" = 0
        "maxmax" = 0
        "minmax" = 0
        "avg" = 0
        "sumavg" = 0
        "minavg" = 0
        "maxavg" = 0
        "summedian" = 0
        "minmedian" = 0
        "maxmedian" = 0
    }
    foreach ($i in $all_results)
    {
        if ($count % 2 -eq 0)
        {
            Write-Host "  Session $($count.ToString().PadRight(3) ) : $($i.req.ToString().PadRight(6) )    : $($i.res.ToString().PadRight(6) )    : $($i.lost.ToString().PadRight(6) ): $(($i.loss.ToString() + "%").PadRight(6) ): $(($i.min.ToString() + "ms").PadRight(8) ): $(($i.max.ToString() + "ms").PadRight(8) ): $(($i.avg.ToString() + "ms").PadRight(8) ): $(($i.median.ToString() + "ms").PadRight(8) ): $($i.starttime.split(" ")[-1].PadRight(10) ): $($i.endtime.split(" ")[-1].PadRight(10) ) "
        }
        else
        {
            Write-Host "  Session $($count.ToString().PadRight(3) ) : $($i.req.ToString().PadRight(6) )    : $($i.res.ToString().PadRight(6) )    : $($i.lost.ToString().PadRight(6) ): $(($i.loss.ToString() + "%").PadRight(6) ): $(($i.min.ToString() + "ms").PadRight(8) ): $(($i.max.ToString() + "ms").PadRight(8) ): $(($i.avg.ToString() + "ms").PadRight(8) ): $(($i.median.ToString() + "ms").PadRight(8) ): $($i.starttime.split(" ")[-1].PadRight(10) ): $($i.endtime.split(" ")[-1].PadRight(10) ) " -ForegroundColor DarkGray
        }

        $count += 1
        $table["req"] += $i.req
        $table["res"] += $i.res
        $table["lost"] += $i.lost
        $table["loss"] += $i.loss
        $table["min"] += $i.min
        $table["max"] += $i.max
        $table["avg"] += $i.avg
        $table["median"] += $i.median
        $table["times"] += $i.times
    }

    $table_sum["req"] = $table["req"] | Measure-Object -Sum | Select-Object -ExpandProperty Sum
    $table_sum["minreq"] = $table["req"] | Measure-Object -Minimum | Select-Object -ExpandProperty Minimum
    $table_sum["maxreq"] = $table["req"] | Measure-Object -Maximum | Select-Object -ExpandProperty Maximum
    $table_sum["res"] = $table["res"] | Measure-Object -Sum | Select-Object -ExpandProperty Sum
    $table_sum["minres"] = $table["res"] | Measure-Object -Minimum | Select-Object -ExpandProperty Minimum
    $table_sum["maxres"] = $table["res"] | Measure-Object -Maximum | Select-Object -ExpandProperty Maximum
    $table_sum["lost"] = $table["lost"] | Measure-Object -Sum | Select-Object -ExpandProperty Sum
    $table_sum["minlost"] = $table["lost"] | Measure-Object -Minimum | Select-Object -ExpandProperty Minimum
    $table_sum["maxlost"] = $table["lost"] | Measure-Object -Maximum | Select-Object -ExpandProperty Maximum
    $table_sum["loss"] = $table["loss"] | Measure-Object -Average | Select-Object -ExpandProperty Average
    $table_sum["loss"] = $table_sum["loss"] | Measure-Object -Sum | Select-Object -ExpandProperty Sum
    $table_sum["loss"] = [math]::Round($table_sum["loss"])
    $table_sum["minloss"] = $table["loss"] | Measure-Object -Minimum | Select-Object -ExpandProperty Minimum
    $table_sum["maxloss"] = $table["loss"] | Measure-Object -Maximum | Select-Object -ExpandProperty Maximum
    $table_sum["sumloss"] = [math]::Round($table_sum["lost"] / $table_sum["req"] * 100)
    $table_sum["min"] = $table["min"] | Measure-Object -Sum | Select-Object -ExpandProperty Sum
    $table_sum["summin"] = $table["min"] | Measure-Object -Sum | Select-Object -ExpandProperty Sum
    $table_sum["minmin"] = $table["min"] | Measure-Object -Minimum | Select-Object -ExpandProperty Minimum
    $table_sum["maxmin"] = $table["min"] | Measure-Object -Maximum | Select-Object -ExpandProperty Maximum
    $table_sum["max"] = $table["max"] | Measure-Object -Sum | Select-Object -ExpandProperty Sum
    $table_sum["summax"] = $table["max"] | Measure-Object -Sum | Select-Object -ExpandProperty Sum
    $table_sum["maxmax"] = $table["max"] | Measure-Object -Maximum | Select-Object -ExpandProperty Maximum
    $table_sum["minmax"] = $table["max"] | Measure-Object -Minimum | Select-Object -ExpandProperty Minimum
    $table_sum["avg"] = $table["avg"]  | Where-Object { $_ -ne 0 } | Measure-Object -Sum | Select-Object -ExpandProperty Sum
    $table_sum["sumavg"] = $table["avg"] | Where-Object { $_ -ne 0 }  | Measure-Object -Sum | Select-Object -ExpandProperty Sum
    $table_sum["minavg"] = $table["avg"] | Where-Object { $_ -ne 0 } | Measure-Object -Minimum | Select-Object -ExpandProperty Minimum
    $table_sum["maxavg"] = $table["avg"] | Where-Object { $_ -ne 0 } | Measure-Object -Maximum | Select-Object -ExpandProperty Maximum
    $table_sum["medavg"] = $table["avg"] | Where-Object { $_ -ne 0 } | Measure-Object -Average | Select-Object -ExpandProperty Average
    $table_sum["summedian"] = $table["median"] | Where-Object { $_ -ne 0 } | Measure-Object -Sum | Select-Object -ExpandProperty Sum
    $table_sum["minmedian"] = $table["median"] | Where-Object { $_ -ne 0 } | Measure-Object -Minimum | Select-Object -ExpandProperty Minimum
    $table_sum["maxmedian"] = $table["median"] | Where-Object { $_ -ne 0 } | Measure-Object -Maximum | Select-Object -ExpandProperty Maximum
    $strAVG = "  AVG        " +
            " : $([math]::Round($table_sum['req'] / $table['req'].Count).ToString() )".PadRight(12) +
            " : $([math]::Round($table_sum['res'] / $table['res'].Count).ToString() )".PadRight(12) +
            " : $([math]::Round($table_sum['lost'] / $table['lost'].Count).ToString() )".PadRight(8) +
            " : $( $table_sum['sumloss'] )%".PadRight(8) +
            " : $([math]::Round($table_sum['min'] / $table['min'].Count) )ms".PadRight(10) +
            " : $([math]::Round($table_sum['max'] / $table['max'].Count) )ms".PadRight(10) +
            " : $([math]::Round($table_sum['avg'] / $table['avg'].Count) )ms".PadRight(10) +
            " : $([math]::Round($table_sum['medavg']) )ms".PadRight(6)
    $strMED = "  MED        " +
            " : $( Get-Median $table['req'] )".PadRight(12) +
            " : $( Get-Median $table['res'] )".PadRight(12) +
            " : $( Get-Median $table['lost'] )".PadRight(8) +
            " : $( Get-Median $table['loss'] )%".PadRight(8) +
            " : $( Get-Median $table['min'] )ms".PadRight(10) +
            " : $( Get-Median $table['max'] )ms".PadRight(10) +
            " : $( Get-Median $table['avg'] )ms".PadRight(10) +
            " : $( Get-Median $table['median'] )ms".PadRight(6)
    $strSUM = "  SUM        " +
            " : $($table_sum['req'].ToString().PadRight(9) )" +
            " : $($table_sum['res'].ToString().PadRight(9) )" +
            " : $($table_sum['lost'].ToString().PadRight(5) )" +
            " : $(($table_sum['loss'].ToString() + '%').PadRight(5) )" +
            " : $(($table_sum['min'].ToString() + 'ms').PadRight(7) )" +
            " : $(($table_sum['max'].ToString() + 'ms').PadRight(7) )" +
            " : $(($table_sum['avg'].ToString() + 'ms').PadRight(7) )" +
            " : $(($table_sum['summedian'].ToString() + 'ms').PadRight(6) )"
    $strMIN = "  MIN        " +
            " : $($table_sum['minreq'].ToString().PadRight(9) )" +
            " : $($table_sum['minres'].ToString().PadRight(9) )" +
            " : $($table_sum['minlost'].ToString().PadRight(5) )" +
            " : $(($table_sum['minloss'].ToString() + '%').PadRight(5) )" +
            " : $(($table_sum['minmin'].ToString() + 'ms').PadRight(7) )" +
            " : $(($table_sum['minmax'].ToString() + 'ms').PadRight(7) )" +
            " : $(($table_sum['minavg'].ToString() + 'ms').PadRight(7) )" +
            " : $(($table_sum['minmedian'].ToString() + 'ms').PadRight(6) )"
    $strMAX = "  MAX        " +
            " : $($table_sum['maxreq'].ToString().PadRight(9) )" +
            " : $($table_sum['maxres'].ToString().PadRight(9) )" +
            " : $($table_sum['maxlost'].ToString().PadRight(5) )" +
            " : $(($table_sum['maxloss'].ToString() + '%').PadRight(5) )" +
            " : $(($table_sum['maxmin'].ToString() + 'ms').PadRight(7) )" +
            " : $(($table_sum['maxmax'].ToString() + 'ms').PadRight(7) )" +
            " : $(($table_sum['maxavg'].ToString() + 'ms').PadRight(7) )" +
            " : $(($table_sum['maxmedian'].ToString() + 'ms').PadRight(6) )"


    Write-Host "----------------------------------------------------------------------------------------------------------------------"
    Write-Host $strAVG
    Write-Host $strMED -ForegroundColor DarkGray
    Write-Host $strMIN
    Write-Host $strMAX -ForegroundColor DarkGray
    Write-Host $strSUM
    Write-Host "----------------------------------------------------------------------------------------------------------------------"
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
        Write-Host "The Variable `$datetimeDifference does not contain a valid TimeSpan."
    }
    Write-Host "  Start Time : $( $all_results[0].starttime )"
    Write-Host "  End Time   : $( $all_results[-1].endtime )"
    Write-Host "  Time       : $( $resultDatetimeString )"
    Write-Host "  Device     : $( $all_results[0].device )"
    Write-Host "  Ping Time  : $( $all_results[0].pingtime ) seconds"
    Write-Host ""
}

# ------------------------------------------------------- #
#                    Load from File                       #
# ------------------------------------------------------- #

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

# ------------------------------------------------------- #
#                  Select Files to Merge                  #
# ------------------------------------------------------- #

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

# ------------------------------------------------------- #
#                         Merge                           #
# ------------------------------------------------------- #

function Show-Merge($files)
{
    $ping_data = @()
    $files = $files | Sort-Object -Descending
    foreach ($file in $files)
    {
        $file_data = Get-Content -Path $file -Raw | ConvertFrom-Json
        $ping_data += $file_data
    }
    return $ping_data
}

# ------------------------------------------------------- #
#                         Split                           #
# ------------------------------------------------------- #

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

function Get-TimeInSeconds ($Time) {
    if ($Time -eq "")
    {
        $Time = $DEFAULT_PING_DURATION
    }
    elseif ($Time -match "^\d+s$")
    {
        $Time = $Time -replace "s", ""
        $Time = [int]$Time
    }
    elseif ($Time -match "^\d+m$")
    {
        $Time = $Time -replace "m", ""
        $Time = [int]$Time * 60
    }
    elseif ([int]::TryParse($Time, [ref]$null))
    {
        $Time = [int]$Time
    }
    else
    {
        Read-Host "Invalid ping duration: $Time, exiting..."
        exit
    }
    return $Time
}


# ------------------------------------------------------- #
#                          Main                           #
# ------------------------------------------------------- #
$logedin_user = whoami
$logedin_user = $logedin_user.split("\")[1]
Set-Location -Path "C:\Users\$( $logedin_user )\Downloads"
Clear-Host
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
* Copyright of Colin Heggli $((Get-Date).Year))                             *
* https://colin.heggli.dev                                     *
* https://github.com/M4rshe1                                   *
****************************************************************

"""

function main()
{
    $options = @("Ping Device", "Load Ping Results from File", "Continue to Ping", "Merge Ping Results", "Split Results")
    $selection = Create-Menu -MenuTitle $banner -MenuOptions $options
    $selection = $options[$selection]
    $all_ping_results = @()
    if ($selection -eq "Load Ping Results from File")
    {
        $file, $old_file_name = Select-File
        $all_ping_results += $file
        Clear-Host
        Show-Resultload -all_results $all_ping_results
        Read-Host "Press enter to exit"
    }
    elseif ($selection -eq "Continue to Ping")
    {
        clear-host
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
            $redo = Read-Host "Default: [y] for redo, [n] for save and exit`n>> "
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
    elseif ($selection -eq "Ping Device")
    {

        clear-host
        $device_to_ping = Read-Host "Enter device to ping (default: $DEFAULT_DEVICE)`n>> "
        if ($device_to_ping -eq "")
        {
            $device_to_ping = $DEFAULT_DEVICE
        }
        $ping_duration = Read-Host "Enter ping duration X, Xs or Xm (default: $DEFAULT_PING_DURATION)`n>> "
        $ping_duration = Get-TimeInSeconds -Time $ping_duration

        Clear-Host
        while ($true)
        {
            $all_pings = ping-device $device_to_ping $ping_duration
            $all_ping_results += $all_pings
            Clear-Host
            #    Write-Host $all_ping_results
            $datetime = Get-Date -Format "yyyy.MM.dd_HH-mm-ss"
            $name = "ping_results_$( $datetime ).json"
            Show-Resultload -all_results $all_ping_results
            $all_ping_results | ConvertTo-Json | Out-File -FilePath "temp_$( $name )" -Encoding UTF8
            $redo = Read-Host "Defaul: [y] for redo, [n] for save and exit`n>> "
            if ($redo -eq "n")
            {

                Write-Host "Saved as:"
                Write-Host "$( $name ) in \Users\$( $logedin_user )\Downloads"
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
    elseif ($selection -eq "Merge Ping Results")
    {
        Write-Host "Select files to merge"
        Write-Host "*************************************"
        Write-Host "* The sequence of the files matters *"
        Write-Host "*************************************"
        $files = Select-Files
        $all_ping_results = Show-Merge -files $files
        show-resultload -all_results $all_ping_results
        $datetime = Get-Date -Format "yyyy.MM.dd_HH-mm-ss"
        $name = "merged_ping_results_$( $datetime ).json"
        Write-Host "Saved as:"
        Write-Host "$( $name ) in \Users\$( $logedin_user )\Downloads"
        $all_ping_results | ConvertTo-Json | Out-File -FilePath $name -Encoding UTF8
    }
    elseif ($selection -eq "Split Results")
    {
        $file, $old_file_name = Select-File
        Show-Split -file $file -oldFilename $old_file_name
    }
}

main


