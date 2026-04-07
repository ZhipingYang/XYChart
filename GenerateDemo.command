#!/bin/zsh

set -euo pipefail

ROOT_DIR="$(cd "$(dirname "$0")" && pwd)"
DEMO_DIR="$ROOT_DIR/Demo"
export PATH="/opt/homebrew/bin:/usr/local/bin:/usr/bin:/bin:/usr/sbin:/sbin:$PATH"

if command -v brew >/dev/null 2>&1; then
  eval "$(brew shellenv)"
fi

echo "==> XYChart demo bootstrap"
echo "Root: $ROOT_DIR"
echo

if ! command -v xcodegen >/dev/null 2>&1; then
  echo "Missing xcodegen. Install it first:"
  echo "  brew install xcodegen"
  echo
  read -r "?Press Enter to close..."
  exit 1
fi

if ! command -v pod >/dev/null 2>&1; then
  echo "Missing CocoaPods. Install it first:"
  echo "  brew install cocoapods"
  echo
  read -r "?Press Enter to close..."
  exit 1
fi

cd "$DEMO_DIR"

echo "==> Generating Xcode project"
xcodegen generate
echo

echo "==> Installing pods"
pod install
echo

WORKSPACE_PATH="$DEMO_DIR/XYChartDemo.xcworkspace"
PROJECT_PATH="$DEMO_DIR/XYChartDemo.xcodeproj"
if [[ -d "$WORKSPACE_PATH" ]]; then
  echo "==> Opening workspace"
  open -a Xcode "$WORKSPACE_PATH"
elif [[ -d "$PROJECT_PATH" ]]; then
  echo "Workspace was not created, opening project instead"
  open -a Xcode "$PROJECT_PATH"
else
  echo "Neither workspace nor project was generated."
  read -r "?Press Enter to close..."
  exit 1
fi

echo
echo "Done."
read -r "?Press Enter to close..."
