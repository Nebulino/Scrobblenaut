Write-Information "Getting dependencies."
dart pub get
Write-Information "Starting building .g.dart build objects."
dart run build_runner build
Write-Information "Finished building."