Write-Host "=== Installing prerequisites ==="

# --- VARIABLES ---
$VcRedist = "C:\build\installers\vc_redist.x64.exe"
$DotNetInstaller = "C:\build\installers\dotnet-hosting.exe"

$DotNetUrl = "https://download.visualstudio.microsoft.com/download/pr/57b33f2a-035e-44a5-a12e-26384e82fa64/8cf236503d17b47779fba399a097e68f/dotnet-hosting-8.0.1-win.exe"

# -----------------------------------------
# 1️⃣ INSTALL VC++ REDISTRIBUTABLE
# -----------------------------------------
Write-Host "Installing VC++ Redistributable..."

if (Test-Path $VcRedist) {
    Write-Host "Found vc_redist.x64.exe — installing..."
    Start-Process -FilePath $VcRedist -ArgumentList "/quiet", "/norestart" -Wait
}
else {
    Write-Host "ERROR: vc_redist.x64.exe not found at $VcRedist"
    exit 1
}

# -----------------------------------------
# 2️⃣ DOWNLOAD & INSTALL .NET HOSTING BUNDLE
# -----------------------------------------
Write-Host "Installing .NET Hosting Bundle..."

if (-Not (Test-Path $DotNetInstaller)) {
    Write-Host "Downloading .NET Hosting Bundle..."
    try {
        Invoke-WebRequest -Uri $DotNetUrl -OutFile $DotNetInstaller -UseBasicParsing
    }
    catch {
        Write-Host "ERROR downloading .NET Hosting bundle"
        Write-Host $_
        exit 1
    }
}

Write-Host "Installing .NET Hosting..."
Start-Process $DotNetInstaller -ArgumentList "/quiet", "/norestart" -Wait

# -----------------------------------------
# 3️⃣ ENABLE IIS ON WINDOWS 10/11 USING DISM
# -----------------------------------------
Write-Host "Installing IIS..."

$IIS = @(
    "IIS-WebServerRole",
    "IIS-WebServer",
    "IIS-CommonHttpFeatures",
    "IIS-DefaultDocument",
    "IIS-StaticContent",
    "IIS-HttpErrors",
    "IIS-HttpLogging",
    "IIS-RequestFiltering",
    "IIS-ASPNET45",
    "IIS-NetFxExtensibility45"
)

foreach ($feature in $IIS) {
    Write-Host "Enabling: $feature"
    dism.exe /online /enable-feature /featurename:$feature /all /norestart | Out-Null
}

Write-Host "IIS installation completed."

# -----------------------------------------
# 4️⃣ INSTALL ASP.NET CORE MODULE FOR IIS
# -----------------------------------------
Write-Host "Installing ASP.NET Core Module (Included with .NET Hosting Bundle)..."
# Already installed by Hosting Bundle — nothing extra needed.

Write-Host "=== Prerequisite installation completed successfully ==="
exit 0
