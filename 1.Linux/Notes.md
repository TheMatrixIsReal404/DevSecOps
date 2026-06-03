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