@echo off
C:\UDK\UDK-2012-07\Binaries\Win32\UDK.com make
IF errorlevel 1 GOTO :ERROR_EXIT
START C:\UDK\UDK-2012-07\Binaries\Win32\UDK.exe editor MagicalTestMap.udk
GOTO :GOOD_EXIT
:ERROR_EXIT
pause
exit /b %ERRORLEVEL%
:GOOD_EXIT
exit 0