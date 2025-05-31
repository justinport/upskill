#!/bin/bash

# Script to run both API and UI projects in parallel

echo "Starting Blazor MonoRepo..."
echo "Building solution..."

# Build the solution
dotnet build

if [ $? -eq 0 ]; then
    echo "Build successful. Starting applications..."
    
    # Start API in background
    echo "Starting API..."
    cd src/BlazorMonoRepo.API
    dotnet run &
    API_PID=$!
    cd ../..
    
    # Wait a moment for API to start
    sleep 3
    
    # Start UI
    echo "Starting UI..."
    cd src/BlazorMonoRepo.UI
    dotnet run &
    UI_PID=$!
    cd ../..
    
    echo "Both applications are starting..."
    echo "API PID: $API_PID"
    echo "UI PID: $UI_PID"
    echo ""
    echo "URLs:"
    echo "- Blazor UI: https://localhost:7084 or http://localhost:5121"
    echo "- API: https://localhost:7045 or http://localhost:5115"
    echo "- API Swagger: https://localhost:7045/swagger"
    echo ""
    echo "Press Ctrl+C to stop both applications"
    
    # Function to cleanup on exit
    cleanup() {
        echo "Stopping applications..."
        kill $API_PID 2>/dev/null
        kill $UI_PID 2>/dev/null
        echo "Applications stopped."
        exit 0
    }
    
    # Set trap to cleanup on script exit
    trap cleanup INT TERM
    
    # Wait for background processes
    wait
else
    echo "Build failed. Please fix the errors and try again."
    exit 1
fi
