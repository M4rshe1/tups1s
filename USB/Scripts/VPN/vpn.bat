@echo off

REM VPN Connection Details
set "vpnServer=heggli.internet-box.ch"
set "preSharedKey=Heimnetzwerk.2020"
set "username=admin2"
set "password=Bananen.123"
set "ConnectionName=heimnetzwerk"

REM Delete existing VPN connection
rasphone -r "%ConnectionName%"

REM Create VPN connection
echo Creating new VPN connection...
echo [VPN]
echo Encoding=1
echo PBVersion=3
echo Type=2
echo AutoLogon=0
echo UseRasCredentials=1
echo LowDateTime=340568576
echo HighDateTime=30591462
echo DialParamsUID=272
echo Guid=9CDEFF96-6F82-42DD-830E-2D15E857B63E
echo VpnStrategy=2
echo ExcludedProtocols=0
echo LcpExtensions=1
echo DataEncryption=8
echo SwCompression=0
echo NegotiateMultilinkAlways=0
echo SkipDoubleDialDialog=0
echo DialMode=0
echo OverridePref=15
echo RedialAttempts=3
echo RedialSeconds=60
echo IdleDisconnectSeconds=0
echo RedialOnLinkFailure=0
echo CallbackMode=0
echo CustomDialDll=
echo CustomDialFunc=
echo CustomRasDialDll=
echo ForceSecureCompartment=
echo DisableIKENameEkuCheck=0
echo AuthenticateServer=0
echo ShareMsFilePrint=0
echo BindMsNetClient=0
echo SharedPhoneNumbers=0
echo GlobalDeviceSettings=0
echo PrerequisiteEntry=
echo PrerequisitePbk=
echo PreferredPort=VPN0-0
echo PreferredDevice=WAN Miniport (L2TP)
echo PreferredBps=0
echo PreferredHwFlow=0
echo PreferredProtocol=1
echo PreferredCompression=0
echo PreferredSpeaker=0
echo PreferredMdmProtocol=0
echo PreviewUserPw=1
echo PreviewDomain=0
echo PreviewPhoneNumber=0
echo ShowDialingProgress=1
echo ShowMonitorIconInTaskBar=1
echo CustomAuthKey=0
echo CustomAuthData=0
echo UseDialingRules=0
echo UsePrefixSuffix=0
echo ShowAuthSettings=0
echo IpPrioritizeRemote=1
echo IpInterfaceMetric=0
echo IpHeaderCompression=0
echo IpAddress=0.0.0.0
echo IpDnsAddress=0.0.0.0
echo IpDns2Address=0.0.0.0
echo IpWinsAddress=0.0.0.0
echo IpWins2Address=0.0.0.0
echo IpAssign=1
echo IpNameAssign=1
echo IpDnsFlags=0
echo IpNBTFlags=1
echo TcpWindowSize=0
echo UseFlags=0
echo IpSecFlags=0
echo IpDnsSuffix=
echo IPv6Assign=1
echo IPv6Address=
echo IPv6PrefixLength=0
echo IPv6PrioritizeRemote=1
echo IPv6InterfaceMetric=0
echo IPv6NameAssign=1
echo IPv6DNSAddress=
echo IPv6DNS2Address=
echo IPv6GatewayAddress=
echo IPv6InterfaceIdentifier=
echo IPv6Prefix=0
echo IPv6InterfaceMetric=0
echo IPv6IfType=0
echo IPv6NameAssign=1
echo IPv6DnsFlags=0
echo IPv6ScopeId=
echo Ipmtu=0
echo IPAddressType=0
echo EnableDns=0
echo DisableClassBasedDefaultRoute=0
echo DisableMobility=0
echo NetworkOutageTime=0
echo ProdKeyID=0
echo ClassID=
echo Ipv6DnsSuffix=
echo AAA_ServerType=0
echo AAA_Server=0
echo AAA_Accounting=0
echo AAA_Authentication=0
echo PrerequisiteEntry=%vpnServer%
echo PrerequisitePbk=
echo PPP_CallbackNumber=
echo PPP_CallbackType=0
echo PPP_PrerequisiteEntry=
echo PPP_PrerequisitePbk=
echo InternetUserName=%username%
echo InternetPassword=%password%
echo InternetDomain=
echo UseRasCredentials=1
echo ExcludedProtocols=0
echo PreviewUserPw=1
echo PreviewDomain=0
echo PreviewPhoneNumber=0
echo PPP_IPv6Assign=1
echo PPP_IPv6Address=
echo PPP_IPv6PrefixLength=0
echo PPP_IPv6PrioritizeRemote=1
echo PPP_IPv6InterfaceMetric=0
echo PPP_IPv6NameAssign=1
echo PPP_IPv6DNSAddress=
echo PPP_IPv6DNS2Address=
echo PPP_IPv6GatewayAddress=
echo PPP_IPv6InterfaceIdentifier=
echo PPP_IPv6Prefix=0
echo PPP_IPv6InterfaceMetric=0
echo PPP_IPv6IfType=0
echo PPP_IPv6NameAssign=1
echo PPP_IPv6DnsFlags=0
echo PPP_IPv6ScopeId=
echo VPNStrategy=2
echo VPNStrategy=2
echo IPAddressType=0
echo DisableClassBasedDefaultRoute=0
echo DisableMobility=0
echo NetworkOutageTime=0
echo DisableIKENameEkuCheck=0
echo UseMachineRootCert=0
echo PrerequisiteEntry=%vpnServer%
echo PrerequisitePbk=
echo PPP_CallbackNumber=
echo PPP_CallbackType=0
echo PPP_PrerequisiteEntry=
echo PPP_PrerequisitePbk=
echo.
echo [Internet]
echo DefaultGateway=0.0.0.0
echo SubnetMask=0.0.0.0
echo ExcludedProtocols=0
echo EnableSecurity=1
echo EnableIpSec=0
echo PPP_CallbackNumber=
echo PPP_CallbackType=0
echo PPP_PrerequisiteEntry=
echo PPP_PrerequisitePbk=

REM Display VPN connection details
echo VPN Connection Details:
echo.
echo Name: %ConnectionName%
echo Server Address: %vpnServer%
echo Type: L2TP
echo Encryption Level: Required
echo Authentication Method: MSCHAPv2
echo Pre-Shared Key: %preSharedKey%
echo Username: %username%
echo Password: %password%
echo Remember Credentials: Yes
echo.
pause
