# Copies the ConPTY build rio needs into its install directory.
#
# Rio loads conpty.dll from its own directory, the way wezterm does. Without it
# rio falls back to the system ConPTY, which swallows the kitty graphics escapes
# coming out of WSL - so corc's browser view stays blank. Verified needed on
# Windows 11 25H2 (26200.9106); being up to date is not enough.
#
# Needs admin only because Rio lives under Program Files. Re-run this after a
# `winget upgrade rio` replaces the install directory.
$src = Join-Path $env:LOCALAPPDATA 'rio\conpty-backup'
$dst = 'C:\Program Files\Rio'
Copy-Item (Join-Path $src '*') -Destination $dst -Force
Get-ChildItem $dst -Include conpty.dll, OpenConsole.exe | Select-Object Name, Length
