# NexusRetail — Project Context (for AI assistants)

Paste this at the start of a conversation so the assistant understands the whole app.

## 1. What we're building
**NexusRetail** is a **Retail Store Management System (RSMS)** — a native **iOS app** for a multi-country **luxury goods** retail chain (jewelry, watches, leather goods, couture). It unifies store administration, clienteling/selling, inventory, omnichannel fulfilment, and after-sales service into one role-based app. Team project (9 members), Jira project key **TEAM5**, 3 sprints.

## 2. Tech stack & key decisions
- **UI:** SwiftUI (iOS 17+/26), iPhone + iPad.
- **Architecture:** MVVM + Swift Concurrency (`async/await`, `@Observable` view models, `actor` for concurrent-safe inventory/payment writes).
- **Backend:** **Supabase** (PostgreSQL + Auth + Realtime + Storage + Row-Level Security). Local cache via **SwiftData**; offline sync engine.
- **Auth:** Supabase Auth (email/password to start; Passkeys are the long-term goal). Role-based access control (RBAC).
- **Scanning:** **QR codes via the Vision framework** (NOT RFID) for all item-level operations.
- **Payments:** **Razorpay** (UPI/netbanking/wallets) + a physical **card terminal** (tap/swipe); digital receipts.
- **AI:** **Core ML** for product recommendations (cross-sell/up-sell/trending).

## 3. The 4 user roles (exactly four — no Inventory Controller)
1. **Admin** (Corporate/Retail Ops) — stores, products, global pricing/floor, inter-store transfers, cross-store revenue.
2. **Manager** (Boutique) — store dashboard, inventory + low-stock, banded local pricing, stock requests, events, staff. (Owns inventory ops.)
3. **Sales Associate** (Client Advisor) — clienteling, appointments/BOPIS, AI recommendations, QR sale, payments.
4. **After-Sales Specialist** — repair/return/exchange/warranty tickets (AST), estimates, QA, returns.

## 4. Core business rules (invariants)
- **Price floor:** Admin sets a base price + minimum **floor** per SKU per currency; a Manager's local price can never go below the floor (enforced by a DB trigger).
- **Atomic QR sale:** one scan updates **inventory (−)** and the **client's purchase history (+)** in a single transaction; rollback if either fails.
- **No work before approval:** a repair can't advance past intake until the client approves the digital estimate.
- **QA gate:** a repair can't be marked complete until a mandatory QA checklist is done.
- **Consent gate:** client personal data is persisted only if consent is granted (GDPR).
- **RBAC scoping:** Admin is global; Manager/Associate/After-Sales are scoped to their own store.

## 5. App folder structure (MVVM)
```
NexusRetail/
├── App/            RootView (RBAC router), DIContainer
├── Core/           shared layer (Platform squad)
│   ├── Auth/       UserRole, Session, SessionStore, AuthService, AccessPolicy
│   ├── Models/     Store, SKU, PriceBand, InventoryItem, Client, Order, TransferRequest, AfterSalesTicket
│   ├── Networking/ SupabaseClient, APIError
│   ├── Persistence/SwiftDataStack, KeychainStore
│   ├── Sync/ Scanning(Vision QR)/ Payments(Razorpay+Card)/
│   ├── Pricing/ Inventory/ Recommendations(CoreML)/ Notifications/
│   └── DesignSystem/ (theme, components, localization)
└── Features/       one group per role, one sub-group per epic (View + ViewModel)
    ├── Admin/        Stores, Products, Transfers, Analytics, Profiles
    ├── Manager/      Inventory, Requests, Pricing, Events, Staff
    ├── SalesAssociate/ Clienteling, Recommendations, Sell, Settings
    └── AfterSales/   Intake, Estimate, Repair, Return, Workload
```
**MVVM rule:** View = UI only (no logic); ViewModel = `@Observable` state + calls services; Service (in Core) = talks to Supabase/Vision/Core ML.

## 6. Data model (Supabase / Postgres — 25 tables)
Key entities and relationships:
- `app_user` (id→auth.users, name, email, **role**, **store_id**, is_active)
- `store` (locale, currency, timezone, manager_id, status) · `payment_terminal`
- `sku` · `price_band` (base + **floor** per currency) · `store_price` (local) · `inventory_item` (on_hand, reorder_threshold) · `serial_item`
- `client` · `appointment` · `orders` · `order_line_item` · `payment`
- `transfer_request` · `purchase_order`
- `event` · `invitation`
- `after_sales_ticket` · `condition_photo` · `estimate` · `qa_checklist` · `warranty`
- `notification` · `performance_metric` · `shift`

RLS: admin = full access; other roles scoped to `store_id`. Full DDL is in `supabase/schema.sql`. ER diagram in `.kiro/specs/retail-store-management/er-diagram.md`.

## 7. Backlog & sprints (Jira keys = TEAM5-xx)
- 77 user stories, ~242 story points, total capacity 693 hrs (Sprint 1: 189, Sprint 2: 283.5, Sprint 3: 220.5).
- **Sprint 1 (foundation):** auth/RBAC + project/Supabase setup, store onboarding, SKU + floor price, manager inventory dashboard + low-stock, stock-request intake & transfer approval. (~65 pts)
- **Sprint 2 (commerce):** clienteling, AI recommendations, QR sale + payments, transfer execution, events.
- **Sprint 3 (after-sales):** full AST lifecycle, analytics dashboard, localization.
- Full per-story detail (acceptance criteria, points, priority, sprint) in `.kiro/specs/retail-store-management/final-backlog-team5.csv`.

## 8. Conventions
- Branch: `feature/TEAM5-<id>-<slug>`; commit messages start with the Jira key.
- Single `main` branch (GitHub Flow); PRs into main; tag sprint releases (`v0.1.0`).
- No secrets in code (Supabase/Razorpay keys via git-ignored config).
- Each story's View/ViewModel is commented with the TEAM5 IDs it implements.

## 9. Non-functional requirements
Offline-resilient POS; zero memory leaks / zero Auto-Layout conflicts; encryption at rest; GDPR consent; accessibility (Dynamic Type, VoiceOver, WCAG AA contrast); multi-language.

---
*When asking for help, tell the assistant which TEAM5 story / role / file you're working on, and it can use this context to give precise, consistent answers.*
