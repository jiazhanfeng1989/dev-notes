---
id: 68krwv07d88e4730egwsui9
title: Git
desc: ''
updated: 1747393092202
created: 1747391620429
---

## Common Git Operations

This section contains frequently used Git commands for daily development workflow. Each command includes:
- Purpose and usage
- Common scenarios
- Important flags and options

## Git Config Commands

```git
# List all configurations (system, global, and local)
git config -l 

# List only local repository configurations (.git/config)
git config --local -l 

# Configure user info for current repository
git config --local user.name 
git config --local user.email
```

## Git Fetch Commands

```git
# Clean up stale remote references and update tags
git fetch --all --prune --tags

# Synchronize branches and tags
git fetch --all --tags

# Fetch remote tags
git fetch --tags
git fetch --tags --force
```

## Git Tag Commands

```git
# Delete all local tags (use with caution!)
git tag -l | xargs -n 1 git tag -d
```

## Git ls-remote Commands
``` git
# ls remote tags
git ls-remote --tags
```

## Git Commands Combination
``` git 
# remove branch not exist on the remote
1. git fetch --prune
2. git branch -vv | grep ': gone]' | awk '{print $1}' | xargs -r git branch -D
```
