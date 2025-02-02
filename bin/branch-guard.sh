#!/bin/bash
set -e  # Exit on error

DEFAULT_BRANCH="main"
CURRENT_BRANCH=$(git rev-parse --abbrev-ref HEAD)

MODE=$1  # Accept "block-default" or "require-default"
DRY_RUN=false

# Check for --dry-run flag
if [[ "$2" == "--dry-run" ]]; then
  DRY_RUN=true
  echo "🟡 Dry-run mode: No errors will cause exit."
fi

if [ "$MODE" == "block-default" ]; then
  if [ "$CURRENT_BRANCH" == "$DEFAULT_BRANCH" ]; then
    if [ "$DRY_RUN" = true ]; then
      echo "⚠️ Warning: You are on '$DEFAULT_BRANCH', but this action should be run on a feature branch!"
    else
      echo "❌ ERROR: You are on '$DEFAULT_BRANCH', but this action must be run on a feature branch!"
      exit 1
    fi
  fi
elif [ "$MODE" == "require-default" ]; then
  if [ "$CURRENT_BRANCH" != "$DEFAULT_BRANCH" ]; then
    if [ "$DRY_RUN" = true ]; then
      echo "⚠️ Warning: You should be on '$DEFAULT_BRANCH' to run this action!"
    else
      echo "❌ ERROR: You must be on '$DEFAULT_BRANCH' to run this action!"
      exit 1
    fi
  fi
else
  echo "ℹ️ Usage: branch-guard.sh [block-default | require-default] [--dry-run]"
  exit 1
fi

echo "✅ Branch check passed! (Current branch: $CURRENT_BRANCH)"
