Write-Host "=== Running Aras Update ==="

$Updater = "C:\Program Files\Aras Innovator\Innovator\Update.exe"

if (!(Test-Path $Updater)) {
    Write-Host "ERROR: Aras Update.exe not found!"
    exit 1
}

Start-Process -FilePath $Updater -ArgumentList "/s" -Wait

Write-Host "=== Aras Update Completed ==="
