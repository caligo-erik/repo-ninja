#!/bin/bash
set -e  # Exit on error

# 🏷️ Get the current version from package.json
VERSION=$(node -p "require('./package.json').version")

# 🏷️ Create and push the tag
echo "Tagging version: $VERSION..."
git commit -a -m "$VERSION"
git tag -a "$VERSION" -m "$VERSION"
git push --follow-tags

echo "✅ Version $VERSION tagged and pushed."
