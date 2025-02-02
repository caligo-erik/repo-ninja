#!/bin/bash
set -e  # Exit on error

DRY_RUN=false

# Parse optional --dry-run argument
if [[ "$1" == "--dry-run" ]]; then
  DRY_RUN=true
  echo "🟡 Dry-run mode: No branches will be deleted."
fi

# 🔍 Ensure we are on the default branch (dry-run mode included)
if [ "$DRY_RUN" = true ]; then
  repo-ninja branch-guard require-default --dry-run
else
  repo-ninja branch-guard require-default
fi

# 🔍 Check for uncommitted changes (dry-run mode included)
if [ "$DRY_RUN" = true ]; then
  repo-ninja check-clean-workspace --dry-run
else
  repo-ninja check-clean-workspace
fi

# Fetch latest remote branches
echo "🔄 Fetching latest remote branches..."
git fetch --prune

# List local branches that no longer exist on remote
echo "🔍 Checking for orphaned local branches..."
LOCAL_BRANCHES=$(git branch --format "%(refname:short)")

# Track deleted branches
DELETED_BRANCHES=()

for BRANCH in $LOCAL_BRANCHES; do
  # Skip `main`, `develop`, or any protected branches
  if [[ "$BRANCH" == "main" || "$BRANCH" == "develop" ]]; then
    continue
  fi

  # Check if branch exists on the remote
  if ! git ls-remote --exit-code --heads origin "$BRANCH" &>/dev/null; then
    if [ "$DRY_RUN" = true ]; then
      echo "🟡 [DRY-RUN] Would delete: $BRANCH"
    else
      echo "🗑️ Deleting local branch: $BRANCH"
      git branch -D "$BRANCH"
      DELETED_BRANCHES+=("$BRANCH")
    fi
  fi
done

# Summary
if [ "$DRY_RUN" = true ]; then
  echo "✅ Dry-run complete. No branches were actually deleted."
else
  echo "✅ Cleanup complete. Deleted ${#DELETED_BRANCHES[@]} branches."
fi
