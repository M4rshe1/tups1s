# *************************************************************************
#
# Script Name: TicTacToe.ps1 (The Tic-Tac-Toe Game)
# Version: 2.0
# Author: Joseph Preston
# Date: March 26, 2014
#
# Description: This PowerShell script is a two player implementation of the
# popular Tic-Tac-Toe game
#
# Additions: Added help screen with game instructions and game statistics
# for win, loss, and draw.
#
# *************************************************************************
 
 
# Initialization Section

#Define variables used in this script
$startGame = "False" #Controls when the game terminates
$playGame = "True" #Controls the play of an individual round of play 
$player = "X" #Specifies the current player's turn
$winner = "" #Specifies the winner
$moves = 0 #Counts the number of moves made
$move = "" #Stores the current player's move
$tie = "False" #Specifies when a tie occurs
$rules = "N" #Specifies whether to show the rules
$noPlayed = 0 #This variable keeps track of the number of games played
$xWon = 0 #This variable keeps track of the number of games X won
$xLost = 0 #This variable keeps track of the number of games X lost
$xTied = 0 #This variable keeps track of the number of games X tied
 
#Variables representing game board squares
$A1 = "1"
$A2 = "1"
$A3 = "1"
$B1 = "1"
$B2 = " "
$B3 = " "
$C1 = " "
$C2 = " "
$C3 = " "
 
# Functions and Filters Section

#This function resets variables representing variable board squares
function Clear-Board {
 
    $script:A1 = " "
    $script:A2 = " "
    $script:A3 = " "
    $script:B1 = " "
    $script:B2 = " "
    $script:B3 = " "
    $script:C1 = " "
    $script:C2 = " "
    $script:C3 = " "
 
}

#This function gets the player's permission to start a round of play
function Get-Permission {
    #Loop until a valid reply is collected
    while ($startGame -eq "False") {
 
        Clear-Host #Clear the Windows command console screen
 
        #Display the game's opening screen
        Write-Host "`n`n`n`n"
        Write-Host "                               |       |"
        Write-Host " Welcome to the            X   |   O   |"
        write-Host "                               |       |"
        Write-Host "                         ------|-------|------"
        Write-Host " T I C - T A C - T O E         |       |"
        Write-Host "                               |   X   |"
        Write-Host "                               |       |"
        Write-Host " G A M E !               ------|-------|------"
        Write-Host "                               |       |"
        Write-Host "                               |   O   |   X"
        Write-Host "                               |       |"
 
        #Collect the player's input
        # $response = Read-Host "`n`n`n`n`n`n`n Would you like to play? (Y/N)"
        $response = Read-Host
 
        #Validate the player's input
        if ($response -eq "quit") {
            #The player wants to quit
            $startGame = "False"
            Clear-Host #Clear the Windows command console screen
            exit #Terminate script execution
        }
        else {
            #The player wants to play a new round
            $startGame = "True"
                            
            #Ask player if they would like to see the instructions
            # $rules = Read-Host "`n`n`n`n`n`n Would you like to see how to play the game? (Y/N)"
            $rules = "n"
            if ($rules -eq "Y") {
                #Player would like to see the instructions
                Clear-Host
                Write-Host "`n`n`n                    How to Play Tic-Tac-Toe"
                Write-Host "`n`n`n Players take turns choosing a grid location to place either an X or an O in"
                Write-Host " the attempt to get three (3) of their symbols to be aligned either vertically,"
                Write-Host " horizontally, or diagonally. The first player to succeed at this, wins."
                Read-Host
                $startGame = "True"
            }
            else {
                $startGame = "True"
                Clear-Host
            }
          
        }

    }
 
}

#This function displays the game board, showing each player's moves
function Display-Board {
 
    Clear-Host #Clear the Windows command console screen
 
    #Display the game board
    Write-Host "`n`n T I C - T A C - T O E`n`n`n"
    Write-Host "      1      2       3`n"
    Write-Host "         |       |"
    Write-Host " A   $A1   |   $A2   |   $A3"
    write-Host "         |       |"
    Write-Host "   ------|-------|------"
    Write-Host "         |       |"
    Write-Host " B   $B1   |   $B2   |   $B3"
    Write-Host "         |       |"
    Write-Host "   ------|-------|------"
    Write-Host "         |       |"
    Write-Host " C   $C1   |   $C2   |   $C3"
    Write-Host "         |       |"
 
    #Collect player move
    $move = Read-Host "`n`n`n`n Player $player's turn. Please enter move in grid format (eg. A1)"
    $move #Return the Player's input to the calling statement
 
}

#This function determines if the player's input is valid
function Validate-Move {
    if ($move -eq "quit") {
        exit
    }
 
    if ($move.length -eq 2) {
        #Valid moves consist of 2 characters
        if ($move -match "[A-C][1-3]") {
            #Regular expression test that looks
            $result = "Valid" #for an instance of A, B, or C and an
        } #instance of 1, 2, or 3.
        else {
            $result = "Invalid" #The move is invalid if it is not A1, A2, A3,
        } # B1, B2, B3, C1, C2, or C3
    }
    else {
        $result = "Invalid" #The move is invalid if it does not consist of 2
    } #characters
 
    #Move is invalid if it has already been assigned to a player during a
    # previous turn
    if (($move -eq "A1") -and ($A1 -ne " ")) { $result = "Invalid" }
    if (($move -eq "A2") -and ($A2 -ne " ")) { $result = "Invalid" }
    if (($move -eq "A3") -and ($A3 -ne " ")) { $result = "Invalid" }
    if (($move -eq "B1") -and ($B1 -ne " ")) { $result = "Invalid" }
    if (($move -eq "B2") -and ($B2 -ne " ")) { $result = "Invalid" }
    if (($move -eq "B3") -and ($B3 -ne " ")) { $result = "Invalid" }
    if (($move -eq "C1") -and ($C1 -ne " ")) { $result = "Invalid" }
    if (($move -eq "C2") -and ($C2 -ne " ")) { $result = "Invalid" }
    if (($move -eq "C3") -and ($C3 -ne " ")) { $result = "Invalid" }
 
    $result #Return this value to the statement that called this function
 
}

#This function checks the game board to see if there is a winner
function Check-Results {
 
    $winner = "" #Always reset this value before checking
 
    #Look for a winner vertically
    if (($A1 -eq $player) -and ($A2 -eq $player) -and ($A3 -eq $player)) {
        $winner = $player
    }
    if (($B1 -eq $player) -and ($B2 -eq $player) -and ($B3 -eq $player)) {
        $winner = $player
    }
    if (($C1 -eq $player) -and ($C2 -eq $player) -and ($C3 -eq $player)) {
        $winner = $player
    }
 
    #Look for a winner horizontally
    if (($A1 -eq $player) -and ($B1 -eq $player) -and ($C1 -eq $player)) {
        $winner = $player
    }
    if (($A2 -eq $player) -and ($B2 -eq $player) -and ($C2 -eq $player)) {
        $winner = $player
    }
    if (($A3 -eq $player) -and ($B3 -eq $player) -and ($C3 -eq $player)) {
        $winner = $player
    }
 
    #Look for a winner diagonally
    if (($A1 -eq $player) -and ($B2 -eq $player) -and ($C3 -eq $player)) {
        $winner = $player
    }
    if (($A3 -eq $player) -and ($B2 -eq $player) -and ($C1 -eq $player)) {
        $winner = $player
    } 
 
    $winner #Return this value to the statement that called this function
 
}

#This function displays the game board and the final results of a round
#of play
function Display-Results {
 
    Clear-Host #Clear the Windows command console screen
 
    #Display the game board
    Write-Host "`n`n T I C - T A C - T O E`n`n`n"
    Write-Host "      1      2       3`n"
    Write-Host "         |       |"
    Write-Host " A  $A1    |  $A2    |  $A3"
    write-Host "         |       |"
    Write-Host "   ------|-------|------"
    Write-Host "         |       |"
    Write-Host " B  $B1    |  $B2    |  $B3"
    Write-Host "         |       |"
    Write-Host "   ------|-------|------"
    Write-Host "         |       |"
    Write-Host " C  $C1    |  $C2    |  $C3"
    Write-Host "         |       |"
 
    if ($tie -eq "True") {
        #Check to see if the game resulted in a tie
        Read-Host "`n`n`n`n The game has ended in a tie. Press Enter to continue"
        $xTied++
    }
    else {
        #If a tie did not occur, identify the winner
        Read-Host "`n`n`n`n Game over. $player has won. Press Enter to continue"
    } 
}

function Display-Stats {
    #Display the game statistics
    Write-Host "`n`n`n Game Statistics`n"
    Write-Host " -----------------------------------`n"
    Write-Host "`n Number of games played: $noPlayed"
    Write-Host "`n Number of games X won: $xWon"
    Write-Host "`n Number of games X lost: $xLost"
    Write-Host "`n Number of games X tied: $xTied`n"
    Write-Host " -----------------------------------"
    Write-Host "`n`n`n`n`n`n`n Press Enter to continue."

    #Pause the game until the player presses the Enter key
    Read-Host

    #Clear the Windows command console screen
    Clear-Host
}

# Main Processing Section

Clear-Board #Call function that resets the game board
 
Get-Permission #Call function that asks the players for permission to
# start a new round of play

while ($Terminate -ne "True") {
    #Loop until the player decides to quit
 
    while ($playGame -eq "True") {
        #This loop controls the logic required to
        #play a round of Tic-Tac-Toe
  
        $move = Display-Board #Call function that displays the game board and
        #collects player moves
 
        $validMove = Validate-Move #Call the function that validates player moves
        if ($validMove -eq "Valid") {
            #Process valid moves
            $moves++ #Increment variable that keeps track of the number of valid moves
 
            #Assign the appropriate game board square to the player that selected it
            if ($move -eq "A1") { $A1 = $player }
            if ($move -eq "A2") { $A2 = $player }
            if ($move -eq "A3") { $A3 = $player }
            if ($move -eq "B1") { $B1 = $player }
            if ($move -eq "B2") { $B2 = $player }
            if ($move -eq "B3") { $B3 = $player }
            if ($move -eq "C1") { $C1 = $player }
            if ($move -eq "C2") { $C2 = $player }
            if ($move -eq "C3") { $C3 = $player }
        }
        else {
            #Process invalid moves
            Clear-Host #Clear the Windows command console screen
            Read-Host "`n`n`n`n`n`n`n`n`n`nInvalid Move. Press Enter to try again"
            continue #Repeat this loop 
        }

        $winner = Check-Results #Call function that determines if the game is over
        #and who, if anyone, has won
 
        if ($winner -eq "X") {
            #Perform the following actions when Player X wins
            Write-Host `a #Make a beep sound
            $xWon++
            $noPlayed++
            Display-Results #Call function that displays game results
            $playGame = "False"
            continue #Repeat this loop
        }
 
        if ($winner -eq "O") {
            #Perform the following actions when Player O wins
            Write-Host `a #Make a beep sound
            $xLost++
            $noPlayed++
            Display-Results #Call function that displays game results
            $playGame = "False"
            continue #Repeat this loop
        }

        if ($moves -eq 9) {
            #Perform the following actions when a tie occurs
            Write-Host `a #Make a beep sound
            $tie = "True"
            $noPlayed++
            Display-Results #Call function that displays game results
            $playGame = "False"
            continue #Repeat this loop
        }

        #The game is not over yet so switch player turn
        if ($playGame -eq "True") {
            if ($player -eq "X") {
                $player = "O" 
            }
            else {
                $player = "X"
            }
        }
    }

    #This next set of statements only runs when the current round of play
    #has ended
 
    $response = "False" #Set default value in order to ensure the loop executes
 
    #Loop until valid input is received
    while ($response -ne "True") {
 
        Clear-Host #Clear the Windows command console screen
         
        Display-Stats #Display win, loss, and tie statistics
         
        Clear-Host
         
        #Prompt the player to play a new game
        $response = Read-Host "`n`n Play again? (Y/N)" 
        #Validate the player's input #Keep playing
        if ($response -eq "Y") {
            #Reset default variable settings to get ready for a new round of play
            $response = "True"
            $terminate = "False"
            $playGame = "True"
            Clear-Board
            $player = "X"
            $moves = 0
            $tie = "False"
        }
        elseif ($response -eq "N") {
            #Time to quit
            Clear-Host #Clear the Windows command console screen
            Write-host " `n`n Please return and play again soon."
            Read-Host #Pause gameplay
            $response = "True"
            $terminate = "True"
        }
        else {
            #Invalid input received
            Clear-Host #Clear the Windows command console screen
            Write-Host "`n`n Invalid input. Please press Enter to try again."
            Read-Host #Pause gameplay
        }
    }
}