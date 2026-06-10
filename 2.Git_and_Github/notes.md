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
 
*Day 8 Complete ✅ — Next: CI/CD pipelines or GitHub Actions (Day 9)*