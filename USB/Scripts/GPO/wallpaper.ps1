Import-Module GroupPolicy

Add-Type -AssemblyName System.Windows.Forms

$folderBrowser = New-Object System.Windows.Forms.FolderBrowserDialog

$dialogResult = $folderBrowser.ShowDialog()

if ($dialogResult -eq 'OK') {
    $selectedFolder = $folderBrowser.SelectedPath
    # Write-Host "Folder selected: $selectedFolder"

    $fileBrowser = New-Object System.Windows.Forms.OpenFileDialog
    $fileBrowser.Filter = "Image Files (*.jpg, *.png)|*.jpg;*.png"
    $fileBrowser.Title = "Select Wallpaper Image"

    $fileDialogResult = $fileBrowser.ShowDialog()

    if ($fileDialogResult -eq 'OK') {
        $selectedFile = $fileBrowser.FileName
        # Write-Host "File selected: $selectedFile"

        $Parameters = @{
            Name = 'wallpaper$'
            Path = $selectedFolder
            # ReadAccess = 'Everyone'
        }
        New-SmbShare @Parameters
        $Extension = (Get-Item -Path $selectedFile).Extension
        $fileName = "wallpaper" + $Extension
        # write-host $filename
        $destinationPath = Join-Path -Path $selectedFolder -ChildPath $fileName

        Copy-Item -Path $selectedFile -Destination $destinationPath
        # Write-Host "File copied to: $destinationPath"
        
        # Create a new GPO
        $gpo = New-GPO -Name "Desktop Wallpaper Policy"
        
        # Configure the settings to prevent changing the desktop wallpaper
        $hostname = hostname
        $gpoSettings = @{
            "NoChangingWallPaper" = 1
            "Wallpaper"           = "\\$hostname\wallaper$\$fileName"
        }
        
        # Set the settings in the GPO
        Set-GPRegistryValue -Name $gpo.DisplayName -Key "HKCU\Software\Microsoft\Windows\CurrentVersion\Policies\ActiveDesktop" -ValueName "NoChangingWallPaper" -Type DWORD -Value $gpoSettings.NoChangingWallPaper
        
        Set-GPRegistryValue -Name $gpo.DisplayName -Key "HKCU\Software\Microsoft\Windows\CurrentVersion\Policies\System" -ValueName "Wallpaper" -Type String -Value $gpoSettings.Wallpaper
        
    }
    else {
        Write-Host "File selection canceled."
    }
}
else {
    Write-Host "Folder selection canceled."
}





