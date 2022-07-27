#NoEnv
SendMode Input
SetWorkingDir %A_ScriptDir%
#Persistent

#Include AutoHotkey-JSON/Jxon.ahk

global CloseOnQuit := []

Loop {
    Process, Wait, VRChat.exe
    Sleep, 5000

    Fileread, file, config.json
    config := Jxon_Load(file)
    for each, obj in config {
        for index, d in obj {
            RunProgram(d)
        }
    }

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
}