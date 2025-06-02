#!/bin/bash

# MAUI iOS Debug Launch Script
# This script builds and launches the MAUI iOS app with debugging support

set -e  # Exit on any error

WORKSPACE_DIR="$(cd "$(dirname "$0")/../.." && pwd)"
PROJECT_PATH="$WORKSPACE_DIR/src/BlazorMonoRepo.MAUI/BlazorMonoRepo.MAUI.csproj"
APP_PATH="$WORKSPACE_DIR/src/BlazorMonoRepo.MAUI/bin/Debug/net9.0-ios/iossimulator-arm64/BlazorMonoRepo.MAUI.app"
SIMULATOR_NAME="iPhone 16 Pro"
BUNDLE_ID="com.companyname.blazormonorepo.maui"

echo "🔨 Building MAUI iOS app for debugging..."
if ! dotnet build "$PROJECT_PATH" -f net9.0-ios -c Debug; then
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

echo "🧹 Uninstalling previous app version (if exists)..."
xcrun simctl uninstall "$SIMULATOR_NAME" "$BUNDLE_ID" 2>/dev/null || true

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

echo "🎯 Launching app with debugging support..."
if APP_PID=$(xcrun simctl launch "$SIMULATOR_NAME" "$BUNDLE_ID" 2>/dev/null); then
    echo "✅ MAUI iOS app launched successfully!"
    echo "   App Process ID: $APP_PID"
    echo "   Simulator: $SIMULATOR_NAME"
    echo "   Bundle ID: $BUNDLE_ID"
    echo ""
    echo "📋 Debug Information:"
    echo "   To attach debugger, look for process: BlazorMonoRepo.MAUI"
    echo "   App is running in Debug configuration"
    echo "   Remote debugging may be available on iOS simulator"
    echo ""
    echo "💡 VS Code Debugging Tips:"
    echo "   1. Use 'MAUI iOS - Debug Attach (Advanced)' to attach to running process"
    echo "   2. Set breakpoints in your C# code before attaching"
    echo "   3. For Blazor debugging, use browser dev tools in simulator"
else
    echo "❌ App launch failed!"
    echo "Checking installed apps..."
    xcrun simctl listapps "$SIMULATOR_NAME" | grep -i blazor || echo "No Blazor apps found"
    exit 1
fi

echo "🎉 Debug session ready! The MAUI iOS app is running with debug support."
