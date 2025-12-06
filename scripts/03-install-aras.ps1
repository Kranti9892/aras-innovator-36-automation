Write-Host "=== Running Aras Innovator Installer ==="

$Installer = "C:\build\installers\ArasInnovator.msi"

if (!(Test-Path $Installer)) {
    Write-Host "ERROR: Aras installer not found!"
    exit 1
}

Start-Process "msiexec.exe" `
    -ArgumentList "/i `"$Installer`" /quiet /norestart" `
    -Wait

Write-Host "=== Aras Innovator Installed Successfully ==="
