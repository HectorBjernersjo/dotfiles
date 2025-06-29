# Define the registry path and value name
$registryPath = "HKCU:\Software\Microsoft\Windows\CurrentVersion\Policies\System"
$name = "DisableLockWorkstation"
$value = 1 # 1 means disabled

# Check if the path exists, create if not
If (-not (Test-Path $registryPath)) {
    New-Item -Path $registryPath -Force | Out-Null
}

# Set the registry value (corrected for older PowerShell versions)
Set-ItemProperty -Path $registryPath -Name $name -Value $value -Force

Write-Host "Windows+L lock has been disabled."
