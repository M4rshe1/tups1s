
$User = Read-Host "Userrname@domain.loocal"
$Pass = Read-Host "Password"

cmdkey /generic:'192.168.19.3' /user:$User /pass:$Pass > NULL
mstsc /v:192.168.19.3 > NULL
cmdkey /delete:TERMSRV/192.168.19.3 > NULL