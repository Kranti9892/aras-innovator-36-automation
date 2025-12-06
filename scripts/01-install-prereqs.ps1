Write-Host "=== Installing prerequisites ==="

# -------------------------------
# Variables
# -------------------------------
$InstallRoot = "C:\build\installers"
$DotNetUrl   = "https://aka.ms/dotnet/8.0/dotnet-hosting-win.exe"
$DotNetExe   = "$InstallRoot\dotnet-hosting.exe"

$VcRedistUrl = "https://aka.ms/vs/17/release/vc_redist.x64.exe"
$VcRedistExe = "$InstallRoot\vc_redist.x64.exe"

$IISFeatures = @(
    "Web-Server",
    "Web-WebServer",
    "Web-Common-Http",
    "Web-Default-Doc",
    "Web-Static-Content",
    "Web-Http-Errors",
    "Web-Asp-Net45",
    "Web-Net-Ext45"
)

# Ensure installer folder exists
if (!(Test-Path $InstallRoot)) {
    New-Item -ItemType Directory -Path $InstallRoot -Force
}

# -------------------------------
# Helper: File Downloader
# -------------------------------
function Download-File {
    param($Url, $OutFile)

    try {
        Write-Host "Downloading: $Url"
        Invoke-WebRequest -Uri $Url -OutFile $OutFile -UseBasicParsing
        return $true
    }
    catch {
        Write-Host "ERROR: Failed downloading file $Url"
        return $false
    }
}

# -------------------------------
# Install IIS
# -------------------------------
Write-Host "Installing IIS..."
Install-WindowsFeature -Name $IISFeatures -IncludeManagementTools -ErrorAction Stop

# -------------------------------
# Install .NET Hosting Bundle
# -------------------------------
if (!(Test-Path $DotNetExe)) {
    if (!(Download-File $DotNetUrl $DotNetExe)) { exit 1 }
}

Write-Host "Installing .NET Hosting Bundle..."
Start-Process -FilePath $DotNetExe -ArgumentList "/quiet", "/norestart" -Wait

# -------------------------------
# Install VC++ Redistributable 2015–2022
# -------------------------------
if (!(Test-Path $VcRedistExe)) {
    if (!(Download-File $VcRedistUrl $VcRedistExe)) { exit 1 }
}

Write-Host "Installing VC++ Redistributable..."
Start-Process -FilePath $VcRedistExe -ArgumentList "/quiet", "/norestart" -Wait

Write-Host "=== Prerequisites installation complete ==="
