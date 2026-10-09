$url = "https://storage.googleapis.com/flutter_infra_release/releases/stable/windows/flutter_windows_3.19.0-stable.zip"
$output = "$env:TEMP\flutter_windows.zip"
$dest = "C:\src"

Write-Host "Checking destination directory..."
if (!(Test-Path $dest)) {
    New-Item -ItemType Directory -Force -Path $dest | Out-Null
}

Write-Host "Downloading Flutter SDK (approx 1GB) using .NET WebClient..."
$webClient = New-Object System.Net.WebClient
try {
    $webClient.DownloadFile($url, $output)
    Write-Host "Download finished successfully!"

    Write-Host "Extracting zip to $dest..."
    Add-Type -AssemblyName System.IO.Compression.FileSystem
    [System.IO.Compression.ZipFile]::ExtractToDirectory($output, $dest, $true)
    Write-Host "Extraction complete!"

    $flutterBin = "C:\src\flutter\bin"
    $userPath = [Environment]::GetEnvironmentVariable("Path", "User")
    if ($userPath -notlike "*$flutterBin*") {
        [Environment]::SetEnvironmentVariable("Path", "$userPath;$flutterBin", "User")
        Write-Host "Added to PATH!"
    }
    Write-Host "FLUTTER INSTALLATION SUCCESSFUL!"
} catch {
    Write-Host "Error during download/extraction: $_"
    exit 1
}
