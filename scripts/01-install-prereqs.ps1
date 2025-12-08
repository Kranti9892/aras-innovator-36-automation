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


Write-Host "Starting Full .NET 8 + IIS + Hosting Bundle Setup..." -ForegroundColor Cyan

# ---------------- ADMIN CHECK ----------------
If (-NOT ([Security.Principal.WindowsPrincipal] `
    [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole(`
    [Security.Principal.WindowsBuiltInRole] "Administrator"))
{
    Write-Host "ERROR: Please RUN PowerShell as Administrator." -ForegroundColor Red
    Pause
    Exit
}

# ---------------- CHECK WINGET ----------------
$winget = Get-Command winget -ErrorAction SilentlyContinue
If (-NOT $winget)
{
    Write-Host "ERROR: winget is not available on this system." -ForegroundColor Red
    Write-Host "Please install 'App Installer' from Microsoft Store." -ForegroundColor Yellow
    Pause
    Exit
}

Write-Host "winget detected successfully." -ForegroundColor Green

# ---------------- INSTALL IIS ----------------
Write-Host "Installing IIS and required features..." -ForegroundColor Yellow

dism /online /enable-feature /featurename:IIS-WebServerRole /all /norestart
dism /online /enable-feature /featurename:IIS-WebServer /all /norestart
dism /online /enable-feature /featurename:IIS-ISAPIExtensions /all /norestart
dism /online /enable-feature /featurename:IIS-ISAPIFilter /all /norestart
dism /online /enable-feature /featurename:IIS-ASPNET45 /all /norestart

Write-Host "IIS installation completed." -ForegroundColor Green

# ---------------- INSTALL .NET 8 RUNTIME ----------------
Write-Host "Installing .NET 8 Runtime..." -ForegroundColor Yellow
winget install Microsoft.DotNet.Runtime.8 --accept-source-agreements --accept-package-agreements

# ---------------- INSTALL ASP.NET CORE RUNTIME ----------------
Write-Host "Installing ASP.NET Core Runtime 8..." -ForegroundColor Yellow
winget install Microsoft.DotNet.AspNetCore.8 --accept-source-agreements --accept-package-agreements

# ---------------- INSTALL IIS HOSTING BUNDLE (MOST IMPORTANT) ----------------
Write-Host "Installing IIS Hosting Bundle 8..." -ForegroundColor Yellow
winget install Microsoft.DotNet.HostingBundle.8 --accept-source-agreements --accept-package-agreements

# ---------------- WAIT ----------------
Start-Sleep -Seconds 10

# ---------------- FINAL VERIFICATION ----------------
$modulePath = "C:\Program Files\IIS\Asp.Net Core Module\V2\aspnetcorev2.dll"

If (Test-Path $modulePath)
{
    Write-Host "SUCCESS: ASP.NET Core IIS Hosting Bundle Installed Correctly." -ForegroundColor Green
}
Else
{
    Write-Host "WARNING: Hosting Bundle not detected yet." -ForegroundColor Yellow
    Write-Host "A restart is REQUIRED to finalize installation." -ForegroundColor Yellow
}

Write-Host "============================================================" -ForegroundColor Cyan
Write-Host "FINAL STEP: RESTART YOUR MACHINE NOW" -ForegroundColor Cyan
Write-Host "============================================================" -ForegroundColor Cyan

Pause

