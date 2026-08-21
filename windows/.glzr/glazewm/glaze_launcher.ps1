<#
.SYNOPSIS
Launches a specific program based on the currently focused GlazeWM workspace.

.DESCRIPTION
This script queries GlazeWM to find which workspace currently has focus. It then uses a switch
statement to launch a pre-defined application associated with that workspace's name.

This script is designed to be called silently from the GlazeWM configuration file. It has
no parameters and requires glazewm.exe to be accessible in the system's PATH.

.EXAMPLE
# In your GlazeWM config.yaml:
- commands: ['shell-exec powershell.exe -WindowStyle Hidden -ExecutionPolicy Bypass -File "C:\path\to\this\script.ps1"']
  bindings: ['LWin+Z']

.OUTPUTS
None. This script launches processes but does not return any output.
#>

try {
    $workspacesData = glazewm.exe query workspaces | ConvertFrom-Json -ErrorAction Stop
}
catch {
    exit
}

$focusedWorkspaceName = $workspacesData.data.workspaces | Where-Object { $_.hasFocus -eq $true } | Select-Object -ExpandProperty name

if ([string]::IsNullOrEmpty($focusedWorkspaceName)) {
    exit
}

switch ($focusedWorkspaceName) {
    "S" {
        Start-Process -FilePath "C:\Program Files\Slack\slack.exe"
    }
    "N" {
        # rio rather than wezterm: it draws kitty graphics with unicode
        # placeholders, which corc's browser view needs and wezterm ignores.
        # The shell and tmux attach live in %LOCALAPPDATA%\rio\config.toml.
        Start-Process -FilePath "C:\Program Files\Rio\rio.exe"
    }
    "X" {
        Start-Process -FilePath "explorer.exe"
    }
    "I" {
        Start-Process -FilePath "C:\Program Files\Mozilla Firefox\firefox.exe"
    }
    "B" {
        Start-Process -FilePath "C:\Program Files\Mozilla Firefox\firefox.exe"
    }
    "C" {
        Start-Process -FilePath "explorer.exe" -ArgumentList "shell:AppsFolder\Claude_pzs8sxrjxfjjc!Claude"
    }
    "M" {
        Start-Process -FilePath "C:\Program Files\Mozilla Firefox\firefox.exe" -ArgumentList "--new-window gmail.com"
    }
    "Y" {
        Start-Process -FilePath "C:\Program Files\Mozilla Firefox\firefox.exe" -ArgumentList "--new-window https://www.youtube.com"
    }
    "E" {
        Start-Process -FilePath "C:\Users\hector.bjernersjo\AppData\Local\Programs\cursor\Cursor.exe"
    }
    "O" {
        Start-Process -FilePath "C:\Program Files\Obsidian\Obsidian.exe"
    }
    "D" {
        Start-Process -FilePath "C:\Program Files\JetBrains\JetBrains Rider 2025.1.1\bin\rider64.exe"
    }
    "G" {
        Start-Process -FilePath "C:\Users\hector.bjernersjo\AppData\Local\Programs\GIMP 3\bin\gimp-3.exe"
    }
}
