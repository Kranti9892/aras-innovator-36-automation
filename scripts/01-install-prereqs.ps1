Write-Host "=== Installing prerequisites ==="

############################
# 1) Install IIS (Windows 10/11 compatible)
############################
Write-Host "Installing IIS..."

$iisFeatures = @(
    "IIS-WebServerRole",
    "IIS-WebServer",
    "IIS-CommonHttpFeatures",
    "IIS-DefaultDocument",
    "IIS-DirectoryBrowsing",
    "IIS-HttpErrors",
    "IIS-StaticContent",
    "IIS-ManagementConsole"
)

foreach ($feature in $iisFeatures) {
    Write-Host "Enabling feature: $feature"
    dism.exe /online /enable-feature /featurename:$feature /all /norestart
}

Write-Host "IIS installation complete!"
Write-Host "---------------------------------------------"


############################
# 2) Install VC++ Redistributable
############################

$VcRedistExe = "C:\build\installers\vc_redist.x64.exe"

if (Test-Path $VcRedistExe) {
    Write-Host "Installing VC++ Runtime..."
    Start-Process -FilePath $VcRedistExe -ArgumentList "/install /quiet /norestart" -Wait
} else {
    Write-Host "ERROR: VC++ installer not found at $VcRedistExe"
    exit 1
}

Write-Host "VC++ Runtime installed."
Write-Host "---------------------------------------------"


############################
# 3) Install .NET Hosting Bundle
############################

$dotnetUrl = "https://download.visualstudio.microsoft.com/download/pr/21e40adf-861b-4ad9-8354-760bc6d2439b/9cfae449f3dcded6e9e4db696cd34f03/dotnet-hosting-8.0.1-win.exe"
$localDotnet = "C:\build\installers\dotnet-hosting.exe"

Write-Host "Downloading .NET Hosting Bundle..."

Invoke-WebRequest -Uri $dotnetUrl -OutFile $localDotnet -UseBasicParsing

Write-Host "Installing .NET Hosting Bundle..."
Start-Process -FilePath $localDotnet -ArgumentList "/quiet" -Wait

Write-Host ".NET Hosting Bundle installed."
Write-Host "---------------------------------------------"

Write-Host "=== Prerequisite installation completed ==="
