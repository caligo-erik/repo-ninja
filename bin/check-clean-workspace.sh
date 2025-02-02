#!/bin/bash
set -e  # Exit on error

# Check for uncommitted changes
if [[ -n $(git status --porcelain) ]]; then
  echo "❌ Error: You have uncommitted changes!"
  echo "Commit or stash your changes before bumping the version."
  exit 1
fi

echo "✅ Workspace is clean."
