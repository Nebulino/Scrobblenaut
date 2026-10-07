#!/bin/sh
echo "Getting dependencies."
dart pub get
echo "Starting building .g.dart build objects."
dart run build_runner build
echo "Finished building."