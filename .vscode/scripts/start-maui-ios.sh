#!/bin/bash

# MAUI iOS Simulator Launch Script
# This script builds and launches the MAUI iOS app in the simulator

set -e  # Exit on any error

WORKSPACE_DIR="$(cd "$(dirname "$0")/../.." && pwd)"
PROJECT_PATH="$WORKSPACE_DIR/src/BlazorMonoRepo.MAUI/BlazorMonoRepo.MAUI.csproj"
APP_PATH="$WORKSPACE_DIR/src/BlazorMonoRepo.MAUI/bin/Debug/net9.0-ios/iossimulator-arm64/BlazorMonoRepo.MAUI.app"
SIMULATOR_NAME="iPhone 16 Pro"
BUNDLE_ID="com.companyname.blazormonorepo.maui"

echo "🔨 Building MAUI iOS app..."
if ! dotnet build "$PROJECT_PATH" -f net9.0-ios; then
    echo "❌ Build failed!"
    exit 1
fi

echo "✅ Build successful!"

echo "📱 Booting iOS Simulator ($SIMULATOR_NAME)..."
# Boot simulator (ignore if already booted)
xcrun simctl boot "$SIMULATOR_NAME" 2>/dev/null || true

echo "🚀 Opening Simulator app..."
open -a Simulator

echo "⏳ Waiting for simulator to be ready..."
sleep 3

echo "📦 Installing app on simulator..."
if ! xcrun simctl install "$SIMULATOR_NAME" "$APP_PATH"; then
    echo "❌ App installation failed!"
    echo "Checking if app bundle exists..."
    if [ ! -d "$APP_PATH" ]; then
        echo "❌ App bundle not found at: $APP_PATH"
        echo "Available files in build directory:"
        ls -la "$(dirname "$APP_PATH")" 2>/dev/null || echo "Build directory not found"
    fi
    exit 1
fi

echo "✅ App installed successfully!"

echo "🎯 Launching app..."
if APP_PID=$(xcrun simctl launch "$SIMULATOR_NAME" "$BUNDLE_ID" 2>/dev/null); then
    echo "✅ MAUI iOS app launched successfully!"
    echo "   App Process ID: $APP_PID"
    echo "   Simulator: $SIMULATOR_NAME"
    echo "   Bundle ID: $BUNDLE_ID"
else
    echo "❌ App launch failed!"
    echo "Checking installed apps..."
    xcrun simctl listapps "$SIMULATOR_NAME" | grep -i blazor || echo "No Blazor apps found"
    exit 1
fi

echo "🎉 All done! The MAUI iOS app is now running in the simulator."
