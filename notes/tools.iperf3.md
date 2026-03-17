---
id: 1706kc0frw1w5s7g6q3ocqs
title: Iperf3
desc: ''
updated: 1773712482069
created: 1773712129462
---
# Description:

[Iperf3](https://iperf.fr/iperf-doc.html) is a tool for measuring network performance. It can be used to test the bandwidth of a network connection, and to test the latency of a network connection.


# Installation:

```bash
# On Debian/Ubuntu
sudo apt-get install iperf3

# On CentOS/RedHat
yum install iperf3

# On macOS using Homebrew
brew install iperf3
# On Windows, download the installer from the official website
```
# Usage
```bash

# Start server
iperf3 -s

# Test connection, upload network throughput
iperf3 -c <remote_host>

# Test reverse connection, download network throughput
iperf3 -c <remote_host> -R

# Test connection with 8 threads
iperf3 -c  <remote_host> -P 8
```