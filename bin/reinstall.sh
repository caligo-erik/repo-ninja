#!/bin/bash
set -e  # Exit on error

RESET_MODE=false
if [[ "$1" == "--reset" ]]; then
  RESET_MODE=true
  echo "🔄 Running in reset mode: Lock files will be deleted."
fi

echo "🗑️ Removing node_modules..."
rm -rf node_modules

# Remove lock files only if --reset is provided
if [ "$RESET_MODE" = true ]; then
  echo "🗑️ Removing lock files..."
  rm -f package-lock.json pnpm-lock.yaml yarn.lock
fi

# Detect package manager
if command -v pnpm &> /dev/null; then
  echo "📦 Reinstalling dependencies with pnpm..."
  pnpm install
elif command -v yarn &> /dev/null; then
  echo "📦 Reinstalling dependencies with yarn..."
  yarn install
elif command -v npm &> /dev/null; then
  echo "📦 Reinstalling dependencies with npm..."
  npm install
else
  echo "❌ Error: No package manager found! Install pnpm, yarn, or npm."
  exit 1
fi

echo "✅ Reinstallation complete!"
