---
id: odenqqawtbds9vz8xu14vcu
title: SSH
desc: ''
updated: 1774516956329
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

# GitHub SSH Passwordless Login Configuration Guide
## 1. Generate SSH Key
### 1. Generate ED25519 Type SSH Key Pair

```bash
ssh-keygen -t ed25519 -C "devops" -f ~/.ssh/id_ed25519 -N ""
```

**Parameter Explanation:**
- `-t ed25519`: Use ED25519 algorithm (more secure and faster)
- `-C "devops"`: Add comment for identification
- `-f ~/.ssh/id_ed25519`: Specify key file path
- `-N ""`: Set empty passphrase (no password)

**Generated Files:**
- `~/.ssh/id_ed25519`: Private key (keep secret, do not share)
- `~/.ssh/id_ed25519.pub`: Public key (add to GitHub)

---

## 2. Configure ssh-agent
### 1. Start ssh-agent and Add Key

```bash
eval "$(ssh-agent -s)"
ssh-add ~/.ssh/id_ed25519
```

---

## 3. Configure SSH config File

### 1. Create or Edit `~/.ssh/config` File

```bash
cat > ~/.ssh/config << 'EOF'
Host github.com
  AddKeysToAgent yes
  UseKeychain yes
  IdentityFile ~/.ssh/id_ed25519

Host *
  AddKeysToAgent yes
  UseKeychain yes
EOF
```

### 2. Set config File Permissions

```bash
chmod 600 ~/.ssh/config
```

**Configuration Explanation:**
- `AddKeysToAgent yes`: Automatically add key to ssh-agent
- `UseKeychain yes`: Use keychain to save passphrase on macOS
- `IdentityFile`: Specify the private key file to use

---

## 4. Get Public Key

### 1. View Public Key Content

```bash
cat ~/.ssh/id_ed25519.pub
```

### 2. Copy Public Key to Clipboard (macOS)

```bash
cat ~/.ssh/id_ed25519.pub | pbcopy
```
---

## 5. Add SSH Public Key to GitHub

### 1. Visit GitHub SSH Settings Page

Open browser and visit: https://github.com/settings/keys

### 2. Add New SSH Key

1. Click the green **"New SSH key"** button in the upper right corner
2. **Title**: Enter a descriptive name (e.g., `MacBook Pro`)
3. **Key type**: Select `Authentication Key`
4. **Key**: Paste the public key content (Cmd+V)
5. Click **"Add SSH key"** button
6. Enter GitHub password to confirm if required
---

## 6. Add GitHub to known_hosts

```bash
ssh-keyscan -t ed25519 github.com >> ~/.ssh/known_hosts
```
**Purpose:** Avoid host verification prompt on first connection

---
## 7. Test SSH Connection

```bash
ssh -T git@github.com
```

**Successful Output Example:**
```
Hi jiazhanfeng1989! You've successfully authenticated, but GitHub does not provide shell access.
```

**If Failed:**
- Check if public key is correctly added to GitHub
- Check network connection
- View detailed error: `ssh -Tv git@github.com`

---

## 8. Common Commands Quick Reference

### SSH Related

```bash
# View loaded SSH keys
ssh-add -l

# Remove all loaded keys
ssh-add -D

# Re-add key
ssh-add ~/.ssh/id_ed25519

# Test GitHub connection (show detailed information)
ssh -Tv git@github.com

# View SSH public key
cat ~/.ssh/id_ed25519.pub

# Copy public key to clipboard
cat ~/.ssh/id_ed25519.pub | pbcopy
```
---

## 9. File Structure

SSH directory structure after configuration:

```
~/.ssh/
├── id_ed25519          # Private key (keep secret)
├── id_ed25519.pub      # Public key (add to GitHub)
├── config              # SSH configuration file
└── known_hosts         # Known hosts list
```

---

## 10. Security Recommendations

1. **Private Key Security**
   - Never share the `id_ed25519` private key file
   - Do not upload private key to any online service
   - Regularly backup private key to a secure location

2. **Passphrase**
   - This configuration uses empty password for convenience
   - For higher security, regenerate key with password:
     ```bash
     ssh-keygen -t ed25519 -C "github_key" -f ~/.ssh/id_ed25519
     # Without -N "" parameter, you'll be prompted for password
     ```

3. **Multi-Device Management**
   - Generate independent SSH keys for each device
   - Add descriptive names for each key in GitHub
   - You can revoke unused keys in GitHub at any time

4. **Permission Settings**
   - `~/.ssh` directory permission should be `700`
   - Private key file permission should be `600`
   - Public key and config file permission should be `644` or `600`

---
## Appendix: SSH Key Type Comparison

| Type | Key Length | Security | Speed | Recommendation |
|------|-----------|----------|-------|----------------|
| **ED25519** | 256-bit | ⭐⭐⭐⭐⭐ | Fastest | ✅ Recommended |
| RSA | 2048-bit | ⭐⭐⭐ | Slower | ⚠️ Old standard |
| RSA | 4096-bit | ⭐⭐⭐⭐ | Slowest | ⚠️ Overly conservative |
| ECDSA | 256-bit | ⭐⭐⭐⭐ | Fast | ⚠️ Implementation issues |

**ED25519 is Recommended** because:
- Short key length but high security
- Fast generation and verification speed
- Resistant to side-channel attacks
- Officially recommended by GitHub

---

**Configuration Complete! 🎉**
Now you can happily use SSH method to operate GitHub repositories!
