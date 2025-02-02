#!/bin/bash
set -e  # Exit on error

# 🏷️ Check if dry-run mode is enabled
DRY_RUN=false
if [[ "$1" == "--dry-run" ]]; then
  DRY_RUN=true
  echo "🔍 Running in dry-run mode. No tags will be deleted."
fi

echo "🔍 Searching for obsolete beta tags..."

# 🏷️ Get all beta tags
beta_tags=$(git tag -l '*beta*')

# 🏷️ Get all remote branches and sanitize their names
remote_branches=$(git ls-remote --heads origin | awk '{print $2}' | sed 's|refs/heads/||' | while read -r branch; do repo-ninja sanitize-branch "$branch"; done)

# 🗑️ Check for obsolete beta tags
for tag in $beta_tags; do
  matched=false
  for branch in $remote_branches; do
    if [[ "$tag" == *"$branch"* ]]; then
      matched=true
      break
    fi
  done

  if [ "$matched" = false ]; then
    if [ "$DRY_RUN" = true ]; then
      echo "🟡 Would [DELETE]: $tag"
    else
      echo "🗑️ Deleting obsolete beta tag: $tag"
      git tag -d "$tag"
      git push origin :refs/tags/"$tag"
    fi
  else
    echo "✅ Would [KEEP]: $tag (branch exists)"
  fi
done

# ✅ Print completion message ONLY if NOT in dry-run mode
if [ "$DRY_RUN" = false ]; then
  echo "✅ Clean-up complete."
fi
