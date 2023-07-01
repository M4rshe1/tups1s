$FilePath = ".\USB\Scripts\!files\NetMapper\NetMapper.bat"

Remove-Item -Path $FilePath -ErrorAction SilentlyContinue
New-Item -ItemType "directory" -Path ".\USB\Scripts\!files\NetMapper" -ErrorAction SilentlyContinue | Out-Null
New-Item -ItemType "file" -Path ".\USB\Scripts\!files\NetMapper" -name "NetMapper.bat" -ErrorAction SilentlyContinue | Out-Null

$deleteDrives = Read-Host "Delete all Net Drives before Mapping New Drives. Default [Y], No [N]"
Clear-Host
if ($deleteDrives -ne "n") {
    "net use * /delete /yes" | Out-File -FilePath $FilePath -Append -Encoding ASCII -Width 50
}
Write-Host "quit [q], Delete lowest entry [d]"
do {
    $SharePath = Read-Host "<Letter>: \\<ComputerName>\<ShareName>"
    if ($SharePath.length -gt 0) {
        if ($SharePath -eq "q") {
            break
        }
        elseif ($SharePath -eq "d") {
            $FileContent = Get-Content -Path $FilePath
            for ($i = 0; $i -lt ($FileContent.length - 1); $i++) {
                $FileContent[$i] | Out-File -FilePath $FilePath -Append -Encoding ASCII -Width 50
            }
        }
        else {
            "net use $SharePath" | Out-File -FilePath $FilePath -Append -Encoding ASCII -Width 50
        }
    }
} while ($true) {
    
}
ii ".\USB\Scripts\!files\NetMapper"