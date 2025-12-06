Write-Host "=== Installing prerequisites ==="

# 1. Install IIS
Write-Host "Installing IIS..."
$IISFeatures = "Web-Server","Web-WebServer","Web-Common-Http"

Install-WindowsFeature -Name $IISFeatures -IncludeManagementTools -ErrorAction Stop

Write-Host "IIS installed successfully!"

# 2. Install VC Redistributable (2015–2022)
Write-Host "Installing VC++ Redistributable..."

$VcUrl = "https://aka.ms/vs/17/release/vc_redist.x64.exe"
$VcPath = "$env:TEMP\vc_redist.x64.exe"

Invoke-WebRequest -Uri $VcUrl -OutFile $VcPath -UseBasicParsing

Start-Process -FilePath $VcPath -ArgumentList "/quiet", "/norestart" -Wait

Write-Host "VC Redistributable installed!"

# 3. Install .NET Hosting Bundle
Write-Host "Installing .NET Hosting Bundle..."

$DotnetUrl = "https://dotnet.microsoft.com/download/dotnet/thank-you/runtime-aspnetcore-8.0.1-windows-hosting-bundle-installer"
$DotnetExe = "$env:TEMP\dotnethosting.exe"

Invoke-WebRequest -Uri $DotnetUrl -OutFile $DotnetExe -UseBasicParsing

Start-Process -FilePath $DotnetExe -ArgumentList "/quiet", "/norestart" -Wait

Write-Host "DOTNET Hosting Bundle installed!"

Write-Host "=== Prerequisites installation completed! ==="
