#!/bin/bash
set -e  # Exit on error

# 🛑 Ensure we are NOT on the main branch and have a clean workspace
repo-ninja branch-guard block-default
repo-ninja check-clean-workspace

# 🔍 Get the current branch name
BRANCH_NAME=$(git rev-parse --abbrev-ref HEAD)

# 🔄 Sanitize the branch name (replace non-alphanumeric characters with "-")
SANITIZED_BRANCH_NAME=$(echo "$BRANCH_NAME" | sed 's/[^a-zA-Z0-9]/-/g')

# 🔼 Bump the prerelease version in package.json
echo "🔼 Bumping prerelease version in package.json..."
npm --no-git-tag-version --preid=beta-"$SANITIZED_BRANCH_NAME" version prerelease

# 📌 Get the updated version from package.json
BETA_VERSION=$(node -p "require('./package.json').version")

# 🔍 Find the last beta tag matching this version
LAST_BETA_TAG=$(git tag -l "$BETA_VERSION.*" | sort -V | tail -n 1)

# 🔢 Determine the next beta number
if [[ -z "$LAST_BETA_TAG" ]]; then
  NEXT_BETA_NUM=0
else
  NEXT_BETA_NUM=$(( $(echo "$LAST_BETA_TAG" | awk -F. '{print $NF}') + 1 ))
fi

# 🏷️ Construct the correct beta tag (without appending `-beta-branch` again)
BETA_TAG="$BETA_VERSION.$NEXT_BETA_NUM"

# 📌 Generate version.ts (required for genversion)
repo-ninja version -e -s ./src/version.ts

# ✅ Commit the updated version files
git add package.json ./src/version.ts
git commit -m "Bump beta version: $BETA_TAG"

# 🏷️ Create and push the new beta tag
echo "🏷️ Creating beta tag: $BETA_TAG..."
git tag -a "$BETA_TAG" -m "Beta release $BETA_TAG"
git push origin "$BETA_TAG"

echo "✅ Beta tag $BETA_TAG created successfully!"
