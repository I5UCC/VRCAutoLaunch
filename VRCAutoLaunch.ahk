#NoEnv
SendMode Input
SetWorkingDir %A_ScriptDir%
#Persistent

#Include AutoHotkey-JSON/Jxon.ahk

global CloseOnQuit := []

Loop {
    Menu, Tray, Icon, Icons/Main.ico
    Menu, Tray, Tip , Waiting for VRChat to launch
    Process, Wait, VRChat.exe
    Menu, Tray, Icon, Icons/Waiting.ico
    Menu, Tray, Tip , Launching Programs...
    Sleep, 3000

    Fileread, file, config.json
    config := Jxon_Load(file)
    for each, obj in config {
        for index, d in obj {
            RunProgram(d)
        }
    }

    Menu, Tray, Icon, Icons/Launched.ico
    Menu, Tray, Tip , Waiting for VRChat to exit
    Process, WaitClose, VRChat.exe
    ClosePrograms()
}

RunProgram(d) {
    Process, Exist, vrmonitor.exe
    If ((!d.VROnly || !ErrorLevel) && d.VROnly) {
        Return
    }

    If (d.StartMinimized) {
        Run, % d.FileName . " " . d.Arguments, % d.WorkingDir, Min, temp
    }
    Else {
        Run, % d.FileName . " " . d.Arguments, % d.WorkingDir, , temp
    }

    If (d.CloseOnQuit) {
        CloseOnQuit.Push(temp)
    }
}

ClosePrograms() {
    for index, element in CloseOnQuit
    {
        Process, Close, %element%
    }
    CloseOnQuit := []
}