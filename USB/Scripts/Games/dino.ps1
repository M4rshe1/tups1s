function Play-ChromeDinoGame {
    $gameOver = $false
    $score = 0
    $dinoPosition = 0
    $obstaclePositions = @()

    Clear-Host
    Write-Host "Welcome to the PowerShell Chrome Dino Game!"
    Write-Host "Press any key to make the dino jump. Avoid the obstacles!"
    Write-Host "Press 'q' to quit."

    while (-not $gameOver) {
        if ($obstaclePositions -contains $dinoPosition) {
            $gameOver = $true
            break
        }

        if ($Host.UI.RawUI.KeyAvailable) {
            $key = $Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown").Character

            switch ($key) {
                'q' {
                    $gameOver = $true
                    break
                }
                default {
                    # Jump logic
                    for ($i = 0; $i -lt 3; $i++) {
                        $dinoPosition++
                        Clear-Host
                        Write-Host "Score: $score"
                        Write-Host (' ' * $dinoPosition) -NoNewline
                        Write-Host "^"
                        Start-Sleep -Milliseconds 50
                    }

                    for ($i = 0; $i -lt 3; $i++) {
                        $dinoPosition--
                        Clear-Host
                        Write-Host "Score: $score"
                        Write-Host (' ' * $dinoPosition) -NoNewline
                        Write-Host "^"
                        Start-Sleep -Milliseconds 50
                    }
                }
            }
        }

        $score++
        $obstaclePositions = $obstaclePositions | Where-Object { $_ -gt 0 }
        if ($score % 10 -eq 0) {
            $obstaclePositions += [Console]::WindowWidth - 1
        }

        foreach ($position in $obstaclePositions) {
            $position--
        }

        Clear-Host
        Write-Host "Score: $score"
        Write-Host (' ' * $dinoPosition) -NoNewline
        Write-Host "^"

        foreach ($position in $obstaclePositions) {
            Write-Host (' ' * $position) -NoNewline
            Write-Host "X"
        }

        Start-Sleep -Milliseconds 100
    }

    Write-Host "Game over. Your final score is $score."
}

Play-ChromeDinoGame
