
Clear-Host
Write-Host "##########################################################"
Write-Host "#                                                       #"
Write-Host "#       Do you realy want to Reset the settings.        #"
Write-Host "#       The settings can't be recovered.                #"
Write-Host "#                                                       #"
Write-Host "#########################################################"
$DeleteSettings = Read-Host "Delete [YES], Default: Cancle [N]"
if ($DeleteSettings -eq "yes") {
    Copy-Item ".\USB\Scripts\!config\Default.json" -Destination ".\USB\Scripts\!config\config.json"
    Read-Host "Reseted Sucsessfully. Press ENTER to continue"
}
