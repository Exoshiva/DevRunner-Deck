Set objShell = CreateObject("WScript.Shell")
Set objFSO = CreateObject("Scripting.FileSystemObject")

' Den Pfad des aktuellen Ordners holen (damit es vom Stick/Ordner funktioniert)
strPath = objFSO.GetParentFolderName(WScript.ScriptFullName)

' Befehl zusammenbauen
strCommand = "powershell.exe -NoLogo -NoProfile -WindowStyle Hidden -ExecutionPolicy Bypass -File """ & strPath & "\launcher.ps1"""

' Die 0 am Ende ist der Magic Key: 0 = HIDE WINDOW
objShell.CurrentDirectory = strPath
objShell.Run strCommand, 0, False