#!/bin/bash
set -e  # Exit on error

echo "🔗 Ensuring the latest version of repo-ninja is linked..."

# Get the package name from package.json
PACKAGE_NAME=$(node -p "require('./package.json').name")

# Check if repo-ninja is already linked globally
if npm list -g --depth=0 | grep -q "$PACKAGE_NAME@"; then
  echo "🔗 Unlinking old repo-ninja..."
  npm unlink -g "$PACKAGE_NAME"
fi

# Link the latest local version
echo "🔗 Linking repo-ninja globally..."
npm link

# Verify the new link
if command -v repo-ninja &> /dev/null; then
  echo "✅ repo-ninja is now up-to-date and linked!"
else
  echo "❌ Error: repo-ninja was not linked correctly!"
  exit 1
fi
