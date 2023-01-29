;@Ahk2Exe-Let Version = 1.4
;@Ahk2Exe-IgnoreBegin
;@Ahk2Exe-IgnoreEnd
;@Ahk2Exe-SetMainIcon Icons/VRCAL_Main.ico
;@Ahk2Exe-SetVersion %U_Version%
;@Ahk2Exe-SetName VRCAutolaunch
;@Ahk2Exe-SetDescription VRCAutolaunch

SendMode Input
SetWorkingDir %A_ScriptDir%
#Persistent
#SingleInstance Force
#NoEnv
SetBatchLines -1

#Include AutoHotkey-JSON/Jxon.ahk

global CloseOnQuit := []
global running := 0

OnExit("ClosePrograms")

Loop {
    Menu, Tray, Icon, Icons/VRCAL_Main.ico
    Menu, Tray, Tip , VRCAutoLaunch`nWaiting for VRChat

    While (!running) {
        Process, Exist, VRChat.exe
        If (Errorlevel)
            running := 1
        Else
            Sleep, 5000
    }

    Menu, Tray, Icon, Icons/VRCAL_Waiting.ico
    Menu, Tray, Tip , VRCAutoLaunch`nLaunching Programs...

    Fileread, file, config.json
    config := Jxon_Load(file)
    for each, obj in config {
        for index, d in obj {
            RunProgram(d)
        }
    }

    Menu, Tray, Icon, Icons/VRCAL_Launched.ico
    Menu, Tray, Tip , VRCAutoLaunch`nWaiting for VRChat to exit

    While (running) {
        Process, Exist, VRChat.exe
        If (!Errorlevel)
            running := 0
        Else
            Sleep, 5000
    }

    ClosePrograms()
    
    if (A_Args[1] = "--once") {
        ExitApp
    }
}

RunProgram(d) {
    If (d.WorkingDir == "" || d.FileName == "") {
        Menu, Tray, Icon, Icons/VRCAL_Error.ico
        Menu, Tray, Tip , VRCAutoLaunch`nERROR
        MsgBox, Either WorkingDir or FileName not set`, check your configuration. Exiting program...
        ExitApp
    }

    StringRight, checkvar, % d.WorkingDir, 1
    If (checkvar != "/")
        d.WorkingDir := d.WorkingDir . "/"
    file := d.WorkingDir . d.FileName
    
    If (FileExist(file) == "") {
        Menu, Tray, Icon, Icons/VRCAL_Error.ico
        Menu, Tray, Tip , VRCAutoLaunch`nERROR
        MsgBox, File %file% does not exist`, check your configuration. Exiting program...
        ExitApp
    }
    
    Process, Exist, vrmonitor.exe
    If ((!d.VROnly || !ErrorLevel) && d.VROnly) {
        Return
    }

    If (d.StartMinimized == 1) {
        Run, % d.FileName . " " . d.Arguments, % d.WorkingDir, Min, temp
    }
    Else {
        Run, % d.FileName . " " . d.Arguments, % d.WorkingDir, , temp
    }

    If (d.StartMinimized == 2) {
        WinWait, ahk_pid %temp%
        Sleep, 500
        WinMinimize, ahk_pid %temp%
    }

    If (d.CloseOnQuit) {
        CloseOnQuit.Push(temp)
        CloseOnQuit.Push(d.FileName)
    }
}

ClosePrograms() {
    for index, element in CloseOnQuit
    {
        Process, Exist, %element%
        While (ErrorLevel) {
            Process, Close, %element%
        }
    }
    CloseOnQuit := []
}
