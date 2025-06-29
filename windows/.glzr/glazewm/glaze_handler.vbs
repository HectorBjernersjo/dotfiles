' glaze_handler.vbs
' Author: Gemini
' Description: A single VBScript to focus a GlazeWM workspace.
' If the workspace does not exist, it is created and an optional program is launched.
' This script is designed to be called from the GlazeWM config and runs silently.
'
' REQUIREMENTS:
'   - glazewm.exe must be in your system's PATH.
'   - jq.exe must be in your system's PATH.
'
' USAGE from GlazeWM config.yaml:
'   - commands: ['shell-exec wscript.exe "C:\path\to\this\script.vbs" -Letter "S" -ProgramToRun "slack.exe"']

Option Explicit

' --- VARIABLE DECLARATION ---
Dim objShell, objArgs
Dim workspaceLetter, programToRun, command, exec, output
Dim workspaceExists, i

' --- INITIALIZATION ---
Set objShell = CreateObject("WScript.Shell")
Set objArgs = WScript.Arguments
workspaceLetter = ""
programToRun = ""
workspaceExists = False

' --- PARSE COMMAND LINE ARGUMENTS ---
' VBScript doesn't have nice named parameters, so we loop through them.
For i = 0 To objArgs.Count - 1
    If LCase(objArgs(i)) = "-letter" And i + 1 < objArgs.Count Then
        workspaceLetter = objArgs(i + 1)
    ElseIf LCase(objArgs(i)) = "-programtorun" And i + 1 < objArgs.Count Then
        programToRun = objArgs(i + 1)
    End If
Next

' Exit if the required -Letter argument was not found
If workspaceLetter = "" Then
    WScript.Quit
End If

' --- CHECK IF WORKSPACE EXISTS ---
' 1. Run "glazewm query" and pipe the JSON output to "jq".
' 2. jq extracts just the names of the workspaces.
' 3. Read the output of jq to see if our workspaceLetter is in the list.
command = "cmd.exe /c glazewm.exe query workspaces | jq.exe .data.workspaces[].name"
Set exec = objShell.Exec(command)

' Read all the output from the command
output = exec.StdOut.ReadAll()

' Check if the workspace letter is in the output string.
' We add quotes to match the output from jq (e.g., "S").
If InStr(output, """" & workspaceLetter & """") > 0 Then
    workspaceExists = True
End If

' --- PERFORM ACTIONS ---
' 1. Always focus the workspace. GlazeWM will create it if it doesn't exist.
objShell.Run "cmd.exe /c glazewm.exe command focus --workspace " & workspaceLetter, 0, False

' 2. If the workspace did NOT exist and a program was specified, launch it.
If Not workspaceExists And programToRun <> "" Then
    ' Use "cmd /c start" as a robust way to launch programs without waiting
    objShell.Run "cmd /c start """" """ & programToRun & """", 0, False
End If

' --- CLEANUP ---
Set objShell = Nothing
Set objArgs = Nothing
Set exec = Nothing
