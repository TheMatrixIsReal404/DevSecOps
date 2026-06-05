# Linux DevSecOps — Study Notes
 
> **Sources:** The Linux Command Line (7th Ed.) · Adventures with the Command Line (1st Ed.) · UNIX & Linux System Administration Handbook (5th Ed.)
 
---
 
## Day 1 — Monday
### Linux Foundations: The Shell & Filesystem
**Tags:** `#linux-basics` `#cpp-setup` `#day1`
**Schedule:** 08:00–10:00 Theory | 10:00–12:00 Hands-On Labs
 
---
 
### What Is the Shell?
 
The **shell** is a program that reads keyboard commands and passes them to the operating system. Almost all Linux distributions use **bash** (Bourne Again SHell) — an enhanced version of the original Unix shell written by Steve Bourne.
 
**Why DevSecOps engineers live in the terminal:** The CLI gives you direct, scriptable, and auditable access to every system resource. GUIs make easy tasks easy; the command line makes hard tasks *possible*.
 
**Shell prompt anatomy:**
```
username@hostname ~$    ← regular user
root@hostname    ~#    ← root / superuser
```
 
**Key keyboard shortcuts:**
```
↑ / ↓      scroll command history
Ctrl-R     reverse-search history
Ctrl-C     interrupt / kill running command
Ctrl-D     logout / end of input
Tab        auto-complete paths & commands
```
 
> *Source: The Linux Command Line, 7th Ed., Ch. 1 — "What Is the Shell?"*
 
---
 
### Linux Distributions — Why It Matters for DevSecOps
 
| Distro Family | Examples | Package Manager | Common Use Case |
|---|---|---|---|
| **Debian** | Ubuntu, Kali | `apt` / `dpkg` | Cloud instances, security labs |
| **Red Hat** | RHEL, CentOS, Rocky | `yum` / `dnf` / `rpm` | Enterprise servers, STIG compliance |
| **Arch** | Arch, Manjaro | `pacman` | Rolling release, developer desktops |
 
> **DevSecOps relevance:** Most cloud servers run Ubuntu or RHEL variants. Security tools like Metasploit ship on Kali (Debian). Know `apt` and `dnf/yum` — you will encounter both.
 
> *Source: UNIX and Linux System Administration Handbook, 5th Ed., Ch. 1 — "Linux Distributions"*
 
---
 
### Linux Filesystem Hierarchy — Security Map
 
Linux uses a **single-rooted tree** starting at `/`. Unlike Windows, there are no drive letters — all storage is mounted onto this one tree.
 
| Directory | Purpose | Security Relevance |
|---|---|---|
| `/etc` | System-wide configuration files | Contains `passwd`, `shadow`, `sudoers`, `group` — the crown jewels of access control |
| `/var/log` | Log files (syslog, auth.log, etc.) | Your audit trail — never delete; monitor for intrusion indicators |
| `/home` | User home directories | Where sensitive user data lives; default landing after SSH login |
| `/tmp` | Temporary files (world-writable) | **World-writable — attacker playground;** often used for exploit staging |
| `/proc` | Virtual FS: real-time process/kernel info | Live system state; `/proc/net` shows connections; useful for forensics |
| `/usr/bin` | User-installed executables | Where most system commands live — check for rogue binaries |
| `/bin` | Essential command binaries (boot-time) | `ls`, `cp`, `bash` — required even before `/usr` is mounted |
| `/sbin` | System administration binaries | Root-level tools: `iptables`, `ifconfig`, `fsck` |
| `/dev` | Device files (block & char devices) | Access controlled via filesystem permissions; `/dev/null`, `/dev/sda` |
| `/root` | Root user's home directory | Only root can enter; never expose via web or shared mounts |
 
> *Source: TLCL 7th Ed., Ch. 3 "Exploring the System"; ULSAH 5th Ed., Ch. 5 "The Filesystem"*
 
---
 
### Core Navigation Commands
 
**pwd** — Print Working Directory
```bash
$ pwd
→ /home/alice
```
 
**ls** — List directory contents
```bash
$ ls -la /etc
# -l long format, -a show hidden files
```
 
**cd** — Change Directory (`cd` alone = home, `cd -` = previous dir)
```bash
$ cd /var/log
$ cd ~         # home dir
$ cd ..        # parent dir
```
 
**file** — Determine file type (doesn't rely on extension)
```bash
$ file /bin/bash
→ ELF 64-bit LSB executable
```
 
**less** — Scroll through file contents (`q` to quit, `/term` to search)
```bash
$ less /var/log/auth.log
```
 
**cat / head / tail** — Print file contents. `tail -f` follows log files live
```bash
$ tail -f /var/log/syslog    # live monitoring!
$ head -n 20 /etc/passwd     # first 20 lines
```
 
**Absolute vs Relative Paths:**
```bash
# Absolute path — always starts from root /
$ cd /usr/bin
 
# Relative path — from your current location
$ cd ../etc          # go up then into etc
$ cd ./scripts       # go into scripts/ here (. = current dir)
```
 
> *Source: TLCL 7th Ed., Ch. 2 "Navigation" & Ch. 3 "Exploring the System"*
 
---
 
### Reading `ls -l` Output
 
```
drwxr-xr-x  2  alice  staff   4096  Jun 03 09:15  Documents
-rw-r--r--  1  root   root    1234  Jun 01 12:00  /etc/passwd
```
 
| Field | Example | Meaning |
|---|---|---|
| File type + permissions | `drwxr-xr-x` | `d`=directory, `-`=file, `l`=symlink; then 9 permission bits |
| Hard links | `2` | Number of names pointing to this inode |
| Owner | `alice` | User who owns the file (UID) |
| Group | `staff` | Group owner (GID) |
| Size | `4096` | Bytes; use `ls -lh` for human-readable (4.0K) |
| Modified | `Jun 03 09:15` | Last modification timestamp |
| Name | `Documents` | Filename or directory name |
 
> *Source: TLCL 7th Ed., Ch. 3 — Table 3-2 "Long Listing Fields"*
 
---
 
### Study Tip — Day 1
 
Build a cheatsheet file and add the filesystem hierarchy table as you study. Annotate each path with a real security scenario — e.g. `/tmp` → "attacker wrote exploit here", `/var/log/auth.log` → "check for brute-force attempts". This sticks far better than passive reading.
 
---

 
## Day 2 — Tuesday
### Linux Permissions & Users
**Tags:** `#permissions` `#day2`
**Schedule:** 08:00–10:00 Theory | Hands-On Labs
 
---
 
### The Unix Multi-User Security Model
 
Linux is a **multi-user OS** — multiple people can use it simultaneously (via SSH, terminals, etc.). To prevent users from damaging each other's data, *every file has an owner and a group*. The kernel enforces access rules based on UIDs and GIDs.
 
**Three entities for every file:**
- **Owner (User)** — the person who created it
- **Group** — a named collection of users
- **Others (World)** — everyone else
**Check your identity:**
```bash
$ id
uid=1000(alice) gid=1000(alice) groups=1000(alice),27(sudo)
```
 
> **Root — UID 0 = unlimited power.** Root can read/write/execute any file, regardless of permissions. Root can also change UIDs/GIDs and run privileged operations. Treat root access like a loaded weapon.
 
```bash
$ sudo -l    # list what you can sudo
```
 
> *Source: TLCL 7th Ed., Ch. 9 "Permissions"; ULSAH 5th Ed., Ch. 3 "Access Control and Rootly Powers"*
 
---
 
### Permission Notation Decoded
 
```
-  r w x   r - x   r - -
│  │ │ │   │ │ │   │ │ │
│  └─┴─┘   └─┴─┘   └─┴─┘
│  Owner   Group   Others
└─ File type  (- = file,  d = directory,  l = symlink)
 
r = 4,  w = 2,  x = 1
Owner: rwx = 4+2+1 = 7  |  Group: r-x = 4+0+1 = 5  |  Others: r-- = 4+0+0 = 4
→ chmod 754 filename
```
 
**Octal permission table:**
 
| Octal | Binary | Permissions | Meaning |
|---|---|---|---|
| `7` | 111 | `rwx` | Read, write, execute |
| `6` | 110 | `rw-` | Read and write |
| `5` | 101 | `r-x` | Read and execute |
| `4` | 100 | `r--` | Read only |
| `0` | 000 | `---` | No permissions |
 
**Common permission patterns:**
 
| chmod | Meaning |
|---|---|
| `600` | Owner rw only — SSH private keys |
| `644` | Owner rw, group/world r — config files |
| `755` | Owner rwx, group/world rx — executables |
| `700` | Owner rwx only — private scripts |
| `777` | **World-writable — dangerous, avoid!** |
 
**Symbolic chmod notation:**
```bash
# u=user/owner, g=group, o=others, a=all
$ chmod u+x script.sh      # add execute for owner
$ chmod go-w file.txt      # remove write from group+others
$ chmod a=r file.txt       # everyone gets read only
$ chmod u+x,go=rx file     # combined
```
 
> *Source: TLCL 7th Ed., Ch. 9 — Tables 9-4, 9-5, 9-6; ULSAH 5th Ed., Ch. 5 "The Filesystem"*
 
---
 
### User & Group Files to Know
 
| File | Contains | Format | Security Note |
|---|---|---|---|
| `/etc/passwd` | User account info | `user:x:uid:gid:comment:home:shell` | World-readable — no passwords here. The `x` means look in shadow. |
| `/etc/shadow` | Hashed passwords + expiry policy | `user:$hash:lastchg:min:max:warn:...` | **Root-only readable.** Contains salted password hashes — prime target. Never expose. |
| `/etc/group` | Group memberships | `groupname:x:gid:member1,member2` | Shows who has elevated access (e.g. sudo, docker groups). Check regularly. |
| `/etc/sudoers` | Sudo permissions policy | Structured config language | Controls who can run what as root. **Always edit with `visudo`** — syntax errors can lock you out. |
 
**Quick inspection commands:**
```bash
$ cat /etc/passwd              # list all users
$ sudo cat /etc/shadow         # password hashes (root only)
$ cat /etc/group               # list groups
$ getent passwd alice          # info for specific user
$ groups alice                 # groups a user belongs to
$ id alice                     # uid/gid/groups
```
 
**User management commands:**
```bash
$ sudo useradd -m -s /bin/bash bob
$ sudo passwd bob              # set password
$ sudo usermod -aG sudo bob    # add to sudo group
$ sudo userdel -r bob          # delete user + home dir
$ sudo groupadd devteam
$ sudo gpasswd -a bob devteam
```
 
> *Source: TLCL 7th Ed., Ch. 9 "Permissions"; ULSAH 5th Ed., Ch. 8 "User Management"*
 
---
 
### Privilege Escalation — su vs sudo
 
**su — Substitute User**
```bash
$ su                # become root (needs root password)
$ su - alice        # switch to alice (login shell)
$ exit              # return to previous user
```
> **su weakness:** No audit trail of what commands were run as root. Best reserved for emergencies when sudo is broken.
 
**sudo — Limited Superuser Access**
```bash
$ sudo command              # run as root
$ sudo -u alice command     # run as alice
$ sudo -l                   # list your allowed commands
$ sudo -i                   # root login shell
$ sudo visudo               # safely edit /etc/sudoers
```
> **sudo advantages:** Full audit log (`/var/log/auth.log`), granular command restriction, individual accountability — the DevSecOps standard.
 
**`/etc/sudoers` basic structure:**
```
# Format: who  where = (as_whom) commands
alice      ALL = (ALL) ALL              # alice can run anything as any user
%devops    ALL = (ALL) NOPASSWD: ALL    # devops group, no password (DANGEROUS)
bob        ALL = /usr/bin/systemctl    # bob can only run systemctl
 
# ALWAYS edit with visudo, never directly edit the file
$ sudo visudo
```
 
> *Source: ULSAH 5th Ed., Ch. 3 — "sudo: limited su" & "Management of the root account"; TLCL 7th Ed., Ch. 9*
 
---
 
### Ownership & Permission Commands
 
**chmod** — Change file mode/permissions (only owner or root)
```bash
$ chmod 644 file.txt
$ chmod +x script.sh
$ chmod -R 755 /webroot
```
 
**chown** — Change file owner (root only)
```bash
$ sudo chown alice file.txt
$ sudo chown alice:devs dir/
$ sudo chown -R alice /home/alice
```
 
**chgrp** — Change group owner
```bash
$ chgrp devteam project/
$ sudo chgrp -R www-data /var/www
```
 
**umask** — Set default permission mask for new files
```bash
$ umask            # show current (e.g. 0022)
$ umask 027        # owner all, group rx, others nothing
```
 
**stat** — Detailed file info: permissions, inode, timestamps, owner
```bash
$ stat /etc/passwd
# shows Access: (0644/-rw-r--r--)
```
 
**find + permissions** — Find files with specific permissions (critical for audits)
```bash
$ find / -perm -4000 2>/dev/null     # find all setuid files
$ find /tmp -perm -o+w               # find world-writable in /tmp
```
 
> *Source: TLCL 7th Ed., Ch. 9; ULSAH 5th Ed., Ch. 3 & Ch. 5*
 
---
 
### Special Permissions — Security-Critical
 
| Bit | Octal | On File | On Directory | Security Impact |
|---|---|---|---|---|
| **Setuid (SUID)** | `4000` | Runs as the file's *owner*, not the caller. e.g. `passwd` runs as root. | No effect | Dangerous if misconfigured — attackers use setuid binaries to escalate. Audit with `find / -perm -4000` |
| **Setgid (SGID)** | `2000` | Runs with the file's group permissions | New files inherit directory's group — useful for shared project dirs | Audit with `find / -perm -2000` |
| **Sticky bit** | `1000` | Ignored on modern Linux | Users can only delete their *own* files in the directory. Used on `/tmp`. | Protects shared dirs. `/tmp` has this — see the `t` in `drwxrwxrwt` |
 
```bash
# Example output showing special bits
-rwsr-xr-x  root  root  /usr/bin/passwd   # 's' = setuid on owner execute bit
drwxrwxrwt  root  root  /tmp              # 't' = sticky bit on others execute bit
 
# Set special permissions
$ chmod u+s program       # set setuid
$ chmod g+s shared_dir    # set setgid on directory
$ chmod +t /shared        # set sticky bit
```
 
> *Source: TLCL 7th Ed., Ch. 9 — "Some Special Permissions"; ULSAH 5th Ed., Ch. 3 "Setuid and setgid execution"*
 
---
 
### DevSecOps: Permission Audit Commands
 
```bash
# Find all setuid binaries (potential priv-esc vectors)
$ find / -perm -4000 -type f 2>/dev/null
 
# Find world-writable files (attacker can modify)
$ find / -perm -o+w -type f 2>/dev/null
 
# Find files with no owner (orphaned — possible indicator)
$ find / -nouser 2>/dev/null
 
# Check for recently modified files in /etc (config tampering)
$ find /etc -mmin -60 -type f 2>/dev/null
 
# Validate sudoers syntax
$ sudo visudo -c
 
# Who is logged in right now?
$ who
$ w                    # more detail: uptime + sessions
$ last                 # recent login history
$ lastb                # failed login attempts (root only)
 
# Check for suspicious cron jobs
$ crontab -l           # your crontab
$ cat /etc/crontab
$ ls /etc/cron.*
```
 
---
 
### Study Tip — Day 2
 
Create a test file and practice the full permissions cycle:
1. `touch test.txt`
2. `chmod 754 test.txt` — decode each bit aloud
3. `stat test.txt` — verify what you set
4. Create a shared group directory with setgid and check how new files inherit the group
5. Run `find / -perm -4000 2>/dev/null` and research each result you find
---


# 📓 Linux Notes — Day 3 (Wednesday)
## Bash Scripting Fundamentals
 
> **Week 1 | Phase 1 — Foundations**
> Reference: *The Linux Command Line* (7th Ed.) — Ch. 24, 25, 26, 32
 
 
## 1. Bash Scripting — Core Fundamentals
 
> *"In the simplest terms, a shell script is a file containing a series of commands. The shell reads this file and carries out the commands as though they have been entered directly on the command line."* — The Linux Command Line, Ch. 24
 
### What is a Shell Script?
A shell script is a plain text file that contains a sequence of shell commands. The shell itself is **both a command-line interface and a scripting language interpreter** — most things you can do on the command line can be done in a script, and vice versa.
 
### The Three Rules of a Working Script
 
To create and run a shell script successfully you need exactly three things:
 
| Step | What to do | Why |
|---|---|---|
| 1 | **Write the script** | Use any text editor (vim, nano, gedit). Save as plain text. |
| 2 | **Make it executable** | `chmod 755 script.sh` — without this, Linux won't run it as a program |
| 3 | **Place it in PATH** | Put it in `~/bin` so the shell can find it without specifying the full path |
 
---
 
### The Shebang Line (`#!`)
 
```bash
#!/bin/bash
```
 
- **Must be the very first line** of every script — even before comments.
- `#!` is called the **shebang** (hash-bang). It tells the Linux kernel *which interpreter* to use to execute the script.
- Without the shebang, the shell tries to guess the interpreter, which can cause mysterious failures.
- The rest of the line is the absolute path to the interpreter: `/bin/bash` for bash scripts.
```bash
#!/bin/bash              # Standard bash script
#!/usr/bin/env python3   # Python script (finds python3 in PATH)
#!/bin/sh                # POSIX-compliant sh (more portable, fewer features)
```
 
> **Security Note:** Using `#!/usr/bin/env bash` is more portable across systems where bash may not be at `/bin/bash`, but in security-critical scripts, explicit paths (`/bin/bash`) are preferred because `env` searches PATH, which an attacker could potentially manipulate.
 
### Script File Format Example
 
```bash
#!/bin/bash
# This is a comment — the shell ignores everything after #
# Author: Your Name
# Date: 2026-06-04
# Purpose: Demonstrate basic script structure
 
echo "Hello, DevSecOps!"   # Comments can appear at end of lines too
```
 
---
 
## 2. Variables & Constants
 
### Assigning Variables
 
```bash
NAME="DevSecOps"          # String — no spaces around the = sign
AGE=21                    # Number (still treated as a string by bash)
IS_ACTIVE=true            # Boolean-like (no real boolean type in bash)
```
 
> ⚠️ **Critical Rule:** There must be **no spaces** around the `=` sign when assigning variables.  
> `NAME = "DevSecOps"` → **ERROR** (bash thinks `NAME` is a command)  
> `NAME="DevSecOps"` → **Correct**
 
### Using Variables
 
```bash
echo $NAME                 # Basic expansion
echo "${NAME}"             # Safer — braces make boundary explicit
echo "${NAME}_2026"        # Required when followed immediately by text
echo "Hello, $NAME!"       # Inside double quotes — expands
echo 'Hello, $NAME!'       # Inside single quotes — does NOT expand
```
 
### Variable Naming Rules (from *The Linux Command Line*, Ch. 25)
 
1. Variable names may contain **letters, numbers, and underscores** only
2. The **first character must be a letter or underscore** — not a number
3. **No spaces, no punctuation** allowed in variable names
4. Convention: use **UPPERCASE for constants**, **lowercase for variables**
```bash
# Good names
user_name="alice"
MAX_RETRIES=3
LOG_FILE="/var/log/audit.log"
 
# Bad names (will cause errors or bugs)
2name="wrong"     # starts with digit
my-var="wrong"    # hyphen not allowed
my var="wrong"    # space not allowed
```
 
### Constants (Read-Only Variables)
 
```bash
declare -r PI=3.14159        # -r flag makes it read-only
declare -r MAX_SIZE=100
 
PI=3.0                       # This will now throw an error
```
 
The shell makes **no automatic distinction** between variables and constants — using `declare -r` and uppercase naming is a convention that helps readability and prevents accidental modification.
 
### Variable Scope
 
By default, all variables in bash are **global** within a script. Variables defined in shell functions are also global unless explicitly declared as `local`:
 
```bash
my_function() {
    local temp_var="only inside this function"
    global_var="visible everywhere"
}
```
 
---
 
## 3. Command Substitution
 
Command substitution lets you **capture the output of a command** and use it as a value. There are two syntaxes:
 
```bash
# Modern syntax (preferred — nestable)
TODAY=$(date +%Y-%m-%d)
FILE_COUNT=$(ls -1 | wc -l)
CURRENT_USER=$(whoami)
UPTIME=$(uptime -p)
 
# Legacy syntax (avoid in new scripts)
TODAY=`date +%Y-%m-%d`
```
 
The `$()` syntax is preferred because it **can be nested**:
 
```bash
# Nested command substitution
LATEST_LOG=$(ls -t $(find /var/log -name "*.log") | head -1)
```
 
### Practical Examples
 
```bash
#!/bin/bash
# Capture system information dynamically
HOSTNAME=$(hostname)
KERNEL=$(uname -r)
DISK_USAGE=$(df -h / | awk 'NR==2{print $5}')
MEM_USED=$(free -h | awk '/Mem:/{print $3}')
DATE=$(date +"%Y-%m-%d %H:%M:%S")
 
echo "=== System Report: $DATE ==="
echo "Host: $HOSTNAME | Kernel: $KERNEL"
echo "Disk: $DISK_USAGE used | Memory: $MEM_USED used"
```
 
---
 
## 4. Special Variables
 
These are automatically set by bash — you never assign them, you only read them:
 
| Variable | Meaning | Example |
|---|---|---|
| `$0` | Name/path of the script itself | `./my_script.sh` |
| `$1`, `$2`, ... `$9` | Positional arguments (what user passed in) | `./script.sh arg1 arg2` → `$1=arg1` |
| `$#` | Total count of arguments passed | `3` (if 3 args given) |
| `$@` | All arguments as **separate words** (preferred) | `"arg1" "arg2" "arg3"` |
| `$*` | All arguments as a **single string** | `"arg1 arg2 arg3"` |
| `$?` | Exit code of the **last command** run | `0` = success, non-zero = failure |
| `$$` | PID (process ID) of the current script | `12345` |
| `$!` | PID of the last background process | useful for tracking background jobs |
| `$_` | Last argument of the previous command | shortcut for repeating args |
 
### `$@` vs `$*` — The Critical Difference (Ch. 32)
 
This difference only matters inside **double quotes**:
 
```bash
#!/bin/bash
# Demonstrating the $@ vs $* difference
# Run as: ./demo.sh "hello world" "foo bar"
 
echo "--- Using \$@ (correct for loops) ---"
for arg in "$@"; do
    echo "  arg: $arg"
done
# Output:
#   arg: hello world
#   arg: foo bar        ← each argument preserved as a single unit
 
echo "--- Using \$* (loses argument boundaries) ---"
for arg in "$*"; do
    echo "  arg: $arg"
done
# Output:
#   arg: hello world foo bar   ← everything becomes ONE string
```
 
> **Rule:** Always use `"$@"` when passing arguments to another command or iterating over them. `"$*"` collapses everything into one string, destroying argument boundaries.
 
### The `shift` Command — Processing Many Arguments (Ch. 32)
 
`shift` moves all positional parameters **down by one**: `$2` becomes `$1`, `$3` becomes `$2`, and `$#` decreases by one. This lets you process an unlimited number of arguments using just `$1`:
 
```bash
#!/bin/bash
# Process all arguments using shift
count=1
while [[ $# -gt 0 ]]; do
    echo "Argument $count = $1"
    count=$((count + 1))
    shift        # $2 → $1, $3 → $2, etc.
done
```
 
```bash
$ ./script.sh alpha beta gamma
Argument 1 = alpha
Argument 2 = beta
Argument 3 = gamma
```
 
### Exit Codes ($?) — Critical for DevSecOps
 
```bash
# Every command returns an exit code
ls /etc/passwd
echo $?           # → 0 (success)
 
ls /nonexistent
echo $?           # → 2 (error: no such file)
 
# Using $? for error handling
cp important.conf backup.conf
if [ $? -eq 0 ]; then
    echo "Backup successful"
else
    echo "Backup FAILED!" >&2
    exit 1
fi
```
 
> **Best Practice:** Check `$?` immediately after a critical command. Once you run another command, the previous exit code is overwritten.
 
### Positional Parameters in Practice
 
```bash
#!/bin/bash
# Script: greet_user.sh
# Usage: ./greet_user.sh Alice Senior
echo "Hello, $2 $1!"          # Hello, Senior Alice!
echo "Script name: $0"
echo "Arguments received: $#"
echo "All arguments: $@"
 
# Default value if argument not provided
NAME=${1:-"World"}            # Use $1, or "World" if $1 is unset/empty
echo "Hello, $NAME!"
```
 
---
 
## 5. Quoting Rules (Critical!)
 
Quoting is one of the most important (and most misunderstood) aspects of bash scripting. Getting it wrong causes bugs that are very hard to diagnose.
 
### The Three Quoting Modes
 
```bash
NAME="DevSecOps Engineer"
 
# 1. DOUBLE QUOTES — expands variables and command substitutions
echo "Hello, $NAME"          # → Hello, DevSecOps Engineer
echo "Today: $(date)"        # → Today: Thu Jun  4 10:00:00 IST 2026
echo "Tab:\there"            # → Tab:    here  (escape sequences work)
 
# 2. SINGLE QUOTES — absolutely literal, NO expansion whatsoever
echo 'Hello, $NAME'          # → Hello, $NAME  (literally)
echo 'Today: $(date)'        # → Today: $(date)  (literally)
echo 'Tab:\there'            # → Tab:\there  (no escape processing)
 
# 3. NO QUOTES — word splitting occurs (dangerous with spaces)
FILE="my file.txt"
cp $FILE /tmp/               # ERROR: treated as two args: "my" and "file.txt"
cp "$FILE" /tmp/             # CORRECT: treated as one argument
```
 
### The Golden Rule
 
> **Always quote variables that might contain spaces or special characters.**  
> Use `"$variable"` not `$variable` as your default habit.
 
```bash
# Dangerous — breaks if filename has spaces
rm $FILE
 
# Safe
rm "$FILE"
 
# Safe — braces + quotes
rm "${FILE}"
```
 
### When Single Quotes Are Useful
 
```bash
# Passing literal strings to grep (avoid regex interpretation)
grep '$100' prices.txt          # Looks for literal $100
grep "$100" prices.txt          # Looks for value of variable $100
 
# In scripts that generate other scripts or configs
cat > /etc/cron.d/cleanup << 'EOF'
0 2 * * * root find /tmp -mtime +7 -delete
EOF
# The 'EOF' in single quotes prevents expansion inside the here-doc
```
 
---
 
## 6. Here Documents
 
A **here document** is a third way to pass multi-line text to a command, defined in Ch. 25 of the book. Instead of multiple `echo` calls, you embed a block of text directly in the script and feed it as standard input to a command.
 
### Syntax
 
```bash
command << TOKEN
text line 1
text line 2
TOKEN
```
 
The `TOKEN` (commonly `_EOF_`, `EOF`, or `END`) marks the end of the embedded text. It **must appear alone on its own line** with no leading spaces or trailing characters.
 
### Basic Example
 
```bash
#!/bin/bash
TITLE="System Information Report"
TIMESTAMP=$(date +"%Y-%m-%d %H:%M")
 
cat << _EOF_
<html>
  <head><title>$TITLE</title></head>
  <body>
    <h1>$TITLE</h1>
    <p>Generated: $TIMESTAMP</p>
  </body>
</html>
_EOF_
```
 
By default, variables and command substitutions **expand** inside a here document, just like double quotes.
 
### Suppressing Expansion (Quoted Token)
 
Wrapping the opening token in **single quotes** disables all expansion inside the block — useful when generating scripts or config files:
 
```bash
cat << 'EOF'
#!/bin/bash
# This $VARIABLE will NOT be expanded
echo "Literal: $HOME"
EOF
```
 
### Here Strings (`<<<`)
 
A simpler variant: feeds a **single string** to a command's stdin:
 
```bash
# Feed a string directly to a command
grep "error" <<< "no error here"
read first rest <<< "hello world foo"
echo $first   # → hello
echo $rest    # → world foo
```
 
### Here Doc vs `echo` — When to Use Which
 
| Use `echo` when... | Use here doc when... |
|---|---|
| Outputting a single line | Outputting many lines of text |
| Simple variable printing | Generating config files, HTML, SQL |
| Quick inline messages | Avoiding lots of escape characters |
 
---
 
## 7. Shell Functions
 
Shell functions let you group commands into a **reusable, named block** — like a mini-script inside your script. Defined in Ch. 26 of the book.
 
### Two Syntax Forms (Both Equivalent)
 
```bash
# Form 1 — formal (with 'function' keyword)
function greet {
    echo "Hello, $1!"
    return 0
}
 
# Form 2 — simplified (generally preferred)
greet () {
    echo "Hello, $1!"
    return 0
}
```
 
> **Rule:** Function definitions must appear **before** they are called in the script. The shell reads top-to-bottom.
 
### Calling a Function
 
```bash
greet "DevSecOps"    # → Hello, DevSecOps!
greet "Alice"        # → Hello, Alice!
```
 
Functions receive their own positional parameters (`$1`, `$2`, etc.) **separate from the script's** `$1`, `$2`. Inside a function, `$1` is the first argument passed to the *function*, not the script.
 
### Local Variables
 
Without `local`, all variables in a function are **global** and can overwrite variables in the rest of the script. Always use `local` inside functions:
 
```bash
#!/bin/bash
foo=0                  # global variable
 
funct_1 () {
    local foo          # local — only lives inside this function
    foo=1
    echo "funct_1: foo = $foo"    # → 1
}
 
echo "global: foo = $foo"   # → 0
funct_1
echo "global: foo = $foo"   # → still 0 (local foo didn't affect global)
```
 
### Return Values
 
`return` exits the function and sets `$?`. By convention: `0` = success, `1` (or non-zero) = failure.
 
```bash
is_root () {
    if [[ $(id -u) -eq 0 ]]; then
        return 0    # success
    else
        return 1    # failure
    fi
}
 
if is_root; then
    echo "Running as root"
else
    echo "Not root — some features may be unavailable"
fi
```
 
> To return **data** (not just a status), use `echo` inside the function and capture it with command substitution:
> ```bash
> get_date () { echo "$(date +%Y-%m-%d)"; }
> TODAY=$(get_date)
> ```
 
### Practical Example — Reusable Checks
 
```bash
#!/bin/bash
# Color codes
GREEN='\e[0;32m'; RED='\e[0;31m'; NC='\e[0m'
 
check_port () {
    local PORT=$1
    local SERVICE=$2
    if ss -tulpn 2>/dev/null | grep -q ":${PORT} "; then
        echo -e "${GREEN}[OPEN]${NC}   Port $PORT ($SERVICE)"
    else
        echo -e "${RED}[CLOSED]${NC} Port $PORT ($SERVICE)"
    fi
}
 
echo "=== Port Status: $(date) ==="
check_port 22   "SSH"
check_port 80   "HTTP"
check_port 443  "HTTPS"
```
 
---
 
## 8. Writing & Running Scripts
 
### Step-by-Step Workflow
 
```bash
# 1. Create the script file
nano ~/practice/scripts/my_script.sh
# OR
vim ~/practice/scripts/my_script.sh
 
# 2. Make it executable
chmod +x ~/practice/scripts/my_script.sh
# Common permissions:
# 755 → owner: rwx, group: r-x, others: r-x (everyone can run)
# 700 → owner: rwx, group: ---, others: --- (only owner can run)
 
# 3. Run it
./my_script.sh                     # From current directory (explicit path)
bash my_script.sh                  # Alternative: pass to bash directly
~/practice/scripts/my_script.sh    # Full path
 
# 4. Add to PATH (optional, for scripts you use often)
mkdir -p ~/bin
cp my_script.sh ~/bin/
export PATH="$HOME/bin:$PATH"      # Add to ~/.bashrc for permanence
```
 
### Script File Location Best Practices
 
| Location | Purpose |
|---|---|
| `~/bin/` | Personal scripts for your user only |
| `/usr/local/bin/` | Scripts usable by all users (standard for local software) |
| `/usr/local/sbin/` | Admin scripts usable by all (system administration tools) |
| `/etc/cron.d/` | Cron job definitions |
 
> `/bin/` and `/usr/bin/` are managed by your Linux distribution — **never put your own scripts there**.
 
---
 
## 9. Practical Script Writing — 5 Scripts
 
### Script 1: System Info Report (`system_info.sh`)
 
```bash
#!/bin/bash
# system_info.sh — Report system statistics
# Usage: ./system_info.sh
 
echo "=== System Info Report ==="
echo "Hostname:    $(hostname)"
echo "User:        $(whoami)"
echo "Date:        $(date)"
echo "Uptime:      $(uptime -p)"
echo "Disk:        $(df -h / | awk 'NR==2{print $5}') used on /"
echo "Memory:      $(free -h | awk '/Mem:/{print $3}') / $(free -h | awk '/Mem:/{print $2}') used"
echo "OS:          $(cat /etc/os-release | grep PRETTY_NAME | cut -d'"' -f2)"
echo "Kernel:      $(uname -r)"
```
 
**Concepts used:** command substitution, `awk` for column extraction, `cat` + `grep` + `cut` pipeline.
 
### Script 2: Log Analyzer (`log_counter.sh`)
 
```bash
#!/bin/bash
# log_counter.sh — Count log entries and flag issues
# Usage: ./log_counter.sh [logfile]
 
LOG_FILE=${1:-/var/log/syslog}    # Default to syslog if no arg given
 
if [ ! -f "$LOG_FILE" ]; then
    echo "ERROR: $LOG_FILE not found" >&2
    exit 1
fi
 
TOTAL=$(wc -l < "$LOG_FILE")
ERRORS=$(grep -ci 'error' "$LOG_FILE" 2>/dev/null || echo 0)
WARNINGS=$(grep -ci 'warning' "$LOG_FILE" 2>/dev/null || echo 0)
 
echo "Log file:      $LOG_FILE"
echo "Total lines:   $TOTAL"
echo "ERROR count:   $ERRORS"
echo "WARNING count: $WARNINGS"
```
 
**Concepts used:** default parameter `${1:-default}`, file existence test `-f`, error redirection `>&2`, `grep -ci` (case-insensitive count).
 
### Script 3: Backup Script (`backup.sh`)
 
```bash
#!/bin/bash
# backup.sh — Create a timestamped backup of a directory or file
# Usage: ./backup.sh <source_path>
 
SOURCE=$1
TIMESTAMP=$(date +%Y%m%d_%H%M%S)
DEST="/tmp/backup_${TIMESTAMP}"
 
# Validate input
if [ -z "$SOURCE" ]; then
    echo "Usage: $0 <source_path>" >&2
    exit 1
fi
 
if [ ! -e "$SOURCE" ]; then
    echo "ERROR: $SOURCE does not exist" >&2
    exit 1
fi
 
cp -r "$SOURCE" "$DEST" && echo "✓ Backed up '$SOURCE' → '$DEST'" \
    || echo "✗ Backup FAILED" >&2
```
 
**Concepts used:** `-z` (empty string test), `-e` (path existence test), `&&` and `||` for inline error handling.
 
### Script 4: User Checker (`user_check.sh`)
 
```bash
#!/bin/bash
# user_check.sh — Check if a user exists and show their info
# Usage: ./user_check.sh <username>
 
USERNAME=${1:-$(whoami)}
 
if id "$USERNAME" &>/dev/null; then
    echo "User '$USERNAME' EXISTS"
    echo "UID:    $(id -u $USERNAME)"
    echo "GID:    $(id -g $USERNAME)"
    echo "Groups: $(id -Gn $USERNAME)"
    echo "Home:   $(grep "^$USERNAME:" /etc/passwd | cut -d: -f6)"
    echo "Shell:  $(grep "^$USERNAME:" /etc/passwd | cut -d: -f7)"
else
    echo "User '$USERNAME' does NOT exist" >&2
    exit 1
fi
```
 
**Concepts used:** `id` command, `&>/dev/null` to suppress output, `grep` + `cut` to parse `/etc/passwd`.
 
### Script 5: Port Scanner (`port_check.sh`)
 
```bash
#!/bin/bash
# port_check.sh — Check if common ports are open
# Usage: ./port_check.sh
 
GREEN='\e[0;32m'
RED='\e[0;31m'
NC='\e[0m'  # No Color
 
check_port() {
    local PORT=$1
    local SERVICE=$2
    if ss -tulpn 2>/dev/null | grep -q ":${PORT} "; then
        echo -e "${GREEN}[OPEN]${NC}   Port $PORT ($SERVICE)"
    else
        echo -e "${RED}[CLOSED]${NC} Port $PORT ($SERVICE)"
    fi
}
 
echo "=== Port Status Report: $(date) ==="
check_port 22   "SSH"
check_port 80   "HTTP"
check_port 443  "HTTPS"
check_port 3306 "MySQL"
check_port 5432 "PostgreSQL"
check_port 6379 "Redis"
```
 
**Concepts used:** shell functions with `local` variables, color codes (`\e[0;32m`), `ss -tulpn` for port checking.
 
---
 


# Day 4 — Bash Loops & Functions
> **Session:** 08:00–10:00 | Theory  
> **Watch:** Udemy Bash Scripting Module — Part 2  
> **Reference:** *The Linux Command Line* (TLCL) 7th Ed — Chapters 26, 29, 33
 
---
 
## 1. Why Loops?
 
Loops let you repeat a series of commands until some condition is met, making it possible to automate repetitive tasks without writing the same commands over and over. Bash provides three looping constructs: `for`, `while`, and `until`.
 
---
 
## 2. The `for` Loop
 
### 2.1 Traditional Shell Form (Range / List)
 
The basic syntax:
 
```bash
for variable [in words]; do
    commands
done
```
 
**Example — numeric range using brace expansion:**
 
```bash
for i in {1..10}; do
    echo "Iteration: $i"
done
```
 
- `{1..10}` generates the sequence 1 through 10.
- Each iteration assigns the next value to `i`.
- The variable name `i` is traditional (inherited from Fortran), but any valid variable name works.
**Example — loop through files matching a glob:**
 
```bash
for file in /var/log/*.log; do
    echo "Found: $file ($(wc -l < $file) lines)"
done
```
 
- Pathname expansion (`/var/log/*.log`) gives a clean list of matching files.
- `$(wc -l < $file)` uses command substitution to count lines inside each file.
- **Tip:** Always guard against failed expansions in scripts:
  ```bash
  for file in /var/log/*.log; do
      if [[ -e "$file" ]]; then
          echo "$file"
      fi
  done
  ```
 
### 2.2 C-Style `for` Loop
 
Bash also supports a C-language form useful for numeric sequences:
 
```bash
for (( expression1; expression2; expression3 )); do
    commands
done
```
 
| Expression | Purpose |
|---|---|
| `expression1` | Initialise (runs once before the loop starts) |
| `expression2` | Condition — loop runs while this is true |
| `expression3` | Increment — runs at the end of each iteration |
 
**Example:**
 
```bash
for (( i=0; i<5; i=i+1 )); do
    echo $i
done
```
 
Output: `0 1 2 3 4`
 
### 2.3 Key Points
 
- If the `in words` part is omitted, `for` processes the **positional parameters** (`$1`, `$2`, …) — useful in scripts that accept arguments.
- Use command substitution to generate a word list: `for i in $(cat file.txt); do …`
- Word splitting **does** occur with command substitution in `for`, which is intentional and useful here.
---
 
## 3. The `while` Loop
 
Repeats commands as long as a condition (exit status) is **zero (true)**.
 
### Basic Syntax
 
```bash
while [ condition ]; do
    commands
done
```
 
### 3.1 Simple Counter
 
```bash
COUNT=0
while [ $COUNT -lt 5 ]; do
    echo "Count: $COUNT"
    ((COUNT++))
done
```
 
- `[ $COUNT -lt 5 ]` — evaluates to true while COUNT is less than 5.
- `((COUNT++))` — arithmetic increment (Bash arithmetic context).
- **Equivalent `[[ ]]` form:** `while [[ "$COUNT" -lt 5 ]]; do`
### 3.2 Reading Lines from a File
 
```bash
while IFS= read -r line; do
    echo "Processing: $line"
done < /etc/passwd
```
 
- `< /etc/passwd` — redirects the file as standard input to the loop (placed **after** `done`).
- `IFS=` — clears the Internal Field Separator so leading/trailing whitespace is preserved.
- `-r` flag on `read` — prevents backslash interpretation.
- Works for any text file; processes one line per iteration.
**Pipe variant (note: runs in a subshell — variables don't persist):**
 
```bash
sort file.txt | while read -r line; do
    echo "$line"
done
```
 
### 3.3 Infinite Loop with `break`
 
```bash
while true; do
    read -p "Enter selection [1-3, 0 to quit]: " REPLY
    if [[ "$REPLY" == 0 ]]; then
        break
    fi
    # handle selections…
done
```
 
- `true` always exits with status 0, so the loop runs forever.
- Use `break` to exit the loop from inside.
- Use `continue` to skip the rest of the current iteration and jump to the next.
---
 
## 4. The `until` Loop
 
The mirror image of `while` — runs while the condition is **non-zero (false)**:
 
```bash
count=1
until [[ "$count" -gt 5 ]]; do
    echo "$count"
    count=$((count + 1))
done
```
 
Choose `while` or `until` based on whichever makes the condition clearest to read.
 
---
 
## 5. `break` and `continue`
 
| Command | Effect |
|---|---|
| `break` | Exit the loop immediately; execution resumes after `done` |
| `continue` | Skip the rest of the current iteration; jump to the next cycle |
 
These work inside `for`, `while`, and `until`.
 
---
 
## 6. Bash Functions
 
Shell functions are mini-scripts embedded inside a script. They allow you to:
- Avoid repeating code
- Break complex tasks into named, manageable pieces (top-down design)
- Accept arguments (positional parameters)
- Use local variables isolated from the rest of the script
### 6.1 Two Syntax Forms
 
**Formal (keyword) form:**
```bash
function name {
    commands
    return
}
```
 
**Preferred (POSIX-compatible) form:**
```bash
name () {
    commands
    return
}
```
 
Both are equivalent. Prefer the second form for portability.
 
### 6.2 A Practical Example — Port Checker
 
```bash
function check_port() {
    local PORT=$1
    if ss -tulpn | grep -q ":$PORT "; then
        echo -e "\e[0;32m[+] Port $PORT is OPEN\e[0m"
    else
        echo -e "\e[0;31m[-] Port $PORT is CLOSED\e[0m"
    fi
}
 
check_port 22
check_port 80
```
 
**Breaking it down:**
 
| Element | Meaning |
|---|---|
| `local PORT=$1` | `$1` is the first argument passed to the function; `local` confines it to this function |
| `ss -tulpn` | Lists all listening TCP/UDP ports |
| `grep -q ":$PORT "` | Silently searches for the port number; exit status signals found/not found |
| `\e[0;32m…\e[0m` | ANSI escape code for green text (32=green, 31=red) |
| `echo -e` | Enables interpretation of escape sequences |
 
### 6.3 Local Variables
 
Variables declared with `local` only exist inside their function:
 
```bash
foo=0           # global variable
 
my_func () {
    local foo   # local to my_func
    foo=99
    echo "Inside: $foo"   # prints 99
}
 
my_func
echo "Outside: $foo"      # prints 0 — unchanged
```
 
- `local` prevents functions from accidentally overwriting global variables.
- Makes functions self-contained and reusable across scripts.
### 6.4 Rules and Best Practices
 
- Functions **must be defined before they are called** in a script.
- A function must contain **at least one command** (`return` counts).
- Functions receive arguments as positional parameters (`$1`, `$2`, `$@`).
- Functions can be redirected just like any other command: `my_func > output.txt`
- You can store a function's output in a variable: `result="$(my_func)"`
- Add frequently used functions to `~/.bashrc` to make them available in every session.
---
 
## 7. Combining Loops and Functions
 
```bash
check_ports () {
    local port
    for port in "$@"; do
        if ss -tulpn | grep -q ":$port "; then
            echo "[+] Port $port: OPEN"
        else
            echo "[-] Port $port: CLOSED"
        fi
    done
}
 
check_ports 22 80 443 3306
```
 
- `"$@"` expands to all arguments passed to the function, each as a separate word.
- The `for` loop iterates over each port number.
---
 
## 8. Key Takeaways
 
1. Use `for` when you know the list of items upfront (files, ranges, arguments).
2. Use `while` when you loop until a condition changes (counters, reading input/files).
3. Use `until` when it reads more naturally than `while [ ! condition ]`.
4. Always use `local` for function variables to avoid side effects.
5. Put the input-redirection operator (`< file`) **after** `done`, not inside the loop.
6. `IFS= read -r line` is the correct idiom for reading file lines safely.
7. `break` exits the loop; `continue` moves to the next iteration.
8. Functions must be defined before they are called.
---
 
## 9. Further Reading
 
- TLCL Ch. 29 — *Flow Control: Looping with while / until*
- TLCL Ch. 33 — *Flow Control: Looping with for*
- TLCL Ch. 26 — *Top-Down Design* (Shell Functions)
- Bash Reference Manual — Looping Constructs: https://www.gnu.org/software/bash/manual/bashref.html#Looping-Constructs
- Advanced Bash-Scripting Guide — Loops: https://tldp.org/LDP/abs/html/loops1.html