---
id: cxdb69due45txsbp5h32imr
title: Witr
desc: ''
updated: 1767065092109
created: 1767064842604
---

# Description
[witr](https://github.com/pranshuparmar/witr) is a tool for describing why this process running.

# Usage
```bash
# Install witr
curl -fsSL https://raw.githubusercontent.com/pranshuparmar/witr/main/install.sh | bash

# Describe why the process with PID 14233 is running
witr --pid 14233

# Describe why the process with port 5000 is running
witr --port 5000

# Describe process or service is running
witr nginx
```