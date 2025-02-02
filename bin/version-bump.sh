#!/bin/bash
set -e  # Exit on error

# 🛑 Ensure a version type is provided
if [ -z "$1" ]; then
  echo "❌ Error: Missing version type!"
  echo "Usage: repo-ninja version-bump <patch|minor|major>"
  exit 1
fi

VERSION_TYPE=$1

# 🔍 Validate version type
if [[ "$VERSION_TYPE" != "patch" && "$VERSION_TYPE" != "minor" && "$VERSION_TYPE" != "major" ]]; then
  echo "❌ Error: Invalid version type '$VERSION_TYPE'."
  echo "Usage: repo-ninja version-bump <patch|minor|major>"
  exit 1
fi

# 🛑 Check for uncommitted changes
repo-ninja check-clean-workspace

# 🛑 Ensure we're on the correct branch (main)
repo-ninja branch-guard require-default

# 🔼 Bump version
echo "🔼 Bumping version: $VERSION_TYPE..."
npm --no-git-tag-version version "$VERSION_TYPE"

# 📌 Generate version file
repo-ninja version -e -s ./src/version.ts

# 🏷️ Tag and push the new version
repo-ninja tag-release

# 🗑️ Clean obsolete beta tags
repo-ninja clean-beta

echo "✅ Version bump to $(node -p 'require(\"./package.json\").version') completed!"
