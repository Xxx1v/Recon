@echo off
title Recon
color F
call :banner
goto typecmd

:typecmd
set c=
set /P c="[1;92m%username%|[0m[95mRecon[0m[1;92m - [0m

if /I "%c%" EQU "help" goto help
if /I "%c%" EQU "exit" goto exit
if /I "%c%" EQU "myip" goto myip
if /I "%c%" EQU "clear" goto clear
if /I "%c%" EQU "tracemac" goto tracemac
if /I "%c%" EQU "locate" goto locate
if /I "%c%" EQU "listen" goto listen
if /I "%c%" EQU "scan" goto scan
if /I "%c%" EQU "trace" goto trace
if /I "%c%" EQU "ports" goto ports
if /I "%c%" EQU "dos" goto dos
if /I "%c%" EQU "about" goto about
goto typecmd

:about
cls
echo.
echo ReconV1.2
echo Created by Red Fish(@Xxx1v)
echo About program: Recon is simple net stuff
echo.
echo [91m!The developer of this tool will not be held responsible for its illegal use, and the user is responsible for violating any law![0m
pause >nul
goto clear



:help
echo about    - About this program
echo locate   - Find location of an Ip adress
echo trace    - Get the Device/Domain name from Ip address
echo tracemac - Trace Ip adress
echo  help    - list all commands
echo  myip    - List your Private and Public Ip adress
echo clear    - Clear console
echo  exit    - Exits console
echo  scan    - Scan your Network  for Ip address
echo ports    - Ports Scanner
echo  dos     - DoS(Denial of Service) Atack
goto typecmd



:exit
exit

:myip
for /f "tokens=2 delims=: " %%a in ('nslookup myip.opendns.com resolver1.opendns.com ^| findstr /i "Address: "') do set publicIP=%%a
echo Your Public Ip is: %publicIP%
for /f "tokens=2 delims=:" %%a in ('ipconfig ^| findstr /R /C:"IPv4.*"') do (
    set yourip=%%a
)
echo Your Private Ip address is:%yourip%
goto typecmd

:clear
cls
color F
call :banner
goto typecmd

:tracemac
set /p ipaddress="Enter Ip address: "
ping -n 1 -w 100 %ipaddress% >nul
	for /f "tokens=2" %%a in ('arp -a %ipaddress% ^| findstr %ipaddress%') do (
    set macaddress=%%a
)
if defined macaddress (
    echo MAC address for Ip %ipaddress% is: %macaddress%
) else (
    echo MAC address for Ip %ipaddress% has not been found.
)
goto typecmd

:locate
set /p ip=Enter ip adress: 
echo Ip localization %ip%...
echo Geographical location:
curl -s http://ip-api.com/line/%ip%?fields=country,regionName,city,zip,lat,lon
goto typecmd





:scan
cls
setlocal enableextensions
set /p subnet="Enter primary IP address (e.g. 192.168.1.): "
for /l %%i in (1,1,254) do (
    ping -n 1 -w 100 %subnet%%%i | find "Reply from" >nul && echo %subnet%%%i: [92monline[0m
)
endlocal
pause
goto clear

:trace
echo.
set /p ip=Enter Ip adress: 
for /f "tokens=2 delims= " %%a in ('nslookup %ip% ^| find "Name"') do set dns=%%a
echo.
echo Domain Name: %dns%
goto typecmd



:ports
set /p ip=Enter IP address: 
set /p ports=Enter ports(e.g. 21,22,23): 
cls
echo I check the open ports for %ip%...
for %%p in (%ports%) do (
    powershell -Command "$erroractionpreference = 'SilentlyContinue'; $tcp = new-object Net.Sockets.TcpClient; $tcp.Connect('%ip%', %%p); if ($tcp.Connected) { echo Port %%p: [92mopen[0m } else { echo Port %%p: [31mclosed[0m }; $tcp.Close()"
)
pause >nul
goto clear

:dos
cls
color a
setlocal
color a
set /p ip=Enter Ip address: 
set /p port=Enter port: 
set /p packets=Enter number of packets: 
for /L %%a in (1,1,%packets%) do (
    echo Packet %%a > packet.txt
    powershell -Command "& { $erroractionpreference = 'SilentlyContinue'; $socket = New-Object System.Net.Sockets.TCPClient('%ip%',%port%); $stream = $socket.GetStream(); $writer = New-Object System.IO.StreamWriter($stream); $writer.Write('$(Get-Content packet.txt)'); $writer.Flush(); $socket.Close() }"
)
del packet.txt
endlocal
pause >nul
goto clear


:banner
echo   [95m######                               [0m                               
echo   [95m#     # ######  ####   ####  #    #  [0m 
echo   [95m#     # #      #    # #    # ##   #  [0m   
echo   [95m######  #####  #      #    # # #  #  [0m 
echo   [95m#   #   #      #      #    # #  # #  [0m   
echo   [95m#    #  #      #    # #    # #   ##  [0m
echo   [95m#     # ######  ####   ####  #    #  [0m
echo.
echo.
echo [45mTip: Type "help" to list all commands [0m [30mh[0m
echo.
