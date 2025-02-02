#!/bin/bash
set -e  # Exit on error

DRY_RUN=false

# Check for --dry-run flag
if [[ "$1" == "--dry-run" ]]; then
  DRY_RUN=true
fi

# Check for uncommitted changes
if ! git diff --quiet || ! git diff --cached --quiet; then
  if [ "$DRY_RUN" = true ]; then
    echo "⚠️ Warning: Uncommitted changes detected (dry-run mode)."
  else
    echo "❌ Error: You have uncommitted changes. Please commit or stash them first!"
    exit 1
  fi
else
  echo "✅ Workspace is clean."
fi
