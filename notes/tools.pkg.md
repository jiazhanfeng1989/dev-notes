---
id: n2f0x39mh9tllknlchvf0b9
title: Pkg
desc: ''
updated: 1788746986720
created: 1788745940177
---

# Description

Common commands for packaging, compressing, and verifying archives.

# tar vs gzip vs zip vs unzip

In short: **tar** archives files, **gzip** compresses a single file, **zip** archives and compresses in one step, **unzip** extracts `.zip` only.

## What each tool does

| Command | Role | Main job | Typical output |
|---------|------|----------|----------------|
| **tar** | Archiver | Combine files/dirs into one archive | `.tar` |
| **gzip** | Compressor | Compress a **single** file | `.gz` |
| **zip** | Archiver + compressor | Archive and compress in one step | `.zip` |
| **unzip** | Extractor | Extract `.zip` (companion to `zip`) | Restored files/dirs |

## Key differences

### Archive vs compress

| | Archive | Compress |
|---|---------|----------|
| **tar** | Yes | No (use with gzip, etc.) |
| **gzip** | No | Yes |
| **zip** | Yes | Yes |
| **unzip** | — | Extract `.zip` only |

A `.tar.gz` / `.tgz` file is two steps: `dir/` → `tar` → `.tar` → `gzip` → `.tar.gz`.  
Or one step: `tar -czf dir.tar.gz dir/`.

### Compress a directory?

| Tool | Directory support |
|------|-------------------|
| **tar** | Yes — `tar -cf dir.tar dir/` |
| **zip** | Yes — `zip -r dir.zip dir/` |
| **gzip** | No — single file only (`gzip file.txt` → `file.txt.gz`) |

For directories, use `tar -czf` (Unix/Linux) or `zip -r` (cross-platform).

### Platform conventions

| Scenario | Common format |
|----------|---------------|
| Linux / servers / source releases | `.tar.gz` |
| Windows / cross-platform sharing | `.zip` |
| Single log or data file | `.gz` |

### Metadata

| Tool | Notes |
|------|-------|
| **tar** | Preserves permissions, timestamps, symlinks well (Unix-friendly) |
| **zip** | Good cross-platform support; Unix metadata handling varies by tool |
| **gzip** | Operates on a single file stream; no directory structure |

## When to use which

| Need | Use |
|------|-----|
| Archive a directory on Linux/server | `tar -czf` |
| Share with Windows users or email attachments | `zip` |
| Compress one large file (log, data) | `gzip` |
| Extract `.zip` | `unzip` |
| Extract `.tar.gz` | `tar -xzf` (not `unzip`) |

## Common pitfalls

| Mistake | Correct approach |
|---------|------------------|
| `.tar.gz` is not a tar format alone | It is `.tar` + `.gz` |
| `unzip` on `.gz` or `.tar.gz` | Use `gunzip` or `tar -xzf` |
| No `ungzip` command | Use `gunzip` or `gzip -d` |
| `.gz` holds one file stream | Use `.tar.gz` or `.zip` for directories |

## Flow

```
Single file:
  file.txt ──gzip──► file.txt.gz

Directory (Unix):
  dir/ ──tar──► dir.tar ──gzip──► dir.tar.gz
         └── tar -czf (one step) ──┘

Directory (cross-platform):
  dir/ ──zip──► dir.zip ──unzip──► dir/
```

# Commands
```bash

# Create a tarball of a directory
tar --exclude='.DS_Store' -czf test.tar.gz test

# Extract a tarball
tar -xzf test.tar.gz

# List the contents of a tarball
tar -tvf test.tar.gz

# Calculate the MD5 checksum of a file
md5sum test.tar.gz > test.tar.gz.md5

# Verify the MD5 checksum of a file
md5sum -c test.tar.gz.md5

# Calculate the SHA1 checksum of a file
sha256sum test.tar.gz > test.tar.gz.sha256

# Verify the SHA1 checksum of a file
sha256sum -c test.tar.gz.sha256

# Create a zip archive of a directory
zip -r -x '*.DS_Store' test.zip test

# Extract a zip archive
unzip test.zip

# Decompress a file,  keep original file
gunzip  -c test.gz > test.data
gzip -dc test.gz > test.data

# List the compression ratio of a gzip file
gzip -l test.gz


# View the contents of a gzip file
zless test.gz

# Search for a pattern in a gzip file
zgrep "pattern" test.gz
```