#!/usr/bin/env bash
# Compila el APK de depuración de RELL'S LIFE.
# GitHub Actions lo llama después de instalar Java y el Android SDK.
set -euo pipefail
cd "$(dirname "$0")/.."

find_sdkmanager() {
  if command -v sdkmanager >/dev/null 2>&1; then
    command -v sdkmanager
    return
  fi
  local root="${ANDROID_SDK_ROOT:-${ANDROID_HOME:-}}"
  if [ -n "$root" ]; then
    find "$root" -type f -name sdkmanager 2>/dev/null | head -n 1
  fi
}

SDKMANAGER="$(find_sdkmanager || true)"
if [ -n "${SDKMANAGER}" ]; then
  yes | "${SDKMANAGER}" --licenses >/dev/null || true
  "${SDKMANAGER}" --install "platforms;android-35" "build-tools;35.0.0"
fi

chmod +x ./gradlew
./gradlew testDebugUnitTest assembleDebug --stacktrace --no-daemon
echo "APK listo: app/build/outputs/apk/debug/app-debug.apk"
