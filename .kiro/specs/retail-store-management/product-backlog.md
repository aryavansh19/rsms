# RSMS Product Backlog

Complete backlog for the Retail Store Management System (RSMS) iOS app, derived from `all_backogs.numbers`.

**Conventions**
- **Priority (MoSCoW):** `Must` = required for MVP · `Should` = important, near-term · `Could` = nice-to-have / later.
- **Points:** Fibonacci story points (1, 2, 3, 5, 8) reflecting relative effort + complexity.
- **Standardization applied:** "After-Sales Associate" → **After-Sales Specialist**; "Store Manager" → **Manager**.

Stories 1–75 are the original uploaded backlog (order preserved). Stories 76–89 are **new additions** (appended at the end) that close gaps found during analysis.

---

## 1. Admin

| ID | User Story | Acceptance Criteria | Priority | Points |
|----|-----------|---------------------|----------|--------|
| 1 | As an Admin, I want store managers to receive transfer status notifications so that they can prepare for incoming inventory. | • When a transfer changes state, the requesting Manager is notified.<br>• Notification includes SKU, qty, status, and ETA. | Should | 2 |
| 2 | As an Admin, I want to dispatch approved inventory transfers to stores so that requested products reach their destination. | • Only approved transfers can be dispatched.<br>• Dispatch decrements source and marks transfer "in transit". | Must | 3 |
| 3 | As an Admin, I want to create purchase orders when warehouse stock is insufficient so that required inventory can be replenished. | • PO can be raised when no store can fulfil a request.<br>• PO captures SKU, qty, supplier, expected date. | Should | 3 |
| 4 | As an Admin, I want to approve transfer requests when sufficient stock is available so that inventory can be dispatched to stores. | • Approve action available only if a source store has stock.<br>• Approval routes from the best-placed store. | Must | 3 |
| 5 | As an Admin, I want to verify warehouse stock availability for requested items so that I can decide whether inventory can be transferred immediately. | • System shows on-hand qty per location for the SKU.<br>• Flags shortfall if none available. | Must | 2 |
| 14 | As an Admin, I want to delete a Manager profile so that a resigned person is no longer in the database. | • Delete requires confirmation.<br>• Action is soft-delete + audit-logged (who/when).<br>• Removed manager cannot log in. | Should | 2 |
| 15 | As an Admin, I want to remove a store profile so that a non-operational store doesn't reflect in the database. | • Store can be deactivated/removed with confirmation.<br>• Historical records retained for reporting.<br>• Removed store hidden from active lists. | Should | 3 |
| 18 | As an Admin, I want to receive and review transfer requests raised by managers so that I can evaluate stock needs across the network. | • All pending requests listed with SKU, qty, urgency, store.<br>• Sortable by urgency. | Must | 2 |
| 19 | As an Admin, I want to set a minimum floor price per SKU per currency so that managers cannot discount below brand-protecting margins. | • Floor stored per SKU per currency.<br>• Floor enforced downstream on all local prices. | Must | 3 |
| 20 | As an Admin, I want to create a new SKU with product details and a launch date so that the product is catalogued and ready for distribution. | • SKU must be unique.<br>• Launch date cannot be in the past.<br>• Captures name, assets, description. | Must | 3 |
| 21 | As an Admin, I want to filter the revenue dashboard by country so that I can analyse performance across geographies. | • Filter recomputes figures for selected country/region.<br>• Empty selection shows all. | Should | 2 |
| 25 | As an Admin, I want to log in with my credentials so that I can access only the features and data relevant to my role. | • Passkey-based auth.<br>• Admin sees only Admin modules (RBAC).<br>• Invalid auth denied. | Must | 3 |
| 26 | As an Admin, I want the manager profile view to be read-only so that performance records cannot be altered. | • No edit controls on the manager profile view.<br>• Data is display-only. | Must | 1 |
| 70 | As an Admin, I want a cross-store revenue dashboard with monthly breakdowns so that I can monitor business performance at a glance. | • Shows daily/weekly/monthly actuals vs targets.<br>• Aggregates across all stores. | Must | 5 |
| 71 | As an Admin, I want to view each manager's currently assigned store so that I know who is responsible for which location. | • Lists managers with their current store.<br>• Searchable. | Should | 2 |
| 72 | As an Admin, I want to assign a manager when creating a store so that the store has operational ownership from day one. | • Store creation requires/accepts a manager assignment.<br>• Assigned manager linked to store. | Must | 2 |
| 73 | As an Admin, I want to configure payment terminals (Razorpay and card) for a new store so that it can accept payments from day one. | • Store config captures Razorpay + card terminal setup.<br>• Validated before go-live. | Must | 3 |
| 74 | As an Admin, I want to assign a locale, currency, and timezone to each store so that transactions, reports, and communications reflect local context. | • Locale, currency, timezone captured at creation.<br>• Applied to store transactions/reports. | Must | 2 |
| 75 | As an Admin, I want to create a new store profile with name, address, and contact details so that the store is registered and visible across the platform. | • Required fields validated.<br>• Created store appears in active store list. | Must | 3 |

## 2. Manager

| ID | User Story | Acceptance Criteria | Priority | Points |
|----|-----------|---------------------|----------|--------|
| 13 | As a Manager, I want to delete a Staff profile so that a resigned person is no longer in the database. | • Delete requires confirmation.<br>• Soft-delete + audit-logged.<br>• Removed staff cannot log in. | Should | 2 |
| 16 | As a Manager, I want to view event analytics and RSVP reports so that I can evaluate event performance. | • Report shows invites sent, RSVP breakdown, attendance.<br>• Exportable. | Could | 3 |
| 17 | As a Manager, I want to track RSVP responses (Accepted, Declined, Pending) so that I can estimate event attendance. | • Real-time RSVP status per invitee.<br>• Counts per status. | Should | 2 |
| 24 | As a Manager, I want to log in with my credentials so that I can access only the features and data relevant to my role. | • Passkey auth.<br>• Manager sees only Manager modules scoped to their store. | Must | 3 |
| 61 | As a Manager, I want to adjust the selling price within the Admin-defined band so that I can respond to local market conditions while complying with corporate policy. | • Editable only within band.<br>• Cannot exceed max or go below floor. | Must | 3 |
| 62 | As a Manager, I want the system to block saving a price below the Admin's floor so that I cannot breach pricing policy accidentally. | • Below-floor save rejected with minimum shown.<br>• No save persists. | Must | 2 |
| 63 | As a Manager, I want to monitor the approval status of my stock requests so that I know when inventory will be allocated/delivered. | • Each request shows status (pending/approved/routed/delivered).<br>• Updates in real time. | Should | 2 |
| 64 | As a Manager, I want low-stock items flagged automatically for reorder so that I can act before stock runs out. | • SKU below threshold auto-flagged.<br>• Visible on dashboard. | Must | 3 |
| 65 | As a Manager, I want to raise stock requests with SKU, quantity, and urgency so that Admin can replenish via transfer or warehouse before stockout. | • Request captures SKU, qty, urgency.<br>• Submitted to Admin queue. | Must | 3 |
| 66 | As a Manager, I want to view associate performance metrics (units sold, upsell rate, CSAT) so that I can evaluate employee performance. | • Per-associate metrics displayed.<br>• Date-range filterable. | Should | 3 |
| 67 | As a Manager, I want to review shift histories so that I can monitor employee attendance. | • Shift history per associate.<br>• Shows dates/hours. | Could | 2 |
| 68 | As a Manager, I want to send digital invitations so that customers can be notified about events. | • Invites sent via digital channel.<br>• Linked to the event. | Should | 2 |
| 69 | As a Manager, I want to create a VIP or launch event with name, date, time, venue, and description so that the event is formally scheduled. | • Required fields validated.<br>• Optionally linked to an Admin product launch. | Should | 3 |

## 3. Sales Associate

| ID | User Story | Acceptance Criteria | Priority | Points |
|----|-----------|---------------------|----------|--------|
| 23 | As a Sales Associate, I want to log in with my credentials so that I can access only the features and data relevant to my role. | • Passkey auth.<br>• Associate sees only Sales modules scoped to store. | Must | 3 |
| 45 | As a Sales Associate, I want to route a completed order as store sale, BOPIS, or ship-from-warehouse so that the correct fulfilment is triggered. | • Order-type selection triggers correct flow.<br>• Each path produces correct downstream action. | Must | 3 |
| 46 | As a Sales Associate, I want to process payments via card terminal (tap/swipe) so that clients can pay by card. | • Card terminal integration completes payment.<br>• Result recorded on order. | Must | 3 |
| 47 | As a Sales Associate, I want to take payment via Razorpay and issue a digital receipt so that checkout is fast and compliant. | • Razorpay (UPI/netbanking/wallet) supported.<br>• Digital receipt sent to client. | Must | 5 |
| 48 | As a Sales Associate, I want alternative product suggestions when the desired item is unavailable so that I don't lose the sale. | • Out-of-stock triggers AI alternatives.<br>• Associate can present or dismiss. | Should | 3 |
| 49 | As a Sales Associate, I want to scan a product QR at point of sale so that purchase history and inventory update simultaneously in one action. | • Single scan updates both atomically.<br>• Failure rolls back both. | Must | 5 |
| 50 | As a Sales Associate, I want to check inventory availability (in-store, warehouse, nearby stores) before presenting a product so that I don't recommend out-of-stock items. | • Availability shown across the three sources.<br>• Real-time. | Must | 3 |
| 51 | As a Sales Associate, I want higher-value alternatives surfaced at the cart stage so that I can offer upsell options matching the client's taste. | • Upsell suggestions appear at cart.<br>• Associate selects which to add. | Should | 3 |
| 52 | As a Sales Associate, I want complementary products surfaced at the cart stage so that I can suggest cross-sell options. | • Cross-sell suggestions appear at cart.<br>• Associate selects which to add. | Should | 3 |
| 53 | As a Sales Associate, I want trending/similar suggestions for new clients with no history so that I can still offer relevant options. | • New client triggers trending/similar model.<br>• Relevant items displayed. | Should | 3 |
| 54 | As a Sales Associate, I want recommendations based on a client's purchase patterns so that I have data-driven suggestions. | • Recommendations derived from client history.<br>• Displayed for review. | Should | 5 |
| 55 | As a Sales Associate, I want to create ship-from-warehouse orders for remote selling so that out-of-store products can ship directly to the client. | • Order created against warehouse stock.<br>• Shipping details captured. | Should | 3 |
| 56 | As a Sales Associate, I want to manage BOPIS pickup alerts so that I can prepare the order and notify the client when ready. | • Alert on BOPIS order.<br>• Client notified when ready. | Should | 3 |
| 57 | As a Sales Associate, I want to conduct a video consultation and share curated cart links so that clients can shop remotely. | • Video consult supported.<br>• Shareable curated cart link generated. | Could | 5 |
| 58 | As a Sales Associate, I want to book an in-store or video appointment so that I can provide a scheduled, personalised consultation. | • Booking supports both types.<br>• Reminders scheduled. | Should | 3 |
| 59 | As a Sales Associate, I want to search an existing client in the CRM by name or phone so that I can quickly pull up their profile. | • Search by name/phone returns matches.<br>• Opens profile. | Must | 2 |
| 60 | As a Sales Associate, I want to create a new client card with consented basic details so that I can build a personalised experience. | • Captures name, phone, style prefs.<br>• Persisted only if consent granted. | Must | 3 |

## 4. After-Sales Specialist

| ID | User Story | Acceptance Criteria | Priority | Points |
|----|-----------|---------------------|----------|--------|
| 6 | As an After-Sales Specialist, I want to view all active service requests so that I can monitor ongoing repair workloads. | • Lists all active ASTs.<br>• Shows stage and assignee. | Should | 2 |
| 7 | As an After-Sales Specialist, I want to filter repair requests by status so that I can quickly locate specific cases. | • Filter by stage/status.<br>• Results update immediately. | Should | 2 |
| 8 | As an After-Sales Specialist, I want to generate invoices for completed repairs so that customers receive a detailed breakdown. | • Invoice itemizes parts + labour.<br>• Generated only for completed paid repairs. | Should | 3 |
| 9 | As an After-Sales Specialist, I want to schedule customer pickups so that completed items are returned in an organized manner. | • Pickup scheduled with date/method.<br>• (Consolidate with #34.) | Should | 2 |
| 10 | As an After-Sales Specialist, I want to view pending customer approvals so that I can follow up on delayed responses. | • Lists ASTs awaiting client approval.<br>• Shows age of request. | Should | 2 |
| 11 | As an After-Sales Specialist, I want to view a product's service history so that I understand previous repairs before creating a new request. | • History by serial number.<br>• Shows prior ASTs/outcomes. | Should | 3 |
| 12 | As an After-Sales Specialist, I want to verify a product's authenticity so that counterfeit items are not accepted for service. | • Authenticity check by serial/certificate.<br>• Flags suspected counterfeit. | Should | 5 |
| 22 | As an After-Sales Specialist, I want to log in with my credentials so that I can access only the features and data relevant to my role. | • Passkey auth.<br>• After-Sales modules only (RBAC). | Must | 3 |
| 27 | As an After-Sales Specialist, I want declined repairs to skip the repair workflow and go directly to return/pickup so that the client retrieves their item without delay. | • Declined estimate routes straight to collection.<br>• No repair stage entered. | Must | 2 |
| 28 | As an After-Sales Specialist, I want repair to proceed only after client approval so that we avoid disputes over unauthorised work. | • Repair blocked beyond intake until approval.<br>• Approval recorded. | Must | 3 |
| 29 | As an After-Sales Specialist, I want to send the cost estimate to the client digitally for approval/decline so that no work begins without consent. | • Estimate sent via secure digital link.<br>• Client decision recorded. | Must | 3 |
| 30 | As an After-Sales Specialist, I want an itemised cost estimate (parts + labour + timeline) so that the client knows exactly the cost and duration. | • Estimate itemizes parts, labour, timeline.<br>• Total computed. | Must | 3 |
| 31 | As an After-Sales Specialist, I want to scan a final packaging QR before release so that inventory updates and the AST closes accurately. | • Packaging QR scan required before release.<br>• Closes AST + syncs inventory. | Should | 3 |
| 32 | As an After-Sales Specialist, I want the client to digitally sign off on collection so that we have proof of delivery and can close the ticket. | • Digital signature captured at handover.<br>• Stored against the AST. | Should | 3 |
| 33 | As an After-Sales Specialist, I want to generate return documentation so that there is a formal record of the handover. | • Return doc generated with item + service details.<br>• Attached to AST. | Should | 2 |
| 34 | As an After-Sales Specialist, I want to schedule a store pickup or courier so that the client can collect or receive their product. | • Pickup or courier selectable.<br>• Scheduling captured. (Consolidate with #9.) | Should | 3 |
| 35 | As an After-Sales Specialist, I want to send items back to repair if they fail QA so that issues are resolved before the client receives the product. | • Failed QA returns item to repair stage.<br>• Reason logged. | Must | 2 |
| 36 | As an After-Sales Specialist, I want a mandatory QA checklist before marking a repair done so that no item is returned without quality verification. | • Repair cannot be Completed unless checklist fully done. | Must | 3 |
| 37 | As an After-Sales Specialist, I want to track a repair through defined stages so that progress is transparent and auditable. | • Stages Received → In Repair → QA → Completed.<br>• Transitions timestamped. | Must | 3 |
| 38 | As an After-Sales Specialist, I want out-of-warranty/voided coverage flagged clearly so that the client is informed upfront about costs. | • Coverage status shown prominently.<br>• Paid-repair flag set. | Must | 2 |
| 39 | As an After-Sales Specialist, I want to validate whether the warranty is active so that I can flag warranty (free) vs paid repair. | • Serial lookup returns warranty status.<br>• Determines free/paid path. | Must | 3 |
| 40 | As an After-Sales Specialist, I want to create an AST tagged with the correct service type (exchange, return, repair, warranty) so that it follows the right workflow. | • Service type required.<br>• Drives downstream workflow. | Must | 3 |
| 41 | As an After-Sales Specialist, I want to capture condition photos and a diagnostic report at intake so that the item's state is documented before work. | • Photos + diagnostics captured in-app.<br>• Stored with AST. | Must | 3 |
| 42 | As an After-Sales Specialist, I want to pull the client's purchase history linked to the product so that I have full context on the original transaction. | • Purchase record linked via serial.<br>• Displayed at intake. | Should | 2 |
| 43 | As an After-Sales Specialist, I want to manually enter product details if the QR scan fails so that I can still create a ticket for damaged labels. | • Manual entry path available.<br>• AST created normally. | Should | 2 |
| 44 | As an After-Sales Specialist, I want to scan a product's QR code to look up the item so that I can quickly identify it and pull records. | • QR scan resolves SKU/serial.<br>• Pulls item records. | Must | 3 |

---

## New Additions (gap closure)

> Appended after the original backlog. Introduces a **Customer** actor for magic-link interactions and adds cross-cutting/NFR stories.

| ID | Role | User Story | Acceptance Criteria | Priority | Points |
|----|------|-----------|---------------------|----------|--------|
| 76 | After-Sales | As a Customer, I want automated notifications at every service milestone (Received, Estimated, Approved, In Repair, Ready, Dispatched) so that I stay informed without contacting the store. | • Push/SMS sent at each milestone.<br>• Message references the AST. | Must | 3 |
| 77 | Customer | As a Customer, I want to approve or decline a repair estimate via a secure link without creating an account so that I can authorise work quickly and safely. | • Tokenized, single-use, time-limited link.<br>• Approve/decline recorded against AST.<br>• Expired/used link rejected. | Must | 5 |
| 78 | Customer | As a Customer, I want to digitally sign off on collection via a secure link so that handover is confirmed remotely. | • Link scoped to collection action.<br>• Signature stored; link invalidated after use. | Should | 3 |
| 79 | Admin | As an Admin, I want to upload product assets and push them with pricing to all target stores simultaneously on launch so that the product goes live everywhere at once. | • Assets + pricing pushed to selected stores in one action.<br>• All target stores reflect launch. | Must | 5 |
| 80 | Admin | As an Admin, I want a global stock map of on-hand quantities per SKU across all stores so that I can route transfers from the best-placed store. | • Map/list shows per-store on-hand per SKU.<br>• Supports transfer routing. | Should | 3 |
| 81 | Admin | As an Admin, I want to view each manager's performance history across locations so that I can make informed reassignment decisions. | • Read-only history spanning prior stores.<br>• Shows KPIs per location. | Should | 3 |
| 82 | Manager | As a Manager, I want to search and view real-time on-hand stock per SKU in my store so that I know exactly what's available before promising it. | • Search/scan SKU shows live on-hand.<br>• Reflects latest scans/sales. | Must | 3 |
| 83 | Sales Associate | As a Sales Associate, I want to review, reorder, and curate AI recommendations before presenting them so that human judgment stays in control. | • Accept/remove/reorder before presenting.<br>• Only curated set shown to client. | Should | 3 |
| 84 | Sales Associate | As a Sales Associate, I want a declined/cancelled payment to preserve the cart without changing inventory so that I can retry without data loss. | • On decline, cart intact.<br>• Inventory not decremented. | Must | 2 |
| 85 | Sales Associate | As a Sales Associate, I want to verify a client's digital receipt at BOPIS pickup so that only the correct person collects the reserved item. | • Receipt validated against reservation.<br>• Mismatch blocks handover. | Should | 2 |
| 86 | All | As any user, I want the app to lock after inactivity and let me sign out so that store devices stay secure. | • Idle timeout locks app, requires re-auth.<br>• Explicit sign-out clears session. | Must | 2 |
| 87 | Sales Associate | As a Sales Associate, I want POS checkout to work offline and sync when reconnected so that I can sell during network outages. | • Sales recorded offline.<br>• Sync on reconnect with conflict handling. | Should | 8 |
| 88 | Customer | As a Customer, I want to manage my consent and request data deletion so that my privacy rights are respected (GDPR). | • Consent capture/withdrawal.<br>• Data export/deletion supported. | Should | 5 |
| 89 | All | As any user, I want full accessibility (Dynamic Type, VoiceOver, sufficient contrast) so that the app is usable by everyone. | • Dynamic Type across screens.<br>• VoiceOver labels.<br>• WCAG AA contrast. | Should | 5 |

---

## Summary

| Metric | Value |
|--------|-------|
| Original stories | 75 |
| New added stories | 14 |
| **Total** | **89** |
| Must | 41 |
| Should | 39 |
| Could | 9 |
| Total story points | ~270 |
