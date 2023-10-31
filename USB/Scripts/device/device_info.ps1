# Display User Information
Write-Host "USER:"
Write-Host "  Username          : $(whoami)"
Write-Host "  Domain            : $env:USERDOMAIN"

# Display Computer Information
Write-Host "COMPUTER:"
$os = Get-WmiObject -Class Win32_OperatingSystem
Write-Host "  Operating System  : $($os.Caption) $($os.Version)"
$uptime = (Get-WmiObject -Class Win32_OperatingSystem).LastBootUpTime
$uptime = (Get-Date) - [System.Management.ManagementDateTimeConverter]::ToDateTime($uptime)
Write-Host "  Uptime            : $($uptime.Days) days, $($uptime.Hours) hours, $($uptime.Minutes) minutes"
Write-Host "  Hostname          : $(hostname)"
$model = (Get-WmiObject -Class "Win32_ComputerSystem").Model
Write-Host "  Model             : $model"

# Display GPU Information
$graphics = Get-WmiObject -Class "Win32_VideoController"
if ($graphics) {
    $graphicsName = $graphics.Name
    $graphicsDriver = $graphics.DriverVersion
    Write-Host "  GPU               : $graphicsName"
    Write-Host "    Driver          : $graphicsDriver"
} else {
    Write-Host "  GPU               : Information not available"
}

# Display CPU Information
$cpu = Get-WmiObject -Class "Win32_Processor"
if ($cpu) {
    $cpuName = $cpu.Name
    $cpuCores = $cpu.NumberOfCores
    $cpuThreads = $cpu.NumberOfLogicalProcessors
    Write-Host "  CPU               : $cpuName"
    Write-Host "    CPU Cores       : $cpuCores"
    Write-Host "    CPU Threads     : $cpuThreads"
} else {
    Write-Host "  CPU               : Information not available"
}
$memory = Get-WmiObject -Class "Win32_PhysicalMemory"
$totalMemoryGB = [math]::Round(($memory | Measure-Object -Property Capacity -Sum).Sum / 1GB, 3)
Write-Host "  Total Memory      : $totalMemoryGB GB"

# Display BIOS Serial Number
Write-Host "  Serial Number     : $(Get-WmiObject -Class "Win32_BIOS").SerialNumber"

# Display Network Adapters Information
$networkAdapters = Get-NetAdapter | Where-Object { $_.Status -eq "Up" }
$ipAddresses = Get-NetIPAddress | Where-Object { $_.AddressFamily -eq "IPv4" }

$macTitleDisplayed = $false
$ipTitleDisplayed = $false
Write-Host "NETWORK:"
foreach ($adapter in $networkAdapters) {
    if (-not $macTitleDisplayed) {
        Write-Host "  MAC Address       : $($adapter.MacAddress)"
        $macTitleDisplayed = $true
    } else {
        Write-Host "                      $($adapter.MacAddress)"
    }
}

foreach ($ipAddress in $ipAddresses) {
    if (-not $ipTitleDisplayed) {
        Write-Host "  IP Address        : $($ipAddress.IPAddress)"
        $ipTitleDisplayed = $true
    } else {
        Write-Host "                      $($ipAddress.IPAddress)"
    }
}

# Display Disk Drives Information
Write-Host "DRIVES:"
$drives = Get-PSDrive -PSProvider FileSystem

foreach ($drive in $drives) {
    $freeSpaceGB = [math]::Round($drive.Free / 1GB, 3)
    $usedSpaceGB = [math]::Round($drive.Used / 1GB, 3)
    $totalSpaceGB = $freeSpaceGB + $usedSpaceGB
    Write-Host "  $($drive.Name):"
    Write-Host "    Free Space  : $freeSpaceGB GB"
    Write-Host "    Used Space  : $usedSpaceGB GB"
    Write-Host "    Total Space : $totalSpaceGB GB"
}

