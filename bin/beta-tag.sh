#!/bin/bash
set -e  # Exit on error

# 🛑 Ensure we are NOT on the default branch and have no uncommitted changes
repo-ninja branch-guard block-default

# 🛑 Check for uncommitted changes
repo-ninja check-clean-workspace

# 🔍 Get current branch name
BRANCH_NAME=$(git rev-parse --abbrev-ref HEAD)

# 🔄 Sanitize branch name (replace non-alphanumeric characters with "-")
SANITIZED_BRANCH_NAME=$(echo "$BRANCH_NAME" | sed 's/[^a-zA-Z0-9]/-/g')

# 📌 Get current version
CURRENT_VERSION=$(node -p "require('./package.json').version")

# 🔍 Find next beta number
LAST_BETA_TAG=$(git tag -l "$CURRENT_VERSION-beta-$SANITIZED_BRANCH_NAME.*" | sort -V | tail -n 1)
if [[ -z "$LAST_BETA_TAG" ]]; then
  NEXT_BETA_NUM=0
else
  NEXT_BETA_NUM=$(( $(echo "$LAST_BETA_TAG" | awk -F. '{print $NF}') + 1 ))
fi

# 🏷️ Construct the beta tag
BETA_TAG="$CURRENT_VERSION-beta-$SANITIZED_BRANCH_NAME.$NEXT_BETA_NUM"

# 🔖 Create and push the tag
echo "🏷️ Creating beta tag: $BETA_TAG"
git tag -a "$BETA_TAG" -m "Beta release $BETA_TAG"
git push origin "$BETA_TAG"

echo "✅ Beta tag $BETA_TAG created successfully!"
