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

@FOR /f "tokens=2*" %%i in ('Reg Query "HKEY_CURRENT_USER\Software\VRChat" /ve 2^>Nul') do Set "ExePath=%%j"
If defined ExePath (echo VRChat path: "%ExePath%" ) Else ( 
    echo VRChat path not found...
    set /p ExePath=Enter VRChat path:
    echo VRChat path: "%ExePath%"
    )
echo Current path: %~dp0

echo Creating task.xml ...
powershell -Executionpolicy Bypass -NoProfile -Command "(gc VRCAutoLaunch.xml) -replace 'PATH1', '%ExePath%\VRChat.exe' -replace 'PATH2', '%~dp0VRCAutoLaunchOnce.exe' | Out-File task.xml"
echo Enabling Audit process Tracking ...
auditpol /set /category:"Detailed Tracking" /success:enable
gpupdate /force
echo Creating Task ...
schtasks /delete /tn VRCAutoLaunch /f
schtasks /create /xml task.xml /tn VRCAutoLaunch
del /q /f task.xml
echo Done!
timeout /T 10