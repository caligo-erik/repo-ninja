#!/usr/bin/env node
const { execSync } = require('child_process');

const args = process.argv.slice(2);

if (args.length === 0 || args.includes('--help')) {
  console.log(`
  Usage: repo-ninja <command> [options]

  Available Commands:
    beta-tag               Create a beta tag
    beta-check-tag         Check if the last commit has a beta tag
    branch-guard <mode>    Ensure the correct branch is checked out
                           Modes:
                           - require-default  (Fail if NOT on default branch)
                           - block-default    (Fail if ON default branch)
    check-clean-workspace  Ensure no uncommitted changes
    clean-beta             Remove obsolete beta tags
    clean-local-branches   Remove local branches that no longer exist on remote
    link                   Ensure repo-ninja is properly linked
    reinstall              Remove node_modules and reinstall dependencies
    sanitize-branch        Sanitize a branch name (for tag compatibility)
    tag-release            Tag and push the latest version
    version-bump <type>    Bump version (patch, minor, major)
    version                Generate the version file

  Options:
    --dry-run              Simulate the command without making changes
    --help                 Show this help message

  Example package.json integration:
  ---------------------------------
  {
    "scripts": {
      "reinstall": "repo-ninja reinstall",
      "beta": "repo-ninja beta-tag",
      "patch": "repo-ninja version-bump patch",
      "minor": "repo-ninja version-bump minor",
      "major": "repo-ninja version-bump major"
    }
  }
  ---------------------------------
  `);
  process.exit(0);
}

// Extract the command
const command = args[0];

// Map commands to scripts
const scriptMap = {
  'beta-tag': 'beta-tag.sh',
  'beta-check-tag': 'check-last-commit-beta.sh',
  'branch-guard': 'branch-guard.sh',
  'check-clean-workspace': 'check-clean-workspace.sh',
  'clean-beta': 'clean-beta.sh',
  'clean-local-branches': 'clean-local-branches.sh',
  link: 'link-repo-ninja.sh',
  reinstall: 'reinstall.sh',
  'sanitize-branch': 'sanitize-branch.sh',
  'tag-release': 'tag-release.sh',
  'version-bump': 'version-bump.sh',
  version: 'version.sh',
};

if (!scriptMap[command]) {
  console.error(`❌ Error: Unknown command '${command}'`);
  console.error(`Run 'repo-ninja --help' for a list of available commands.`);
  process.exit(1);
}

// Execute the mapped script
try {
  execSync(`${__dirname}/${scriptMap[command]} ${args.slice(1).join(' ')}`, { stdio: 'inherit' });
} catch (error) {
  process.exit(1);
}
