' glaze_handler_v4.vbs
' Author: Gemini
' Description: A single VBScript to launch a program based on the currently focused GlazeWM workspace.
' This script uses a temporary file to capture command output, preventing any flashing black windows.
'
' REQUIREMENTS:
'   - glazewm.exe must be in your system's PATH.
'   - jq.exe must be in your system's PATH.
'
' USAGE from GlazeWM config.yaml:
'   - commands: ['shell-exec wscript.exe "C:\path\to\this\script.vbs"']
'     bindings: ['LWin+Z'] ' Or any other desired keybinding

Option Explicit

' --- VARIABLE DECLARATION ---
Dim objShell, fso, tempFolder, tempFile, tempFilePath
Dim command, currentFocus, fileContents


' --- INITIALIZATION ---
Set objShell = CreateObject("WScript.Shell")
Set fso = CreateObject("Scripting.FileSystemObject")


' --- GET CURRENTLY FOCUSED WORKSPACE (SILENTLY) ---
' 1. Create a path for a temporary file to store the command output.
tempFolder = objShell.ExpandEnvironmentStrings("%TEMP%")
tempFilePath = "C:\Users\hector.bjernersjo\.glaze\glazewm\current_focus.txt"

' 2. Build the command to run glazewm/jq and redirect the output (>) to our temp file.
'    The "cmd /c" is necessary to handle the redirection.
command = "cmd.exe /c glazewm.exe query workspaces | jq.exe .data.workspaces[] | select(.hasFocus == true) | .name > """ & tempFilePath & """"

' 3. Run the command silently and wait for it to complete.
'    The "0" hides the window. The "True" forces the script to wait.
objShell.Run command, 0, True

objShell.Run "cmd /c start """" ""cursor """ & tempFilePath & """", 0, False
' WScript.Quit

' 4. Read the content from the temporary file.
If fso.FileExists(tempFilePath) Then
    Set tempFile = fso.OpenTextFile(tempFilePath, 1) ' 1 = ForReading
    If Not tempFile.AtEndOfStream Then
        fileContents = tempFile.ReadAll()
    End If
    tempFile.Close
    ' 5. Delete the temporary file.
    fso.DeleteFile tempFilePath
End If

' 6. Clean up the output.
currentFocus = Trim(Replace(fileContents, """", ""))


' Exit if no focused workspace was found
If currentFocus = "" Then
    WScript.Quit
End If

' --- PERFORM ACTIONS ---
' Launch a program based on the currently focused workspace.
'
' *** EDIT YOUR PROGRAM MAPPINGS HERE ***
'
' We use LCase() to make the comparison case-insensitive.
Select Case LCase(currentFocus)
    Case "s" ' <-- This now correctly matches LCase("S")
        ' If on workspace "S", launch Slack
        objShell.Run "cmd /c start """" ""C:\Program Files\Slack\slack.exe""", 0, False
    Case "n"
        ' If on workspace "N", launch Notepad
        objShell.Run "cmd /c start """" ""notepad.exe""", 0, False
    Case "i"
        ' If on workspace "I", launch File Explorer
        objShell.Run "cmd /c start """" ""explorer.exe""", 0, False
    
    ' --- ADD MORE CASES FOR YOUR WORKSPACES ---
    ' Case "y"
    '     objShell.Run "cmd /c start """" ""my_other_program.exe""", 0, False
    
End Select


' --- CLEANUP ---
Set fso = Nothing
Set objShell = Nothing
