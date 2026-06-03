# Linux Command Cheatsheet
### DevSecOps — Day 1 & Day 2 Quick Reference
 
> *Sources: The Linux Command Line (7th Ed.) · Adventures with the Command Line (1st Ed.) · UNIX & Linux System Administration Handbook (5th Ed.)*
 
---
 
## Filesystem Hierarchy — Security Map
 
| Directory | Purpose | Security Note |
|---|---|---|
| `/etc` | System configs | Contains `passwd`, `shadow`, `sudoers` — access control crown jewels |
| `/var/log` | Log files | Your audit trail — never delete |
| `/home` | User home dirs | Sensitive user data; SSH login landing |
| `/tmp` | Temporary files | **World-writable — attacker playground** |
| `/proc` | Process / kernel info | Live system state; `/proc/net` shows connections |
| `/usr/bin` | User binaries | Where executables live — check for rogue binaries |
| `/bin` | Essential binaries | `ls`, `bash` — required before `/usr` mounts |
| `/sbin` | Sysadmin binaries | Root-level tools: `iptables`, `ifconfig` |
| `/dev` | Device files | Permission-controlled; `/dev/null`, `/dev/sda` |
| `/root` | Root's home | Never expose via web or shared mounts |
 
---
 
## Navigation & File Reading
 
| Command | What it does | Key flags / examples |
|---|---|---|
| `pwd` | Print current directory | — |
| `ls` | List directory contents | `-l` long · `-a` all · `-h` human · `-t` by time · `-R` recursive |
| `cd /path` | Change directory | `cd` → home · `cd -` → previous · `cd ..` → parent |
| `cat` | Print entire file | `cat /etc/passwd` |
| `less` | Scroll through file | `q` quit · `/term` search · `G` end · `g` top |
| `head` | Show first N lines | `head -n 20 file` |
| `tail` | Show last N lines | `tail -f /var/log/syslog` — live follow |
| `file` | Determine file type | `file /bin/bash` → ELF 64-bit LSB executable |
| `stat` | Detailed file metadata | Shows octal perms, timestamps, inode, owner |
| `find` | Search for files | `-name` · `-perm` · `-type` · `-mtime` · `-user` · `-nouser` |
 
**Paths reminder:**
```bash
cd /usr/bin        # absolute — starts from /
cd ../etc          # relative — from current dir
cd ./scripts       # .  = current directory
```
 
---
 
## Permissions — Decode & Set
 
**Permission string layout:**
```
- r w x   r - x   r - -
│ └─┴─┘   └─┴─┘   └─┴─┘
│ Owner   Group   Others
└ type: - file  d dir  l symlink
 
r=4  w=2  x=1
rwx=7  r-x=5  r--=4  rw-=6  ---=0
```
 
**Octal quick reference:**
 
| Octal | Perms | Meaning |
|---|---|---|
| `7` | `rwx` | Read, write, execute |
| `6` | `rw-` | Read and write |
| `5` | `r-x` | Read and execute |
| `4` | `r--` | Read only |
| `0` | `---` | No permissions |
 
**Common patterns:**
 
| chmod | Meaning | Typical Use |
|---|---|---|
| `600` | Owner rw only | SSH private keys |
| `644` | Owner rw, rest r | Config files |
| `755` | Owner rwx, rest rx | Executables, public dirs |
| `700` | Owner rwx only | Private scripts |
| `640` | Owner rw, group r | Group-shared configs |
| `777` | **Everyone everything** | **Dangerous — avoid!** |
 
**Permission string quick decode:**
 
| String | Meaning | Typical Use |
|---|---|---|
| `-rwx------` | Owner: all \| others: none | Private script / SSH key |
| `-rw-------` | Owner: rw \| others: none | `~/.ssh/authorized_keys` |
| `-rw-r--r--` | Owner: rw \| rest: r | `/etc/passwd`, public config |
| `-rwxr-xr-x` | Owner: all \| rest: rx | System executables `/usr/bin` |
| `drwxrwxrwt` | All perms + sticky bit | `/tmp` — protected deletes |
| `-rwsr-xr-x` | Setuid — runs as owner | `/usr/bin/passwd`, `ping` |
| `drwxrws---` | Dir + setgid | Shared team project dirs |
 
---
 
## chmod / chown / chgrp
 
```bash
# chmod — change permissions (owner or root)
chmod 644 file.txt               # octal
chmod +x script.sh               # symbolic: add execute for owner
chmod go-w file.txt              # remove write from group & others
chmod u+x,go=rx file             # combined symbolic
chmod -R 755 /webroot            # recursive
 
# chown — change owner (root only)
sudo chown alice file.txt
sudo chown alice:devs dir/
sudo chown -R alice /home/alice  # recursive
 
# chgrp — change group
chgrp devteam project/
sudo chgrp -R www-data /var/www
 
# umask — default permission mask for new files
umask                            # show current (e.g. 0022)
umask 027                        # owner all, group rx, others nothing
```
 
---
 
## Special Permission Bits
 
| Bit | Octal | On File | On Directory |
|---|---|---|---|
| **Setuid (SUID)** | `4000` | Runs as file's owner (not caller) — e.g. `passwd` | No effect |
| **Setgid (SGID)** | `2000` | Runs with file's group | New files inherit dir's group |
| **Sticky bit** | `1000` | Ignored | Users delete only their own files — used on `/tmp` |
 
```bash
chmod u+s program       # set setuid
chmod g+s shared_dir    # set setgid on directory
chmod +t /shared        # set sticky bit
 
# Identifying special bits in ls output
-rwsr-xr-x   # 's' on owner x = setuid
drwxrwxrwt   # 't' on others x = sticky bit
```
 
---
 
## User & Group Files
 
| File | Contains | Security Note |
|---|---|---|
| `/etc/passwd` | User accounts | World-readable — no passwords. Format: `user:x:uid:gid:comment:home:shell` |
| `/etc/shadow` | Hashed passwords | **Root-only.** Never expose. Format: `user:$hash:lastchg:...` |
| `/etc/group` | Group memberships | Check for unexpected sudo/docker group members |
| `/etc/sudoers` | sudo policy | **Always edit with `visudo`** — syntax errors lock you out |
 
---
 
## User Identity & Inspection
 
```bash
id                          # your uid/gid/groups
id alice                    # another user's ids
whoami                      # just your username
groups alice                # groups a user belongs to
getent passwd alice         # full account info for alice
cat /etc/passwd             # all user accounts
sudo cat /etc/shadow        # hashed passwords (root only)
cat /etc/group              # all groups
```
 
---
 
## User Management
 
```bash
# Create user
sudo useradd -m -s /bin/bash bob    # -m creates home, -s sets shell
sudo passwd bob                      # set/change password
 
# Modify user
sudo usermod -aG sudo bob           # add to group (-a = append)
sudo usermod -s /bin/zsh bob        # change shell
sudo usermod -l newname bob         # rename user
 
# Delete user
sudo userdel bob                    # keep home dir
sudo userdel -r bob                 # delete user + home dir
 
# Groups
sudo groupadd devteam
sudo gpasswd -a bob devteam        # add bob to group
sudo gpasswd -d bob devteam        # remove bob from group
sudo groupdel devteam
```
 
---
 
## sudo & su
 
```bash
# sudo — preferred for DevSecOps (full audit log)
sudo command                        # run as root
sudo -u alice command               # run as alice
sudo -l                             # list your allowed commands
sudo -i                             # open root login shell
sudo visudo                         # safely edit /etc/sudoers
sudo visudo -c                      # validate sudoers syntax only
 
# su — switch user (needs target's password)
su                                  # become root
su - alice                          # switch to alice (login shell)
su -c "command" alice               # run single command as alice
exit                                # return to previous user
```
 
**`/etc/sudoers` rule format:**
```
# who   where = (as_whom) commands
alice   ALL=(ALL) ALL                    # full sudo
bob     ALL=/usr/bin/systemctl          # restricted to systemctl
%devops ALL=(ALL) NOPASSWD: ALL         # group, no password (risky!)
```
 
---
 
## Security Audit Commands
 
```bash
# Find all setuid binaries (priv-esc vectors)
find / -perm -4000 -type f 2>/dev/null
 
# Find all setgid binaries
find / -perm -2000 -type f 2>/dev/null
 
# Find world-writable files (attacker can modify)
find / -perm -o+w -type f 2>/dev/null
 
# Find world-writable directories
find / -perm -o+w -type d 2>/dev/null
 
# Find files with no owner (orphaned — suspicious)
find / -nouser 2>/dev/null
 
# Find recently modified files in /etc (config tampering)
find /etc -mmin -60 -type f 2>/dev/null
 
# Active sessions & login history
who                                 # who is logged in
w                                   # sessions + what they're running
last                                # recent login history
lastb                               # failed login attempts (root only)
 
# Suspicious cron jobs
crontab -l                          # your crontab
sudo crontab -l                     # root's crontab
cat /etc/crontab
ls /etc/cron.*
```
 
---
 
## Shell Shortcuts
 
| Shortcut | Action |
|---|---|
| `↑` / `↓` | Scroll command history |
| `Ctrl-R` | Reverse-search history |
| `Ctrl-C` | Interrupt / kill running command |
| `Ctrl-D` | Logout / end of input |
| `Tab` | Auto-complete paths & commands |
| `!!` | Repeat last command |
| `!sudo` | Repeat last command starting with "sudo" |
| `Ctrl-L` | Clear screen |
| `Ctrl-A` / `Ctrl-E` | Jump to start / end of line |
 
---
 
## Package Managers Quick Ref
 
```bash
# Debian/Ubuntu (apt)
sudo apt update && sudo apt upgrade
sudo apt install <package>
sudo apt remove <package>
apt search <term>
 
# RHEL/CentOS/Rocky (dnf)
sudo dnf update
sudo dnf install <package>
sudo dnf remove <package>
dnf search <term>
```
 
---
 