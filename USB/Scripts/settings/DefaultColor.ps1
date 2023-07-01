Clear-Host

$ConfigFile = ".\USB\Scripts\!Config\config.json"
$ConfigFileContent = Get-Content -Raw $ConfigFile -ErrorAction SilentlyContinue | ConvertFrom-Json 

function show-chooseColor {

    Write-Host "
        0 = Schwarz         8 = Grau
        1 = Blau            9 = Hellblau
        2 = Gruen           A = Hellgruen
        3 = Tuerkis         B = Helltuerkis
        4 = Rot             C = Hellrot
        5 = Lila            D = Helllila
        6 = Gelb            E = Hellgelb
        7 = Hellgrau        F = Weiss"
    Write-Host
    Write-Host "Format: 00"
    Write-Host
    $DefaultColor = Read-Host Color
    
    if ($DefaultColor.Length -ne 2) {
        Write-Host "Invalid Color Code"
        Read-Host "Press ENTER to continue"

    }
    elseif ($DefaultColor.Length -eq "quit") {
        exit
    }
    else {
        show-SetDefaultColor 
    }
}

function show-SetDefaultColor {
    
    cmd.exe /c "color $DefaultColor"
    
    $ConfigFileContent.settings.color = $DefaultColor
    
    # Save the modified content back to the JSON file with UTF-8 encoding
    $ConfigFileContent | ConvertTo-Json -Depth 10 | Out-File -Encoding UTF8 -FilePath $ConfigFile -Force
}
show-chooseColor