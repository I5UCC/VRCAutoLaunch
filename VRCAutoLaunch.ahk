;@Ahk2Exe-Let Version = 1.4
;@Ahk2Exe-IgnoreBegin
;@Ahk2Exe-IgnoreEnd
;@Ahk2Exe-SetMainIcon icon.ico
;@Ahk2Exe-SetVersion %U_Version%
;@Ahk2Exe-SetName VRCAutolaunch
;@Ahk2Exe-SetDescription VRCAutolaunch
;@Ahk2Exe-Bin Unicode 64*
;@Ahk2Exe-Obey U_au, = "%A_IsUnicode%" ? 2 : 1 ; .Bin file ANSI or Unicode?
;@Ahk2Exe-PostExec "BinMod.exe" "%A_WorkFileName%"
;@Ahk2Exe-Cont  "%U_au%2.>AUTOHOTKEY SCRIPT<. DATA              "

SendMode Input
SetWorkingDir %A_ScriptDir%
#Persistent
#SingleInstance Force
#Persistent
#NoEnv
SetBatchLines -1

#Include AutoHotkey-JSON/Jxon.ahk

global CloseOnQuit := []
global running := 0

Loop {
    Menu, Tray, Icon, Icons/VRCAL_Main.ico
    Menu, Tray, Tip , VRCAutoLaunch: Waiting for VRChat

    While (!running) {
        Process, Exist, VRChat.exe
        If (Errorlevel)
            running := 1
        Else
            Sleep, 5000
    }

    Menu, Tray, Icon, Icons/VRCAL_Waiting.ico
    Menu, Tray, Tip , VRCAutoLaunch: Launching Programs...

    Fileread, file, config.json
    config := Jxon_Load(file)
    for each, obj in config {
        for index, d in obj {
            RunProgram(d)
        }
    }

    Menu, Tray, Icon, Icons/VRCAL_Launched.ico
    Menu, Tray, Tip , VRCAutoLaunch: Waiting for VRChat to exit

    While (running) {
        Process, Exist, VRChat.exe
        If (!Errorlevel)
            running := 0
        Else
            Sleep, 5000
    }

    ClosePrograms()
}

RunProgram(d) {
    If (d.WorkingDir == "" || d.FileName == "") {
        Menu, Tray, Icon, Icons/VRCAL_Error.ico
        Menu, Tray, Tip , VRCAutoLaunch: ERROR
        MsgBox, Either WorkingDir or FileName not set`, check your configuration. Exiting program...
        ExitApp
    }

    StringRight, checkvar, % d.WorkingDir, 1
    If (checkvar != "/")
        d.WorkingDir := d.WorkingDir . "/"
    file := d.WorkingDir . d.FileName
    
    If (FileExist(file) == "") {
        Menu, Tray, Icon, Icons/VRCAL_Error.ico
        Menu, Tray, Tip , VRCAutoLaunch: ERROR
        MsgBox, File %file% does not exist`, check your configuration. Exiting program...
        ExitApp
    }
    
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
