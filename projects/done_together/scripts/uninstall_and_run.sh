#!/bin/sh
# Emülatördeki tüm Done Together kurulumlarını kaldırır ve dev flavor ile yeniden çalıştırır.
# Kullanım: Emülatör açıkken ./scripts/uninstall_and_run.sh
# veya: sh scripts/uninstall_and_run.sh

set -e
ADB="${ANDROID_HOME:-$HOME/Library/Android/sdk}/platform-tools/adb"
cd "$(dirname "$0")/.."

echo "Uninstalling existing app(s)..."
"$ADB" uninstall com.donetogether.done_together 2>/dev/null || true
"$ADB" uninstall com.donetogether.done_together.dev 2>/dev/null || true
echo "Starting app (dev flavor)..."
flutter run --flavor dev -t lib/flavors/main_dev.dart
