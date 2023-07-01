@echo off
title TIC-TAC-TOE
:menu
cls
echo.
echo  Which mode do you want to play?
echo.
echo    1 player mode      (1)
echo    2 player mode      (2)
echo.
echo.
set /p letter=
if %letter% == 1 goto 1player
if %letter% == 2 goto 2player
if %letter% == 3 goto changes
goto menu
:2player
set mode=2
cls
echo Who will be X's?
echo Please type name
echo.
set /p p1=
:2player-2
cls
echo Who will be O's?
echo Please type name
echo.
set /p p2=
:othertotal2
goto begin(2)setter
:begin(2)
set current_player=1
cls
echo   %a% %b% %c%
echo   %d% %e% %f%
echo   %g% %h% %i%
echo.
echo %p1%, your turn
echo.
echo Please enter the number that
echo you want to replace with a X
echo.
set /p choice=
if %choice% == 1 goto set_a_x
if %choice% == 2 goto set_b_x
if %choice% == 3 goto set_c_x
if %choice% == 4 goto set_d_x
if %choice% == 5 goto set_e_x
if %choice% == 6 goto set_f_x
if %choice% == 7 goto set_g_x
if %choice% == 8 goto set_h_x
if %choice% == 9 goto set_i_x
:begin(2)choice

:begin(2)setter
set a=1
set b=2
set c=3
set d=4
set e=5
set f=6
set g=7
set h=8
set i=9
goto begin(2)
:set_a_x
if %a% == 0 goto cpe
set a=X
if %a%%b%%c% == XXX goto X_won
if %d%%e%%f% == XXX goto x_won
if %g%%h%%i% == XXX goto x_won
if %a%%e%%i% == XXX goto x_won
if %g%%e%%c% == XXX goto x_won
if %a%%b%%c% == OOO goto O_won
if %d%%e%%f% == OOO goto O_won
if %g%%h%%i% == OOO goto O_won
if %a%%e%%i% == OOO goto O_won
if %g%%e%%c% == OOO goto O_won
if %current_player% == 1 goto current_player2
if %current_player% == 2 goto begin(2)
:set_b_x
if %b% == 0 goto cpe
set b=X
if %a%%b%%c% == XXX goto X_won
if %d%%e%%f% == XXX goto x_won
if %g%%h%%i% == XXX goto x_won
if %a%%e%%i% == XXX goto x_won
if %g%%e%%c% == XXX goto x_won
if %a%%b%%c% == OOO goto O_won
if %d%%e%%f% == OOO goto O_won
if %g%%h%%i% == OOO goto O_won
if %a%%e%%i% == OOO goto O_won
if %g%%e%%c% == OOO goto O_won
if %current_player% == 1 goto current_player2
if %current_player% == 2 goto begin(2)
:set_c_x
if %c% == 0 goto cpe
set c=X
if %a%%b%%c% == XXX goto X_won
if %d%%e%%f% == XXX goto x_won
if %g%%h%%i% == XXX goto x_won
if %a%%e%%i% == XXX goto x_won
if %g%%e%%c% == XXX goto x_won
if %a%%b%%c% == OOO goto O_won
if %d%%e%%f% == OOO goto O_won
if %g%%h%%i% == OOO goto O_won
if %a%%e%%i% == OOO goto O_won
if %g%%e%%c% == OOO goto O_won
if %current_player% == 1 goto current_player2
if %current_player% == 2 goto begin(2)
:set_d_x
if %d% == 0 goto cpe
set d=X
if %a%%b%%c% == XXX goto X_won
if %d%%e%%f% == XXX goto x_won
if %g%%h%%i% == XXX goto x_won
if %a%%e%%i% == XXX goto x_won
if %g%%e%%c% == XXX goto x_won
if %a%%b%%c% == OOO goto O_won
if %d%%e%%f% == OOO goto O_won
if %g%%h%%i% == OOO goto O_won
if %a%%e%%i% == OOO goto O_won
if %g%%e%%c% == OOO goto O_won
if %current_player% == 1 goto current_player2
if %current_player% == 2 goto begin(2)
:set_e_x
if %e% == 0 goto cpe
set e=X
if %a%%b%%c% == XXX goto X_won
if %d%%e%%f% == XXX goto x_won
if %g%%h%%i% == XXX goto x_won
if %a%%e%%i% == XXX goto x_won
if %g%%e%%c% == XXX goto x_won
if %a%%b%%c% == OOO goto O_won
if %d%%e%%f% == OOO goto O_won
if %g%%h%%i% == OOO goto O_won
if %a%%e%%i% == OOO goto O_won
if %g%%e%%c% == OOO goto O_won
if %current_player% == 1 goto current_player2
if %current_player% == 2 goto begin(2)
:set_f_x
if %f% == 0 goto cpe
set f=X
if %a%%b%%c% == XXX goto X_won
if %d%%e%%f% == XXX goto x_won
if %g%%h%%i% == XXX goto x_won
if %a%%e%%i% == XXX goto x_won
if %g%%e%%c% == XXX goto x_won
if %a%%b%%c% == OOO goto O_won
if %d%%e%%f% == OOO goto O_won
if %g%%h%%i% == OOO goto O_won
if %a%%e%%i% == OOO goto O_won
if %g%%e%%c% == OOO goto O_won
if %current_player% == 1 goto current_player2
if %current_player% == 2 goto begin(2)
:set_g_x
if %g% == 0 goto cpe
set g=X
if %a%%b%%c% == XXX goto X_won
if %d%%e%%f% == XXX goto x_won
if %g%%h%%i% == XXX goto x_won
if %a%%e%%i% == XXX goto x_won
if %g%%e%%c% == XXX goto x_won
if %a%%b%%c% == OOO goto O_won
if %d%%e%%f% == OOO goto O_won
if %g%%h%%i% == OOO goto O_won
if %a%%e%%i% == OOO goto O_won
if %g%%e%%c% == OOO goto O_won
if %current_player% == 1 goto current_player2
if %current_player% == 2 goto begin(2)
:set_h_x
if %h% == 0 goto cpe
set h=X
if %a%%b%%c% == XXX goto X_won
if %d%%e%%f% == XXX goto x_won
if %g%%h%%i% == XXX goto x_won
if %a%%e%%i% == XXX goto x_won
if %g%%e%%c% == XXX goto x_won
if %a%%b%%c% == OOO goto O_won
if %d%%e%%f% == OOO goto O_won
if %g%%h%%i% == OOO goto O_won
if %a%%e%%i% == OOO goto O_won
if %g%%e%%c% == OOO goto O_won
if %current_player% == 1 goto current_player2
if %current_player% == 2 goto begin(2)
:set_i_x
if %i% == 0 goto cpe
set i=X
if %a%%b%%c% == XXX goto X_won
if %d%%e%%f% == XXX goto x_won
if %g%%h%%i% == XXX goto x_won
if %a%%e%%i% == XXX goto x_won
if %g%%e%%c% == XXX goto x_won
if %a%%b%%c% == OOO goto O_won
if %d%%e%%f% == OOO goto O_won
if %g%%h%%i% == OOO goto O_won
if %a%%e%%i% == OOO goto O_won
if %g%%e%%c% == OOO goto O_won
if %current_player% == 1 goto current_player2
if %current_player% == 2 goto begin(2)
:current_player2
set current_player=2
cls
echo   %a% %b% %c%
echo   %d% %e% %f%
echo   %g% %h% %i%
echo.
echo %p2%, your turn
echo.
echo Please enter the number that
echo you want to replace with a 'O'
echo.
set /p choice=
if %choice% == 1 goto set_a_o
if %choice% == 2 goto set_b_o
if %choice% == 3 goto set_c_o
if %choice% == 4 goto set_d_o
if %choice% == 5 goto set_e_o
if %choice% == 6 goto set_f_o
if %choice% == 7 goto set_g_o
if %choice% == 8 goto set_h_o
if %choice% == 9 goto set_i_o
:set_a_o
if %a% == X goto cpe
set a=O
if %a%%b%%c% == XXX goto X_won
if %d%%e%%f% == XXX goto x_won
if %g%%h%%i% == XXX goto x_won
if %a%%e%%i% == XXX goto x_won
if %g%%e%%c% == XXX goto x_won
if %a%%b%%c% == OOO goto O_won
if %d%%e%%f% == OOO goto O_won
if %g%%h%%i% == OOO goto O_won
if %a%%e%%i% == OOO goto O_won
if %g%%e%%c% == OOO goto O_won
if %current_player% == 1 goto current_player2
if %current_player% == 2 goto begin(2)
:set_b_o
if %b% == X goto cpe
set b=O
if %a%%b%%c% == XXX goto X_won
if %d%%e%%f% == XXX goto x_won
if %g%%h%%i% == XXX goto x_won
if %a%%e%%i% == XXX goto x_won
if %g%%e%%c% == XXX goto x_won
if %a%%b%%c% == OOO goto O_won
if %d%%e%%f% == OOO goto O_won
if %g%%h%%i% == OOO goto O_won
if %a%%e%%i% == OOO goto O_won
if %g%%e%%c% == OOO goto O_won
if %current_player% == 1 goto current_player2
if %current_player% == 2 goto begin(2)
:set_c_o
if %c% == X goto cpe
set c=O
if %a%%b%%c% == XXX goto X_won
if %d%%e%%f% == XXX goto x_won
if %g%%h%%i% == XXX goto x_won
if %a%%e%%i% == XXX goto x_won
if %g%%e%%c% == XXX goto x_won
if %a%%b%%c% == OOO goto O_won
if %d%%e%%f% == OOO goto O_won
if %g%%h%%i% == OOO goto O_won
if %a%%e%%i% == OOO goto O_won
if %g%%e%%c% == OOO goto O_won
if %current_player% == 1 goto current_player2
if %current_player% == 2 goto begin(2)
:set_d_o
if %d% == X goto cpe
set d=O
if %a%%b%%c% == XXX goto X_won
if %d%%e%%f% == XXX goto x_won
if %g%%h%%i% == XXX goto x_won
if %a%%e%%i% == XXX goto x_won
if %g%%e%%c% == XXX goto x_won
if %a%%b%%c% == OOO goto O_won
if %d%%e%%f% == OOO goto O_won
if %g%%h%%i% == OOO goto O_won
if %a%%e%%i% == OOO goto O_won
if %g%%e%%c% == OOO goto O_won
if %current_player% == 1 goto current_player2
if %current_player% == 2 goto begin(2)
:set_e_o
if %e% == X goto cpe
set e=O
if %a%%b%%c% == XXX goto X_won
if %d%%e%%f% == XXX goto x_won
if %g%%h%%i% == XXX goto x_won
if %a%%e%%i% == XXX goto x_won
if %g%%e%%c% == XXX goto x_won
if %a%%b%%c% == OOO goto O_won
if %d%%e%%f% == OOO goto O_won
if %g%%h%%i% == OOO goto O_won
if %a%%e%%i% == OOO goto O_won
if %g%%e%%c% == OOO goto O_won
set e=O
if %current_player% == 1 goto current_player2
if %current_player% == 2 goto begin(2)
:set_f_o
if %f% == X goto cpe
set f=O
if %a%%b%%c% == XXX goto X_won
if %d%%e%%f% == XXX goto x_won
if %g%%h%%i% == XXX goto x_won
if %a%%e%%i% == XXX goto x_won
if %g%%e%%c% == XXX goto x_won
if %a%%b%%c% == OOO goto O_won
if %d%%e%%f% == OOO goto O_won
if %g%%h%%i% == OOO goto O_won
if %a%%e%%i% == OOO goto O_won
if %g%%e%%c% == OOO goto O_won
if %current_player% == 1 goto current_player2
if %current_player% == 2 goto begin(2)
:set_g_o
if %g% == X goto cpe
set g=O
if %a%%b%%c% == XXX goto X_won
if %d%%e%%f% == XXX goto x_won
if %g%%h%%i% == XXX goto x_won
if %a%%e%%i% == XXX goto x_won
if %g%%e%%c% == XXX goto x_won
if %a%%b%%c% == OOO goto O_won
if %d%%e%%f% == OOO goto O_won
if %g%%h%%i% == OOO goto O_won
if %a%%e%%i% == OOO goto O_won
if %g%%e%%c% == OOO goto O_won
if %current_player% == 1 goto current_player2
if %current_player% == 2 goto begin(2)
:set_h_o
if %h% == X goto cpe
set h=O
if %a%%b%%c% == XXX goto X_won
if %d%%e%%f% == XXX goto x_won
if %g%%h%%i% == XXX goto x_won
if %a%%e%%i% == XXX goto x_won
if %g%%e%%c% == XXX goto x_won
if %a%%b%%c% == OOO goto O_won
if %d%%e%%f% == OOO goto O_won
if %g%%h%%i% == OOO goto O_won
if %a%%e%%i% == OOO goto O_won
if %g%%e%%c% == OOO goto O_won
if %current_player% == 1 goto current_player2
if %current_player% == 2 goto begin(2)
:set_i_o
if %i% == X goto cpe
set i=O
if %a%%b%%c% == XXX goto X_won
if %d%%e%%f% == XXX goto x_won
if %g%%h%%i% == XXX goto x_won
if %a%%e%%i% == XXX goto x_won
if %g%%e%%c% == XXX goto x_won
if %a%%b%%c% == OOO goto O_won
if %d%%e%%f% == OOO goto O_won
if %g%%h%%i% == OOO goto O_won
if %a%%e%%i% == OOO goto O_won
if %g%%e%%c% == OOO goto O_won
if %current_player% == 1 goto current_player2
if %current_player% == 2 goto begin(2)
:x_won
cls
echo %p1% won!
echo.
pause
goto menu
:X_won
cls
echo %p1% won!
echo.
pause
goto menu
:O_won
cls
echo %p2% won!
echo.
pause
goto menu
:o_won
cls
echo %p2% won!
echo.
pause
goto menu
:1player
cls
echo Loading...
set mode=1
set a=1
set b=2
set c=3
set d=4
set e=5
set f=6
set g=7
set h=8
set i=9
set p1=You
set p2=You lost! The other player
cls
echo 1 player mode is currently under construction
echo.
echo Do you want to play anyways?
echo.
echo 1 = Yes
echo 2 = No
echo.
set /p letter=
if %letter% == 1 goto 1player(b)
if %letter% == 2 goto menu
goto 1player
:cpe
if %current_player% == 2 goto current_player2
if %current_player% == 1 goto begin(2)
Cls
echo Error
pause
goto menu
:changes
cls
echo Changes in Version 1.2
echo ----------------------
echo 1 player mode loading time has been decreased
echo.
echo 1 player mode will now say who won the game
echo.
echo Tic-Tac-Toe V 1.2 and higher will now be available to download online
echo.
echo Added the word "Created" in front of the date on the menu
echo.
echo Will now skip a line when viewing the changes page
echo.
pause
goto menu
:1player(b)
cls
echo %a% %b% %c%
echo %d% %e% %f%
echo %g% %h% %i%
echo.
echo Please enter the number that
echo you want to replace with a 'X'
echo.
set /p letter=
if %letter% == 1 goto a_x_cpu
if %letter% == 2 goto b_x_cpu
if %letter% == 3 goto c_x_cpu
if %letter% == 4 goto d_x_cpu
if %letter% == 5 goto e_x_cpu
if %letter% == 6 goto f_x_cpu
if %letter% == 7 goto g_x_cpu
if %letter% == 8 goto h_x_cpu
if %letter% == 9 goto i_x_cpu
goto 1player(b)
:a_x_cpu
cls
echo Loading...
if %a% == O goto 1player(b)
set a=X
set minval=1
set maxval=9
if /i "%maxval%" leq "¬" goto EnterMaxVal
if /i "%maxval%" geq "a" goto EnterMaxVal
if /i %minval% gtr %maxval% echo Minimum value can not be smaller than maximum value.& goto RandomNumber
if /i %maxval% gtr 62767 echo Maximum value too high.
set /a ValDifference= ( %MaxVal% - %MinVal% ) + 1
set /a Divisor= 32767 / %ValDifference%
set count=0
:NumberGenerator_a_x_cpu
set /a RandomNumber= %random% / %Divisor%
set /a RandomNumber= %RandomNumber% + %MinVal%
if /i %RandomNumber% GTR %Maxval% goto NumberGenerator_a_x_cpu
set temp=%RandomNumber%
if %a%%b%%c% == XXX goto X_won
if %d%%e%%f% == XXX goto x_won
if %g%%h%%i% == XXX goto x_won
if %a%%e%%i% == XXX goto x_won
if %g%%e%%c% == XXX goto x_won
if %a%%b%%c% == OOO goto O_won
if %d%%e%%f% == OOO goto O_won
if %g%%h%%i% == OOO goto O_won
if %a%%e%%i% == OOO goto O_won
if %g%%e%%c% == OOO goto O_won
if %temp% == 2 goto b_o_cpu
if %temp% == 3 goto c_o_cpu
if %temp% == 4 goto d_o_cpu
if %temp% == 5 goto e_o_cpu
if %temp% == 6 goto f_o_cpu
if %temp% == 7 goto g_o_cpu
if %temp% == 8 goto h_o_cpu
if %temp% == 9 goto i_o_cpu
goto a_x_cpu
:b_x_cpu
cls
echo Loading...
if %b% == O goto 1player(b)
set b=X
if %a%%b%%c% == XXX goto X_won
if %d%%e%%f% == XXX goto x_won
if %g%%h%%i% == XXX goto x_won
if %a%%e%%i% == XXX goto x_won
if %g%%e%%c% == XXX goto x_won
if %a%%b%%c% == OOO goto O_won
if %d%%e%%f% == OOO goto O_won
if %g%%h%%i% == OOO goto O_won
if %a%%e%%i% == OOO goto O_won
if %g%%e%%c% == OOO goto O_won
set minval=1
set maxval=9
if /i "%maxval%" leq "¬" goto EnterMaxVal
if /i "%maxval%" geq "a" goto EnterMaxVal
if /i %minval% gtr %maxval% echo Minimum value can not be smaller than maximum value.& goto RandomNumber
if /i %maxval% gtr 62767 echo Maximum value too high.
set /a ValDifference= ( %MaxVal% - %MinVal% ) + 1
set /a Divisor= 32767 / %ValDifference%
set count=0
:NumberGenerator_b_x_cpu
set /a RandomNumber= %random% / %Divisor%
set /a RandomNumber= %RandomNumber% + %MinVal%
if /i %RandomNumber% GTR %Maxval% goto NumberGenerator_b_x_cpu
set temp=%RandomNumber%
if %temp% == 1 goto a_o_cpu
if %temp% == 3 goto c_o_cpu
if %temp% == 4 goto d_o_cpu
if %temp% == 5 goto e_o_cpu
if %temp% == 6 goto f_o_cpu
if %temp% == 7 goto g_o_cpu
if %temp% == 8 goto h_o_cpu
if %temp% == 9 goto i_o_cpu
goto b_x_cpu
:c_x_cpu
cls
echo Loading...
if %c% == O goto 1player(b)
set c=X
if %a%%b%%c% == XXX goto X_won
if %d%%e%%f% == XXX goto x_won
if %g%%h%%i% == XXX goto x_won
if %a%%e%%i% == XXX goto x_won
if %g%%e%%c% == XXX goto x_won
if %a%%b%%c% == OOO goto O_won
if %d%%e%%f% == OOO goto O_won
if %g%%h%%i% == OOO goto O_won
if %a%%e%%i% == OOO goto O_won
if %g%%e%%c% == OOO goto O_won
set minval=1
set maxval=9
if /i "%maxval%" leq "¬" goto EnterMaxVal
if /i "%maxval%" geq "a" goto EnterMaxVal
if /i %minval% gtr %maxval% echo Minimum value can not be smaller than maximum value.& goto RandomNumber
if /i %maxval% gtr 62767 echo Maximum value too high.
set /a ValDifference= ( %MaxVal% - %MinVal% ) + 1
set /a Divisor= 32767 / %ValDifference%
set count=0
:NumberGenerator_c_x_cpu
set /a RandomNumber= %random% / %Divisor%
set /a RandomNumber= %RandomNumber% + %MinVal%
if /i %RandomNumber% GTR %Maxval% goto NumberGenerator_c_x_cpu
set temp=%RandomNumber%
if %temp% == 1 goto a_o_cpu
if %temp% == 2 goto b_o_cpu
if %temp% == 4 goto d_o_cpu
if %temp% == 5 goto e_o_cpu
if %temp% == 6 goto f_o_cpu
if %temp% == 7 goto g_o_cpu
if %temp% == 8 goto h_o_cpu
if %temp% == 9 goto i_o_cpu
goto c_x_cpu
:d_x_cpu
cls
echo Loading...
if %d% == O goto 1player(b)
set d=X
if %a%%b%%c% == XXX goto X_won
if %d%%e%%f% == XXX goto x_won
if %g%%h%%i% == XXX goto x_won
if %a%%e%%i% == XXX goto x_won
if %g%%e%%c% == XXX goto x_won
if %a%%b%%c% == OOO goto O_won
if %d%%e%%f% == OOO goto O_won
if %g%%h%%i% == OOO goto O_won
if %a%%e%%i% == OOO goto O_won
if %g%%e%%c% == OOO goto O_won
set minval=1
set maxval=9
if /i "%maxval%" leq "¬" goto EnterMaxVal
if /i "%maxval%" geq "a" goto EnterMaxVal
if /i %minval% gtr %maxval% echo Minimum value can not be smaller than maximum value.& goto RandomNumber
if /i %maxval% gtr 62767 echo Maximum value too high.
set /a ValDifference= ( %MaxVal% - %MinVal% ) + 1
set /a Divisor= 32767 / %ValDifference%
set count=0
:NumberGenerator_d_x_cpu
set /a RandomNumber= %random% / %Divisor%
set /a RandomNumber= %RandomNumber% + %MinVal%
if /i %RandomNumber% GTR %Maxval% goto NumberGenerator_d_x_cpu
set temp=%RandomNumber%
if %temp% == 1 goto a_o_cpu
if %temp% == 2 goto b_o_cpu
if %temp% == 3 goto c_o_cpu
if %temp% == 5 goto e_o_cpu
if %temp% == 6 goto f_o_cpu
if %temp% == 7 goto g_o_cpu
if %temp% == 8 goto h_o_cpu
if %temp% == 9 goto i_o_cpu
goto d_x_cpu
:e_x_cpu
cls
echo Loading...
if %e% == O goto 1player(b)
set e=X
if %a%%b%%c% == XXX goto X_won
if %d%%e%%f% == XXX goto x_won
if %g%%h%%i% == XXX goto x_won
if %a%%e%%i% == XXX goto x_won
if %g%%e%%c% == XXX goto x_won
if %a%%b%%c% == OOO goto O_won
if %d%%e%%f% == OOO goto O_won
if %g%%h%%i% == OOO goto O_won
if %a%%e%%i% == OOO goto O_won
if %g%%e%%c% == OOO goto O_won
set minval=1
set maxval=9
if /i "%maxval%" leq "¬" goto EnterMaxVal
if /i "%maxval%" geq "a" goto EnterMaxVal
if /i %minval% gtr %maxval% echo Minimum value can not be smaller than maximum value.& goto RandomNumber
if /i %maxval% gtr 62767 echo Maximum value too high.
set /a ValDifference= ( %MaxVal% - %MinVal% ) + 1
set /a Divisor= 32767 / %ValDifference%
set count=0
:NumberGenerator_e_x_cpu
set /a RandomNumber= %random% / %Divisor%
set /a RandomNumber= %RandomNumber% + %MinVal%
if /i %RandomNumber% GTR %Maxval% goto NumberGenerator_e_x_cpu
set temp=%RandomNumber%
if %temp% == 1 goto a_o_cpu
if %temp% == 2 goto b_o_cpu
if %temp% == 3 goto c_o_cpu
if %temp% == 4 goto d_o_cpu
if %temp% == 6 goto f_o_cpu
if %temp% == 7 goto g_o_cpu
if %temp% == 8 goto h_o_cpu
if %temp% == 9 goto i_o_cpu
goto e_x_cpu
:f_x_cpu
cls
echo Loading...
if %f% == O goto 1player(b)
set f=X
if %a%%b%%c% == XXX goto X_won
if %d%%e%%f% == XXX goto x_won
if %g%%h%%i% == XXX goto x_won
if %a%%e%%i% == XXX goto x_won
if %g%%e%%c% == XXX goto x_won
if %a%%b%%c% == OOO goto O_won
if %d%%e%%f% == OOO goto O_won
if %g%%h%%i% == OOO goto O_won
if %a%%e%%i% == OOO goto O_won
if %g%%e%%c% == OOO goto O_won
set minval=1
set maxval=9
if /i "%maxval%" leq "¬" goto EnterMaxVal
if /i "%maxval%" geq "a" goto EnterMaxVal
if /i %minval% gtr %maxval% echo Minimum value can not be smaller than maximum value.& goto RandomNumber
if /i %maxval% gtr 62767 echo Maximum value too high.
set /a ValDifference= ( %MaxVal% - %MinVal% ) + 1
set /a Divisor= 32767 / %ValDifference%
set count=0
:NumberGenerator_f_x_cpu
set /a RandomNumber= %random% / %Divisor%
set /a RandomNumber= %RandomNumber% + %MinVal%
if /i %RandomNumber% GTR %Maxval% goto NumberGenerator_f_x_cpu
set temp=%RandomNumber%
if %temp% == 1 goto a_o_cpu
if %temp% == 2 goto b_o_cpu
if %temp% == 3 goto c_o_cpu
if %temp% == 4 goto d_o_cpu
if %temp% == 5 goto e_o_cpu
if %temp% == 7 goto g_o_cpu
if %temp% == 8 goto h_o_cpu
if %temp% == 9 goto i_o_cpu
goto f_x_cpu
:g_x_cpu
cls
echo Loading...
if %g% == O goto 1player(b)
set g=X
if %a%%b%%c% == XXX goto X_won
if %d%%e%%f% == XXX goto x_won
if %g%%h%%i% == XXX goto x_won
if %a%%e%%i% == XXX goto x_won
if %g%%e%%c% == XXX goto x_won
if %a%%b%%c% == OOO goto O_won
if %d%%e%%f% == OOO goto O_won
if %g%%h%%i% == OOO goto O_won
if %a%%e%%i% == OOO goto O_won
if %g%%e%%c% == OOO goto O_won
set minval=1
set maxval=9
if /i "%maxval%" leq "¬" goto EnterMaxVal
if /i "%maxval%" geq "a" goto EnterMaxVal
if /i %minval% gtr %maxval% echo Minimum value can not be smaller than maximum value.& goto RandomNumber
if /i %maxval% gtr 62767 echo Maximum value too high.
set /a ValDifference= ( %MaxVal% - %MinVal% ) + 1
set /a Divisor= 32767 / %ValDifference%
set count=0
:NumberGenerator_g_x_cpu
set /a RandomNumber= %random% / %Divisor%
set /a RandomNumber= %RandomNumber% + %MinVal%
if /i %RandomNumber% GTR %Maxval% goto NumberGenerator_g_x_cpu
set temp=%RandomNumber%
if %temp% == 1 goto a_o_cpu
if %temp% == 2 goto b_o_cpu
if %temp% == 3 goto c_o_cpu
if %temp% == 4 goto d_o_cpu
if %temp% == 5 goto e_o_cpu
if %temp% == 6 goto f_o_cpu
if %temp% == 8 goto h_o_cpu
if %temp% == 9 goto i_o_cpu
goto g_x_cpu
:h_x_cpu
cls
echo Loading...
if %h% == O goto 1player(b)
set h=X
if %a%%b%%c% == XXX goto X_won
if %d%%e%%f% == XXX goto x_won
if %g%%h%%i% == XXX goto x_won
if %a%%e%%i% == XXX goto x_won
if %g%%e%%c% == XXX goto x_won
if %a%%b%%c% == OOO goto O_won
if %d%%e%%f% == OOO goto O_won
if %g%%h%%i% == OOO goto O_won
if %a%%e%%i% == OOO goto O_won
if %g%%e%%c% == OOO goto O_won
set minval=1
set maxval=9
if /i "%maxval%" leq "¬" goto EnterMaxVal
if /i "%maxval%" geq "a" goto EnterMaxVal
if /i %minval% gtr %maxval% echo Minimum value can not be smaller than maximum value.& goto RandomNumber
if /i %maxval% gtr 62767 echo Maximum value too high.
set /a ValDifference= ( %MaxVal% - %MinVal% ) + 1
set /a Divisor= 32767 / %ValDifference%
set count=0
:NumberGenerator_h_x_cpu
set /a RandomNumber= %random% / %Divisor%
set /a RandomNumber= %RandomNumber% + %MinVal%
if /i %RandomNumber% GTR %Maxval% goto NumberGenerator_h_x_cpu
set temp=%RandomNumber%
if %temp% == 1 goto a_o_cpu
if %temp% == 2 goto b_o_cpu
if %temp% == 3 goto c_o_cpu
if %temp% == 4 goto d_o_cpu
if %temp% == 5 goto e_o_cpu
if %temp% == 6 goto f_o_cpu
if %temp% == 8 goto g_o_cpu
if %temp% == 9 goto i_o_cpu
goto h_x_cpu
:i_x_cpu
cls
echo Loading...
if %i% == O goto 1player(b)
set i=X
if %a%%b%%c% == XXX goto X_won
if %d%%e%%f% == XXX goto x_won
if %g%%h%%i% == XXX goto x_won
if %a%%e%%i% == XXX goto x_won
if %g%%e%%c% == XXX goto x_won
if %a%%b%%c% == OOO goto O_won
if %d%%e%%f% == OOO goto O_won
if %g%%h%%i% == OOO goto O_won
if %a%%e%%i% == OOO goto O_won
if %g%%e%%c% == OOO goto O_won
set minval=1
set maxval=9
if /i "%maxval%" leq "¬" goto EnterMaxVal
if /i "%maxval%" geq "a" goto EnterMaxVal
if /i %minval% gtr %maxval% echo Minimum value can not be smaller than maximum value.& goto RandomNumber
if /i %maxval% gtr 62767 echo Maximum value too high.
set /a ValDifference= ( %MaxVal% - %MinVal% ) + 1
set /a Divisor= 32767 / %ValDifference%
set count=0
:NumberGenerator_i_x_cpu
set /a RandomNumber= %random% / %Divisor%
set /a RandomNumber= %RandomNumber% + %MinVal%
if /i %RandomNumber% GTR %Maxval% goto NumberGenerator_i_x_cpu
set temp=%RandomNumber%
if %temp% == 1 goto a_o_cpu
if %temp% == 2 goto b_o_cpu
if %temp% == 3 goto c_o_cpu
if %temp% == 4 goto d_o_cpu
if %temp% == 5 goto e_o_cpu
if %temp% == 6 goto f_o_cpu
if %temp% == 8 goto g_o_cpu
if %temp% == 9 goto i_o_cpu
goto i_x_cpu
:a_o_cpu
cls
echo Loading...
if %a% == X goto b_o_cpu
set a=O
if %a%%b%%c% == XXX goto X_won
if %d%%e%%f% == XXX goto x_won
if %g%%h%%i% == XXX goto x_won
if %a%%e%%i% == XXX goto x_won
if %g%%e%%c% == XXX goto x_won
if %a%%b%%c% == OOO goto O_won
if %d%%e%%f% == OOO goto O_won
if %g%%h%%i% == OOO goto O_won
if %a%%e%%i% == OOO goto O_won
if %g%%e%%c% == OOO goto O_won
goto 1player(b)
:b_o_cpu
cls
echo Loading...
if %b% == X goto c_o_cpu
set b=O
if %a%%b%%c% == XXX goto X_won
if %d%%e%%f% == XXX goto x_won
if %g%%h%%i% == XXX goto x_won
if %a%%e%%i% == XXX goto x_won
if %g%%e%%c% == XXX goto x_won
if %a%%b%%c% == OOO goto O_won
if %d%%e%%f% == OOO goto O_won
if %g%%h%%i% == OOO goto O_won
if %a%%e%%i% == OOO goto O_won
if %g%%e%%c% == OOO goto O_won
goto 1player(b)
:c_o_cpu
cls
echo Loading...
if %c% == X goto d_o_cpu
set c=O
if %a%%b%%c% == XXX goto X_won
if %d%%e%%f% == XXX goto x_won
if %g%%h%%i% == XXX goto x_won
if %a%%e%%i% == XXX goto x_won
if %g%%e%%c% == XXX goto x_won
if %a%%b%%c% == OOO goto O_won
if %d%%e%%f% == OOO goto O_won
if %g%%h%%i% == OOO goto O_won
if %a%%e%%i% == OOO goto O_won
if %g%%e%%c% == OOO goto O_won
goto 1player(b)
:d_o_cpu
cls
echo Loading...
if %d% == X goto e_o_cpu
set d=O
if %a%%b%%c% == XXX goto X_won
if %d%%e%%f% == XXX goto x_won
if %g%%h%%i% == XXX goto x_won
if %a%%e%%i% == XXX goto x_won
if %g%%e%%c% == XXX goto x_won
if %a%%b%%c% == OOO goto O_won
if %d%%e%%f% == OOO goto O_won
if %g%%h%%i% == OOO goto O_won
if %a%%e%%i% == OOO goto O_won
if %g%%e%%c% == OOO goto O_won
goto 1player(b)
:e_o_cpu
cls
echo Loading...
if %e% == X goto f_o_cpu
set e=O
if %a%%b%%c% == XXX goto X_won
if %d%%e%%f% == XXX goto x_won
if %g%%h%%i% == XXX goto x_won
if %a%%e%%i% == XXX goto x_won
if %g%%e%%c% == XXX goto x_won
if %a%%b%%c% == OOO goto O_won
if %d%%e%%f% == OOO goto O_won
if %g%%h%%i% == OOO goto O_won
if %a%%e%%i% == OOO goto O_won
if %g%%e%%c% == OOO goto O_won
goto 1player(b)
:f_o_cpu
cls
echo Loading...
if %f% == X goto g_o_cpu
set f=O
if %a%%b%%c% == XXX goto X_won
if %d%%e%%f% == XXX goto x_won
if %g%%h%%i% == XXX goto x_won
if %a%%e%%i% == XXX goto x_won
if %g%%e%%c% == XXX goto x_won
if %a%%b%%c% == OOO goto O_won
if %d%%e%%f% == OOO goto O_won
if %g%%h%%i% == OOO goto O_won
if %a%%e%%i% == OOO goto O_won
if %g%%e%%c% == OOO goto O_won
goto 1player(b)
:g_o_cpu
cls
echo Loading...
if %g% == X goto h_o_cpu
set g=O
if %a%%b%%c% == XXX goto X_won
if %d%%e%%f% == XXX goto x_won
if %g%%h%%i% == XXX goto x_won
if %a%%e%%i% == XXX goto x_won
if %g%%e%%c% == XXX goto x_won
if %a%%b%%c% == OOO goto O_won
if %d%%e%%f% == OOO goto O_won
if %g%%h%%i% == OOO goto O_won
if %a%%e%%i% == OOO goto O_won
if %g%%e%%c% == OOO goto O_won
goto 1player(b)
:h_o_cpu
cls
echo Loading...
if %h% == X goto i_o_cpu
set h=O
if %a%%b%%c% == XXX goto X_won
if %d%%e%%f% == XXX goto x_won
if %g%%h%%i% == XXX goto x_won
if %a%%e%%i% == XXX goto x_won
if %g%%e%%c% == XXX goto x_won
if %a%%b%%c% == OOO goto O_won
if %d%%e%%f% == OOO goto O_won
if %g%%h%%i% == OOO goto O_won
if %a%%e%%i% == OOO goto O_won
if %g%%e%%c% == OOO goto O_won
goto 1player(b)
:i_o_cpu
cls
echo Loading...
if %i% == X goto a_o_cpu
set i=O
if %a%%b%%c% == XXX goto X_won
if %d%%e%%f% == XXX goto x_won
if %g%%h%%i% == XXX goto x_won
if %a%%e%%i% == XXX goto x_won
if %g%%e%%c% == XXX goto x_won
if %a%%b%%c% == OOO goto O_won
if %d%%e%%f% == OOO goto O_won
if %g%%h%%i% == OOO goto O_won
if %a%%e%%i% == OOO goto O_won
if %g%%e%%c% == OOO goto O_won
goto 1player(b)