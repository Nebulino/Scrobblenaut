Write-Host "Getting dependencies."
pub get
Write-Host "Starting building .g.dart build objects."
pub run build_runner build
Write-Host "Finished building."