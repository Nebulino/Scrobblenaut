Write-Information "Getting dependencies."
pub get
Write-Information "Starting building .g.dart build objects."
pub run build_runner build
Write-Information "Finished building."