# smart_focus.ps1 - v3 (JSON-aware)
#
# Determines whether to just focus a workspace or launch a program in it.
#

param(
  [string]$WorkspaceName,
  [string]$CommandToRun
)

# --- CONFIGURATION ---
# The full path to the GlazeWM executable.
# Verify this path is correct for your system.
# $glazeExePath = "$env:LOCALAPPDATA\Programs\glazewm\glazewm.exe"
$glazeExePath = "glazewm.exe"
# ---------------------

# Verify that glazewm.exe exists at the specified path.
if (-not (Test-Path $glazeExePath)) {
    # You can uncomment the lines below to get a popup error if the path is wrong.
    # Add-Type -AssemblyName PresentationCore,PresentationFramework
    # [System.Windows.MessageBox]::Show("Error: glazewm.exe not found at $glazeExePath", "GlazeWM Script Error")
    exit
}

# --- SCRIPT LOGIC ---

# 1. Query GlazeWM for the full JSON state of all workspaces.
#    The `query workspaces` command provides the structured data we need.
$jsonState = & $glazeExePath query workspaces | ConvertFrom-Json

# 2. Check if the query was successful and data exists.
if (($null -eq $jsonState) -or (-not $jsonState.success)) {
    # The command failed; exit gracefully.
    exit
}

# 3. Find the target workspace in the list of workspaces that currently have windows.
#    We search the 'workspaces' array for an object with a matching name.
$targetWorkspace = $jsonState.data.workspaces | Where-Object { $_.name -eq $WorkspaceName }

# 4. Decide what to do based on whether the workspace was found.
if ($null -ne $targetWorkspace) {
    # ---- WORKSPACE EXISTS (it has windows) ----
    # The workspace was found in the list, meaning it already has at least one window.
    # We simply focus it.
    & $glazeExePath command focus --workspace $WorkspaceName
}
else {
    # ---- WORKSPACE IS EMPTY (or not in the active tree) ----
    # The workspace was not found, meaning it's empty.
    # First, we focus the empty workspace to make it the target for new windows.
    & $glazeExePath command focus --workspace $WorkspaceName

    # Give the system a brief moment to register the focus change.
    Start-Sleep -Milliseconds 50

    # Second, launch the desired program. GlazeWM will place it in the newly active workspace.
    Start-Process $CommandToRun
}
