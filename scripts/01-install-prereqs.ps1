Write-Host "`n=== Installing prerequisites ===`n"

[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12

$InstallRoot = "C:\build\installers"
if (!(Test-Path $InstallRoot)) {
    New-Item -Path $InstallRoot -ItemType Directory -Force | Out-Null
}

function DownloadFile($Url, $OutFile) {
    Write-Host "Downloading: $Url"
    try {
        Invoke-WebRequest -Uri $Url -OutFile $OutFile -UseBasicParsing
        return $true
    } catch {
        Write-Host "ERROR downloading file: $($_.Exception.Message)"
        return $false
    }
}

# IIS
Write-Host "Installing IIS..."
dism.exe /Online /Enable-Feature /FeatureName:IIS-WebServerRole /All /Quiet /NoRestart
dism.exe /Online /Enable-Feature /FeatureName:IIS-WebServer /All /Quiet /NoRestart

# .NET Hosting Bundle
$DotNetUrl = "https://download.visualstudio.microsoft.com/download/pr/d4d25f55-a3ee-4ad2-a1b1-2ce63b47d01a/1a4c6c6c3b5f4bb76f1e1a12422bbef4/dotnet-hosting-8.0.1-win.exe"
$DotNetExe = "$InstallRoot\dotnet-hosting.exe"

if (!(Test-Path $DotNetExe)) {
    if (!(DownloadFile $DotNetUrl $DotNetExe)) { exit 1 }
}

Start-Process -FilePath $DotNetExe -ArgumentList "/quiet","/norestart" -Wait

# VC++ Redistributable
$VcUrl = "https://aka.ms/vs/17/release/vc_redist.x64.exe"
$VcExe = "$InstallRoot\vc_redist.x64.exe"

if (!(Test-Path $VcExe)) {
    if (!(DownloadFile $VcUrl $VcExe)) { exit 1 }
}

Start-Process $VcExe -ArgumentList "/quiet","/norestart" -Wait

Write-Host "`n=== Prerequisites installed successfully ==="
exit 0
