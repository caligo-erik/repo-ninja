#!/bin/bash
set -e

DEFAULT_BRANCH="main"
CURRENT_BRANCH=$(git rev-parse --abbrev-ref HEAD)

MODE=$1  # Accept "block-default" or "require-default"

if [ "$MODE" == "block-default" ]; then
  if [ "$CURRENT_BRANCH" == "$DEFAULT_BRANCH" ]; then
    echo "❌ ERROR: You are on '$DEFAULT_BRANCH', but this action must be run on a feature branch!"
    exit 1
  fi
elif [ "$MODE" == "require-default" ]; then
  if [ "$CURRENT_BRANCH" != "$DEFAULT_BRANCH" ]; then
    echo "❌ ERROR: You must be on '$DEFAULT_BRANCH' to run this action!"
    exit 1
  fi
else
  echo "ℹ️ Usage: branch-guard.sh [block-default | require-default]"
  exit 1
fi

echo "✅ Branch check passed! (Current branch: $CURRENT_BRANCH)"
