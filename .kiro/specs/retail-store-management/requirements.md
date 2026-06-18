# Requirements Document

## Introduction

The Retail Store Management System (RSMS) is a configurable iOS application (iPhone/iPad, iOS 26+) for a multi-country luxury goods retail chain (jewelry, watches, leather goods, couture). It unifies global store administration, store operations, clienteling and selling, omnichannel fulfilment, and after-sales service into a single role-based application while preserving a high-touch luxury experience and meeting data-privacy and payment-compliance obligations.

The system supports **four user roles** with role-based access control (RBAC):

1. **Admin** (Corporate / Retail Ops) — global governance: stores, products, pricing, transfers, cross-store revenue.
2. **Manager** (Boutique Manager) — store operations: events, staff, local inventory, banded pricing, stock requests.
3. **Sales Associate** (Client Advisor) — clienteling, selling, QR-based inventory updates, AI recommendations, payments.
4. **After-Sales Specialist** — after-sales tickets, warranty, estimates/approvals, repair tracking, client communication.

Customers are not a logged-in role. Where the after-sales flow requires customer action (approving a repair estimate, signing off on collection), the system reaches the customer through a **secure, tokenized magic link** delivered by SMS/email that opens a lightweight web view — no customer account or app install is required.

Key platform decisions:
- **QR-code scanning** (not RFID) for all item-level operations, using the Vision framework.
- **Razorpay** (UPI/netbanking/wallets) plus a physical **card terminal** (tap/swipe) for payments, with digital receipts.
- **SwiftUI + MVVM + Swift Concurrency**, **Passkeys** authentication, **Core ML** for AI recommendations.
- **Customer interaction** via secure magic link (tokenized, time-limited, single-use) for estimate approval and collection sign-off only.

---

## Requirements

### Requirement 1: Authentication & Role-Based Access Control

**User Story:** As any user, I want to securely sign in and see only the features for my role, so that access is appropriately restricted and the experience is focused.

#### Acceptance Criteria

1. WHEN a user opens the app without an active session THEN the system SHALL present a Passkey-based sign-in screen.
2. WHEN a user authenticates successfully THEN the system SHALL load the role assigned to that user and route to the corresponding role home screen.
3. IF a user attempts to access a feature not permitted for their role THEN the system SHALL deny access and SHALL NOT render the feature's navigation entry.
4. WHEN a user session is idle beyond the configured timeout THEN the system SHALL lock the app and require re-authentication.
5. WHEN a user signs out THEN the system SHALL clear in-memory session state and return to the sign-in screen.

---

### Requirement 2: Admin — Store Onboarding & Manager Oversight

**User Story:** As an Admin, I want to onboard new stores and review manager performance across locations, so that I can stand up boutiques and make staffing decisions.

#### Acceptance Criteria

1. WHEN an Admin creates a new store THEN the system SHALL capture store profile, locale, currency, timezone, payment terminals, and an initial assigned Manager.
2. IF any required store onboarding field is missing THEN the system SHALL block creation and SHALL indicate the missing fields.
3. WHEN an Admin opens Manager profiles THEN the system SHALL display each Manager's current store and cross-location performance history as read-only reference.
4. WHEN an Admin views the cross-store revenue dashboard THEN the system SHALL display daily, weekly, and monthly revenue actuals versus targets.
5. WHEN an Admin applies a region or country filter to the revenue dashboard THEN the system SHALL recompute and display only the matching stores' figures.

---

### Requirement 3: Admin — Product Launch & Global Pricing

**User Story:** As an Admin, I want to launch products globally and set price floors, so that assortment and pricing are controlled centrally.

#### Acceptance Criteria

1. WHEN an Admin creates a new product THEN the system SHALL capture a unique SKU, launch date, target stores, product assets, and pricing.
2. WHEN an Admin confirms a product launch THEN the system SHALL push assets and pricing to all selected target stores simultaneously.
3. WHEN an Admin sets pricing for a SKU THEN the system SHALL store a base price and a minimum floor price per currency.
4. IF a launch date is in the past THEN the system SHALL reject the launch configuration and SHALL prompt for a valid date.
5. WHEN a SKU already exists with the same identifier THEN the system SHALL prevent creating a duplicate SKU.

---

### Requirement 4: Admin — Inter-Store Stock Transfers

**User Story:** As an Admin, I want to review and route inter-store transfer requests, so that stock is balanced across the network from the best-placed store.

#### Acceptance Criteria

1. WHEN a Manager submits a transfer/stock request THEN the system SHALL add it to the Admin's transfer request queue with SKU, quantity, and urgency.
2. WHEN an Admin opens the global stock map THEN the system SHALL display on-hand quantities per SKU across all stores.
3. WHEN an Admin approves a transfer request THEN the system SHALL route fulfilment from a source store and SHALL decrement source and increment destination on-hand counts on completion.
4. IF no store has sufficient stock to fulfil a request THEN the system SHALL flag the request as unfulfillable by transfer and SHALL allow resolution via new stock.
5. WHEN a transfer request changes state THEN the system SHALL notify the requesting Manager of the new status.

---

### Requirement 5: Manager — Events & Staff Performance

**User Story:** As a Manager, I want to run VIP/launch events and review my associates' performance, so that I can drive store engagement and coach staff.

#### Acceptance Criteria

1. WHEN a Manager creates an event THEN the system SHALL capture schedule and SHALL allow linking the event to an Admin-pushed product launch.
2. WHEN a Manager sends event invitations THEN the system SHALL deliver digital invitations and SHALL track RSVP statuses in real time.
3. WHEN a Manager opens an associate's profile THEN the system SHALL display shift history, units sold, upsell rate, and client satisfaction scores.
4. WHEN performance data updates for an associate THEN the system SHALL reflect the updated metrics in the Manager's performance report.

---

### Requirement 6: Manager — Inventory & Banded Pricing

**User Story:** As a Manager, I want to monitor local stock, request replenishment, and adjust local prices within allowed bands, so that the store stays stocked and locally competitive without violating corporate pricing.

#### Acceptance Criteria

1. WHEN a Manager opens inventory lookup THEN the system SHALL display real-time on-hand stock per SKU for that store.
2. WHEN on-hand stock for a SKU falls below its reorder threshold THEN the system SHALL flag the SKU as low-stock.
3. WHEN a Manager raises a product request THEN the system SHALL submit the SKU, quantity needed, and urgency to the Admin transfer queue.
4. WHEN a Manager sets a local displayed price for a SKU THEN the system SHALL accept the price only if it is greater than or equal to the Admin-defined floor for that currency.
5. IF a Manager attempts to set a local price below the Admin floor THEN the system SHALL reject the change and SHALL display the minimum allowed price.

---

### Requirement 7: Sales Associate — Clienteling & Appointments

**User Story:** As a Sales Associate, I want to maintain client profiles and manage appointments and BOPIS, so that I can deliver personalized service across channels.

#### Acceptance Criteria

1. WHEN an Associate creates or edits a client profile THEN the system SHALL capture name, phone, style preferences, and purchase history.
2. IF a client has not consented to data storage THEN the system SHALL NOT persist the client's personal details.
3. WHEN an Associate books an appointment THEN the system SHALL support in-store and video consultation types and SHALL schedule reminders.
4. WHEN a BOPIS order is ready for pickup THEN the system SHALL alert the assigned Associate.
5. WHEN an Associate shares a curated cart THEN the system SHALL generate a shareable cart link tied to the client.

---

### Requirement 8: Sales Associate — AI Recommendations & Upsell

**User Story:** As a Sales Associate, I want AI-assisted recommendations and upsell suggestions that I can curate, so that I can present relevant products while keeping human judgment in control.

#### Acceptance Criteria

1. WHEN an Associate opens recommendations for a client THEN the system SHALL suggest products derived from the client's purchase patterns.
2. WHEN recommendations are generated THEN the system SHALL allow the Associate to accept, remove, or reorder items before presenting them.
3. WHEN a cart reaches checkout stage THEN the system SHALL surface complementary or higher-value upsell/cross-sell alternatives.
4. WHEN an Associate selects an upsell suggestion THEN the system SHALL add it to the cart and SHALL leave non-selected suggestions out.

---

### Requirement 9: Sales Associate — QR Scan & Atomic Update

**User Story:** As a Sales Associate, I want a single QR scan to update both inventory and client purchase history, so that records stay consistent with one action.

#### Acceptance Criteria

1. WHEN an Associate scans a product QR code THEN the system SHALL identify the SKU and serial from the code.
2. WHEN a scan completes for a sale THEN the system SHALL decrement store inventory and append to the client's purchase history within a single atomic transaction.
3. IF either the inventory update or the client history update fails THEN the system SHALL roll back both updates and SHALL report the failure.
4. IF a scanned QR code does not match a known SKU THEN the system SHALL reject the scan and SHALL prompt to rescan.

---

### Requirement 10: Sales Associate — Payments & Receipts

**User Story:** As a Sales Associate, I want to take payment via Razorpay or card terminal and issue a digital receipt, so that checkout is fast and compliant.

#### Acceptance Criteria

1. WHEN an Associate initiates payment THEN the system SHALL offer Razorpay (UPI/netbanking/wallets) and card terminal (tap/swipe) options.
2. WHEN a payment is authorized THEN the system SHALL record the order with line items, SKUs, serials, and the payment method.
3. WHEN a payment is completed THEN the system SHALL issue a digital receipt to the client.
4. IF a payment is declined or cancelled THEN the system SHALL keep the cart intact and SHALL NOT decrement inventory.
5. WHEN a sale's effective price is applied THEN the system SHALL use the store's local price, which SHALL never be below the Admin floor.

---

### Requirement 11: After-Sales — Tickets & Warranty

**User Story:** As an After-Sales Specialist, I want to raise after-sales tickets and verify warranty, so that service intake is accurate and coverage is correctly applied.

#### Acceptance Criteria

1. WHEN a Specialist raises an after-sales ticket (AST) THEN the system SHALL require a service type of exchange, return, repair, or warranty.
2. WHEN an AST is created THEN the system SHALL allow capturing condition photos in-app at intake.
3. WHEN a Specialist performs warranty verification THEN the system SHALL look up the purchase record by serial number and SHALL indicate active, out-of-warranty, or voided coverage.
4. IF no purchase record matches the serial number THEN the system SHALL flag the item as unverifiable and SHALL require manual review.

---

### Requirement 12: After-Sales — Estimates, Repair Workflow & Communication

**User Story:** As an After-Sales Specialist, I want estimate approval gating, staged repair tracking, and automated client communication, so that no work starts without consent and clients stay informed.

#### Acceptance Criteria

1. WHEN a Specialist creates an estimate THEN the system SHALL itemize parts, labour, and timeline and SHALL send it to the client digitally for approval or decline.
2. IF the client has not approved the estimate THEN the system SHALL block the repair from advancing beyond the Received stage.
3. WHEN a repair progresses THEN the system SHALL track stages Received, In Repair, QA Check, and Completed in order.
4. WHEN a Specialist attempts to mark a repair Completed THEN the system SHALL require the QA checklist to be fully completed first.
5. WHEN a return is approved THEN the system SHALL schedule boutique pickup or courier, generate return documentation, and capture a digital client sign-off on collection.
6. WHEN an AST reaches a milestone (Received, Estimated, Approved, In Repair, Ready, Dispatched) THEN the system SHALL send an automated push or SMS notification to the client.

---

### Requirement 13: Non-Functional — Performance, Reliability & Memory

**User Story:** As a stakeholder, I want the app to be fast, reliable, and leak-free, so that it performs well in boutiques under real conditions.

#### Acceptance Criteria

1. WHEN the app loads a primary screen THEN the system SHALL remain responsive on slow network connections by showing cached or skeleton states.
2. WHEN the app runs typical workflows THEN the system SHALL exhibit zero memory leaks and zero Auto Layout constraint conflicts.
3. WHEN a network operation fails THEN the system SHALL recover gracefully and SHALL preserve data consistency.
4. WHEN inventory or payment writes occur concurrently THEN the system SHALL serialize them to prevent inconsistent state.

---

### Requirement 14: Non-Functional — Security, Privacy & Accessibility

**User Story:** As a stakeholder, I want strong security, privacy compliance, and accessibility, so that the app protects users and is usable by the widest range of people.

#### Acceptance Criteria

1. WHEN sensitive data is stored THEN the system SHALL encrypt it at rest and SHALL restrict access by role.
2. WHEN client personal data is handled THEN the system SHALL comply with applicable data-privacy regulations and SHALL honor consent settings.
3. WHEN any screen is presented THEN the system SHALL support Dynamic Type, VoiceOver labels, and sufficient color contrast.
4. WHEN authentication occurs THEN the system SHALL use Passkeys and SHALL support a secondary factor where configured.


---

### Requirement 15: Customer Interaction via Secure Magic Link

**User Story:** As a customer, I want to approve a repair estimate and confirm collection from a secure link sent to me, so that I can act on my after-sales ticket without creating an account or installing an app.

#### Acceptance Criteria

1. WHEN an After-Sales Specialist sends an estimate or requests collection sign-off THEN the system SHALL generate a unique, tokenized magic link tied to that specific after-sales ticket and action.
2. WHEN the system generates a magic link THEN the system SHALL deliver it to the customer via the consented channel (SMS or email).
3. WHEN a customer opens a valid magic link THEN the system SHALL present a lightweight web view scoped only to the relevant ticket, without requiring a customer account, password, or app installation.
4. WHEN a customer opens an estimate magic link THEN the system SHALL display the itemized estimate (parts, labour, timeline) and SHALL allow the customer to approve or decline.
5. WHEN a customer approves or declines an estimate via the link THEN the system SHALL record the decision against the ticket and SHALL reflect it to the After-Sales Specialist.
6. WHEN a customer opens a collection sign-off magic link THEN the system SHALL allow the customer to confirm receipt with a digital sign-off.
7. IF a magic link is expired, already used, or invalid THEN the system SHALL deny access and SHALL display a clear message instructing the customer to request a new link.
8. WHEN a magic link action is completed THEN the system SHALL invalidate the link so it cannot be reused.
9. WHEN a magic link is generated THEN the system SHALL set a configurable expiry (single-use, time-limited) and SHALL NOT expose any data beyond the scope of that ticket and action.
