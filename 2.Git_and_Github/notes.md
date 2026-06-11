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