@echo off
mode 38,20
title Network Stats
echo Loading Network information... 
setlocal enabledelayedexpansion

:: Set the console text color to green
echo|set /p=[32m

:loop

for /f "tokens=2 delims=:" %%a in ('netsh wlan show interface ^| findstr "SSID"') do (
    set ssid=%%a
)

for /f "tokens=2 delims=:" %%a in ('netsh wlan show interface ^| findstr "Description"') do (
    set adapter=%%a
)

for /f "tokens=2 delims=:" %%a in ('netsh wlan show interface ^| findstr "State"') do (
    set state=%%a
)

for /f "tokens=2 delims=:" %%a in ('netsh wlan show interface ^| findstr "Signal"') do (
    set signal=%%a
)

ping -n 3 8.8.8.8 > %temp%\ping.txt

set ping=

for /f "tokens=1,2 delims== " %%a in ('findstr "Average" %temp%\ping.txt') do (
    set ping=%%b
)

for /f "tokens=10 delims= " %%a in ('type %temp%\ping.txt ^| find "Lost"') do set ploss=%%a

for /f "tokens=2,3 delims= " %%a in ('netstat -e ^| find "Bytes"') do (
    set rbytes=%%a
    set sbytes=%%b
)

cls
echo [32m Network:
echo [32m --------
echo [32m SSID: !ssid!
echo [32m NIC: !adapter!
echo [32m State: !state!
echo [32m Signal Strength: !signal!
echo. 
echo [32m Speed:
echo [32m ------
echo [32m Ping: !ping!
echo [32m Packet Loss: !ploss! 
echo [32m Received: !rbytes! Bytes
echo [32m Sent: !sbytes! Bytes
goto loop
