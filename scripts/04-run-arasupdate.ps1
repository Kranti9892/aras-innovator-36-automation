$arasUpdate = "C:\Program Files (x86)\Aras\Aras Update\ArasUpdate.exe"

if (!(Test-Path $arasUpdate)) {
    throw "ArasUpdate tool not found."
}

Start-Process -FilePath $arasUpdate -Wait
Write-Host "ArasUpdate execution completed."
