# Implementation Plan

This plan converts the design into incremental, test-backed coding tasks. Each task references the requirements it satisfies. Tasks are ordered so that foundations land first and each role module builds on the shared core. Only coding/test/wiring activities are included.

---

## Phase 1 — Foundation & Shared Core

- [ ] 1. Set up the Xcode project and module skeleton
  - Create the SwiftUI app target (iOS 26+, iPhone + iPad) and the folder structure: `App/`, `Core/`, `Features/`, `Services/`, `Resources/`.
  - Add a lightweight DI container and a `RootRouter` placeholder.
  - _Requirements: 1_

- [ ] 2. Implement shared domain models
  - Define `Store`, `SKU`, `PriceBand`, `InventoryItem`, `Client`, `Order`, `LineItem`, `TransferRequest`, `AfterSalesTicket`, and supporting enums (`UserRole`, `Urgency`, `TransferStatus`, `ASTType`, `RepairStage`, `WarrantyStatus`).
  - Add unit tests for `Codable` round-trips.
  - _Requirements: 2, 3, 4, 6, 7, 10, 11, 12_

- [ ] 3. Build persistence and networking layer
  - [ ] 3.1 Implement the SwiftData stack with encryption at rest and a Keychain wrapper for secrets/tokens.
    - _Requirements: 14.1_
  - [ ] 3.2 Implement a protocol-based API client with retry/backoff and typed errors.
    - _Requirements: 13.3_
  - [ ] 3.3 Implement the offline Sync engine (write queue + conflict resolution) and cached-read support.
    - _Requirements: 13.1, 13.3_

- [ ] 4. Implement authentication and RBAC
  - [ ] 4.1 Implement `AuthService` with Passkey sign-in (`ASAuthorization`), `Session` creation, and sign-out.
    - _Requirements: 1.1, 1.2, 1.5, 14.4_
  - [ ] 4.2 Implement `AccessPolicy` and wire `RootRouter` to mount only the permitted role shell; enforce policy in repositories.
    - _Requirements: 1.2, 1.3_
  - [ ] 4.3 Implement idle-timeout session monitor that locks the UI and requires re-auth.
    - _Requirements: 1.4_
  - [ ] 4.4 Write unit tests for role gating and session expiry.
    - _Requirements: 1.3, 1.4_

- [ ] 5. Build the shared Design System and accessibility baseline
  - Create reusable components (buttons, cards, list rows, status pills) with Dynamic Type, VoiceOver labels, and WCAG AA contrast; status never conveyed by color alone.
  - _Requirements: 14.3_

---

## Phase 2 — Cross-Cutting Services

- [ ] 6. Implement PricingService with floor enforcement
  - [ ] 6.1 Implement `setFloor`, `setLocalPrice` (validates `>= floor`, throws `belowFloor` with minimum), and `effectivePrice`.
    - _Requirements: 3.3, 6.4, 6.5, 10.5_
  - [ ] 6.2 Write unit tests covering floor rejection and effective-price resolution.
    - _Requirements: 6.5, 10.5_

- [ ] 7. Implement InventoryService as an actor with atomic scan
  - [ ] 7.1 Implement `scan(qr:)` to decode SKU + serial; reject unknown SKUs.
    - _Requirements: 9.1, 9.4_
  - [ ] 7.2 Implement `commitSale` performing inventory decrement + client history append in one transaction with rollback on failure.
    - _Requirements: 9.2, 9.3_
  - [ ] 7.3 Write concurrency tests asserting serialized writes and rollback behavior.
    - _Requirements: 9.3, 13.4_

- [ ] 8. Implement the Vision-based QR scanner service
  - Wrap `VNDetectBarcodesRequest` with a camera capture view; emit decoded payloads with audio/haptic confirmation and a VoiceOver-friendly scanner.
  - _Requirements: 9.1, 14.3_

- [ ] 9. Implement PaymentService (Razorpay + card terminal)
  - [ ] 9.1 Integrate Razorpay (UPI/netbanking/wallets) and card terminal (tap/swipe); return typed `PaymentResult`.
    - _Requirements: 10.1, 10.2_
  - [ ] 9.2 Implement digital receipt issuance to the client.
    - _Requirements: 10.3_
  - [ ] 9.3 Ensure declined/cancelled payments preserve the cart and do not mutate inventory.
    - _Requirements: 10.4_

- [ ] 10. Implement RecommendationService with Core ML
  - Load the Core ML model; implement `recommendations(for:)` and `upsell(for:)` returning proposals (curation handled in the ViewModel).
  - _Requirements: 8.1, 8.3_

- [ ] 11. Implement NotificationService
  - Implement push (APNs) and SMS dispatch for milestone events used by After-Sales.
  - _Requirements: 12.6_

---

## Phase 3 — Admin Module

- [ ] 12. Store onboarding and manager oversight
  - [ ] 12.1 Build store onboarding view + ViewModel capturing profile, locale, currency, timezone, terminals, initial Manager; block on missing fields.
    - _Requirements: 2.1, 2.2_
  - [ ] 12.2 Build read-only Manager profiles screen (current store + cross-location performance history).
    - _Requirements: 2.3_

- [ ] 13. Cross-store revenue dashboard
  - Build the dashboard showing daily/weekly/monthly actuals vs targets with region/country filtering.
  - _Requirements: 2.4, 2.5_

- [ ] 14. Product launch and global pricing
  - [ ] 14.1 Build SKU creation with launch date, target stores, assets, and per-currency pricing; reject duplicate SKUs and past launch dates.
    - _Requirements: 3.1, 3.4, 3.5_
  - [ ] 14.2 Implement simultaneous push of assets and pricing to target stores.
    - _Requirements: 3.2_

- [ ] 15. Inter-store transfers
  - [ ] 15.1 Build the transfer request queue and global stock map view.
    - _Requirements: 4.1, 4.2_
  - [ ] 15.2 Implement approve + route logic that moves stock on completion and flags unfulfillable requests.
    - _Requirements: 4.3, 4.4_
  - [ ] 15.3 Notify the requesting Manager on status changes.
    - _Requirements: 4.5_

---

## Phase 4 — Manager Module

- [ ] 16. Events and staff performance
  - [ ] 16.1 Build event creation with scheduling and linkage to Admin product launches; digital invitations + real-time RSVP tracking.
    - _Requirements: 5.1, 5.2_
  - [ ] 16.2 Build associate profile + performance report (shift history, units sold, upsell rate, CSAT).
    - _Requirements: 5.3, 5.4_

- [ ] 17. Inventory lookup and stock requests
  - [ ] 17.1 Build real-time inventory lookup per SKU with low-stock flagging.
    - _Requirements: 6.1, 6.2_
  - [ ] 17.2 Build stock-request submission (SKU, quantity, urgency) into the Admin transfer queue.
    - _Requirements: 6.3_

- [ ] 18. Store-wise banded pricing UI
  - Build local price editing that calls `PricingService.setLocalPrice`, showing the minimum allowed and rejecting below-floor values.
  - _Requirements: 6.4, 6.5_

---

## Phase 5 — Sales Associate Module

- [ ] 19. Client profiles with consent gating
  - Build client profile create/edit (name, phone, style preferences, purchase history); skip persistence of personal details when consent is not granted.
  - _Requirements: 7.1, 7.2_

- [ ] 20. Appointments, remote selling, and BOPIS
  - [ ] 20.1 Build appointment booking (in-store + video) with reminders.
    - _Requirements: 7.3_
  - [ ] 20.2 Build BOPIS pickup alerts and curated cart link sharing.
    - _Requirements: 7.4, 7.5_

- [ ] 21. AI recommendations and upsell (curation)
  - Build the recommendations view that consumes `RecommendationService` proposals and lets the Associate accept/remove/reorder before presenting; surface upsell/cross-sell at cart stage.
  - _Requirements: 8.1, 8.2, 8.3, 8.4_

- [ ] 22. Sale flow — scan, price, pay, receipt
  - [ ] 22.1 Wire QR scan → `effectivePrice` → cart, using the scanner and pricing services.
    - _Requirements: 9.1, 10.5_
  - [ ] 22.2 Wire checkout to `PaymentService`, then `commitSale` only on authorization, then issue receipt.
    - _Requirements: 9.2, 10.1, 10.2, 10.3, 10.4_
  - [ ] 22.3 Write tests for the end-to-end sale flow including decline path (no inventory mutation).
    - _Requirements: 9.3, 10.4_

---

## Phase 6 — After-Sales Module

- [ ] 23. AST intake and warranty verification
  - [ ] 23.1 Build AST creation with required service type and in-app condition photo capture.
    - _Requirements: 11.1, 11.2_
  - [ ] 23.2 Implement warranty verification by serial (active/out-of-warranty/voided) and unverifiable flagging for manual review.
    - _Requirements: 11.3, 11.4_

- [ ] 24. Estimate, approval gate, and repair workflow
  - [ ] 24.1 Build itemized estimate (parts, labour, timeline) sent to client for digital approve/decline.
    - _Requirements: 12.1_
  - [ ] 24.2 Implement `advanceStage` gating: block past Received without approval; block Completed without a full QA checklist.
    - _Requirements: 12.2, 12.3, 12.4_
  - [ ] 24.3 Write tests for the approval gate and QA gate.
    - _Requirements: 12.2, 12.4_

- [ ] 25. Returns and client communication
  - [ ] 25.1 Build return scheduling (boutique pickup/courier), documentation generation, and digital sign-off on collection.
    - _Requirements: 12.5_
  - [ ] 25.2 Wire milestone notifications (Received, Estimated, Approved, In Repair, Ready, Dispatched) to `NotificationService`.
    - _Requirements: 12.6_

---

## Phase 7 — Quality, Compliance & Submissions

- [ ] 26. Reliability and concurrency hardening
  - Verify graceful recovery on network failure and consistent state under concurrent inventory/payment writes; add tests.
  - _Requirements: 13.1, 13.3, 13.4_

- [ ] 27. Memory and constraint quality gates
  - Run Instruments to confirm zero memory leaks and resolve any Auto Layout constraint conflicts; capture the memory profile screenshot for submission.
  - _Requirements: 13.2_

- [ ] 28. Security and privacy verification
  - Verify encryption at rest, role-scoped data access, consent-aware persistence, and Passkey + optional second factor; add tests for role scoping and consent gating.
  - _Requirements: 14.1, 14.2, 14.4_

- [ ] 29. Accessibility audit
  - Audit Dynamic Type, VoiceOver, and contrast across all screens including the scanner; fix gaps.
  - _Requirements: 14.3_

- [ ] 30. Final integration pass
  - Wire all role shells through `RootRouter`, run the full test suite, and verify each role's navigation visibility matches RBAC.
  - _Requirements: 1.2, 1.3_
