


try {
    # Attempt to import the module
    $module = Get-Module -Name ps2exe -ListAvailable -ErrorAction Stop

    if ($module -eq $null) {
        # If the module is not available, install it
        Install-Module -Name ps2exe -Force -Scope CurrentUser
    }

    # Import the module
    Import-Module -Name ps2exe -Force
}
catch {
    # Handle the exception
    Write-Host "Error: $_"
}

Add-Type -AssemblyName System.Windows.Forms

# Create a File Open dialog box
$openFileDialog = New-Object System.Windows.Forms.OpenFileDialog
$openFileDialog.Filter = "Powershell files (*.ps1)|*.ps1|All files (*.*)|*.*"

# get the path of this file
$downloadsFolder = Split-Path $MyInvocation.MyCommand.Path
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
    # convert to exe with ps2exe
    Write-host "What type of script is this?"
    Write-host "    GUI       [1]"
    Write-host "    Console   [2]"
    $condoleOrGui = Read-Host ">> "

    Write-Host "Converting to exe..."
    if ($condoleOrGui -eq "1") {
        Invoke-PS2EXE -InputFile $selectedFile -OutputFile $selectedFile.exe -STA -NoConsole | Out-Null
    }
    else {
        Invoke-PS2EXE -InputFile $selectedFile -OutputFile $selectedFile.exe -STA | Out-Null
    }
    Write-Host "Done."
    # get the parent folder of the selected file
    $parentFolder = Split-Path $selectedFile
    # open the parent folder in Windows Explorer
    explorer $parentFolder
    # exit the script
    Read-Host "Press Enter to exit..."
    exit
}
else {
    Write-Host "No file selected."
    Read-Host "Press Enter to exit..."
    exit
}