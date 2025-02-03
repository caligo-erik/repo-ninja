#!/bin/bash
set -e  # Exit on error

DRY_RUN=false

# Parse optional --dry-run argument
if [[ "$1" == "--dry-run" ]]; then
  DRY_RUN=true
  echo "🟡 Dry-run mode: No errors will cause exit."
fi

# Get the latest commit hash
LAST_COMMIT=$(git rev-parse HEAD)

# Check for beta tags on the latest commit
BETA_TAG=$(git tag --points-at "$LAST_COMMIT" | grep -E ".*-beta-.*" || true)

if [ -n "$BETA_TAG" ]; then
  echo "✅ Latest commit has a beta tag: $BETA_TAG"
  exit 0
else
  if [ "$DRY_RUN" = true ]; then
    echo "⚠️ Warning: Latest commit does NOT have a beta tag! (Dry-run mode)"
  else
    echo "❌ Error: Latest commit does NOT have a beta tag!"
    exit 1
  fi
fi
