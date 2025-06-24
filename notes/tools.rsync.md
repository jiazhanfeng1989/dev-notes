---
id: pyvot9dxqa4pg830ef0wb0c
title: Rsync
desc: ''
updated: 1750730985565
created: 1750729914343
---

# Description
Rsync is a utility for efficiently transferring and synchronizing files across computer systems, using a remote shell or directly over the network. It is widely used for backups and mirroring.

# Usage
```bash
rsync [OPTION]... SRC [SRC]... DEST
```

# Options
- `-a`, `--archive`: Archive mode; equals -rlptgoD (no -H,-A,-X).
- `-v`, `--verbose`: Increase verbosity.
- `-z`, `--compress`: Compress file data during the transfer.
- `-r`, `--recursive`: Recurse into directories.
- `-u`, `--update`: Skip files that are newer on the receiver.
- `-l`, `--links`: Copy symlinks as symlinks.
- `-p`, `--perms`: Preserve permissions.
- `-t`, `--times`: Preserve modification times.
- `-g`, `--group`: Preserve group.
- `-o`, `--owner`: Preserve owner (super-user only).
- `-D`: Same as --devices --specials.
- `--devices`: Preserve device files (super-user only).
- `--specials`: Preserve special files.
- `--delete`: Delete files that don't exist on the sender.
- `--exclude=PATTERN`: Exclude files matching PATTERN.
- `--include=PATTERN`: Include files matching PATTERN.
- `--dry-run`: Perform a trial run with no changes made.
- `--progress`: Show progress during transfer.
- `--bwlimit=RATE`: Limit I/O bandwidth; K, M, G suffixes supported.
- `--partial`: Keep partially transferred files.
- `--checksum`: Skip based on checksum, not mod-time & size.
- `--ignore-existing`: Skip files that already exist on the destination.
- `--ignore-times`: Don't skip files that match in size and time.
- `--info=FLAGS`: Control what information is displayed during transfer.
- `--log-file=FILE`: Log what is being transferred to FILE.
- `--log-file-format=FORMAT`: Specify the format for log file entries.
- `--stats`: Give some file transfer stats.
- `--human-readable`: Output numbers in a human-readable format.
- `--timeout=SECONDS`: Set I/O timeout in seconds.
- `--port=PORT`: Specify the remote port to connect to.
- `--rsh=COMMAND`: Specify the remote shell to use.
- `--rsync-path=PROGRAM`: Specify the rsync program to use on the remote host.
- `--version`: Output version information and exit.
- `--help`: Show this help message and exit.
# Examples
```bash
# Basic usage: Sync a local directory to a remote server
rsync -avz /path/to/local/dir/ user@remote:/path/to/remote/dir/

# Sync a local directory to a remote server, outputting human-readable numbers
rsync -avz --human-readable /path/to/local/dir/ user@remote:/path/to/remote/dir/

# Sync a local directory to a remote server, excluding certain files
rsync -avz --exclude='*.tmp' /path/to/local/dir/ user@remote:/path/to/remote/dir/

# Sync a remote directory to a local directory, showing progress
rsync -avz --progress user@remote:/path/to/remote/dir/ /path/to/local/dir/

# Sync a local directory to a remote server, limiting bandwidth
rsync -avz --bwlimit=1000 /path/to/local/dir/ user@remote:/path/to/remote/dir/

# Sync a local directory to a remote server, using a specific port
rsync -avz --port=2222 /path/to/local/dir/ user@remote:/path/to/remote/dir/

# Sync a local directory to a remote server, using a specific remote shell
rsync -avz --rsh='ssh -i /path/to/private/key' /path/to/local/dir/ user@remote:/path/to/remote/dir/

# Sync a local directory to a remote server, skipping files that already exist
rsync -avz --ignore-existing /path/to/local/dir/ user@remote:/path/to/remote/dir/

# Sync a local directory to a remote server, skipping files that match in size and time
rsync -avz --ignore-times /path/to/local/dir/ user@remote:/path/to/remote/dir/

# Sync a local directory to a remote server, using checksums to skip files
rsync -avz --checksum /path/to/local/dir/ user@remote:/path/to/remote/dir/

# Sync a local directory to a remote server, logging the transfer
rsync -avz --log-file=/path/to/logfile.log /path/to/local/dir/ user@remote:/path/to/remote/dir/

# Sync a local directory to a remote server, setting an I/O timeout
rsync -avz --timeout=30 /path/to/local/dir/ user@remote:/path/to/remote/dir/

# Sync a local directory to a remote server, using a specific remote port
rsync -avz --port=2222 /path/to/local/dir/ user@remote:/path/to/remote/dir/
```