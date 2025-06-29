<#
.SYNOPSIS
Focuses a GlazeWM workspace. If the workspace doesn't exist, it creates it and optionally launches a specified program.

.DESCRIPTION
This script first queries GlazeWM to see if a workspace with the given name (Letter) already exists.
It then focuses that workspace, which will create it if it's not already present.
If the workspace did NOT exist prior to the focus command, and a program is specified, the script will launch that program.

The script assumes that 'glazewm.exe' is available in your system's PATH.

.PARAMETER Letter
The name of the workspace to focus/create. This is a mandatory parameter.

.PARAMETER ProgramToRun
(Optional) The full path to a program to execute if the workspace does not already exist.
If the path contains spaces, enclose it in quotes.

.EXAMPLE
# Focuses workspace "Y". If "Y" doesn't exist, it's created, and notepad is launched.
PS C:\> .\check_workspace.ps1 -Letter "Y" -ProgramToRun "notepad.exe"

.EXAMPLE
# Focuses workspace "I". If "I" already exists, no program is launched.
PS C:\> .\check_workspace.ps1 -Letter "I" -ProgramToRun "explorer.exe"

.EXAMPLE
# Focuses workspace "N". If "N" doesn't exist, it's created, but no program is launched.
PS C:\> .\check_workspace.ps1 -Letter "N"

.OUTPUTS
None. This script performs actions but does not return a value.
#>
param(
    [Parameter(Mandatory = $true)]
    [string]$Letter,

    [Parameter(Mandatory = $false)]
    [string]$ProgramToRun = ""
)

$workspaceExists = $false

try {
    # Execute the glazewm query to get current workspaces
    $workspaceNames = (glazewm.exe query workspaces | ConvertFrom-Json).data.workspaces.name

    # Check if the provided letter is in the array of workspace names.
    if ($workspaceNames -contains $Letter) {
        $workspaceExists = $true
    }
}
catch {
    # Handle potential errors, such as glazewm.exe not being found or the output not being valid JSON.
    Write-Error "Failed to query GlazeWM workspaces. Please ensure glazewm.exe is running and accessible in your PATH."
    Write-Error "Error details: $_"
    # Exit the script if we can't query GlazeWM, as we cannot proceed safely.
    return
}

# Always focus the target workspace. GlazeWM will create it if it doesn't exist.
Write-Host "Focusing workspace '$Letter'..."
glazewm.exe command focus --workspace $Letter

# If the workspace was not found initially, and a program was provided, launch it.
if (-not $workspaceExists) {
    if ($ProgramToRun -ne "") {
        try {
            Write-Host "Workspace '$Letter' did not exist. Launching '$ProgramToRun'..."
            Start-Process $ProgramToRun -ErrorAction Stop
        }
        catch {
            Write-Error "Failed to start program: '$ProgramToRun'."
            Write-Error "Error details: $_"
        }
    }
    else {
        Write-Host "Workspace '$Letter' was newly created. No program specified to run."
    }
}
else {
     Write-Host "Workspace '$Letter' already existed."
}
