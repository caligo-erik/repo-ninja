#!/bin/bash

# Function to sanitize branch names for beta tags
sanitize_branch() {
  echo "$1" | sed 's/[^a-zA-Z0-9]/-/g'
}

# If run directly, sanitize input from command line
if [[ "$1" ]]; then
  sanitize_branch "$1"
fi
