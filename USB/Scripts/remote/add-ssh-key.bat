@echo off


@REM type $env:USERPROFILE\.ssh\id_rsa.pub | ssh colin@192.168.227.128 "cat >> .ssh/authorized_keys"

@REM echo type of host
@REM echo Linux          [1]
@REM echo Windows        [2]
@REM set /p host=">>"

echo Remote host ip
set /p ip=">>"

echo Remote host user
set /p user=">>"

echo Remote host port
set /p port=">>"

@REM check if the ssh key exists
if not exist %USERPROFILE%\.ssh\id_rsa.pub (
    echo ssh key does not exist$
    echo creating ssh key
    ssh-keygen -t rsa -b 4096 -C "colin@%computername%" -f %USERPROFILE%\.ssh\id_rsa
    echo ssh key created in %USERPROFILE%\.ssh\id_rsa.pub
)


echo check if the remote host has the .ssh folder
@REM if %host%== 1 (
@REM     ssh %user%@%ip% -p %port% "mkdir -p ~/.ssh && touch ~/.ssh/authorized_keys"
@REM ) else (
@REM     ssh %user%@%ip% -p %port% "mkdir -p ~/.ssh && touch ~/.test/authorized_keys"
@REM )

ssh %user%@%ip% -p %port% "mkdir -p ~/.ssh && touch ~/.test/authorized_keys"

echo copy the key to the remote host
type %USERPROFILE%\.ssh\id_rsa.pub | ssh %user%@%ip% -p %port% "cat >> ~/.ssh/authorized_keys"

