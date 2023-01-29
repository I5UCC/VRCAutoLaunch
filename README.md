# VRCAutolaunch

A lightweight program that Automatically launches external programs with VRChat.

Useful if you use a boatload of different OSC programs and dont want to start them manually every time you start VRChat.

# Install
1 - Download the [newest release](https://github.com/I5UCC/VRCAutolaunch/releases/latest)<br>

2 - Unpack the zip somewhere it will stay in. e.g. C:/.<br>

3a - ***If you DON'T have Windows Home Edition***:<br>
- Run ***install.bat*** with **Admin Priviliges**.<br>
***install.bat*** activates Audit process tracking and creates a Scheduled Task with a custom filter to automatically start with vrchat.<br>

3b - ***If you DO have Windows Home Edition***:<br>
- Create a shortcut of the VRCAutoLaunch.exe and place it in ***shell:startup*** or ***create a Scheduled task*** that runs ***VRCAutoLaunch.exe*** on startup and launch the program manually.<br>

4 -  Add all your programs to config.json. look under [#Usage](https://github.com/I5UCC/VRCAutoLaunch#usage) on how to do that.<br>

5 -  Now all of your programs will run on VRChat startup!<br>

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
***"StartMinimized":*** determines if the program should be started minimized or normally. Values are either 0 (false), 1 (true) or 2(legacy). legacy minimizing waits until the window was opened, then minimizes it. Some programs dont want to work unless it is done this way.<br>
***"CloseOnQuit":*** determines if the program should close whenever the game is closed. Values are either 0 (false) or 1 (true) <br>
***"VROnly":*** determines if the program should be autostarted only in VR or always. Values are either 0 (false) or 1 (true).

All the Entries in that list are seperated by a comma ',' and follow the syntax of json. 

### Heres an example on how a configuration might look:

```
{
  "ProgramList": [
    {
      
      "FileName": "vor.exe",
      "WorkingDir": "F:/Program Files/vor/bin/",
      "Arguments": "--enable-on-start",
      "StartMinimized": 2,
      "CloseOnQuit": 1,
      "VROnly": 0
    },
    {
      
      "FileName": "cmd.exe",
      "WorkingDir": "C:/Windows/System32/",
      "Arguments": "/c start steam://run/1009850/",
      "StartMinimized": 1,
      "CloseOnQuit": 0,
      "VROnly": 1
    },
    {
      "FileName": "HRtoVRChat_OSC.exe",
      "WorkingDir": "F:/Program Files/HRtoVRChat/HRtoVRChat_OSC/",
      "Arguments": "",
      "StartMinimized": 1,
      "CloseOnQuit": 1,
      "VROnly": 0
    },
    {
      "FileName": "ThumbParamsOSC_NoConsole.exe",
      "WorkingDir": "F:/Program Files/ThumbParamsOSC/",
      "Arguments": "",
      "StartMinimized": 0,
      "CloseOnQuit": 1,
      "VROnly": 1
    },
    {
      "FileName": "TextboxSTT.exe",
      "WorkingDir": "F:/Program Files/TextboxSTT",
      "Arguments": "",
      "StartMinimized": 1,
      "CloseOnQuit": 1,
      "VROnly": 0
    },
    {
      "FileName": "VRCDiscordMute_NoConsole.exe",
      "WorkingDir": "F:/Program Files/VRCDiscordMute",
      "Arguments": "",
      "StartMinimized": 0,
      "CloseOnQuit": 1,
      "VROnly": 0
    }
  ]
}
```
