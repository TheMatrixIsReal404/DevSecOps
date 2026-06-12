# Day 10 (Week 2 — Day 3) · Bash Automation & 2D Arrays
 
## DevSecOps Goal
Write production-quality Bash scripts for log analysis and file management.
 
## Concepts to Learn
 
### 1. Bash Basics Review
- **Variables**: `VAR="value"`, access with `$VAR` or `${VAR}`
- **Conditionals**: `if [[ condition ]]; then ... elif ...; else ...; fi`
- **Loops**: `for`, `while`, `until`
- **Functions**:
```bash
  my_func() {
      local arg1="$1"
      echo "Got: $arg1"
  }
```
 
### 2. File Management
- `find` — locate files based on conditions
```bash
  find /path -name "*.log" -mtime +7
  find /path -type f -size +100M
```
- `mv` — move/rename files
- `cp` — copy files (`-r` for recursive)
- `rm` — remove files (`-f` force, `-r` recursive) — use cautiously with conditions to avoid accidental deletion
### 3. Log Analysis
- `grep` — search patterns
  - `grep -c 'ERROR' file` → count matches
  - `grep -i` → case-insensitive
- `awk` — field processing
  - `awk '{print $NF}'` → print last field
- `sed` — stream editing / substitution
- `cut` — extract columns (`cut -d':' -f1`)
- `sort` / `uniq`
  - `sort | uniq -c | sort -rn | head -10` → top N frequent items
### 4. Cron Jobs
- `crontab -e` — edit user's cron table
- Syntax: `* * * * * command`
```
  ┌───────────── minute (0-59)
  │ ┌───────────── hour (0-23)
  │ │ ┌───────────── day of month (1-31)
  │ │ │ ┌───────────── month (1-12)
  │ │ │ │ ┌───────────── day of week (0-6, Sun=0)
  │ │ │ │ │
  * * * * * command-to-run
```
- Example: `0 2 * * * /path/to/script.sh` → runs daily at 2 AM
### 5. Script Best Practices
- `set -euo pipefail`
  - `-e` → exit on error
  - `-u` → error on unset variables
  - `-o pipefail` → fail if any command in a pipeline fails
- Error handling: check exit codes, use `||` and `&&`
- Logging: timestamp output, redirect to log files
- Use functions for modularity
- Always quote variables: `"$VAR"`
## Tasks
- [ ] Bash basics review
- [ ] File management practice
- [ ] Log analysis practice
- [ ] Cron jobs practice
- [ ] Apply script best practices in both scripts
 