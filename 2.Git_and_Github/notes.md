# 📘 Day 8 — DevSecOps: Git Branching Strategy
 
> **Today's Goal:** Understand Git's branching model and set up a professional repo structure from scratch.
 
---
 
## 📚 Concepts to Learn
 
---
 
### 1. 🌿 Git Branching Model
 
A **branch** in Git is like a separate timeline of your code. You can work on changes without affecting the main codebase.
 
**Three core branches you must understand:**
 
| Branch | Purpose |
|---|---|
| `main` | Production-ready code. Stable, tested, deployable. |
| `dev` | Integration branch. All features merge here before going to `main`. |
| `feature/*` | Short-lived branches for individual features or tasks (e.g., `feature/login-page`). |
 
**Visual Flow:**
```
main  ──────────────────────────────────────► (stable, production)
         ↑                       ↑
dev   ───┼───────────────────────┼──────────► (integration)
         ↑           ↑
feature/x ──(work)──► merged   feature/y ──(work)──► merged
```
 
**Key Commands:**
```bash
# List all branches
git branch -a
 
# Switch to an existing branch
git checkout dev
 
# Create and switch to a new branch
git checkout -b feature/my-feature
 
# View current branch
git status
```
 
---
 
### 2. 🔄 Branch Lifecycle
 
Every branch follows this lifecycle:
 
```
create → commit → push → PR (Pull Request) → merge → delete
```
 
**Step-by-step breakdown:**
 
**① Create**
```bash
git checkout -b feature/git-setup
# Creates a new branch from wherever you currently are (usually dev)
```
 
**② Commit**
```bash
git add .                          # Stage all changes
git add filename.txt               # Stage a specific file
git commit -m "feat: add git setup notes"   # Commit with message
```
 
**③ Push**
```bash
git push origin feature/git-setup
# Pushes your local branch to GitHub (remote)
```
 
**④ Pull Request (PR)**
- Go to GitHub → your repo → you'll see a prompt to open a PR
- A PR is a **request to merge** your branch into another (e.g., `feature/git-setup` → `dev`)
- Add a title, description, and request a reviewer
**⑤ Merge**
- Once the PR is reviewed and approved, click **Merge Pull Request** on GitHub
- Or via CLI:
```bash
git checkout dev
git merge feature/git-setup
```
 
**⑥ Delete** (cleanup after merging)
```bash
# Delete local branch
git branch -d feature/git-setup
 
# Delete remote branch
git push origin --delete feature/git-setup
```
 
---
 
### 3. ✍️ Commit Conventions — Conventional Commits
 
Good commit messages make your git history readable and professional. The standard format is:
 
```
<type>: <short description>
```
 
**Common types:**
 
| Type | When to Use | Example |
|---|---|---|
| `feat:` | Adding a new feature | `feat: add user login page` |
| `fix:` | Fixing a bug | `fix: resolve null pointer on login` |
| `chore:` | Maintenance tasks (no code logic change) | `chore: update dependencies` |
| `docs:` | Documentation only | `docs: add README setup instructions` |
| `refactor:` | Code restructuring (no feature/fix) | `refactor: simplify auth middleware` |
 
**More types you'll encounter:**
- `test:` — adding or updating tests
- `style:` — formatting, whitespace (no logic change)
- `ci:` — CI/CD pipeline changes
**Examples:**
```bash
git commit -m "feat: create devsecops-week2 repo structure"
git commit -m "docs: add branching notes to README"
git commit -m "chore: remove unused config files"
```
 
> 💡 **Why this matters in DevSecOps:** Clean commits make auditing, rollback, and security reviews much easier.
 
---
 
### 4. 🔀 Pull Requests (PRs)
 
A **Pull Request** is how code gets reviewed before merging. It's the heart of collaborative and secure development.
 
**How to open a PR on GitHub:**
1. Push your branch → `git push origin feature/git-setup`
2. Go to your GitHub repo
3. Click the **"Compare & pull request"** button (appears automatically)
4. Fill in:
   - **Title** — short summary (can follow conventional commit style)
   - **Description** — what changed, why, any notes for reviewers
   - **Reviewers** — assign teammates (or yourself for practice)
   - **Labels** — optional: `feature`, `bugfix`, `documentation`
5. Click **"Create Pull Request"**
**Writing a good PR description:**
```markdown
## What changed
Added a `dev` branch with initial project structure.
 
## Why
Setting up the branching strategy for devsecops-week2 as per Day 8 tasks.
 
## How to test
1. Clone the repo
2. Switch to `dev` branch
3. Verify folder structure matches the plan
```
 
**PR Review process:**
- Reviewer reads your code, leaves comments
- You fix issues → push new commits → PR updates automatically
- Reviewer approves → merge!
---
 
## 🔧 Hands-On Tasks
 
---
 
### ✅ Task 1: Create a new GitHub repo — `devsecops-week2`
 
```bash
# On GitHub:
# 1. Go to github.com → New Repository
# 2. Name it: devsecops-week2
# 3. Set to Public or Private
# 4. Add a README (tick the checkbox)
# 5. Click "Create repository"
 
# Then clone it locally:
git clone https://github.com/<your-username>/devsecops-week2.git
cd devsecops-week2
```
 
---
 
### ✅ Task 2: Set up branch protection on `main`
 
Branch protection rules prevent anyone from pushing directly to `main` — all changes must go through a PR.
 
**Steps on GitHub:**
1. Go to your repo → **Settings** → **Branches**
2. Click **"Add branch protection rule"**
3. In "Branch name pattern", type: `main`
4. Tick: ✅ **Require a pull request before merging**
5. Optionally tick: ✅ Require approvals (set to 1)
6. Click **Save changes**
> 🔐 **DevSecOps relevance:** This enforces code review — a critical security control. No one (not even you) can bypass the review process.
 
---
 
### ✅ Task 3: Create `dev` branch and push a commit
 
```bash
# Make sure you're in the repo folder
cd devsecops-week2
 
# Create and switch to dev branch
git checkout -b dev
 
# Make a small change (e.g., edit README or create a file)
echo "# Dev Branch" >> dev-notes.txt
 
# Stage and commit
git add dev-notes.txt
git commit -m "chore: initialise dev branch"
 
# Push to GitHub
git push origin dev
```
 
---
 
### ✅ Task 4: Create `feature/git-setup` branch, make a change, open a PR to `dev`
 
```bash
# Make sure you're on dev first
git checkout dev
 
# Create the feature branch
git checkout -b feature/git-setup
 
# Make a meaningful change
mkdir docs
echo "# Git Branching Notes" >> docs/git-branching.md
 
# Stage and commit
git add docs/git-branching.md
git commit -m "docs: add git branching strategy notes"
 
# Push to GitHub
git push origin feature/git-setup
```
 
**Then on GitHub:**
1. You'll see a banner: *"feature/git-setup had recent pushes"* → click **"Compare & pull request"**
2. Set **base branch** to `dev` (not `main`!)
3. Write a description
4. Click **"Create Pull Request"**
5. Merge it into `dev`
---
 
### ✅ Task 5: Watch Udemy Git/GitHub module — Branching & Remotes section
 
**Topics to focus on while watching:**
- How `origin` works (remote tracking)
- `git fetch` vs `git pull`
- Merge conflicts — how to resolve them
- `git log --oneline --graph` — visualizing branch history
---
 
## 📝 Notes Space — Key Commands Practiced Today
 
```bash
# Create and switch to a new branch
git checkout -b feature/name
 
# Push a local branch to GitHub
git push origin feature/name
 
# View commit history as a graph
git log --oneline --graph
 
# Additional useful commands:
git branch              # List local branches
git branch -a           # List all branches (local + remote)
git status              # Check current state
git diff                # See unstaged changes
git stash               # Temporarily save changes without committing
git pull origin dev     # Pull latest changes from dev
```
 
---
 
## 🧠 Summary — What You Learned Today
 
| Concept | Key Takeaway |
|---|---|
| Branching model | `main` = stable, `dev` = integration, `feature/*` = work-in-progress |
| Branch lifecycle | create → commit → push → PR → merge → delete |
| Commit conventions | Use `feat:`, `fix:`, `docs:`, etc. for readable history |
| Pull Requests | The mandatory review gate before code hits `dev` or `main` |
| Branch protection | Enforces PRs on `main` — a core DevSecOps control |
 
---
 
## 🔗 Quick Reference
 
```bash
git checkout -b <branch>        # Create + switch
git add .                       # Stage all
git commit -m "type: message"   # Commit
git push origin <branch>        # Push
git log --oneline --graph       # Visualise history
git branch -d <branch>          # Delete local branch
git pull origin dev             # Sync with dev
```
 
---
 
# 📅 Day 9 (Week 2 — Day 2) · GitHub Workflow 
 
> **Today's Goal:** Experience and resolve merge conflicts; write a professional README.
 
---
 
## 📚 Table of Contents
 
1. [What is a Merge Conflict?](#1-what-is-a-merge-conflict)
2. [Merge Conflict Anatomy](#2-merge-conflict-anatomy)
3. [Resolution Strategies](#3-resolution-strategies)
4. [GitHub Workflow (Fork → Clone → Branch → PR → Review → Merge)](#4-github-workflow)
5. [README Best Practices](#5-readme-best-practices)
6. [Hands-On Task Walkthrough](#6-hands-on-task-walkthrough)
7. [Merge Conflict Resolution Checklist](#7-merge-conflict-resolution-checklist)
8. [Quick Reference Cheat Sheet](#8-quick-reference-cheat-sheet)
---
 
## 1. What is a Merge Conflict?
 
A **merge conflict** happens when two people (or two branches) change the **same line** of the same file, and Git doesn't know which version to keep.
 
### Simple Analogy
Imagine two people editing the same Google Doc offline at the same time. When they sync, there are two versions of the same sentence — someone has to decide which one stays. That decision is "resolving the conflict."
 
### When do conflicts happen?
- You and a teammate edit the **same line** in different branches
- One branch **deletes** a file that another branch **modified**
- Two branches make **different changes** to the same function or block of code
---
 
## 2. Merge Conflict Anatomy
 
When Git detects a conflict, it edits the file and inserts special **conflict markers** to show you both versions:
 
````
<<<<<<< HEAD
Your current branch's version of the code
=======
The incoming branch's version of the code
>>>>>>> feature/branch-name
````
 
### Breaking Down the Markers
 
| Marker | Name | What it means |
|--------|------|---------------|
| `<<<<<<< HEAD` | Conflict Start | Everything below this is **your** current branch's version |
| `=======` | Separator | Divides the two conflicting versions |
| `>>>>>>> feature/branch` | Conflict End | Everything above this is the **incoming** branch's version |
 
### Example
 
Suppose both branches edited the same greeting in `index.js`:
 
````javascript
<<<<<<< HEAD
console.log("Hello, World!");
=======
console.log("Hello, DevSecOps!");
>>>>>>> feature/update-greeting
````
 
You must pick one (or write a new combined version) and remove all three marker lines.
 
---
 
## 3. Resolution Strategies
 
There are three ways to resolve a merge conflict:
 
### Strategy 1: Accept Ours (Keep Current Branch)
Keep your version and throw away the incoming change.
 
````javascript
// Before (with conflict markers)
<<<<<<< HEAD
console.log("Hello, World!");
=======
console.log("Hello, DevSecOps!");
>>>>>>> feature/update-greeting
 
// After (kept ours)
console.log("Hello, World!");
````
 
**When to use:** Your change is the correct/final version.
 
---
 
### Strategy 2: Accept Theirs (Keep Incoming Branch)
Discard your version and use the incoming change instead.
 
````javascript
// After (kept theirs)
console.log("Hello, DevSecOps!");
````
 
**When to use:** The incoming change is better or more up to date.
 
---
 
### Strategy 3: Manual Merge (Combine Both)
Write a brand-new version that incorporates ideas from both changes.
 
````javascript
// After (combined both)
console.log("Hello, World! Welcome to DevSecOps!");
````
 
**When to use:** Both versions have value and need to coexist.
 
---
 
### How to Resolve in VS Code
 
VS Code has a built-in merge editor that shows the conflict visually:
 
1. Open the conflicting file — VS Code highlights conflict regions in colour
2. You'll see **Accept Current Change** | **Accept Incoming Change** | **Accept Both Changes** buttons above each conflict
3. Click the option that fits your strategy
4. Save the file after resolving all conflicts
---
 
## 4. GitHub Workflow
 
The standard professional workflow for collaborating on GitHub:
 
````
Fork → Clone → Branch → Code → PR → Review → Merge
````
 
### Step-by-Step
 
#### Step 1: Fork
Create your own copy of someone else's repository on GitHub.
 
- Go to the repo on GitHub
- Click the **Fork** button (top right)
- GitHub creates `your-username/repo-name` under your account
> **Why fork?** You can't push directly to someone else's repo. Forking gives you a personal copy to work in.
 
---
 
#### Step 2: Clone
Download your forked repo to your local machine.
 
````bash
git clone https://github.com/your-username/repo-name.git
cd repo-name
````
 
---
 
#### Step 3: Create a Branch
Never work directly on `main`. Always create a feature branch.
 
````bash
git checkout -b feature/my-new-feature
# or
git branch feature/my-new-feature
git checkout feature/my-new-feature
````
 
> **Branch naming conventions:**
> - `feature/add-login-page`
> - `fix/resolve-null-error`
> - `docs/update-readme`
 
---
 
#### Step 4: Make Changes & Commit
 
````bash
# After editing your files...
git status                          # See what changed
git add filename.js                 # Stage a specific file
git add .                           # Stage all changes
git commit -m "feat: add login page"
````
 
> **Good commit message format:** `type: short description`
> Types: `feat`, `fix`, `docs`, `style`, `refactor`, `test`
 
---
 
#### Step 5: Push to Your Fork
 
````bash
git push origin feature/my-new-feature
````
 
---
 
#### Step 6: Open a Pull Request (PR)
 
1. Go to your fork on GitHub
2. Click **"Compare & pull request"**
3. Write a clear title and description
4. Set the base repo and branch (where you want to merge INTO)
5. Click **"Create pull request"**
---
 
#### Step 7: Code Review
 
A teammate or maintainer reviews your PR:
- They may leave comments or request changes
- You make changes, commit, and push again — the PR updates automatically
- Once approved, the PR is ready to merge
---
 
#### Step 8: Merge
 
Once approved:
- Click **"Merge pull request"** on GitHub
- Or the maintainer merges it
---
 
## 5. README Best Practices
 
A `README.md` is the front page of your project. It should answer: *"What is this? How do I use it?"*
 
### Required Sections
 
#### 1. Project Title + Badges
````markdown
# My Awesome Project
 
![License](https://img.shields.io/badge/license-MIT-blue.svg)
![Version](https://img.shields.io/badge/version-1.0.0-green.svg)
````
 
Badges are small status icons from [shields.io](https://shields.io) that show license type, build status, version, etc.
 
---
 
#### 2. About / Description
````markdown
## About
 
A brief 2-3 sentence description of what the project does and why it exists.
Who is it for? What problem does it solve?
````
 
---
 
#### 3. Installation / Setup
````markdown
## Installation
 
1. Clone the repository
```bash
   git clone https://github.com/username/project.git
```
2. Navigate into the folder
```bash
   cd project
```
3. Install dependencies
```bash
   npm install
```
````
 
---
 
#### 4. Usage
````markdown
## Usage
 
Explain how to run/use the project with examples.
 
```bash
node index.js
```
 
Include screenshots if helpful.
````
 
---
 
#### 5. Contributing
````markdown
## Contributing
 
Contributions are welcome! Please follow these steps:
1. Fork the repo
2. Create a feature branch (`git checkout -b feature/your-feature`)
3. Commit your changes
4. Open a Pull Request
````
 
---
 
#### 6. License
````markdown
## License
 
This project is licensed under the [MIT License](LICENSE).
````
 
---
 
### Full README Template for `devsecops-week2`
 
````markdown
# 🔐 devsecops-week2
 
![License](https://img.shields.io/badge/license-MIT-blue.svg)
![Status](https://img.shields.io/badge/status-active-brightgreen)
 
## About
 
A hands-on DevSecOps learning repository covering Git workflows,
merge conflict resolution, and secure development practices.
Built as part of a structured 30-day DevSecOps challenge.
 
## Installation
 
1. Clone the repository
```bash
   git clone https://github.com/your-username/devsecops-week2.git
   cd devsecops-week2
```
2. No additional dependencies required for this module.
 
## Usage
 
Explore the examples and exercises in each day's folder:
 
```bash
cd day9/
cat notes.md
```
 
## Contributing
 
1. Fork the repo
2. Create your branch: `git checkout -b feature/your-feature`
3. Commit changes: `git commit -m "feat: add your feature"`
4. Push: `git push origin feature/your-feature`
5. Open a Pull Request
 
## License
 
MIT © 2024 Your Name
````
 
---
 
## 6. Hands-On Task Walkthrough
 
### Task 1: Deliberately Create a Merge Conflict
 
````bash
# Start on main branch
git checkout main
 
# Create and switch to branch-A
git checkout -b branch-A
 
# Edit the same line in a file
echo "Hello from Branch A" > hello.txt
git add hello.txt
git commit -m "feat: update hello from branch-A"
 
# Switch back to main
git checkout main
 
# Edit the SAME line in the same file
echo "Hello from Main" > hello.txt
git add hello.txt
git commit -m "feat: update hello from main"
 
# Now merge branch-A into main — this WILL conflict
git merge branch-A
# ❌ CONFLICT (content): Merge conflict in hello.txt
````
 
---
 
### Task 2: Resolve the Conflict Using VS Code
 
1. Open the project in VS Code: `code .`
2. In the Source Control panel, look for files marked with **`!`** (conflict)
3. Click the file — VS Code shows the merge editor
4. Choose **Accept Current**, **Accept Incoming**, or **Accept Both**
5. Save the file
Then finalise the merge:
 
````bash
git add hello.txt
git commit -m "fix: resolve merge conflict in hello.txt"
````
 
---
 
### Task 3: Write a Professional README.md
 
Create the file:
````bash
touch README.md
````
 
Use the template from [Section 5](#5-readme-best-practices) and customise it for your `devsecops-week2` repo. Commit it:
 
````bash
git add README.md
git commit -m "docs: add professional README"
git push origin main
````
 
---
 
## 7. Merge Conflict Resolution Checklist
 
Use this step-by-step checklist every time you hit a conflict:
 
````
1. git merge feature/branch        ← triggers conflict
2. Open file, look for <<<< markers
3. Decide which change to keep (or combine both)
4. Remove ALL conflict markers (<<<<, ====, >>>>)
5. git add <file>
6. git commit -m "fix: resolve merge conflict in <file>"
````
 
### Detailed Breakdown
 
| Step | Command / Action | Notes |
|------|-----------------|-------|
| 1 | `git merge feature/branch` | Git will output which files conflict |
| 2 | Open file in editor | Look for `<<<<<<<` to find conflicts |
| 3 | Decide & edit | Remove markers, keep what you want |
| 4 | Double-check | Ensure NO marker lines remain in the file |
| 5 | `git add <file>` | Tell Git the conflict is resolved |
| 6 | `git commit -m "fix: ..."` | Complete the merge with a clear message |
 
> ⚠️ **Common Mistake:** Forgetting to remove all three conflict marker lines (`<<<<<<<`, `=======`, `>>>>>>>`). If these lines remain in your file, your code will be broken and won't run.
 
---
 
## 8. Quick Reference Cheat Sheet
 
### Essential Git Commands
 
````bash
# Branching
git branch                          # List all branches
git checkout -b feature/name        # Create and switch to new branch
git checkout main                   # Switch back to main
 
# Staging & Committing
git status                          # See changed files
git add .                           # Stage all changes
git add filename                    # Stage a specific file
git commit -m "type: message"       # Commit with message
 
# Merging
git merge feature/branch-name       # Merge a branch into current
git merge --abort                   # Cancel a merge (before resolving)
 
# Remote
git push origin branch-name         # Push to remote
git pull origin main                # Pull latest from main
git fetch                           # Fetch changes without merging
 
# Conflict Helpers
git diff                            # See unstaged changes
git log --oneline --graph           # Visual branch history
git status                          # Shows which files have conflicts
````
 
### Conflict Markers at a Glance
 
````
<<<<<<< HEAD           ← YOUR current branch starts here
your code here
=======                ← divider between the two versions
their code here
>>>>>>> feature/branch ← INCOMING branch ends here
````
 
### Commit Message Types
 
| Type | Use for |
|------|---------|
| `feat` | New feature |
| `fix` | Bug fix |
| `docs` | Documentation changes |
| `style` | Formatting, no logic change |
| `refactor` | Code restructure, no feature change |
| `test` | Adding or updating tests |
 
---
 
> 💡 **Key Takeaway for Today:** Merge conflicts are not scary — they're Git asking you to make a decision. The workflow is always the same: find the markers, choose what to keep, remove the markers, stage, commit.
 
---
 
*Notes for Day 9 — Week 2, Day 2 | DevSecOps Learning Journey*


# Day 11 (Week 2 — Day 4) · Pre-Commit Hooks & Strings Basics
 
## 🔒 DevSecOps — Pre-Commit Security Hooks
 
**Today's Goal:** Build and install a pre-commit hook that prevents secrets from leaking into Git history.
 
---
 
## 📖 Concepts Learned
 
### 1. Git Hooks Overview
- Hooks live in `.git/hooks/` — scripts that Git runs automatically at certain points in the workflow.
- Each hook is just an executable script (any language, but `#!/bin/bash` is common).
- Hooks are **local only** by default — not committed to the repo (the `.git` folder isn't tracked), so each dev/machine needs them set up individually.
- Key hook types:
  - **pre-commit** — runs before a commit is created. If it exits non-zero, the commit is aborted. Used for linting, formatting, secret scanning.
  - **commit-msg** — runs after the commit message is written, can validate/enforce message format (e.g., Conventional Commits).
  - **pre-push** — runs before `git push` sends data to the remote. Good last line of defense (e.g., run tests, block pushing secrets that slipped past pre-commit).
### 2. git-secrets Tool
- Open-source tool (by AWS Labs) that scans commits/diffs for patterns matching credentials, especially AWS keys.
- Already installed in Week 1 ✅
- Core commands:
  - `git secrets --install` — installs git-secrets hooks (pre-commit, commit-msg, prepare-commit-msg) into the current repo.
  - `git secrets --register-aws` — adds AWS-specific regex patterns (access keys, secret keys) to the repo's git-secrets config.
  - `git secrets --scan` — manually scan files/history for matches.
- Provider rules = predefined regex sets for known credential formats (currently AWS; can add custom patterns too).
### 3. Regex for Secret Detection
Patterns commonly used to catch leaked secrets:
- **AWS Access Key ID:** `AKIA[0-9A-Z]{16}` — always starts with `AKIA` followed by 16 uppercase alphanumeric chars.
- **Private key headers:** `-----BEGIN` (matches `-----BEGIN RSA PRIVATE KEY-----`, `-----BEGIN OPENSSH PRIVATE KEY-----`, etc.)
- **Hardcoded passwords:** `password\s*=\s*['"][^'"]+['"]` — matches `password = "something"` or `password='something'` assignments.
### 4. Conventional Commits Validation
- A `commit-msg` hook can enforce the [Conventional Commits](https://www.conventionalcommits.org/) format (e.g., `feat: ...`, `fix: ...`, `chore: ...`) using a regex check on the commit message file.
- Rejects commits whose message doesn't match the expected prefix/structure.
---
 
## 🛠️ Hands-On Tasks
 
### Install git-secrets
- [x] `brew install git-secrets` / `apt install git-secrets` (done in Week 1)
- [x] `git secrets --install` — already done in Week 1
- [x] `git secrets --register-aws` — already done in Week 1
- [ ] Test: try committing a fake AWS key (e.g., `AKIA*************`) → commit should be **blocked**
> **Important consequence:** because `git secrets --install` already created `.git/hooks/pre-commit` (and `commit-msg`, `prepare-commit-msg`), this file **already exists and is already executable**. Today's custom script must be **added into that existing file**, not created fresh — see the "How to install/use this script" section below.
 
### Write a Basic Pre-Commit Regex Scanner
 
This is a **custom secondary scanner** that complements git-secrets by checking for additional patterns (private key headers, hardcoded passwords) using plain bash + grep.
 
```bash
#!/bin/bash
# .git/hooks/pre-commit
STAGED=$(git diff --cached --name-only)
 
PATTERNS=(
  'AKIA[0-9A-Z]{16}'
  '\-\-\-\-\-BEGIN'
  'password\s*=\s*['"'"'"][^'"'"'"]+['"'"'"]'
)
 
for file in $STAGED; do
  for pattern in "${PATTERNS[@]}"; do
    if git show ":$file" | grep -qE "$pattern"; then
      echo -e "\033[0;31m[BLOCKED] Secret pattern found in $file: $pattern\033[0m"
      exit 1
    fi
  done
done
```
 
#### What this script does, step by step:
 
```bash
#!/bin/bash
# .git/hooks/pre-commit
STAGED=$(git diff --cached --name-only)
```
- `#!/bin/bash` — tells Git to run this file using bash.
- `git diff --cached --name-only` — lists only the **filenames** that are staged (added with `git add`) for the upcoming commit. `--cached` means "compare against the staging area", `--name-only` strips out the actual diff content and just gives filenames, one per line.
- This list is stored in `STAGED` as a space/newline-separated string.
```bash
PATTERNS=(
  'AKIA[0-9A-Z]{16}'
  '\-\-\-\-\-BEGIN'
  'password\s*=\s*['"'"'"][^'"'"'"]+['"'"'"]'
)
```
- A bash **array** of regex patterns, each representing a type of secret to detect:
  - `AKIA[0-9A-Z]{16}` — matches AWS Access Key IDs (always start with `AKIA`, followed by exactly 16 uppercase letters/digits).
  - `\-\-\-\-\-BEGIN` — matches the start of any PEM-formatted private key block, e.g. `-----BEGIN RSA PRIVATE KEY-----`, `-----BEGIN OPENSSH PRIVATE KEY-----`, `-----BEGIN CERTIFICATE-----`.
  - `password\s*=\s*['"][^'"]+['"]` — matches hardcoded password assignments like `password = "abc123"` or `password='secret'`. `\s*` allows optional spaces around `=`, and `['"][^'"]+['"]` matches a quoted value.
```bash
for file in $STAGED; do
  for pattern in "${PATTERNS[@]}"; do
```
- **Outer loop:** iterates over each staged filename.
- **Inner loop:** for each file, iterates over every pattern in the `PATTERNS` array (`"${PATTERNS[@]}"` expands to all elements, properly quoted).
```bash
    if git show ":$file" | grep -qE "$pattern"; then
```
- `git show ":$file"` — prints the **staged (index) version** of the file's content. This is critical: it checks what will actually be committed, not what's currently sitting in your working directory (which may have additional unstaged edits).
- `grep -qE "$pattern"` — `-E` enables extended regex (so `{16}`, `+`, etc. work without escaping), `-q` suppresses output and just sets the exit status: `0` if a match is found, `1` if not.
- The `if` checks: "does the staged content of this file match this secret pattern?"
```bash
      echo -e "\033[0;31m[BLOCKED] Secret pattern found in $file: $pattern\033[0m"
      exit 1
    fi
  done
done
```
- If a match is found:
  - `echo -e "\033[0;31m...\033[0m"` — prints a message in **red text**. `\033[0;31m` is the ANSI escape code for red, `\033[0m` resets the color back to normal.
  - The message shows exactly which file and which pattern triggered the block.
  - `exit 1` — non-zero exit code tells Git "abort the commit". Git will print "the pre-commit hook failed" and the commit will **not** be created.
- If no file matches any pattern, both loops finish normally, the script reaches the end (implicit `exit 0`), and Git proceeds with the commit.
---
 
## 📋 How to Install and Use This Script (Step-by-Step)
 
Since `git secrets --install` (Week 1) already created `.git/hooks/pre-commit` as a git-secrets-managed script, you have **two safe options**. Option A (recommended) keeps both layers of protection working together.
 
### Option A — Append this script's logic to the existing git-secrets hook (recommended)
 
1. **Check what's currently in the hook file:**
```bash
   cat .git/hooks/pre-commit
```
   You should see content referencing `git-secrets` (it calls `git secrets --pre_commit_hook`).
 
2. **Open the existing hook file for editing:**
```bash
   nano .git/hooks/pre-commit
```
   (or use `vim`, `code`, etc.)
 
3. **Append the custom scanner logic at the end of the file** (keep the existing git-secrets lines at the top — do not delete them). Add this block below the existing content:
```bash
   # --- Custom secret pattern scanner (Day 11) ---
   STAGED=$(git diff --cached --name-only)
 
   PATTERNS=(
     'AKIA[0-9A-Z]{16}'
     '\-\-\-\-\-BEGIN'
     'password\s*=\s*['"'"'"][^'"'"'"]+['"'"'"]'
   )
 
   for file in $STAGED; do
     for pattern in "${PATTERNS[@]}"; do
       if git show ":$file" | grep -qE "$pattern"; then
         echo -e "\033[0;31m[BLOCKED] Secret pattern found in $file: $pattern\033[0m"
         exit 1
       fi
     done
   done
```
 
4. **Save and exit** the editor.
5. **Ensure it's executable** (should already be, but double-check):
```bash
   chmod +x .git/hooks/pre-commit
```
 
### Option B — Run as a separate "second-opinion" hook
 
Git only executes one `pre-commit` hook per repo, but you can manually invoke a second script from inside the first:
 
1. Save the new logic as a separate file, e.g. `.git/hooks/pre-commit-custom`:
```bash
   nano .git/hooks/pre-commit-custom
```
   Paste the full script (including `#!/bin/bash`).
 
2. Make it executable:
```bash
   chmod +x .git/hooks/pre-commit-custom
```
 
3. At the **end** of the existing `.git/hooks/pre-commit` (git-secrets file), add:
```bash
   .git/hooks/pre-commit-custom || exit 1
```
   This calls the custom script and aborts the commit if it fails too.
 
---
 
## ✅ Testing the Combined Hook
 
1. **Test the "should block" case — fake AWS key:**
```bash
   echo 'AWS_KEY="AKIA*************"' > secret_test.txt
   git add secret_test.txt
   git commit -m "test: fake secret"
```
   Expected: commit aborts. You should see either git-secrets' own block message, or this script's red `[BLOCKED]` message (depending on which check matches first).
 
2. **Test the "should block" case — hardcoded password:**
```bash
   echo 'password = "supersecret123"' > pw_test.txt
   git add pw_test.txt
   git commit -m "test: hardcoded password"
```
   Expected: red `[BLOCKED] Secret pattern found in pw_test.txt: password\s*=\s*['"][^'"]+['"]` message, commit aborted.
 
3. **Test the "should block" case — private key:**
```bash
   printf -- '-----BEGIN RSA PRIVATE KEY-----\nFAKEDATA\n-----END RSA PRIVATE KEY-----\n' > key_test.txt
   git add key_test.txt
   git commit -m "test: fake private key"
```
   Expected: commit aborted with `[BLOCKED]` message referencing `key_test.txt`.
 
4. **Test the "should pass" case — clean file:**
```bash
   echo 'console.log("hello world")' > clean_test.txt
   git add clean_test.txt
   git commit -m "test: clean file"
```
   Expected: commit **succeeds** normally — no false positives.
 
5. **Clean up test files afterward** (if the clean commit went through, just remove/revert the test files and commit again, or use `git reset --hard` if you want to undo everything from this testing session — be careful, this discards uncommitted changes).
---
 
## 📝 Gotchas & Tips
- `git show ":$file"` only works for files that are tracked and staged — if a file is staged for **deletion**, `git show ":$file"` will fail; you may want to add a check to skip deleted files (`git diff --cached --name-status` shows status codes like `D` for deleted).
- The password regex uses single quotes around the pattern but the pattern itself contains single quotes (`'"'"'"` is bash's way of embedding a literal `'` inside a single-quoted string) — be careful copying this exactly.
- If a pattern legitimately appears in a comment or test fixture (false positive), you can either refine the regex or add a temporary bypass with `git commit --no-verify` (use sparingly — this skips **all** hooks, including git-secrets).
- Consider versioning this hook script inside the repo (e.g. `scripts/hooks/pre-commit`) with a setup script that copies/symlinks it into `.git/hooks/`, so every teammate gets the same protection after cloning.