#!/bin/bash
set -e  # Exit on error

# 🛑 Ensure we are NOT on the main branch and have a clean workspace
repo-ninja branch-guard block-default
repo-ninja check-clean-workspace

# 🔍 Get the current branch name
BRANCH_NAME=$(git rev-parse --abbrev-ref HEAD)

# 🔄 Sanitize the branch name (replace non-alphanumeric characters with "-")
SANITIZED_BRANCH_NAME=$(echo "$BRANCH_NAME" | sed 's/[^a-zA-Z0-9]/-/g')

# 📌 Get the current version from package.json
CURRENT_VERSION=$(node -p "require('./package.json').version")

# 🔍 Find the last beta tag matching this branch
LAST_BETA_TAG=$(git tag -l "$CURRENT_VERSION-beta-$SANITIZED_BRANCH_NAME.*" | sort -V | tail -n 1)

# 🔢 Determine the next beta number
if [[ -z "$LAST_BETA_TAG" ]]; then
  NEXT_BETA_NUM=0
else
  # Extract the last numeric part from the last beta tag and increment it
  NEXT_BETA_NUM=$(( $(echo "$LAST_BETA_TAG" | awk -F. '{print $NF}') + 1 ))
fi

# 🏷️ Construct the correct beta tag
BETA_TAG="$CURRENT_VERSION-beta-$SANITIZED_BRANCH_NAME.$NEXT_BETA_NUM"

# 🏷️ Create and push the new beta tag
echo "🏷️ Creating beta tag: $BETA_TAG..."
git tag -a "$BETA_TAG" -m "Beta release $BETA_TAG"
git push origin "$BETA_TAG"

echo "✅ Beta tag $BETA_TAG created successfully!"
