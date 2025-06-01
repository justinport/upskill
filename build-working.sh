#!/bin/bash

# Build script for working projects only
# Skips problematic Android and macOS targets

echo "🔨 Building Blazor MonoRepo - Web Stack Only..."

echo "📦 Building Shared library..."
dotnet build src/BlazorMonoRepo.Shared/BlazorMonoRepo.Shared.csproj
if [ $? -ne 0 ]; then
    echo "❌ Shared build failed"
    exit 1
fi

echo "🧩 Building Components library..."
dotnet build src/BlazorMonoRepo.Components/BlazorMonoRepo.Components.csproj
if [ $? -ne 0 ]; then
    echo "❌ Components build failed"
    exit 1
fi

echo "🌐 Building API..."
dotnet build src/BlazorMonoRepo.API/BlazorMonoRepo.API.csproj
if [ $? -ne 0 ]; then
    echo "❌ API build failed"
    exit 1
fi

echo "💻 Building Web UI..."
dotnet build src/BlazorMonoRepo.UI/BlazorMonoRepo.UI.csproj
if [ $? -ne 0 ]; then
    echo "❌ UI build failed"
    exit 1
fi

echo "📱 Building MAUI iOS (if iOS SDK available)..."
dotnet build src/BlazorMonoRepo.MAUI/BlazorMonoRepo.MAUI.csproj -f net9.0-ios
if [ $? -eq 0 ]; then
    echo "✅ iOS build succeeded"
else
    echo "⚠️ iOS build failed (iOS SDK may not be available)"
fi

echo "✅ Core projects built successfully!"
echo ""
echo "🚀 Ready to launch:"
echo "  • Use VS Code Debug panel to launch API and UI"
echo "  • Use 'start-maui-ios' task for mobile (if iOS build succeeded)"
