#!/bin/bash

set -e

echo "=== Updating system ==="
sudo apt-get update -y
sudo apt-get install -y curl unzip xz-utils git zip libglu1-mesa openjdk-17-jdk

echo "=== Installing Flutter ==="
FLUTTER_VERSION=3.22.0
FLUTTER_URL="https://storage.googleapis.com/flutter_infra_release/releases/stable/linux/flutter_linux_${FLUTTER_VERSION}-stable.tar.xz"
curl -O $FLUTTER_URL
tar xf flutter_linux_${FLUTTER_VERSION}-stable.tar.xz
export PATH="$PWD/flutter/bin:$PATH"

echo "=== Running flutter doctor ==="
flutter doctor

echo "=== Accepting Android licenses ==="
yes | flutter doctor --android-licenses || true

echo "=== Installing Android SDK ==="
mkdir -p "$HOME/Android/Sdk"
cd "$HOME/Android/Sdk"
ANDROID_CMDLINE_TOOLS_VERSION=11076708
TOOLS_URL="https://dl.google.com/android/repository/commandlinetools-linux-${ANDROID_CMDLINE_TOOLS_VERSION}_latest.zip"
curl -O $TOOLS_URL
unzip -q commandlinetools-linux-*-latest.zip
mkdir -p cmdline-tools/latest
mv cmdline-tools/* cmdline-tools/latest/

export ANDROID_HOME="$HOME/Android/Sdk"
export PATH="$ANDROID_HOME/cmdline-tools/latest/bin:$ANDROID_HOME/platform-tools:$PATH"

echo "=== Installing SDK packages ==="
yes | sdkmanager --licenses
sdkmanager "platform-tools" "platforms;android-33" "build-tools;33.0.2"

echo "=== Flutter doctor again ==="
flutter doctor

echo "=== Setup complete! ==="
