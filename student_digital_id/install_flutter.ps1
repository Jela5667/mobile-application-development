$outputZip = "$env:TEMP\flutter_windows.zip"
$flutterDir = "C:\src"

Write-Host "Creating directory $flutterDir..." -ForegroundColor Cyan
if (!(Test-Path $flutterDir)) {
    New-Item -ItemType Directory -Force -Path $flutterDir | Out-Null
}

$flutterUrl = "https://storage.googleapis.com/flutter_infra_release/releases/stable/windows/flutter_windows_3.19.0-stable.zip"

Write-Host "Downloading Flutter SDK using BITS (Fast & Reliable)..." -ForegroundColor Yellow
Import-Module BitsTransfer
Start-BitsTransfer -Source $flutterUrl -Destination $outputZip -DisplayName "Flutter SDK Download"

Write-Host "Extracting Flutter SDK to $flutterDir (This may take a minute)..." -ForegroundColor Yellow
Expand-Archive -Path $outputZip -DestinationPath $flutterDir -Force

Write-Host "Adding Flutter to user PATH..." -ForegroundColor Cyan
$userPath = [Environment]::GetEnvironmentVariable("Path", "User")
$flutterBin = "C:\src\flutter\bin"
if ($userPath -notlike "*$flutterBin*") {
    [Environment]::SetEnvironmentVariable("Path", "$userPath;$flutterBin", "User")
    $env:Path += ";$flutterBin"
}

Write-Host "Flutter & Dart installation completed successfully!" -ForegroundColor Green
