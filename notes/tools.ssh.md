---
id: odenqqawtbds9vz8xu14vcu
title: SSH
desc: ''
updated: 1764835351525
created: 1764832587490
---

# Description
[SSH](https://www.ssh.com/academy/ssh) is a protocol for secure communication between a client and a server.

# SSH Commands
```bash
ssh -p <port> <user>@<host> # connect to a remote server with a specific port
ssh-keygen -t ed25519 -C "your_email@example.com" # generate an ssh key
ssh-copy-id -i ~/.ssh/id_ed25519.pub <user>@<host> # copy the public key to the remote server's authorized_keys file
ssh-keyscan -H <host> >> ~/.ssh/known_hosts # add the remote server's public key to the known_hosts file
```

# SSH Agent Usage
[SSH Agent](https://www.ssh.com/academy/ssh/agent) is used to manage SSH keys and use them to authenticate with remote servers.
```bash
eval "$(ssh-agent -s)" # start the ssh agent and print the agent's socket path
ssh-add <key> # add a key to the ssh agent
ssh-add -l # list the keys in the ssh agent
ssh-add -d <key> # delete a key from the ssh agent
ssh-add -D # delete all keys from the ssh agent
```