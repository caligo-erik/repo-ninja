#!/bin/bash
set -e  # Exit on error

# Use pnpm dlx if available, fallback to npx
if command -v pnpm &> /dev/null; then
  pnpm dlx genversion "$@"
else
  npx genversion "$@"
fi
