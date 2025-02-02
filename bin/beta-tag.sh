#!/bin/bash
set -e  # Exit on error

# 🛑 Ensure we are NOT on the main branch and have a clean workspace
repo-ninja branch-guard block-default
repo-ninja check-clean-workspace

# 🔍 Get the current branch name
BRANCH_NAME=$(git rev-parse --abbrev-ref HEAD)

# 🔄 Sanitize the branch name (replace non-alphanumeric characters with "-")
SANITIZED_BRANCH_NAME=$(echo "$BRANCH_NAME" | sed 's/[^a-zA-Z0-9]/-/g')

# 📌 Get the current version from package.json and remove any beta suffix
RAW_VERSION=$(node -p "require('./package.json').version")

# 🛑 Remove `-beta-branch.N` if it exists
CLEAN_VERSION=$(echo "$RAW_VERSION" | sed -E 's/-beta-[a-zA-Z0-9-]+\.[0-9]+$//')

# 🔍 Find the last beta tag matching this branch
LAST_BETA_TAG=$(git tag -l "$CLEAN_VERSION-beta-$SANITIZED_BRANCH_NAME.*" | sort -V | tail -n 1)

# 🔢 Determine the next beta number
if [[ -z "$LAST_BETA_TAG" ]]; then
  NEXT_BETA_NUM=0
else
  NEXT_BETA_NUM=$(( $(echo "$LAST_BETA_TAG" | awk -F. '{print $NF}') + 1 ))
fi

# 🏷️ Construct the correct beta tag
BETA_TAG="$CLEAN_VERSION-beta-$SANITIZED_BRANCH_NAME.$NEXT_BETA_NUM"

# 🏷️ Create and push the new beta tag
echo "🏷️ Creating beta tag: $BETA_TAG..."
git tag -a "$BETA_TAG" -m "Beta release $BETA_TAG"
git push origin "$BETA_TAG"

echo "✅ Beta tag $BETA_TAG created successfully!"
