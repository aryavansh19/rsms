# RSMS — iOS App (Team 5)

Retail Store Management System. **SwiftUI + MVVM + Swift Concurrency**, Supabase backend, Vision (QR), Core ML, Razorpay. iOS 26+, iPhone + iPad.

## Getting started
1. Install XcodeGen: `brew install xcodegen`
2. From `RSMS/`: `xcodegen generate`
3. Open `RSMS.xcodeproj` and build.

> The `.xcodeproj` is **generated** and git-ignored. To add files or packages, edit `project.yml` and re-run `xcodegen generate`. This removes the single biggest cause of Xcode merge conflicts (the `.pbxproj` file).

## Folder structure
```
RSMS/
├── project.yml                 # XcodeGen config — the source of truth for the Xcode project
├── CODEOWNERS                  # per-module reviewers
├── RSMS/
│   ├── App/                    # entry point, RootView (RBAC router), DI container
│   ├── Core/                   # SHARED — owned by the Platform squad
│   │   ├── Auth/               # UserRole, Session, AuthService, AccessPolicy
│   │   ├── Models/             # Store, SKU, PriceBand, InventoryItem, Client, Order, ...
│   │   ├── Networking/         # Supabase client, API errors
│   │   ├── Persistence/        # SwiftData stack, Keychain
│   │   ├── Sync/               # offline write queue + conflict resolution
│   │   ├── Scanning/           # Vision QR scanner
│   │   ├── Payments/           # Razorpay + card terminal
│   │   ├── Pricing/ Inventory/ Recommendations/ Notifications/
│   │   └── DesignSystem/       # Theme, reusable components, localization
│   ├── Features/               # one folder per ROLE, one sub-folder per EPIC (View + ViewModel)
│   │   ├── Admin/              # Stores, Products, Transfers, Analytics, Profiles
│   │   ├── Manager/            # Inventory, Requests, Pricing, Events, Staff
│   │   ├── SalesAssociate/     # Clienteling, Recommendations, Sell, Settings
│   │   └── AfterSales/         # Intake, Estimate, Repair, Return, Workload
│   └── Resources/              # Assets.xcassets, Core ML models, Localizable.strings
├── RSMSTests/                  # unit tests
└── RSMSUITests/                # UI tests
```
Every View/ViewModel file is commented with the **TEAM5 story IDs** it implements, so each member knows exactly which file maps to their Jira ticket.

## Team allocation (9 members)
| Squad | Members | Owns |
|-------|---------|------|
| Platform / Core | 2 | `App/`, `Core/*` — auth, Supabase, sync, design system, scanning |
| Admin | 2 | `Features/Admin` |
| Sales Associate | 2 | `Features/SalesAssociate` (largest module) |
| After-Sales | 2 | `Features/AfterSales` |
| Manager | 1 | `Features/Manager` |

The Platform squad front-loads the Sprint-1 setup stories (TEAM5-2 Supabase, TEAM5-60 auth/scaffold, TEAM5-7 payments); the other squads build on top from Sprint 2.

## Branching model
- **`main`** — protected, always releasable. **No direct pushes**; merges from `develop` via release PR; tag each release.
- **`develop`** — integration branch; all features merge here first.
- **`feature/TEAM5-<id>-<slug>`** — ONE branch per Jira story, e.g. `feature/TEAM5-31-qr-sale`.
- **`bugfix/TEAM5-<id>-<slug>`**, **`hotfix/<slug>`** — as needed.

You don't pre-create branches — each person cuts a feature branch when they start a story. Only a handful are active at once (one per in-progress story). Because each story lives in its own module folder, two people rarely touch the same file.

## Push / pull best practices
1. **Branch from the latest develop:**
   `git checkout develop && git pull && git checkout -b feature/TEAM5-31-qr-sale`
2. **Commit small & often**, referencing the Jira key: `git commit -m "TEAM5-31: QR scan dual update"`
3. **Stay current — rebase on develop daily:** `git pull --rebase origin develop`
4. **Before pushing:** run `xcodegen generate`, build, and run tests locally.
5. **Push your branch and open a PR into `develop`**; request 1–2 reviews (CODEOWNERS auto-assigns).
6. **Resolve conflicts locally**; never force-push a shared branch.
7. **Squash-merge** PRs and delete the branch after merge.
8. At sprint end, open a **release PR `develop` → `main`** and tag it (e.g. `v0.1.0`).

## Conflict-avoidance rules
- **Never commit `RSMS.xcodeproj`** (it's generated). Add files via `project.yml`.
- Keep your work **inside your module folder**; coordinate in chat before editing shared `Core/` files.
- **Small PRs beat big PRs** — easier to review and less likely to conflict.
- Enable branch protection on `main` and `develop`: require PR + green build + 1 approval.
