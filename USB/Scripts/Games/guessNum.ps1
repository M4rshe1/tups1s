$global:GamesPlayed = 0
$global:TotalGuesses = 0

function PlayGame {
    $n = Get-Random -Minimum 1 -Maximum 101
    $guess = 0
    $guessCount = 0
    $guessedNumbers = @()

    do {
        Clear-Host
        if ($guessedNumbers.Length -ne 0) {
            Write-Host "Guessed numbers:"
            $guessedNumbers | ForEach-Object {
                Write-Host $_
            }
        }
        $guess = Read-Host "Guess a number!"
        $guessCount++
        if ($guess -eq "quit") {
            break
        }
        if ($guess -lt $n) {
            Write-Host "You guessed too low. Try again."
            $guessedNumbers += "$guess (Too low)"
        }
        elseif ($guess -gt $n) {
            Write-Host "You guessed too high. Try again."
            $guessedNumbers += "$guess (Too high)"
        }
        else {
            $guessedNumbers += "$guess (Correct)"
        }
    }
    until ($guess -eq $n)

    $global:GamesPlayed++
    $global:TotalGuesses += $guessCount
    $avg = $global:TotalGuesses / $global:GamesPlayed

    Clear-Host
    Write-Host "You guessed it! Yay!"
    Write-Host "Total guesses: $guessCount"
    Write-Host "Guessed numbers:"
    $guessedNumbers | ForEach-Object {
        Write-Host $_
    }
    Write-Host
    Write-Host "##############################"
    Write-Host "GAME STATS"
    Write-Host
    Write-Host "Games Played: $global:GamesPlayed"
    Write-Host "Total guesses: $global:TotalGuesses"
    Write-Host "Average: $avg"
}

do {
    PlayGame
    $playAgain = Read-Host "Do you want to play again? (Y/N)"

    if ($playAgain -ne "Y" -and $playAgain -ne "y") {
        break
    }
}
while ($true)
