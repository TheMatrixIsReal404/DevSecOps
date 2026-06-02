# Linux Foundations
 
 
## 📺 Theory — Linux Foundations
 
### What is Linux and Why DevSecOps Engineers Live in the Terminal
 
Linux is a free, open-source operating system that powers the vast majority of web servers, cloud infrastructure, and security tools. As a DevSecOps engineer, nearly everything you interact with — containers, servers, CI/CD pipelines, firewalls — runs on Linux.
 
Unlike Windows (which uses a GUI-first design), Linux is **terminal-first**. The terminal gives you precise, scriptable, auditable control over the system. That's why security professionals live in it.
 
**Key Distributions to Know:**
 
| Distro | Used For | Package Manager | Notes |
|--------|----------|----------------|-------|
| **Ubuntu** | Learning, dev environments, cloud | `apt` | Beginner-friendly, large community |
| **RHEL / CentOS** | Enterprise production servers | `yum` / `dnf` | Paid support, used in large orgs |
| **Debian** | Stable servers, base for Ubuntu | `apt` | Rock-solid, minimal |
| **Kali Linux** | Penetration testing | `apt` | Pre-loaded with security tools |
| **Alpine** | Docker containers | `apk` | Ultra-minimal, ~5MB image |
 
> 💡 **For this course:** Ubuntu 22.04 LTS is recommended.
 
> 🧠 **Why it matters:** RHEL-family syntax (like `yum install`) differs from Debian-family (`apt install`). You will encounter both in the real world.
 
---
 
## 🗂️ The Linux Filesystem Hierarchy
 
Unlike Windows (which uses `C:\`, `D:\` drive letters), Linux organizes **everything** under one single tree starting at `/` (called **root**).
 
> **Core concept:** In Linux, *"everything is a file"* — hardware devices, processes, even network sockets are represented as files.
 
```
/                        ← Root of everything
├── etc/                 ← System config (passwd, shadow, sudoers)
├── var/
│   └── log/             ← Audit logs (auth.log, syslog)
├── home/
│   └── yourname/        ← Your personal files
├── root/                ← Root user's home (separate from /home)
├── tmp/                 ← World-writable temp space ⚠️
├── usr/
│   └── bin/             ← Standard user commands (ls, grep, cat)
├── sbin/                ← Root-only system binaries
├── proc/                ← Live process info (RAM only)
└── dev/                 ← Device files (hard drives, USB, etc.)
```
 
### Critical Directories & Their Security Relevance
 
| Directory | Purpose | Security Relevance |
|-----------|---------|-------------------|
| `/` | Root of the entire filesystem | Only `root` user can write here |
| `/etc` | System configuration files | Contains `passwd`, `shadow`, `sudoers` — the nerve center |
| `/etc/passwd` | Local user account info | **World-readable** — attackers use it to enumerate valid users |
| `/etc/shadow` | Hashed user passwords | **Root-only** — stores password hashes to prevent cracking |
| `/etc/sudoers` | Sudo privilege rules | Misconfiguration = instant privilege escalation |
| `/var/log` | System & application logs | Your **audit trail** — never delete; attackers try to wipe `auth.log` |
| `/home` | User home directories | Sensitive files (`.ssh/id_rsa`, `.bashrc`) live here |
| `/root` | Root user's home | Strictly locked down — admin's private configs |
| `/tmp` | Temporary files | **World-writable** — attacker playground; common malware staging area |
| `/usr/bin` | User command binaries | Where `ls`, `grep`, `cat` live — watch for Trojanized replacements |
| `/sbin` | System admin binaries | Root-only tools like `iptables`, `fdisk` |
| `/proc` | Virtual process filesystem | Exists only in RAM — real-time system state, useful for hunting malware |
| `/dev` | Device files | Raw hardware access (e.g., `/dev/sda` = your hard drive) |
 
> 🔐 **Security Instinct:** Always ask — *"Who can read this? Who can write here?"* That question is the foundation of Linux security.
 
---
 
## 💻 Hands-On Labs — Linux CLI Foundations
 
### Setup
- Install **Ubuntu 22.04 LTS** via VirtualBox, OR
- Enable **WSL2** on Windows: open PowerShell as Admin → `wsl --install` → restart
> 💡 **WSL2 Tip:** After install, find Ubuntu in your Start menu. Your Windows files are accessible at `/mnt/c/Users/YourName/`.
 
---
 
## ⌨️ Terminal Shortcuts — Learn These First
 
Before any commands, these shortcuts will save you hours:
 
| Shortcut | What It Does |
|----------|-------------|
| `Tab` | **Auto-complete** a command or filename — use this constantly |
| `Tab Tab` | Show all possible completions when there are multiple |
| `↑` / `↓` | Scroll through command history |
| `Ctrl + R` | **Reverse search** your history — type a keyword to find past commands |
| `Ctrl + C` | Kill the current running command |
| `Ctrl + L` | Clear the terminal screen (same as `clear`) |
| `Ctrl + A` | Jump to the **beginning** of the line |
| `Ctrl + E` | Jump to the **end** of the line |
| `Ctrl + U` | Delete everything to the left of cursor |
| `Ctrl + W` | Delete the last word typed |
| `!!` | Re-run the previous command |
| `sudo !!` | Re-run the previous command **as root** — extremely useful |
 
> 🔥 **Pro Tip:** `sudo !!` is one of the most-used tricks in Linux. Ran a command and got "Permission denied"? Just type `sudo !!` and press Enter.
 
---
 
## 📖 How to Read the Manual — `man` Pages
 
Before Googling, check the built-in manual:
 
```bash
man ls           # Full manual for the ls command
man grep         # Full manual for grep
man 5 passwd     # Section 5 = file formats (the /etc/passwd file structure)
```
 
| Inside `man` | What It Does |
|--------------|-------------|
| `Space` | Scroll down one page |
| `b` | Scroll back one page |
| `/keyword` | Search within the manual |
| `q` | Quit |
 
> 💡 **Quicker alternative:** `ls --help` or `grep --help` gives a short summary without the full manual.
 
---
 
### 1. Navigation & File Management
 
| Command | Example | What It Does |
|---------|---------|-------------|
| `pwd` | `pwd` | **P**rint **W**orking **D**irectory — "Where am I right now?" |
| `ls` | `ls -la` | List files. `-l` = long format (permissions), `-a` = show hidden dotfiles |
| `cd` | `cd ~` | Change directory. `~` = home, `-` = previous directory |
| `mkdir` | `mkdir -p ~/practice/{scripts,logs,configs}` | Make directory. `-p` creates parents; `{}` creates multiple at once |
| `touch` | `touch test.txt` | Creates an empty file (or updates its timestamp if it exists) |
 
**Try it:**
```bash
pwd
ls -la
cd ~
cd -                               # Jump back to where you just were
mkdir -p ~/practice/{scripts,logs,configs}
ls ~/practice                      # Confirm all 3 folders were created
touch test.txt
```
 
### 🔍 Reading `ls -la` Output
 
```
drwxr-xr-x  2 alice alice 4096 Jun  1 10:00 scripts
-rw-r--r--  1 alice alice  220 Jun  1 10:00 test.txt
^          ^ ^     ^
|          | |     └── Group owner
|          | └──────── User owner
|          └─────────── Number of hard links
└────────────────────── Permissions (see below)
```
 
**Permission string breakdown:**
```
- r w x r - x r - -
^ ^   ^   ^   ^   ^
| |   |   |   |   └── Others: read only
| |   |   |   └────── Group: read + execute
| |   |   └────────── User: read + write + execute
| └───────────────── File type: - = file, d = directory, l = symlink
```
 
| Symbol | Meaning |
|--------|---------|
| `r` | Read — view file contents or list directory |
| `w` | Write — modify file or create/delete inside directory |
| `x` | Execute — run the file as a program, or `cd` into directory |
| `-` | Permission NOT granted |
 
> 🔐 **Security Tip:** A file showing `-rwsr-xr-x` has the **SUID bit** set (`s` instead of `x`). It runs as its owner (often root) regardless of who executes it — a common privilege escalation target.
 
---
 
### 2. Viewing File Contents
 
| Command | Example | What It Does |
|---------|---------|-------------|
| `cat` | `cat test.txt` | Print entire file contents to the screen |
| `less` | `less file.txt` | Open interactive reader — scroll with arrows, `q` to quit |
| `head` | `head -20 file.txt` | Show only the **first** 20 lines |
| `tail` | `tail -20 file.txt` | Show only the **last** 20 lines |
| `tail -f` | `tail -f /var/log/auth.log` | **Live follow** — stream new lines as they are written (Ctrl+C to stop) |
| `nano` | `nano file.txt` | Simple terminal text editor — `Ctrl+O` save, `Ctrl+X` exit |
| `wc -l` | `wc -l /etc/passwd` | Count the number of lines in a file |
 
**Try it:**
```bash
cat test.txt
head -20 /etc/passwd
tail -20 /etc/passwd
wc -l /etc/passwd                  # How many user accounts exist?
less /etc/os-release               # q to quit
tail -f /var/log/syslog            # Watch live system logs (Ctrl+C to stop)
```
 
> 🔥 **Pro Tip:** `tail -f` is essential during incident response — run it on `auth.log` while watching for live login attempts.
 
---
 
### 3. Pipes & Redirection — The Power of Linux CLI
 
This is what makes Linux CLI truly powerful. Commands can be **chained together**.
 
| Operator | Example | What It Does |
|----------|---------|-------------|
| `\|` (pipe) | `cat /etc/passwd \| grep "root"` | Sends output of one command as input to the next |
| `>` | `ls -la > output.txt` | Writes output to a file (**overwrites** if file exists) |
| `>>` | `echo "hello" >> log.txt` | **Appends** output to a file (does not overwrite) |
| `2>/dev/null` | `find / -name "*.conf" 2>/dev/null` | Discards error messages (`2` = stderr) |
| `&&` | `mkdir logs && cd logs` | Run second command **only if first succeeds** |
| `\|\|` | `cd /tmp \|\| echo "failed"` | Run second command **only if first fails** |
 
**Try it:**
```bash
# Pipe examples
cat /etc/passwd | grep "bash"            # Find users with bash shell
ls -la /etc | grep "shadow"              # Find the shadow file entry
cat /etc/passwd | wc -l                  # Count total user accounts
 
# Redirection
ls -la ~ > ~/practice/homedir.txt        # Save listing to a file
cat ~/practice/homedir.txt               # Verify it was written
echo "new entry" >> ~/practice/homedir.txt    # Append without overwriting
 
# Chaining
mkdir ~/practice/test && echo "Created!" || echo "Already exists"
```
 
> 🧠 **Mental model for pipes:** Think of `|` as a conveyor belt. Each command picks up what the previous one put down, processes it, and passes it on.
 
---
 
### 4. Searching & Filtering
 
| Command | Example | What It Does |
|---------|---------|-------------|
| `find` | `find / -name "*.conf" 2>/dev/null` | Search entire filesystem for `.conf` files |
| `find` | `find /tmp -type f -mmin -10` | Find files in `/tmp` modified in the last 10 minutes |
| `find` | `find / -perm -4000 2>/dev/null` | Find all **SUID** files — privilege escalation check |
| `grep` | `grep "root" /etc/passwd` | Search for the string `"root"` inside a file |
| `grep -r` | `grep -r "password" /etc/ 2>/dev/null` | **Recursively** search all files in `/etc/` |
| `grep -i` | `grep -i "error" /var/log/syslog` | Case-insensitive search |
| `grep -n` | `grep -n "failed" /var/log/auth.log` | Show **line numbers** with results |
| `grep -v` | `grep -v "^#" /etc/ssh/sshd_config` | Show lines that do **NOT** match (exclude comments) |
 
**Try it:**
```bash
find / -name "*.conf" 2>/dev/null
find /tmp -type f                              # List all files in /tmp
find / -perm -4000 2>/dev/null                 # Find SUID binaries
 
grep "root" /etc/passwd
grep -n "failed" /var/log/auth.log 2>/dev/null    # Failed login attempts with line numbers
grep -v "^#" /etc/ssh/sshd_config 2>/dev/null     # SSH config without comment lines
grep -r "password" /etc/ 2>/dev/null
```
 
> 🔍 **Security note:** `find / -perm -4000 2>/dev/null` lists all SUID binaries on the system. This is one of the first commands a penetration tester runs after gaining access.
 
> 💡 **Grep tip:** `grep -v "^#"` removes comment lines from config files. `^` means "start of line", so `^#` matches any line beginning with `#`.
 
---
 
### 5. File Operations
 
| Command | Example | What It Does |
|---------|---------|-------------|
| `cp` | `cp file.txt backup.txt` | Copy a file |
| `cp -r` | `cp -r folder/ backup_folder/` | Copy an entire directory recursively |
| `mv` | `mv old.txt new.txt` | Move **or rename** a file |
| `rm` | `rm file.txt` | Remove a file |
| `rm -rf` | `rm -rf directory/` | ⚠️ Forcefully delete a directory and ALL its contents — no undo |
| `ln -s` | `ln -s /etc/passwd ~/passwd_link` | Create a **symbolic link** (shortcut) to a file |
 
**Try it:**
```bash
cp test.txt backup.txt
cp -r ~/practice ~/practice_backup
mv backup.txt renamed_backup.txt
rm renamed_backup.txt
```
 
---
 
### 6. System & Identity Information
 
| Command | Example | What It Does |
|---------|---------|-------------|
| `whoami` | `whoami` | Print your current username |
| `id` | `id` | Show your User ID (UID) and all groups you belong to |
| `groups` | `groups` | Show all groups your account belongs to |
| `uname -a` | `uname -a` | Print full system info (kernel version, architecture) |
| `hostname` | `hostname` | Print the machine's hostname |
| `date` | `date` | Print current date and time |
| `uptime` | `uptime` | Show how long the system has been running + load average |
| `df -h` | `df -h` | Show disk space usage in human-readable format |
| `du -sh ~` | `du -sh ~` | Show total size of your home directory |
| `free -h` | `free -h` | Show RAM usage in human-readable format |
| `ps aux` | `ps aux` | Show all running processes |
| `ps aux \| grep ssh` | `ps aux \| grep ssh` | Check if a specific process is running |
| `cat /etc/os-release` | `cat /etc/os-release` | Show your Linux distribution details |
 
**Try it:**
```bash
whoami
id
groups
uname -a
hostname
uptime
df -h
free -h
ps aux | grep ssh
cat /etc/os-release
```
 
> 🔐 **Security check:** `id` tells you if you are in the `sudo` or `docker` group. Being in the `docker` group is essentially equivalent to having root access — a frequent misconfiguration finding.
 
---
 
## 🛠️ Productivity Tips & Tricks
 
### Create Aliases for Long Commands
 
Aliases let you shorten commands you run often. Add them to `~/.bashrc` to make them permanent:
 
```bash
# Add these to ~/.bashrc
alias ll='ls -la'
alias ..='cd ..'
alias ...='cd ../..'
alias grep='grep --color=auto'          # Colorize grep matches
alias ports='ss -tulnp'                 # Quick open ports check
alias logs='tail -f /var/log/syslog'    # Live system log watcher
 
# Apply changes without restarting terminal
source ~/.bashrc
```
 
### Command History Tricks
 
```bash
history                      # Show numbered command history
history | grep "find"        # Search history for past find commands
!42                          # Re-run command number 42 from history
!!                           # Re-run the very last command
sudo !!                      # Re-run last command as root
# Ctrl + R                   # Live interactive history search — type to filter
```
 
> 💡 **Set a larger history:** Add `HISTSIZE=10000` and `HISTFILESIZE=20000` to `~/.bashrc` so you never lose a useful command.
 
### Writing to Files Quickly
 
```bash
# Single line — overwrite
echo "192.168.1.1  target" > hosts.txt
 
# Single line — append
echo "192.168.1.2  server" >> hosts.txt
 
# Multi-line file (heredoc)
cat > notes.txt << EOF
This is line 1
This is line 2
EOF
```
 
### Brace Expansion — Create Many Things at Once
 
```bash
mkdir -p ~/project/{src,tests,docs,logs}          # 4 directories at once
touch file{1..5}.txt                               # Creates file1.txt through file5.txt
cp config.conf config.conf.bak                     # Quick backup before editing
```
 
---
 
## ⚠️ Common Beginner Mistakes
 
| Mistake | What Happens | Fix |
|---------|-------------|-----|
| `rm -rf /` | Deletes the entire system — unrecoverable | Never run this. Modern Linux adds `--no-preserve-root` safeguard |
| `rm -rf *` in wrong directory | Deletes everything in current folder | Always run `pwd` before `rm -rf` |
| Forgetting `sudo` | "Permission denied" errors | Use `sudo !!` to instantly re-run as root |
| `>` instead of `>>` | Overwrites a file you meant to append to | Use `>>` to append, `>` only when you want to overwrite |
| `cat` on a binary file | Garbled output or terminal corruption | Run `file filename` first to check the type |
| Editing `/etc/sudoers` directly with `nano` | Can lock you out of sudo permanently | Always use `visudo` — it validates syntax before saving |
| `chmod 777` on sensitive files | Everyone on the system can read and write | Use the least permissive setting that still works |
 
> 🔥 **Golden rule before any destructive command:** Run `pwd` first. Many disasters happen because someone ran `rm -rf *` in the wrong directory.
 
---
 
## 🔐 Security Eye — Key Takeaways
 
1. **`/tmp` is dangerous** — world-writable, so any user or process can write there. Malware frequently stages and executes from here.
2. **`/etc/shadow` is your password vault** — it should only ever be readable by `root`. Verify with `ls -la /etc/shadow`.
3. **`/var/log` is your evidence** — in any security incident, logs are the first thing you check (and the first thing attackers try to erase). Monitor live with `tail -f /var/log/auth.log`.
4. **`whoami` + `id`** — always know who you are before running privileged commands. Check group membership — `sudo`, `docker`, and `adm` groups all carry significant power.
5. **`find` and `grep`** — dual-use recon tools. Defenders use them to audit; attackers use them to hunt for credentials and misconfigurations.
6. **SUID files** — run `find / -perm -4000 2>/dev/null` periodically. Any unexpected SUID binary is worth investigating.
7. **Pipes are your best friend** — `cat /var/log/auth.log | grep "Failed" | wc -l` gives you the exact count of failed login attempts in one line.
---
 
## 📝 Study Tip — Filesystem Cheatsheet
 
Try to recreate this table from memory in your own `linux_cheatsheet.md`:
 
| Path | What Lives Here | Security Check Command |
|------|----------------|----------------------|
| `/var/log/auth.log` | SSH + sudo login attempts | `tail -f /var/log/auth.log` |
| `/etc/shadow` | Password hashes | `ls -la /etc/shadow` (should be root-only) |
| `/etc/sudoers` | Sudo privilege rules | `sudo visudo` (always edit this way) |
| `/tmp` | World-writable temp files | `ls -la /tmp` (watch for unexpected executables) |
| `/proc` | Live process data | `ls /proc` (each number = a running process PID) |
| `~/.ssh/` | SSH keys | `ls -la ~/.ssh/` (id_rsa must be `chmod 600`) |
| `~/.bashrc` | Shell config + aliases | `cat ~/.bashrc` (attackers add persistence here) |
 
---
 
## 🧪 End-of-Day Challenge
 
Try these on your own — no peeking at the answers first:
 
1. Find all `.log` files under `/var` and count how many there are
2. Show only the lines in `/etc/passwd` that contain the word `bash`
3. Create a directory structure: `~/devsecops/week1/{notes,labs,scripts}`
4. Check how many failed SSH attempts are in your auth log
5. Find all SUID binaries on your system
<details>
<summary>Answers (click to reveal)</summary>
```bash
# 1 - Find and count all .log files under /var
find /var -name "*.log" 2>/dev/null | wc -l
 
# 2 - Show only bash-shell users
grep "bash" /etc/passwd
 
# 3 - Create directory structure with brace expansion
mkdir -p ~/devsecops/week1/{notes,labs,scripts}
 
# 4 - Count failed SSH attempts
grep "Failed" /var/log/auth.log 2>/dev/null | wc -l
 
# 5 - Find all SUID binaries
find / -perm -4000 2>/dev/null
```
 
</details>
---