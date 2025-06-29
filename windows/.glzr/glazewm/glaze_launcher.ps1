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
        Start-Process -FilePath "C:\Program Files\WezTerm\wezterm-gui.exe"# -ArgumentList "wsl" # tmux attach-session -t default || tmux new-session -s default"
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
        Start-Process -FilePath "C:\Program Files\Mozilla Firefox\firefox.exe" -ArgumentList "--new-window https://gemini.google.com/gem/a81c507221e7"
    }
    "M" {
        Start-Process -FilePath "C:\Program Files\Mozilla Firefox\firefox.exe" -ArgumentList "--new-window gmail.com"
    }
    "Y" {
        Start-Process -FilePath "C:\Program Files\Mozilla Firefox\firefox.exe" -ArgumentList "--new-window https://www.youtube.com"
    }
    "E" {
        Start-Process -FilePath "cursor"
    }
    "O" {
        Start-Process -FilePath "C:\Program Files\Obsidian\Obsidian.exe"
    }
    "D" {
        Start-Process -FilePath "C:\Program Files\JetBrains\JetBrains Rider 2025.1.1\bin\rider64.exe"
    }
}
