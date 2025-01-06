Write-Host "[1/6] Cleaning up generated files..." -ForegroundColor Cyan
Get-ChildItem -Path . -Filter "*.freezed.dart" -Recurse | Remove-Item -Force
Get-ChildItem -Path . -Filter "*.g.dart" -Recurse | Remove-Item -Force

Write-Host "[2/6] Running flutter clean..." -ForegroundColor Cyan
flutter clean

Write-Host "[3/6] Getting dependencies..." -ForegroundColor Cyan
flutter pub get

Write-Host "[4/6] Running build_runner clean..." -ForegroundColor Cyan
dart run build_runner clean

Write-Host "[5/6] Rebuilding generated files..." -ForegroundColor Cyan
dart run build_runner build --delete-conflicting-outputs

Write-Host "[6/6] Done!" -ForegroundColor Green
