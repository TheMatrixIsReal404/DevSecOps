# 🐧 Linux Command Cheatsheet
> **Day 1 Reference** — Quick-access commands for CLI navigation, file ops, searching, and system info.  

 
---
 
## ⌨️ Terminal Shortcuts
 
| Shortcut | What It Does |
|----------|-------------|
| `Tab` | Auto-complete a command or filename |
| `Tab Tab` | Show all possible completions |
| `↑` / `↓` | Scroll through command history |
| `Ctrl + R` | Reverse search history — type a keyword |
| `Ctrl + C` | Kill the current running command |
| `Ctrl + L` | Clear the terminal screen |
| `Ctrl + A` | Jump to the beginning of the line |
| `Ctrl + E` | Jump to the end of the line |
| `Ctrl + U` | Delete everything left of cursor |
| `Ctrl + W` | Delete the last word typed |
| `!!` | Re-run the previous command |
| `sudo !!` | Re-run previous command as root |
 
---
 
## 📖 Manual & Help
 
```bash
man ls                # Full manual for ls
man grep              # Full manual for grep
man 5 passwd          # Section 5 = file formats
ls --help             # Quick summary (faster than man)
grep --help
```
 
| Inside `man` | Action |
|--------------|--------|
| `Space` | Scroll down one page |
| `b` | Scroll back one page |
| `/keyword` | Search within the manual |
| `q` | Quit |
 
---
 
## 📂 1. Navigation & File Management
 
| Command | Example | What It Does |
|---------|---------|-------------|
| `pwd` | `pwd` | Print current directory |
| `ls` | `ls -la` | List files; `-l` = long format, `-a` = show hidden |
| `cd` | `cd ~` | Change directory; `~` = home, `-` = previous dir |
| `mkdir` | `mkdir -p ~/practice/{scripts,logs,configs}` | Make dir; `-p` creates parents + multiple at once |
| `touch` | `touch test.txt` | Create empty file (or update its timestamp) |
 
```bash
pwd
ls -la
cd ~
cd -                                    # Jump back to where you just were
mkdir -p ~/practice/{scripts,logs,configs}
ls ~/practice                           # Confirm all 3 folders were created
touch test.txt
```
 
### Reading `ls -la` output
 
```
drwxr-xr-x  2 alice alice 4096 Jun  1 10:00 scripts
-rw-r--r--  1 alice alice  220 Jun  1 10:00 test.txt
│           │ │     │
│           │ │     └── Group owner
│           │ └──────── User owner
│           └─────────── Hard links
└────────────────────── Permissions string
```
 
```
- r w x r - x r - -
│ ├───┤ ├───┤ ├───┤
│  U    G    O
│
└── File type: - = file, d = directory, l = symlink
```
 
| Symbol | Meaning |
|--------|---------|
| `r` | Read |
| `w` | Write |
| `x` | Execute / enter directory |
| `-` | Permission NOT granted |
 
> 🔐 `-rwsr-xr-x` → **SUID bit set** (`s` instead of `x`). Runs as owner (often root). Common privesc target.
 
---
 
## 👁️ 2. Viewing File Contents
 
| Command | Example | What It Does |
|---------|---------|-------------|
| `cat` | `cat test.txt` | Print entire file to screen |
| `less` | `less file.txt` | Interactive reader; scroll with arrows, `q` to quit |
| `head` | `head -20 file.txt` | Show first 20 lines |
| `tail` | `tail -20 file.txt` | Show last 20 lines |
| `tail -f` | `tail -f /var/log/auth.log` | **Live follow** — stream new lines in real time |
| `nano` | `nano file.txt` | Simple text editor; `Ctrl+O` save, `Ctrl+X` exit |
| `wc -l` | `wc -l /etc/passwd` | Count lines in a file |
 
```bash
cat test.txt
head -20 /etc/passwd
tail -20 /etc/passwd
wc -l /etc/passwd                       # How many user accounts?
less /etc/os-release                    # q to quit
tail -f /var/log/syslog                 # Watch live system logs (Ctrl+C to stop)
```
 
---
 
## 🔗 3. Pipes & Redirection
 
| Operator | Example | What It Does |
|----------|---------|-------------|
| `\|` | `cat /etc/passwd \| grep "root"` | Pipe output as input to next command |
| `>` | `ls -la > output.txt` | Write output to file (**overwrites**) |
| `>>` | `echo "hello" >> log.txt` | **Append** to file |
| `2>/dev/null` | `find / -name "*.conf" 2>/dev/null` | Discard error messages |
| `&&` | `mkdir logs && cd logs` | Run next command only if first **succeeds** |
| `\|\|` | `cd /tmp \|\| echo "failed"` | Run next command only if first **fails** |
 
```bash
cat /etc/passwd | grep "bash"           # Users with bash shell
ls -la /etc | grep "shadow"             # Find the shadow file
cat /etc/passwd | wc -l                 # Count total user accounts
 
ls -la ~ > ~/practice/homedir.txt       # Save listing to a file
echo "new entry" >> ~/practice/homedir.txt    # Append without overwriting
 
mkdir ~/practice/test && echo "Created!" || echo "Already exists"
```
 
> 🧠 Think of `|` as a conveyor belt — each command processes what the previous one passed.
 
---
 
## 🔍 4. Searching & Filtering
 
| Command | Example | What It Does |
|---------|---------|-------------|
| `find` | `find / -name "*.conf" 2>/dev/null` | Search filesystem for `.conf` files |
| `find` | `find /tmp -type f -mmin -10` | Files in `/tmp` modified in last 10 min |
| `find` | `find / -perm -4000 2>/dev/null` | **SUID** files — privilege escalation check |
| `grep` | `grep "root" /etc/passwd` | Search string inside a file |
| `grep -r` | `grep -r "password" /etc/ 2>/dev/null` | Recursive search through directory |
| `grep -i` | `grep -i "error" /var/log/syslog` | Case-insensitive search |
| `grep -n` | `grep -n "failed" /var/log/auth.log` | Show line numbers with results |
| `grep -v` | `grep -v "^#" /etc/ssh/sshd_config` | Exclude matching lines (e.g., strip comments) |
 
```bash
find / -name "*.conf" 2>/dev/null
find /tmp -type f                               # All files in /tmp
find / -perm -4000 2>/dev/null                  # Find all SUID binaries
 
grep "root" /etc/passwd
grep -n "failed" /var/log/auth.log 2>/dev/null  # Failed logins with line numbers
grep -v "^#" /etc/ssh/sshd_config 2>/dev/null  # SSH config, no comments
grep -r "password" /etc/ 2>/dev/null
```
 
---
 
## 📁 5. File Operations
 
| Command | Example | What It Does |
|---------|---------|-------------|
| `cp` | `cp file.txt backup.txt` | Copy a file |
| `cp -r` | `cp -r folder/ backup/` | Copy directory recursively |
| `mv` | `mv old.txt new.txt` | Move or rename a file |
| `rm` | `rm file.txt` | Remove a file |
| `rm -rf` | `rm -rf directory/` | ⚠️ Force-delete directory + all contents — no undo |
| `ln -s` | `ln -s /etc/passwd ~/passwd_link` | Create a symbolic link |
 
```bash
cp test.txt backup.txt
cp -r ~/practice ~/practice_backup
mv backup.txt renamed_backup.txt
rm renamed_backup.txt
```
 
---
 
---
 
## 🖥️ 6. System & Identity Info
 
| Command | Example | What It Does |
|---------|---------|-------------|
| `whoami` | `whoami` | Print current username |
| `id` | `id` | Show UID and all group memberships |
| `groups` | `groups` | Show groups your account belongs to |
| `uname -a` | `uname -a` | Full system info (kernel, architecture) |
| `hostname` | `hostname` | Print machine hostname |
| `date` | `date` | Current date and time |
| `uptime` | `uptime` | System uptime + load average |
| `df -h` | `df -h` | Disk space usage (human-readable) |
| `du -sh ~` | `du -sh ~` | Total size of home directory |
| `free -h` | `free -h` | RAM usage (human-readable) |
| `ps aux` | `ps aux` | Show all running processes |
| `ps aux \| grep ssh` | — | Check if a specific process is running |
| `cat /etc/os-release` | — | Show Linux distribution details |
 
```bash
whoami
id                                      # Check for sudo/docker group membership!
groups
uname -a
hostname
uptime
df -h
free -h
ps aux | grep ssh
cat /etc/os-release
```
 
> 🔐 Being in the `docker` group = effectively root. Being in `sudo` group = can run anything as root. Always verify with `id`.
 
---
 
## ⚡ 7. Productivity Shortcuts
 
### Aliases (add to `~/.bashrc`)
 
```bash
alias ll='ls -la'
alias ..='cd ..'
alias ...='cd ../..'
alias grep='grep --color=auto'
alias ports='ss -tulnp'                 # Quick open ports check
alias logs='tail -f /var/log/syslog'    # Live log watcher
 
source ~/.bashrc                        # Apply changes without restarting
```
 
### History Tricks
 
```bash
history                         # Show numbered history
history | grep "find"           # Search history for a command
!42                             # Re-run command #42
!!                              # Re-run last command
sudo !!                         # Re-run last command as root
# Ctrl+R                        # Live interactive history search
```
 
> 💡 Add `HISTSIZE=10000` and `HISTFILESIZE=20000` to `~/.bashrc` to never lose a command.
 
### Writing to Files
 
```bash
echo "192.168.1.1  target" > hosts.txt        # Overwrite
echo "192.168.1.2  server" >> hosts.txt       # Append
 
cat > notes.txt << EOF
This is line 1
This is line 2
EOF
```
 
### Brace Expansion
 
```bash
mkdir -p ~/project/{src,tests,docs,logs}      # 4 directories at once
touch file{1..5}.txt                          # Creates file1.txt–file5.txt
cp config.conf config.conf.bak               # Quick backup before editing
```
 
---
 
## ⚠️ Danger Zone — Mistakes to Avoid
 
| Mistake | Consequence | Fix |
|---------|------------|-----|
| `rm -rf /` | Deletes entire system | Never run this |
| `rm -rf *` in wrong directory | Deletes everything in current folder | Always `pwd` before `rm -rf` |
| `>` instead of `>>` | Overwrites file you meant to append | Use `>>` to append |
| Editing `/etc/sudoers` with `nano` | Can lock you out of sudo | Always use `visudo` |
| `chmod 777` on sensitive files | Everyone can read and write | Use least permissive setting |
 
> 🔥 **Golden rule:** Run `pwd` before any destructive command.
 
---
 
## 🏁 End-of-Day Challenge Answers
 
```bash
# 1 — Find and count all .log files under /var
find /var -name "*.log" 2>/dev/null | wc -l
 
# 2 — Show only bash-shell users in /etc/passwd
grep "bash" /etc/passwd
 
# 3 — Create directory structure with brace expansion
mkdir -p ~/devsecops/week1/{notes,labs,scripts}
 
# 4 — Count failed SSH attempts
grep "Failed" /var/log/auth.log 2>/dev/null | wc -l
 
# 5 — Find all SUID binaries
find / -perm -4000 2>/dev/null
```
 
---
 
## 🗂️ Key Paths Quick Reference
 
| Path | What Lives Here | Security Check |
|------|----------------|----------------|
| `/var/log/auth.log` | SSH + sudo login attempts | `tail -f /var/log/auth.log` |
| `/etc/shadow` | Password hashes | `ls -la /etc/shadow` (should be root-only) |
| `/etc/sudoers` | Sudo privilege rules | `sudo visudo` |
| `/tmp` | World-writable temp files | `ls -la /tmp` (watch for executables) |
| `/proc` | Live process data | `ls /proc` (each number = a PID) |
| `~/.ssh/` | SSH keys | `ls -la ~/.ssh/` (id_rsa must be `chmod 600`) |
| `~/.bashrc` | Shell config + aliases | `cat ~/.bashrc` (attackers add persistence here) |