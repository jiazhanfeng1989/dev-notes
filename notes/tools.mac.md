---
id: 3ow2waa14bgo01jsubc2ae3
title: Mac
desc: ''
updated: 1778558747341
created: 1770346207348
---

# Description
Some tools for Mac.

# Tools
- [mole](https://github.com/tw93/mole) Deep clean and optimize your Mac.
- [AppCleaner](https://freemacsoft.net/appcleaner/) Uninstall unwanted apps.
- [OmniDiskSweeper](https://www.omnigroup.com/more/omnidisksweeper/) Disk space analyzer.

## Mac shortcuts
```

# Source for added/corrected Apple shortcuts: https://support.apple.com/en-us/102650
Show Desktop:                              Fn + F11
Spotlight Search:                          Command (⌘) + space
switch app:                                Command (⌘) + Tab
switch same app different window:          Command (⌘) + ~
full screen mode:                          Control (⌃) + Command (⌘) + F
open mission control:                      Control (⌃) + Up Arrow (↑)
search in Finder:                          Command (⌘) + Option (⌥) + Space
open system settings:                      Command (⌘) + Space, then type "System Settings"
open activity monitor:                     Command (⌘) + Space, then type "Activity Monitor"
open terminal:                             Command (⌘) + Space, then type "Terminal"
show hidden files:                         Command (⌘) + Shift (⇧) + .
Quit current app:                          Command (⌘) + Q
Force quit an app:                         Command (⌘) + Option (⌥) + Esc
Minimize front window:                     Command (⌘) + M
Close front window:                        Command (⌘) + W
Hide front app:                            Command (⌘) + H
Show/hide Dock:                            Command (⌘) + Option (⌥) + D
Lock screen:                               Control (⌃) + Command (⌘) + Q
Open app settings/preferences:             Command (⌘) + ,
```

# Commands
```bash
# Show the top 10 processes by memory usage
top -l 1 -n 10 -o mem

# Show the memory pressure
memory_pressure

# Clean up disk space and memory cache
sudo purge

# Show the network usage by pid
nettop -P

# Show the system uptime
uptime

# Show the system disk and memory usage    
iostat

# Show the system disk usage
df -h

# Show all installed packages
brew list

# Show only command line tools (formula)
brew list --formula

# Show only GUI applications (cask)
brew list --cask

# Show all installed packages with versions
brew list --versions

brew install python@3.11

brew info geos

# Disable brew auto update
echo 'export HOMEBREW_NO_AUTO_UPDATE=1' >> ~/.zshrc
HOMEBREW_NO_AUTO_UPDATE=1 brew install wget


# Keep the computer awake
 caffeinate -d

# Keep the computer awake for 1 hour
caffeinate -dimsu -t 3600
```

# Development Tools
```
# install brew
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

# install ohmyzsh
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"

# configure brew
eval "$(/opt/homebrew/bin/brew shellenv)" 
export HOMEBREW_NO_AUTO_UPDATE=1  

# option: install git-lfs
brew install git-lfs
brew install htop

# install mitmproxy
brew install mitmproxy
alias mitmp='mitmproxy --set console_mouse=false'

# install uv
curl -LsSf https://astral.sh/uv/install.sh | sh
uv python install 3.12.10

# install temurin@21 java21
brew install --cask temurin@21

# install ninja
brew install ninja

# install npm
brew install npm

# install orbstack
brew install orbstack

# install meld
brew install --cask meld
```