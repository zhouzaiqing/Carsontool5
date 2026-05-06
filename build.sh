#!/usr/bin/env bash
# Carsontool5 build script
#
# Usage:
#   ./build.sh           # incremental build
#   ./build.sh clean     # clean + build
#   ./build.sh package   # build + produce a .deb in packages/
#   ./build.sh -v        # verbose (passes through to make)
set -euo pipefail

cd "$(dirname "$0")"

# ---- Toolchain ------------------------------------------------------------
export THEOS="${THEOS:-$HOME/theos}"
export PATH="$THEOS/bin:/opt/homebrew/bin:/usr/local/bin:$PATH"

if [[ ! -d "$THEOS" ]]; then
  echo "error: THEOS not found at $THEOS" >&2
  exit 1
fi
if ! command -v ldid >/dev/null; then
  echo "error: ldid not in PATH (try: brew install ldid)" >&2
  exit 1
fi
if ! xcrun --sdk iphoneos --show-sdk-path >/dev/null 2>&1; then
  echo "error: iPhoneOS SDK not available — install full Xcode and run xcode-select -s /Applications/Xcode.app" >&2
  exit 1
fi

# ---- Parse args -----------------------------------------------------------
DO_CLEAN=0
DO_PACKAGE=0
EXTRA_ARGS=()
for arg in "$@"; do
  case "$arg" in
    clean)   DO_CLEAN=1 ;;
    package) DO_PACKAGE=1 ;;
    *)       EXTRA_ARGS+=("$arg") ;;
  esac
done

# ---- Run ------------------------------------------------------------------
if (( DO_CLEAN )); then
  echo "==> make clean"
  make clean
fi

JOBS="$(sysctl -n hw.ncpu 2>/dev/null || echo 4)"

if (( DO_PACKAGE )); then
  echo "==> make package -j${JOBS}"
  make package "-j${JOBS}" ${EXTRA_ARGS[@]+"${EXTRA_ARGS[@]}"}
  echo
  echo "Package(s):"
  ls -1 packages/*.deb 2>/dev/null || echo "  (none produced)"
else
  echo "==> make -j${JOBS}"
  make "-j${JOBS}" ${EXTRA_ARGS[@]+"${EXTRA_ARGS[@]}"}
fi

DYLIB=".theos/obj/debug/Carsontool5.dylib"
if [[ -f "$DYLIB" ]]; then
  echo
  echo "Output: $DYLIB"
  ls -la "$DYLIB"
  lipo -info "$DYLIB"
fi
