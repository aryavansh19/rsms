# Design Document

## Overview

The Retail Store Management System (RSMS) is a native iOS application built with SwiftUI for iPhone and iPad (iOS 26+). It serves a multi-country luxury retail chain through a single role-based app with four roles: Admin, Manager, Sales Associate, and After-Sales Specialist.

The architecture follows **MVVM with Swift Concurrency**. Each role is delivered as a self-contained feature module that plugs into a shared core (authentication, RBAC, data models, networking, persistence). Item-level operations use **QR scanning via the Vision framework**. Payments use **Razorpay** and a **card terminal**. AI recommendations use **Core ML**.

This document maps directly to the 14 requirements in `requirements.md` and describes how each is realized.

### Design Goals

- **Role isolation with a shared core** — minimize duplication; enforce access at the navigation and data layers.
- **Consistency under concurrency** — inventory and payment writes must never produce partial/inconsistent state.
- **Offline resilience** — boutiques may have slow/intermittent networks; the app degrades gracefully.
- **Compliance by construction** — consent gates, encryption at rest, role-scoped data access.
- **Quality bar** — zero memory leaks, zero constraint conflicts, accessible by default.

---

## Architecture

### High-Level Layered Architecture

```
┌─────────────────────────────────────────────────────────────┐
│                      Presentation (SwiftUI)                   │
│   Role shells → Feature Views → ViewModels (@Observable)      │
└───────────────────────────┬─────────────────────────────────┘
                            │ async/await
┌───────────────────────────▼─────────────────────────────────┐
│                        Domain Layer                           │
│   Use cases / Services (pricing, transfers, scan, AST,        │
│   recommendations) + Business rules (price floor, QA gate)    │
└───────────────────────────┬─────────────────────────────────┘
                            │
┌───────────────────────────▼─────────────────────────────────┐
│                         Data Layer                            │
│   Repositories (protocol-based) → Remote API client +         │
│   Local store (SwiftData) + Keychain + Sync/queue engine      │
└───────────────────────────┬─────────────────────────────────┘
                            │
┌───────────────────────────▼─────────────────────────────────┐
│            Platform & Integrations                            │
│   Passkeys (ASAuthorization) · Vision (QR) · Core ML ·        │
│   Razorpay SDK · Card terminal · APNs/SMS · App Intents       │
└─────────────────────────────────────────────────────────────┘
```

### Module Structure

```
RSMS/
├── App/                      # App entry, DI container, root router
├── Core/
│   ├── Auth/                 # Passkey sign-in, session, RBAC (Req 1, 14)
│   ├── Models/               # Shared domain entities
│   ├── Networking/           # API client, request/response, retry
│   ├── Persistence/          # SwiftData stack, Keychain, encryption
│   ├── Sync/                 # Offline queue, conflict resolution (Req 13)
│   ├── DesignSystem/         # Reusable components, Dynamic Type, a11y (Req 14)
│   └── Scanning/             # Vision QR scanner service (Req 9)
├── Features/
│   ├── Admin/                # Req 2, 3, 4
│   ├── Manager/              # Req 5, 6
│   ├── SalesAssociate/       # Req 7, 8, 9, 10
│   └── AfterSales/           # Req 11, 12
├── Services/
│   ├── Pricing/              # Floor/band enforcement (Req 3, 6, 10)
│   ├── Payments/             # Razorpay + card terminal (Req 10)
│   ├── Recommendations/      # Core ML inference (Req 8)
│   └── Notifications/        # Push/SMS milestones (Req 12)
└── Resources/                # Assets, ML models, localizations
```

### Architectural Decisions

| Decision | Choice | Rationale |
|----------|--------|-----------|
| UI framework | SwiftUI | Required; declarative, adaptive for iPhone/iPad |
| Pattern | MVVM + `@Observable` ViewModels | Testable, clear separation, Swift Concurrency friendly |
| Concurrency | `async/await` + `actor` for inventory/payment | Serializes critical writes (Req 9, 10, 13) |
| Local persistence | SwiftData | Native, offline cache, integrates with concurrency |
| Secrets/session | Keychain | Encrypted credential and token storage (Req 14) |
| DI | Constructor injection via a lightweight container | Enables mocking repositories for tests |
| Navigation | Role-driven `NavigationStack` per shell | RBAC enforced at routing layer (Req 1) |

---

## Components and Interfaces

### Core: Authentication & RBAC (Req 1, 14)

```swift
enum UserRole: String, Codable {
    case admin, manager, salesAssociate, afterSales
}

protocol AuthService {
    func signInWithPasskey() async throws -> Session
    func currentSession() -> Session?
    func signOut() async
}

struct Session {
    let userID: String
    let role: UserRole
    let storeID: String?      // nil for Admin (global)
    let expiresAt: Date
}

protocol AccessPolicy {
    func canAccess(_ feature: Feature, as role: UserRole) -> Bool
}
```

- The **RootRouter** reads `Session.role` and mounts only the permitted role shell.
- `AccessPolicy` is checked both at navigation time and inside repositories (defense in depth).
- Idle-timeout via a session monitor that locks the UI and requires re-auth.

### Core: Domain Models

```swift
struct Store: Identifiable, Codable {
    let id: String
    var name: String
    var locale: Locale
    var currencyCode: String
    var timeZone: TimeZone
    var paymentTerminals: [PaymentTerminal]
    var managerID: String?
}

struct SKU: Identifiable, Codable {
    let id: String                 // unique product identifier
    var name: String
    var assets: [Asset]
    var launch: LaunchConfig
    var pricing: [String: PriceBand] // currencyCode -> band
}

struct PriceBand: Codable {
    var basePrice: Decimal
    var floorPrice: Decimal         // Admin-set minimum (Req 3, 6, 10)
    var localPrice: Decimal?        // Manager-set, must be >= floor
}

struct InventoryItem: Codable {
    var skuID: String
    var storeID: String
    var onHand: Int
    var serials: [String]
    var reorderThreshold: Int
}

struct Client: Identifiable, Codable {
    let id: String
    var name: String
    var phone: String
    var stylePreferences: [String]
    var consentGranted: Bool        // gates persistence (Req 7)
    var purchaseHistory: [OrderRef]
}

struct Order: Identifiable, Codable {
    let id: String
    var lineItems: [LineItem]       // SKU, serial, qty, appliedPrice
    var paymentMethod: PaymentMethod
    var clientID: String?
    var receiptURL: URL?
}

struct TransferRequest: Identifiable, Codable {
    let id: String
    var skuID: String
    var quantity: Int
    var urgency: Urgency
    var requestingStoreID: String
    var status: TransferStatus      // requested, approved, routed, completed, unfulfillable
    var sourceStoreID: String?
}

struct AfterSalesTicket: Identifiable, Codable {
    let id: String
    var type: ASTType               // exchange, return, repair, warranty
    var serial: String
    var conditionPhotos: [Asset]
    var warranty: WarrantyStatus    // active, outOfWarranty, voided, unverifiable
    var estimate: Estimate?
    var stage: RepairStage          // received, inRepair, qaCheck, completed
    var qaChecklist: QAChecklist?
}
```

### Service: Pricing & Floor Enforcement (Req 3, 6, 10)

```swift
protocol PricingService {
    func setFloor(skuID: String, currency: String, base: Decimal, floor: Decimal) async throws
    func setLocalPrice(skuID: String, storeID: String, price: Decimal) async throws  // validates >= floor
    func effectivePrice(skuID: String, storeID: String) async throws -> Decimal
}
```

- `setLocalPrice` throws `PricingError.belowFloor(minimum:)` if `price < floor` (Req 6.5).
- `effectivePrice` returns `localPrice ?? basePrice`, guaranteed `>= floor` (Req 10.5).

### Service: Inventory & Atomic QR Scan (Req 9)

```swift
actor InventoryService {
    func scan(qr: String) throws -> ScannedItem            // decode SKU + serial (Req 9.1)
    func commitSale(_ item: ScannedItem, clientID: String?) async throws
    // commitSale performs inventory decrement + client history append in ONE transaction;
    // on any failure it rolls back both (Req 9.2, 9.3)
}
```

- Implemented as an `actor` so concurrent scans/sales are serialized (Req 13.4).
- Unknown QR → `ScanError.unknownSKU` → UI prompts rescan (Req 9.4).

### Service: Transfers (Req 4)

```swift
protocol TransferService {
    func submit(_ request: TransferRequest) async throws
    func globalStockMap(skuID: String?) async throws -> [InventoryItem]
    func approve(requestID: String, sourceStoreID: String) async throws  // moves stock on completion
}
```

- If no source store has sufficient on-hand, the request is marked `unfulfillable` and surfaced for new-stock resolution (Req 4.4).
- Status changes emit notifications to the requesting Manager (Req 4.5, 5/6 linkage).

### Service: Payments (Req 10)

```swift
enum PaymentMethod: Codable { case razorpay(RazorpayMeta), cardTerminal(CardMeta) }

protocol PaymentService {
    func pay(amount: Decimal, currency: String, method: PaymentMethod) async throws -> PaymentResult
    func issueDigitalReceipt(order: Order, to client: Client) async throws -> URL
}
```

- On decline/cancel, the cart is preserved and inventory is **not** decremented (Req 10.4). Inventory commit happens only after `PaymentResult.authorized`.

### Service: Recommendations (Req 8)

```swift
protocol RecommendationService {
    func recommendations(for clientID: String) async throws -> [SKU]      // Core ML inference
    func upsell(for cart: Cart) async throws -> [SKU]
}
```

- Output is a **proposal**; the Associate curates (accept/remove/reorder) before presenting (Req 8.2, 8.4). The ViewModel holds a mutable curated list distinct from the raw model output.

### Service: After-Sales Workflow (Req 11, 12)

```swift
protocol AfterSalesService {
    func createTicket(type: ASTType, serial: String, photos: [Asset]) async throws -> AfterSalesTicket
    func verifyWarranty(serial: String) async throws -> WarrantyStatus
    func submitEstimate(ticketID: String, estimate: Estimate) async throws  // sends to client
    func advanceStage(ticketID: String, to stage: RepairStage) async throws // enforces gates
}
```

**Gates enforced in `advanceStage`:**
- Cannot move beyond `received` unless `estimate.approved == true` (Req 12.2).
- Cannot set `completed` unless `qaChecklist.isComplete` (Req 12.4).
- Each stage transition triggers a milestone notification (Req 12.6).

---

## Data Flow — Key Scenarios

### A. Sale with QR scan + payment (Req 9, 10)

```
Associate scans QR
   → InventoryService.scan() decodes SKU+serial
   → PricingService.effectivePrice() (>= floor)
   → Cart updated; upsell suggestions surfaced
   → PaymentService.pay() (Razorpay or card)
   → IF authorized: InventoryService.commitSale() [atomic decrement + history append]
   → issueDigitalReceipt()
   → IF declined: cart preserved, no inventory change
```

### B. Manager stock request → Admin transfer (Req 4, 6)

```
Manager raises request (SKU, qty, urgency)
   → Admin queue
   → Admin views global stock map → approves with source store
   → on completion: source onHand--, destination onHand++
   → Manager notified of status
   → IF no source has stock → marked unfulfillable → resolve via new stock
```

### C. After-sales repair lifecycle (Req 11, 12)

```
Specialist raises AST (type + condition photos)
   → verifyWarranty(serial) → active / outOfWarranty / voided / unverifiable
   → submitEstimate() → client approves/declines digitally
   → IF approved: advanceStage Received → In Repair → QA Check → Completed
        (Completed blocked until QA checklist complete)
   → return: schedule pickup/courier, generate docs, digital sign-off
   → milestone notifications at each step
```

---

## Business Rules (cross-cutting invariants)

1. **Price floor is absolute** — no local price, discount, or sale price may resolve below the Admin floor for the currency.
2. **Atomic scan** — inventory decrement and client history append succeed or fail together; no partial writes.
3. **No work before approval** — repairs cannot advance past Received without a client-approved estimate.
4. **QA gate** — a repair cannot be Completed until the QA checklist is fully satisfied.
5. **Consent gate** — client personal data is not persisted unless consent is granted.
6. **Role scoping** — Admin operates globally; Manager/Associate/After-Sales are scoped to their store.

---

## Error Handling

| Area | Strategy |
|------|----------|
| Network failures | Retry with backoff; queue writes in Sync engine; show cached/skeleton UI (Req 13.1, 13.3) |
| Concurrent writes | `actor`-isolated inventory/payment services serialize access (Req 13.4) |
| Atomic scan failure | Transaction rollback; user-facing error + retry (Req 9.3) |
| Unknown QR | Reject + rescan prompt (Req 9.4) |
| Below-floor price | `PricingError.belowFloor` with minimum shown (Req 6.5) |
| Payment decline | Preserve cart, no inventory mutation (Req 10.4) |
| Warranty not found | Mark unverifiable, require manual review (Req 11.4) |
| Auth/session expiry | Lock UI, require re-auth (Req 1.4) |

Errors are modeled as typed `enum` conforming to `Error` and surfaced through ViewModel state, never via force-unwraps.

---

## Testing Strategy

- **Unit tests** for business rules: floor enforcement, atomic scan rollback, AST stage gates, QA gate, consent gate.
- **Repository tests** with in-memory/mock implementations (protocol-based DI).
- **ViewModel tests** for state transitions (loading/loaded/error) and curation logic for recommendations.
- **UI tests** for the critical sale flow, the repair lifecycle, and RBAC navigation visibility.
- **Concurrency tests** asserting serialized inventory/payment writes produce consistent state.
- **Quality gates**: Instruments leak checks (zero leaks, Req 13.2), no Auto Layout constraint conflicts, accessibility audit (Dynamic Type, VoiceOver, contrast — Req 14.3).

---

## Security & Privacy Design (Req 14)

- **Passkeys** via `ASAuthorization` for passwordless auth; optional second factor where configured.
- **Encryption at rest** for sensitive data (SwiftData with protected files; secrets in Keychain).
- **Role-scoped data access** enforced in repositories, not just UI.
- **Consent-aware persistence** for client PII; collect only basic consented details, no sensitive categories.
- **GDPR alignment**: consent capture, data minimization, and deletion support.

---

## Accessibility & Usability (Req 14.3)

- Dynamic Type across all text; layouts adapt with no truncation.
- VoiceOver labels and hints on interactive controls, including the QR scanner (audio/haptic scan confirmation).
- Color contrast meets WCAG AA; never rely on color alone for status (icons + labels).
- iPad multi-column and iPhone compact layouts via adaptive SwiftUI containers.
