#!/usr/bin/env node
const { execSync } = require('child_process');
const path = require('path');

const args = process.argv.slice(2); // Get command-line arguments

if (args.length === 0) {
  console.error('Usage: repo-ninja <command> [options]');
  process.exit(1);
}

// Construct the full path to the corresponding shell script
const scriptPath = path.join(__dirname, `${args[0]}.sh`);

try {
  // Run the shell script with remaining arguments
  execSync(`${scriptPath} ${args.slice(1).join(' ')}`, { stdio: 'inherit', shell: true });
} catch (error) {
  console.error(`Error: Command failed - ${error.message}`);
  process.exit(1);
}
