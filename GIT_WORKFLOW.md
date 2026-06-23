# Git Workflow — NexusRetail (9 members)

How everyone pushes/pulls to keep `main` clean and avoid conflicts. We use **GitHub Flow**: a single long-lived branch (`main`) plus short-lived feature branches.

## 1. Branch model
```
main      ← protected. Always builds & runs. NEVER push directly. Tag each sprint (v0.1.0, ...).
 ├─ feature/TEAM5-60-admin-login
 ├─ feature/TEAM5-31-qr-sale
 └─ feature/TEAM5-...     ← ONE branch per Jira story, PR straight into main
```
In GitHub → Settings → Branches: protect `main` (require Pull Request + 1 approval + "build passes"). No `develop` branch — we keep it simple and mark demo-ready points with tags.

## 2. One-time setup (each member)
```bash
git clone https://github.com/aryavansh19/rsms.git
cd rsms
git config user.name  "Your Name"
git config user.email "you@email.com"
```

## 3. The daily loop (do this for EVERY story)
```bash
# (1) start from the latest main
git checkout main
git pull origin main

# (2) cut a branch for ONE story
git checkout -b feature/TEAM5-31-qr-sale

# (3) ... write code in Xcode, commit small & often ...
git add .
git commit -m "TEAM5-31: add QR scan service"

# (4) STAY IN SYNC — rebase main into your branch at least once a day
git pull --rebase origin main      # replays your commits on top of latest main

# (5) push your branch
git push -u origin feature/TEAM5-31-qr-sale

# (6) open a Pull Request on GitHub:  your branch → main
#     request 1-2 reviewers, wait for approval, then "Squash and merge"
#     delete the branch after merge

# (7) next story → go back to step (1)
```

## 4. Naming & commit conventions
- Branch: `feature/TEAM5-<id>-<short-slug>` (e.g. `feature/TEAM5-67-floor-price`).
- Bugfix: `bugfix/TEAM5-<id>-<slug>` · Hotfix: `hotfix/<slug>`.
- Commit message: start with the Jira key — `TEAM5-67: enforce floor price on save`.
- Keep commits small and focused (one logical change each).

## 5. Sprint releases (instead of a develop branch)
At the end of each sprint, when `main` is demo-ready, tag it:
```bash
git checkout main && git pull
git tag -a v0.1.0 -m "Sprint 1 complete"
git push origin v0.1.0
```
Always demo from a tag, so a freshly merged half-feature never breaks your demo.

## 6. How to minimize conflicts (the important part)
1. **One story = one branch = one person.** Two people never work the same ticket.
2. **Stay inside your module folder.** Each squad owns a folder (Core, Admin, Manager, Sales, AfterSales). You rarely touch another squad's files.
3. **Small, frequent PRs.** Merge a finished story the same day. A 200-line PR rarely conflicts; a 2,000-line one always does.
4. **Rebase on main daily** (`git pull --rebase origin main`) so you're never far behind.
5. **Pull main right before opening a PR** so the merge is clean.
6. **Don't reformat/move files you're not working on** — it creates noise conflicts.
7. **Communicate** in chat before editing a shared file in `Core/` (models, services, navigation).

## 7. The Xcode `.pbxproj` problem (read this!)
When several people add new files in Xcode, the `project.pbxproj` file conflicts constantly — this is the #1 source of pain on iOS teams.

**Reduce it with these rules:**
- The repo has a `.gitattributes` with `*.pbxproj merge=union`, which keeps additions from BOTH sides instead of conflicting.
- **Add files in small batches** and push/merge quickly — don't let many "new file" changes pile up.
- **Pull before adding new files** in Xcode, and push soon after.
- Prefer **"New Group with Folder"** so structure matches disk.
- If you can, nominate **one person per squad** to do bulk file-structure changes, then others pull.
- Never commit: `xcuserdata/`, `*.xcuserstate`, `DerivedData/`, `build/` (they're in `.gitignore`).

## 8. If you get a conflict
```bash
git pull --rebase origin main
# Git pauses on a conflicted file. Open it in Xcode/VS Code.
# Look for <<<<<<<  =======  >>>>>>> markers; keep the correct code, delete the markers.
git add <fixed-file>
git rebase --continue        # repeat until done
# build & run to confirm nothing broke, then:
git push --force-with-lease  # only your OWN feature branch, never main
```
For a conflicted `.pbxproj`: easiest fix is often to accept both additions (it's a list), then in Xcode do **Clean Build Folder** and confirm the project opens.

## 9. PR review process
- PR title: `TEAM5-67: Set floor price per SKU`.
- Description: what changed, how you tested, screenshots if UI.
- CODEOWNERS auto-requests the module's reviewer.
- Reviewer checks: builds, meets Jira acceptance criteria, no secrets committed.
- **Squash and merge** → delete branch.

## 10. Golden rules (pin these)
- Never `git push` to `main` directly — always via PR.
- Never force-push `main`. Only your own feature branch (`--force-with-lease`).
- Never commit secrets (Supabase keys, Razorpay keys) — use a git-ignored config file.
- Pull every morning; push every evening; finish stories fast.
- When in doubt, ask in the team channel before touching shared code.
