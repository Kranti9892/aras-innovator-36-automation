# ===================================================================
# Aras Innovator 36 - Prerequisites Installer
# Works in Jenkins + Windows Server/Windows 10/11
# ===================================================================

Write-Host "=== Aras Innovator 36 - Installing Prerequisites ==="

# -------------------------------------------
# Fix TLS errors in Jenkins (Microsoft requires TLS 1.2+)
# -------------------------------------------
[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12

# -------------------------------------------
# Create installers folder
# -------------------------------------------
$installerRoot = "C:\build\installers"

if (!(Test-Path $installerRoot)) {
    Write-Host "Creating folder: $installerRoot"
    New-Item -Path $installerRoot -ItemType Directory -Force | Out-Null
}

# -------------------------------------------
# 1. Install IIS Web Server
# -------------------------------------------
Write-Host "=== Installing IIS Web Server ==="

try {
    Install-WindowsFeature Web-Server,
        Web-WebServer,
        Web-Common-Http,
        Web-Default-Doc,
        Web-Static-Content,
        Web-Http-Errors,
        Web-Http-Redirect,
        Web-Health,
        Web-Http-Logging,
        Web-Stat-Compression,
        Web-Mgmt-Tools -IncludeManagementTools

    Write-Host "IIS installation completed."
}
catch {
    Write-Host "ERROR installing IIS: $($_.Exception.Message)"
    exit 1
}

# -------------------------------------------
# 2. Download + Install .NET 8 Hosting Bundle
# -------------------------------------------
Write-Host "=== Downloading .NET 8 Hosting Bundle ==="

$dotnetUrl = "https://download.visualstudio.microsoft.com/download/pr/89c3a5f2-aa65-4e45-9232-c4aa7
