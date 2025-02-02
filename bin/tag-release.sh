#!/bin/bash
set -e  # Exit on error

# Get current version from package.json
VERSION=$(node -p 'require("./package.json").version')

echo "🔖 Tagging version: $VERSION..."

# Ensure latest commit is pushed before tagging
if [ "$(git rev-parse --abbrev-ref HEAD)" != "main" ]; then
  echo "❌ Error: You must be on main to tag a release!"
  exit 1
fi

# 🔄 Push the latest commit before tagging
echo "📤 Pushing latest commit to origin..."
git push origin main

# 🏷️ Create and push the tag
git tag -a "$VERSION" -m "Release $VERSION"
git push origin "$VERSION"

echo "✅ Version $VERSION tagged and pushed!"
