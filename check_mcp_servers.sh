#!/bin/bash

echo "Checking npx installation..."
if command -v npx &> /dev/null; then
    echo "✅ npx is installed: $(npx --version)"
else
    echo "❌ npx is not installed. Install Node.js first."
    exit 1
fi

echo -e "\nChecking MCP servers..."

servers=(
    "@modelcontextprotocol/server-filesystem"
    "@modelcontextprotocol/server-github" 
    "@modelcontextprotocol/server-memory"
    "@modelcontextprotocol/server-puppeteer"
    "@modelcontextprotocol/server-everything"
    "@modelcontextprotocol/server-sequential-thinking"
)

for server in "${servers[@]}"; do
    echo -n "Checking $server... "
    if npx $server --help &> /dev/null; then
        echo "✅ Available"
    else
        echo "❌ Not available (will be downloaded on first use)"
    fi
done

echo -e "\nNote: npx will automatically download missing packages when first used."
