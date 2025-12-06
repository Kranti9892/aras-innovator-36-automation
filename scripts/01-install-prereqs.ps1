Write-Host "Installing IIS prerequisites..."

dism.exe /Online /Enable-Feature /FeatureName:IIS-WebServerRole /All /Quiet /NoRestart
dism.exe /Online /Enable-Feature /FeatureName:IIS-WebServer /All /Quiet /NoRestart
dism.exe /Online /Enable-Feature /FeatureName:IIS-CommonHttpFeatures /All /Quiet /NoRestart


Write-Host "Installing .NET 8 Hosting Bundle..."

$dotnetUrl = "https://download.visualstudio.microsoft.com/download/pr/8.0.0/dotnet-hosting-8.0.0-win.exe"
$localDotnet = "$env:TEMP\dotnet-hosting-8.exe"

Invoke-WebRequest -Uri $dotnetUrl -OutFile $localDotnet
Start-Process -FilePath $localDotnet -ArgumentList "/quiet","/norestart" -Wait

Write-Host "Installing Visual C++ Redistributable..."

$vcUrl = "https://aka.ms/vs/17/release/vc_redist.x64.exe"
$localVc = "$env:TEMP\vc_redist_x64.exe"

Invoke-WebRequest -Uri $vcUrl -OutFile $localVc
Start-Process -FilePath $localVc -ArgumentList "/quiet","/norestart" -Wait

Write-Host "Prerequisites installed successfully!"
