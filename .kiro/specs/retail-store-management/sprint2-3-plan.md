# Sprint 2 & 3 Plan (re-planned from actual Sprint 1 completion)

## Where we are
- **Sprint 1 — DONE:** 21 stories, **67 pts** (~189 hrs). Velocity ≈ 2.82 hrs/pt — on track.
  - Completed the Admin foundation + all 4 role logins + revenue dashboard (10, 65) + client card (20).
  - Deferred to Sprint 2: TEAM5-15, 16, 18, 19, 74 (manager stock/pricing/staff).
- **Remaining:** 56 stories, **174 pts**, to fit Sprint 2 (283.5 hrs) + Sprint 3 (220.5 hrs) = 504 hrs.
- Velocity for remaining ≈ 504 / 174 = **2.9 hrs/point**. Proportional targets: **Sprint 2 ≈ 98 pts, Sprint 3 ≈ 76 pts**.

---

## SPRINT 2 — Commerce engine + Manager ops (28 stories, 97 pts ≈ 281 hrs)
Goal: complete the **revenue path** (sell + pay) and Manager day-to-day, building on Sprint 1's stores/SKUs/clients.

| Epic | Stories |
|------|---------|
| Clienteling & appointments | TEAM5-21, 22, 23, 24, 25 |
| AI recommendations | TEAM5-26, 27, 28, 29, 32 |
| Sell · QR · payments | TEAM5-30, 31, 33, 34, 35, 87 |
| Manager inventory & pricing | TEAM5-15, 16, 17, 18, 19 |
| Manager events | TEAM5-11, 12, 70, 71 |
| Admin transfer execution | TEAM5-84, 85, 86 |

**Sprint 2 demo:** an associate logs in → finds a client → AI recommends → scans QR → takes payment → order recorded; a manager sees low-stock, adjusts price within band, raises a request that the admin dispatches.

---

## SPRINT 3 — After-sales lifecycle + polish (28 stories, 77 pts ≈ 223 hrs)
Goal: the full service lifecycle + remaining manager staff + localization + submissions.

| Epic | Stories |
|------|---------|
| AST intake & warranty | TEAM5-40, 41, 42, 43, 44, 45, 46, 75, 76 |
| Estimate & approval | TEAM5-54, 55, 56, 57 |
| Repair & QA | TEAM5-47, 48, 49, 79 |
| Return & collection | TEAM5-50, 51, 52, 53 |
| Workload views | TEAM5-77, 80, 81 |
| Manager staff | TEAM5-13, 14, 74 |
| Accessibility / localization | TEAM5-89 |
| Submissions | demo video, memory profile, flow diagram |

**Sprint 3 demo:** a customer returns an item → specialist raises an AST → warranty check → estimate sent & approved → repair + QA → return + close.

---

## Capacity check
| Sprint | Stories | Points | Hours (×2.9) | Capacity | Diff |
|--------|---------|--------|--------------|----------|------|
| 2 | 28 | 97 | 281 | 283.5 | −2.5 |
| 3 | 28 | 77 | 223 | 220.5 | +2.5 |
| **Total** | **56** | **174** | **504** | **504** | — |

## Dependency check (no violations)
- Sprint 2 selling depends only on Sprint-1 done items (stores, SKUs+floor, client card, inventory dashboard).
- Transfer execution (84/85/86) depends on verify/approve (82/83) — both DONE in Sprint 1.
- Sprint 3 after-sales depends on sales/serial records produced in Sprint 2.
- Manager staff (13/14/74) depends on app_user (done). Localization (89) is cross-cutting.

## Notes
- Sprint 2 is the heaviest and most valuable — protect it; defer scope from here first if anything slips.
- Lowest-priority candidates to drop if needed: TEAM5-23 (video consult), 89 (localization), 13 (shift history).
