# Download SQLite DLL for Windows
$url = "https://www.sqlite.org/2024/sqlite-dll-win64-x64-3430200.zip"
$output = "sqlite3.zip"
$dll = "sqlite3.dll"

Write-Host "Downloading SQLite..."
try {
    Invoke-WebRequest -Uri $url -OutFile $output -ErrorAction Stop
    
    Write-Host "Extracting SQLite..."
    Expand-Archive -Path $output -DestinationPath . -Force -ErrorAction Stop
    
    Write-Host "Moving SQLite DLL..."
    Move-Item -Path $dll -Destination .. -Force -ErrorAction Stop
    
    Write-Host "Cleaning up..."
    Remove-Item $output -ErrorAction SilentlyContinue
    
    Write-Host "SQLite setup complete!"
} catch {
    Write-Host "Error: $_"
    exit 1
} 