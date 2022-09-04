# VRCAutolaunch

A lightweight program that Automatically launches external programs with VRChat, 
needs to be run in the background at all times, shows status in the system tray. Useful if you use a boatload of different OSC programs and dont want to start them manually every time you start VRChat.

# [Download here](https://github.com/I5UCC/VRCAutolaunch/releases/download/v1.0/VRCAutolaunch_v1.0.zip)

# Usage
To add a program to your Autolaunch, you need to edit the config.json file. <br>
It looks as follows: 
```
{
  "ProgramList": [
    {
      "FileName": "",
      "WorkingDir": "",
      "Arguments": "",
      "StartMinimized": 1,
      "CloseOnQuit": 1,
      "VROnly": 1
    }
  ]
}
```

***"FileName":*** full name of the .exe file <br>
***"WorkingDir":*** is the directory of your executable. <br>
***"Arguments":*** if you need any, can leave empty. <br>
***"StartMinimized":*** determines if the program should be started minimized or normally. <br>
***"CloseOnQuit":*** determines if the program should close whenever the game is closed. Values are either 0 (false) or 1 (true).  <br>
***"VROnly":*** determines if the program should be autostarted only in VR or always. Values are either 0 (false) or 1 (true).

### Example:

```
{
  "ProgramList": [
    {
      "FileName": "ThumbParamsOSC.exe",
      "WorkingDir": "F:/Program Files/ThumbParamsOSC/",
      "Arguments": "",
      "StartMinimized": 1,
      "CloseOnQuit": 1,
      "VROnly": 1
    },
    {
      "FileName": "filename.exe",
      "WorkingDir": "C:/Path/to/Folder,
      "Arguments": "--test --x 2",
      "StartMinimized": 0,
      "CloseOnQuit": 0,
      "VROnly": 1
    },
    {
      "FileName": "filename2.exe",
      "WorkingDir": "C:/Path/to/Folder2,
      "Arguments": "--debug",
      "StartMinimized": 0,
      "CloseOnQuit": 0,
      "VROnly": 0
    }
  ]
}
```
