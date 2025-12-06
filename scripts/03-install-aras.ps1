param(
    [string]$InstallerPath = "C:\build\installers\Aras_36_Setup.exe"
)

if (!(Test-Path $InstallerPath)) {
    throw "Aras 36 Installer not found at $InstallerPath"
}

Write-Host "Launching Aras 36 Installer..."
Start-Process -FilePath $InstallerPath -Wait

Write-Host "Aras installer completed."
