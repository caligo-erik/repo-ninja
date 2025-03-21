# 🚀 repo-ninja

**A CLI tool to automate repo management tasks.**

📌 **Features:**

- 📦 **Automates versioning** (`patch`, `minor`, `major`)
- 🏷 **Creates & cleans beta tags**
- 🛠 **Manages local branches**
- 🔍 **Ensures repo cleanliness before key actions**
- ⚡ **Easily integrates into package.json scripts**

---

## 📌 **Installation**

You can install `repo-ninja` either **globally** or as a **dev dependency**.

### **Option 1: Global Installation**

```sh
npm install -g repo-ninja
```

📌 This allows you to run repo-ninja from anywhere:

```sh
repo-ninja version-bump patch
repo-ninja beta-tag
```

### **Option 2: Install as Dev Dependency**

```sh
npm install --save-dev repo-ninja
```

📌 Then, add repo-ninja to your package.json scripts (see below).

---

## 📌 **Usage**

Run `repo-ninja --help` to see available commands:

```sh
repo-ninja --help
```

### **Available Commands**

```sh
repo-ninja link                   # Ensure repo-ninja is properly linked
repo-ninja reinstall              # Remove node_modules and reinstall dependencies
repo-ninja version-bump <type>     # Bump version (patch, minor, major)
repo-ninja tag-release            # Tag and push the latest version
repo-ninja beta-tag               # Create a beta tag
repo-ninja beta-check-tag          # Check if the last commit has a beta tag
repo-ninja clean-beta             # Remove obsolete beta tags
repo-ninja clean-local-branches   # Remove local branches that no longer exist on remote
repo-ninja branch-guard <mode>    # Ensure the correct branch is checked out
                                  # Modes:
                                  #   require-default  (Fail if NOT on default branch)
                                  #   block-default    (Fail if ON default branch)
repo-ninja check-clean-workspace  # Ensure no uncommitted changes
```

### **Options**

```sh
repo-ninja <command> --dry-run   # Simulate the command without making changes
repo-ninja --help                # Show this help message
```

---

## 📌 **Package.json Integration Example**

```json
{
  "scripts": {
    "reinstall": "repo-ninja reinstall",
    "beta": "repo-ninja beta-tag",
    "patch": "repo-ninja version-bump patch",
    "minor": "repo-ninja version-bump minor",
    "major": "repo-ninja version-bump major",
    "check": "repo-ninja version -c -e -s -v ./src/version.ts",
    "prepublishOnly": "npm run check && npm run reinstall && npm run test",
    "branchCheck:main": "repo-ninja branch-guard require-default",
    "branchCheck:dev": "repo-ninja branch-guard block-default",
    "cleanBranches:dry": "repo-ninja clean-local-branches --dry-run",
    "cleanBranches": "repo-ninja clean-local-branches"
  }
}
```

Then, run them like this:

```sh
npm run patch
npm run beta
npm run reinstall
```

---

## 📌 **Examples**

### **Bump a Patch Version**

```sh
repo-ninja version-bump patch
```

🔼 **This will:**

1. Check for uncommitted changes
2. Ensure you're on the default branch
3. Update `package.json.version`
4. Generate `version.ts`
5. Commit & tag the new version

---

### **Check If the Last Commit Has a Beta Tag**

```sh
repo-ninja beta-check-tag
```

🔍 **This will:**

- Check if the last commit is tagged with a beta version
- Exit with success if a beta tag exists
- Fail if no beta tag is found

To **run in dry-run mode** (only warn, no failure):

```sh
repo-ninja beta-check-tag --dry-run
```

---

### **Clean Old Local Branches**

```sh
repo-ninja clean-local-branches --dry-run
```

🔍 **This will:**

- List local branches that no longer exist on the remote
- Warn if uncommitted changes exist
- **No branches will be deleted in dry-run mode**

Run without `--dry-run` to actually delete them:

```sh
repo-ninja clean-local-branches
```

---

## 📌 **Contributing**

Want to improve `repo-ninja`? Check out our [contribution guide!](CONTRIBUTING.md) 🚀
