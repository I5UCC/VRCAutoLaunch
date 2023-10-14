@echo off

:: BatchGotAdmin
:-------------------------------------
REM  --> Check for permissions
    IF "%PROCESSOR_ARCHITECTURE%" EQU "amd64" (
>nul 2>&1 "%SYSTEMROOT%\SysWOW64\cacls.exe" "%SYSTEMROOT%\SysWOW64\config\system"
) ELSE (
>nul 2>&1 "%SYSTEMROOT%\system32\cacls.exe" "%SYSTEMROOT%\system32\config\system"
)

REM --> If error flag set, we do not have admin.
if '%errorlevel%' NEQ '0' (
    echo Requesting administrative privileges...
    goto UACPrompt
) else ( goto gotAdmin )

:UACPrompt
    echo Set UAC = CreateObject^("Shell.Application"^) > "%temp%\getadmin.vbs"
    set params= %*
    echo UAC.ShellExecute "cmd.exe", "/c ""%~s0"" %params:"=""%", "", "runas", 1 >> "%temp%\getadmin.vbs"

    "%temp%\getadmin.vbs"
    del "%temp%\getadmin.vbs"
    exit /B

:gotAdmin
    pushd "%CD%"
    CD /D "%~dp0"
:--------------------------------------    

for /f "tokens=4-5 delims=. " %%i in ('powershell -c wmic os get Caption') do set EDITION=%%i

if "%EDITION%" EQU "Home" (
	schtasks /create /tn "VRCAutoLaunch" /tr '%~dp0VRCAutoLaunch.exe' /sc onstart
	exit
)

@FOR /f "tokens=2*" %%i in ('Reg Query "HKEY_CURRENT_USER\Software\VRChat" /ve 2^>Nul') do Set "ExePath=%%j"
If defined ExePath (echo VRChat path: "%ExePath%" ) Else ( 
    echo VRChat path not found...
    set /p ExePath="Enter VRChat path (Folder):"
    echo VRChat path: "%ExePath%"
    )
echo Current path: %~dp0
SET /P correct=Is %ExePath% the correct path to VRChat? ([Y]/N)?

IF /I "%correct%" EQU "N" (
    set /p ExePath="Enter VRChat path (Folder):"
)

del /q /f task.xml
echo Creating task.xml ...
powershell -Executionpolicy Bypass -NoProfile -Command "(gc VRCAutoLaunch.xml) -replace 'PATH1', '%ExePath%\VRChat.exe' -replace 'PATH2', '%~dp0VRCAutoLaunch.exe' | Out-File task.xml"
echo Enabling Audit process Tracking ...
auditpol /set /category:"Detailed Tracking" /success:enable
gpupdate /force
echo Creating Task ...
schtasks /delete /tn VRCAutoLaunch /f
schtasks /create /xml task.xml /tn VRCAutoLaunch
echo Done!
timeout /T 10