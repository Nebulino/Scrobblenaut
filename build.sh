#!/bin/sh
echo "Getting dependencies."
pub get
echo "Starting building .g.dart build objects."
pub run build_runner build
echo "Finished building."