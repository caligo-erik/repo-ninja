#!/bin/bash
set -e  # Exit on error

# 🛑 Ensure a version type is provided
if [ -z "$1" ]; then
  echo "❌ Error: Missing version type!"
  echo "Usage: repo-ninja version-bump <patch|minor|major> [--commit <message>] [--version-args \"args\"] [--dry-run]"
  exit 1
fi

VERSION_TYPE=$1
shift

# 🔍 Validate version type
if [[ "$VERSION_TYPE" != "patch" && "$VERSION_TYPE" != "minor" && "$VERSION_TYPE" != "major" ]]; then
  echo "❌ Error: Invalid version type '$VERSION_TYPE'."
  echo "Usage: repo-ninja version-bump <patch|minor|major> [--commit <message>] [--version-args \"args\"] [--dry-run]"
  exit 1
fi

# 🏷️ Default values
COMMIT_MESSAGE="Bump version"
VERSION_ARGS="-e -s ./src/version.ts"
DRY_RUN=false

# Check for optional parameters
while [[ "$#" -gt 0 ]]; do
  case "$1" in
    --commit)
      shift
      COMMIT_MESSAGE="$1"
      ;;
    --version-args)
      shift
      VERSION_ARGS="$1"
      ;;
    --dry-run)
      DRY_RUN=true
      ;;
    *)
      echo "❌ Unknown option: $1"
      exit 1
      ;;
  esac
  shift
done

# 🛑 Check for uncommitted changes (Warn in dry-run mode, fail otherwise)
if [ "$DRY_RUN" = true ]; then
  repo-ninja check-clean-workspace --dry-run
else
  repo-ninja check-clean-workspace
fi

# 🔍 Preview new version name (Dry-Run)
if [ "$DRY_RUN" = true ]; then
  echo "🔍 Previewing new version..."
  npm --no-git-tag-version version "$VERSION_TYPE" --dry-run
else
  echo "🔼 Bumping version: $VERSION_TYPE..."
  npm --no-git-tag-version version "$VERSION_TYPE"
fi

# 📌 Generate version file (allow custom arguments)
if [ "$DRY_RUN" = false ]; then
  repo-ninja version $VERSION_ARGS
  git commit -a -m "$COMMIT_MESSAGE"
fi

# 🏷️ Tag and push the new version
if [ "$DRY_RUN" = true ]; then
  echo "🟡 [DRY-RUN] Skipping tagging and push."
else
  repo-ninja tag-release
fi


# 🗑️ Beta cleanup
if [ "$DRY_RUN" = true ]; then
  repo-ninja clean-beta --dry-run
else
  repo-ninja clean-beta
fi

if [ "$DRY_RUN" = true ]; then
  echo "✅ [DRY-RUN] Version bump simulation completed!"
else
  VERSION=$(node -p 'require("./package.json").version')
  echo "✅ Version bump to $VERSION completed!"
fi
