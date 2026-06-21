# RSMS Sprint Plan

Capacity-based allocation of the 89-story backlog across 3 sprints.

**Capacity:** 840 hrs total — Sprint 1: 210 hrs · Sprint 2: 350 hrs · Sprint 3: 280 hrs
**Method:** ~2.5 hrs per story point (code + unit tests), with reserved overhead per sprint for setup, ceremonies, integration testing, profiling, and section-5 submissions (demo video, memory profile, flow diagram).

| Sprint | Theme | Stories | Points | Hours |
|--------|-------|---------|--------|-------|
| 1 | Foundation + Admin setup | 17 | 44 | 210 |
| 2 | Commerce + transfers + events | 44 | 128 | 350 |
| 3 | After-sales + NFR + submissions | 28 | 90 | 280 |
| **Total** | | **89** | **262** | **840** |

---

## Sprint 1 — Foundation, Auth & Admin Setup (210 hrs)

**Goal:** Stand up the architecture, role-based login, and the supply side so stores can be created, stocked, and priced.

| Epic | Story IDs | Pts |
|------|-----------|-----|
| Auth & RBAC | 22, 23, 24, 25, 86 | 14 |
| Store Onboarding | 15, 72, 73, 74, 75 | 13 |
| Product & Pricing | 19, 20 | 6 |
| Profiles | 13, 14, 26 | 5 |
| Inventory Base | 64, 82 | 6 |

**Capacity:** 100 hrs foundation (Xcode/MVVM scaffold, Supabase + SwiftData + sync, design system, RBAC) + 110 hrs story dev (44 x 2.5) = **210 hrs**

---

## Sprint 2 — Commerce Engine, Transfers & Events (350 hrs)

**Goal:** Build the revenue core (Sales Associate selling flow, AI, payments), cross-store transfers, manager events, and analytics.

| Epic | Story IDs | Pts |
|------|-----------|-----|
| Clienteling & Appointments | 55, 56, 57, 58, 59, 60 | 19 |
| AI Recommendations | 48, 51, 52, 53, 54, 83 | 20 |
| Sell, QR & Payments | 45, 46, 47, 49, 50, 84, 85 | 23 |
| Pricing & Stock Requests | 61, 62, 63, 65 | 10 |
| Product Launch Push | 79 | 5 |
| Inter-store Transfers | 1, 2, 3, 4, 5, 18, 80 | 18 |
| Events & Staff | 16, 17, 66, 67, 68, 69 | 15 |
| Analytics & Oversight | 21, 70, 71, 81 | 12 |
| After-Sales Workload Views | 6, 7, 10 | 6 |

**Capacity:** 320 hrs story dev (128 x 2.5) + 30 hrs overhead (ceremonies, integration testing) = **350 hrs**

---

## Sprint 3 — After-Sales Lifecycle, NFRs & Submissions (280 hrs)

**Goal:** Complete the service lifecycle, customer magic-link, non-functional requirements, and project deliverables.

| Epic | Story IDs | Pts |
|------|-----------|-----|
| AST Intake & Warranty | 11, 12, 38, 39, 40, 41, 42, 43, 44 | 26 |
| Estimate & Approval | 27, 28, 29, 30 | 11 |
| Repair & QA | 8, 35, 36, 37 | 11 |
| Return & Collection | 9, 31, 32, 33, 34 | 13 |
| Customer Magic-Link & Notifications | 76, 77, 78 | 11 |
| Non-Functional (Offline/GDPR/A11y) | 87, 88, 89 | 18 |

**Capacity:** 225 hrs story dev (90 x 2.5) + 55 hrs overhead (system/UAT testing, memory profiling, demo video + flow diagram + memory screenshot, bug-fix buffer) = **280 hrs**

---

## Sequencing rationale

- **Sprint 1** is point-light but hour-heavy: most of its 210 hrs go into one-time infrastructure (auth, DB, architecture) that unblocks everything else.
- **Sprint 2** is the peak (350 hrs) and carries the revenue-generating flow plus all cross-store operations.
- **Sprint 3** wraps the service lifecycle (which depends on sale/serial records produced in Sprint 2) and reserves real time for the memory profile, demo video, and flow diagram required in section 5.
- **Dependencies respected:** login/RBAC + data models (S1) -> selling + transfers (S2) -> after-sales (S3).
