# TEAM5 Backlog - Estimated

Estimation of the 75 user stories in `team5_user_stories_only.txt`, keyed by Jira ID.

**Conventions:** Priority = MoSCoW (Must/Should/Could). Story Points = Fibonacci (1, 2, 3, 5, 8) covering code + unit tests.

## Summary

| Metric | Value |
|--------|-------|
| Total stories | 75 |
| Total story points | 222 |
| Must / Should / Could | 39 / 33 / 3 |
| Points 1/2/3/5/8 | 1 / 25 / 43 / 2 / 4 |
| Sprint 1 | 15 stories, 39 pts |
| Sprint 2 | 38 stories, 122 pts |
| Sprint 3 | 22 stories, 61 pts |

## Admin (19 stories, 49 pts)

| Key | User Story | Acceptance Criteria | Priority | Pts | Sprint |
|-----|-----------|---------------------|----------|-----|--------|
| TEAM5-2 | As an Admin, I want to create a new store profile with name, address, and contact details, so that the store is registered in the system and visible across the platform. | Required fields validated<br>created store appears in active list | Must | 3 | 1 |
| TEAM5-6 | As an Admin, I want to assign a locale, currency, and timezone to each store, so that all transactions, reports, and communications reflect the store’s local context. | Locale, currency, timezone captured at creation<br>applied to transactions/reports | Must | 2 | 1 |
| TEAM5-7 | As an Admin, I want to configure payment terminals (Razorpay and card) for a new store, so that the store can accept payments from day one. | Store config captures Razorpay + card terminal<br>validated before go-live | Must | 3 | 1 |
| TEAM5-8 | As an Admin, I want to assign a manager when creating a store, so that the store has operational ownership from day one. | Store creation accepts manager assignment<br>linked to store | Must | 2 | 1 |
| TEAM5-9 | As an Admin, I want to view each manager’s currently assigned store, so that I know who is responsible for which location at any time. | Lists managers with current store<br>searchable | Should | 2 | 2 |
| TEAM5-10 | As an Admin, I want to view a cross-store revenue dashboard with monthly breakdowns, so that I can monitor business performance at a glance. | Shows daily/weekly/monthly actuals vs targets<br>aggregates across stores | Must | 5 | 2 |
| TEAM5-58 | As an Admin, I want the manager profile view to be read-only, so that performance records cannot be altered. | No edit controls on manager profile<br>display-only | Must | 1 | 1 |
| TEAM5-60 | As an Admin, I want to log in with my credentials, so that I can access only the features and data relevant to my role. | Passkey auth<br>Admin modules only (RBAC)<br>invalid auth denied | Must | 3 | 1 |
| TEAM5-65 | As an Admin, I want to filter the revenue dashboard by country, so that I can analyse performance across specific geographies. | Filter recomputes figures for selected country/region<br>empty shows all | Should | 2 | 2 |
| TEAM5-66 | As an Admin, I want to create a new SKU with product details and define its launch date, so that the product is catalogued and ready for distribution. | SKU unique<br>launch date not in past<br>captures name, assets, description | Must | 3 | 1 |
| TEAM5-67 | As an Admin, I want to set a minimum floor price per SKU per currency, so that managers cannot discount below a level that protects brand value and margins. | Floor stored per SKU per currency<br>enforced on all local prices | Must | 3 | 1 |
| TEAM5-68 | As an Admin, I want to receive and review transfer requests raised by managers, so that I can evaluate stock needs across the network. | All pending requests listed with SKU, qty, urgency, store<br>sortable by urgency | Must | 2 | 2 |
| TEAM5-72 | As an Admin I want to remove store profile so that the store which is not operational doesn't reflect in database. | Deactivate/remove with confirmation<br>history retained<br>hidden from active lists | Should | 3 | 1 |
| TEAM5-73 | As an Admin I want to delete Manager profile so that the person who has resgined is not in the database anymore. | Delete requires confirmation<br>soft-delete + audit-logged<br>removed manager cannot log in | Should | 2 | 1 |
| TEAM5-82 | As an Admin, I want to verify warehouse stock availability for requested items so that I can decide whether inventory can be transferred immediately. | Shows on-hand qty per location<br>flags shortfall if none available | Must | 2 | 2 |
| TEAM5-83 | As an Admin, I want to approve transfer requests when sufficient stock is available so that inventory can be dispatched to stores. | Approve available only if source store has stock<br>routes from best-placed store | Must | 3 | 2 |
| TEAM5-84 | As an Admin, I want to create purchase orders when warehouse stock is insufficient so that required inventory can be replenished. | PO raised when no store can fulfil<br>PO captures SKU, qty, supplier, expected date | Should | 3 | 2 |
| TEAM5-85 | As an Admin, I want to dispatch approved inventory transfers to stores so that requested products reach their destination. | Only approved transfers dispatchable<br>dispatch decrements source and marks in-transit | Must | 3 | 2 |
| TEAM5-86 | As an Admin, I want store managers to receive transfer status notifications so that they can prepare for incoming inventory. | Manager notified on transfer state change<br>notification includes SKU, qty, status, ETA | Should | 2 | 2 |

## Manager (13 stories, 33 pts)

| Key | User Story | Acceptance Criteria | Priority | Pts | Sprint |
|-----|-----------|---------------------|----------|-----|--------|
| TEAM5-11 | As a Manager, I want to create a VIP or launch event with name, date, time, venue, and description, so that the event is formally scheduled. | Required fields validated<br>optionally linked to Admin product launch | Should | 3 | 2 |
| TEAM5-12 | As a Manager, I want to send digital invitations to selected customers, so that they can be informed about upcoming events. | Invites sent via digital channel<br>linked to event | Should | 2 | 2 |
| TEAM5-13 | As a Manager, I want to review shift histories so that I can monitor employee attendance. | Shift history per associate<br>shows dates/hours | Could | 2 | 2 |
| TEAM5-14 | As a Manager, I want to view performance metrics, units sold, upsell rate, and client satisfaction score of the sales associate so that I can evaluate employee performance. | Per-associate metrics displayed<br>date-range filterable | Should | 3 | 2 |
| TEAM5-15 | ⁠As a Manager, I want to raise stock requests by specifying the Stock Keeping Unit (SKU), required quantity, and urgency level so that the Admin can replenish inventory through inter-store transfers or warehouse stock before products run out. | Request captures SKU, qty, urgency<br>submitted to Admin queue | Must | 3 | 2 |
| TEAM5-16 | As a Manager, I want low-stock items to be flagged automatically for reorder, so that I can take action before the product runs out. | SKU below threshold auto-flagged<br>visible on dashboard | Must | 3 | 1 |
| TEAM5-17 | As a Manager, I want to monitor the approval status of my stock requests so that I know when requested inventory will be allocated or delivered to my store. | Each request shows status (pending/approved/routed/delivered)<br>real-time | Should | 2 | 2 |
| TEAM5-18 | As a Manager, I want the system to block me from saving a price below the Admin's floor, so that I cannot breach corporate pricing policy accidentally. | Below-floor save rejected with minimum shown<br>no save persists | Must | 2 | 2 |
| TEAM5-19 | As a Manager, I want to adjust the selling price of products within the pricing band defined by the Admin so that I can respond to local market conditions while complying with corporate pricing policies. | Editable only within band<br>cannot exceed max or go below floor | Must | 3 | 2 |
| TEAM5-61 | As a Manager, I want to log in with my credentials, so that I can access only the features and data relevant to my role. | Passkey auth<br>Manager modules only scoped to store | Must | 3 | 1 |
| TEAM5-70 | As a Manager, I want to track RSVP responses (Accepted, Declined, Pending), so that I can estimate event attendance. | Real-time RSVP status per invitee<br>counts per status | Should | 2 | 2 |
| TEAM5-71 | As a Manager, I want to view event analytics and RSVP reports, so that I can evaluate event performance. | Shows invites sent, RSVP breakdown, attendance<br>exportable | Could | 3 | 2 |
| TEAM5-74 | As a Manager I want to delete Staff profile so that the person who has resgined is not in the database anymore. | Delete requires confirmation<br>soft-delete + audit-logged<br>removed staff cannot log in | Should | 2 | 1 |

## Sales Associate (17 stories, 70 pts)

| Key | User Story | Acceptance Criteria | Priority | Pts | Sprint |
|-----|-----------|---------------------|----------|-----|--------|
| TEAM5-20 | As a Sales Associate, I want to create a new client card with basic consented details (name, phone number, style preferences), so that I can start building a personalised shopping experience. | Captures name, phone, style prefs<br>persisted only if consent granted | Must | 3 | 2 |
| TEAM5-21 | As a Sales Associate, I want to search for an existing client in the CRM by name or phone number, so that I can quickly pull up their profile when they visit. | Search by name/phone returns matches<br>opens profile | Must | 2 | 2 |
| TEAM5-22 | As a Sales Associate, I want to book an in-store or video call appointment for a client, so that I can provide a scheduled, personalised consultation. | Booking supports both types<br>reminders scheduled | Should | 3 | 2 |
| TEAM5-23 | As a Sales Associate, I want to conduct a video consultation and share curated cart links with the client remotely, so that clients can shop without visiting the store. | Video consult supported<br>shareable curated cart link generated | Could | 8 | 2 |
| TEAM5-24 | As a Sales Associate, I want to manage BOPIS (Buy Online Pick Up In Store) pickup alerts, so that I can prepare the order and notify the client when it's ready for collection. | Alert on BOPIS order<br>client notified when ready | Should | 3 | 2 |
| TEAM5-25 | As a Sales Associate, I want to create ship-from-warehouse orders for remote selling, so that products not available in-store can be shipped directly to the client. | Order created against warehouse stock<br>shipping details captured | Should | 3 | 2 |
| TEAM5-26 | As a Sales Associate, I want the system to generate product recommendations based on a client's purchase patterns and preferences, so that I have data-driven suggestions to present. | Recommendations derived from client history<br>displayed for review | Should | 8 | 2 |
| TEAM5-27 | As a Sales Associate, I want the system to suggest trending and similar products for new clients with no purchase history, so that I can still offer relevant options. | New client triggers trending/similar model<br>relevant items displayed | Should | 3 | 2 |
| TEAM5-28 | As a Sales Associate, I want the system to surface complementary products at the cart stage, so that I can suggest cross-sell options to the client. | Cross-sell suggestions appear at cart<br>associate selects which to add | Should | 3 | 2 |
| TEAM5-29 | As a Sales Associate, I want the system to suggest higher-value alternatives at the cart stage, so that I can offer upsell options that match the client's taste. | Upsell suggestions appear at cart<br>associate selects which to add | Should | 3 | 2 |
| TEAM5-30 | As a Sales Associate, I want to check inventory availability (in-store, warehouse, nearby stores) before presenting a product, so that I don't recommend items that are out of stock. | Availability shown across three sources<br>real-time | Must | 3 | 2 |
| TEAM5-31 | As a Sales Associate, I want to scan a product's QR code at the point of sale, so that both the client's purchase history and the store's inventory records are updated simultaneously in one action. | Single scan updates both atomically<br>failure rolls back both | Must | 8 | 2 |
| TEAM5-32 | As a Sales Associate, I want the system to suggest similar alternative products when the desired item is unavailable, so that I can still serve the client without losing the sale. | Out-of-stock triggers AI alternatives<br>associate can present or dismiss | Should | 3 | 2 |
| TEAM5-33 | As a Sales Associate, I want to take payment via Razorpay and issue a digital receipt, so that checkout is fast and compliant. | Razorpay (UPI/netbanking/wallet) supported<br>digital receipt sent to client | Must | 8 | 2 |
| TEAM5-34 | As a Sales Associate, I want to process payments via card terminal (tap/swipe), so that clients can pay with credit or debit cards. | Card terminal completes payment<br>result recorded on order | Must | 3 | 2 |
| TEAM5-35 | As a Sales Associate, I want to route the completed order as a store sale, BOPIS reservation, or ship-from-warehouse, so that the correct fulfilment process is triggered based on the order type. | Order-type selection triggers correct flow<br>each path produces correct action | Must | 3 | 2 |
| TEAM5-62 | As a Sales Associate I want to log in with my credentials, so that I can access only the features and data relevant to my role. | Passkey auth<br>Sales modules only scoped to store | Must | 3 | 1 |

## After-Sales (26 stories, 70 pts)

| Key | User Story | Acceptance Criteria | Priority | Pts | Sprint |
|-----|-----------|---------------------|----------|-----|--------|
| TEAM5-40 | As an After-Sales Specialist, I want to scan a product's QR code to look up the item, so that I can quickly identify the product and pull its records. | QR scan resolves SKU/serial<br>pulls item records | Must | 3 | 3 |
| TEAM5-41 | As an After-Sales Specialist, I want to manually enter product details if the QR scan fails, so that I can still create a ticket for items with damaged labels. | Manual entry path available<br>AST created normally | Should | 2 | 3 |
| TEAM5-42 | As an After-Sales Specialist, I want to pull the client's purchase history linked to the product, so that I have full context on the original transaction. | Purchase record linked via serial<br>displayed at intake | Should | 2 | 3 |
| TEAM5-43 | As an After-Sales Specialist, I want to capture condition photos and a diagnostic report in-app at intake, so that the item's state is documented before any work begins. | Photos + diagnostics captured in-app<br>stored with AST | Must | 3 | 3 |
| TEAM5-44 | As an After-Sales Specialist, I want to create an after-sales ticket (AST) tagged with the correct service type (exchange, return, repair, warranty), so that the ticket follows the right workflow. | Service type required<br>drives downstream workflow | Must | 3 | 3 |
| TEAM5-45 | As an After-Sales Specialist, I want to validate whether the product's warranty is still active, so that I can flag it as a warranty repair (free) or a paid repair. | Serial lookup returns warranty status<br>determines free/paid path | Must | 3 | 3 |
| TEAM5-46 | As an After-Sales Specialist, I want the system to flag out-of-warranty or voided coverage clearly, so that the client is informed upfront about potential costs. | Coverage status shown prominently<br>paid-repair flag set | Must | 2 | 3 |
| TEAM5-47 | As an After-Sales Specialist, I want to track a repair through defined stages, so that the progress is transparent and auditable. | Stages Received -> In Repair -> QA -> Completed<br>transitions timestamped | Must | 3 | 3 |
| TEAM5-48 | As an After-Sales Specialist, I want a mandatory QA checklist to be completed before marking a repair as done, so that no item is returned to the client without quality verification. | Repair cannot be Completed unless checklist fully done | Must | 3 | 3 |
| TEAM5-49 | As an After-Sales Specialist, I want to send items back to repair if they fail the QA check, so that issues are resolved before the client receives the product. | Failed QA returns item to repair stage<br>reason logged | Must | 2 | 3 |
| TEAM5-50 | As an After-Sales Specialist, I want to schedule a store pickup or courier for the completed item, so that the client can conveniently collect or receive their product. | Pickup or courier selectable<br>scheduling captured (consolidate with #9) | Should | 3 | 3 |
| TEAM5-51 | As an After-Sales Specialist, I want to generate return documentation for the completed service, so that there is a formal record of the handover. | Return doc generated with item + service details<br>attached to AST | Should | 2 | 3 |
| TEAM5-52 | As an After-Sales Specialist, I want the client to digitally sign off on collection, so that we have proof of delivery and the ticket can be formally closed. | Digital signature captured at handover<br>stored against AST | Should | 3 | 3 |
| TEAM5-53 | As an After-Sales Specialist, I want to scan a final packaging QR before releasing the item, so that inventory records are updated and the AST is closed accurately. | Packaging QR scan required before release<br>closes AST + syncs inventory | Should | 3 | 3 |
| TEAM5-54 | As an After-Sales Specialist, I want to generate an itemised cost estimate (parts + labour + timeline), so that the client knows exactly what the repair will cost and how long it will take. | Estimate itemizes parts, labour, timeline<br>total computed | Must | 3 | 3 |
| TEAM5-55 | As an After-Sales Specialist, I want to send the cost estimate to the client digitally for approval or decline, so that no work begins without the client's consent. | Estimate sent via secure digital link<br>client decision recorded | Must | 3 | 3 |
| TEAM5-56 | As an After-Sales Specialist, I want the repair to proceed only after client approval, so that we avoid disputes over unauthorised work. | Repair blocked beyond intake until approval<br>approval recorded | Must | 3 | 3 |
| TEAM5-57 | As an After-Sales Specialist, I want declined repairs to skip the repair workflow and go directly to return/pickup scheduling, so that the client can retrieve their item without delay. | Declined estimate routes straight to collection<br>no repair stage entered | Must | 2 | 3 |
| TEAM5-63 | As an After-Sales Specialist I want to log in with my credentials, so that I can access only the features and data relevant to my role. | Passkey auth<br>After-Sales modules only (RBAC) | Must | 3 | 1 |
| TEAM5-75 | As an After-Sales Associate, I want to verify a product's authenticity so that counterfeit items are not accepted for service. | Authenticity check by serial/certificate<br>flags suspected counterfeit | Should | 5 | 3 |
| TEAM5-76 | As an After-Sales Associate, I want to view a product's service history so that I can understand previous repairs before creating a new request. | History by serial number<br>shows prior ASTs/outcomes | Should | 3 | 3 |
| TEAM5-77 | As an After-Sales Associate, I want to view pending customer approvals so that I can follow up on delayed responses. | Lists ASTs awaiting client approval<br>shows age of request | Should | 2 | 2 |
| TEAM5-78 | As an After-Sales Associate, I want to schedule customer pickups so that completed items are returned in an organized manner. | Pickup scheduled with date/method (consolidate with #34) | Should | 2 | 3 |
| TEAM5-79 | As an After-Sales Associate, I want to generate invoices for completed repairs so that customers receive a detailed breakdown of charges. | Invoice itemizes parts + labour<br>only for completed paid repairs | Should | 3 | 3 |
| TEAM5-80 | As an After-Sales Associate, I want to filter repair requests by status so that I can quickly locate specific service cases. | Filter by stage/status<br>results update immediately | Should | 2 | 2 |
| TEAM5-81 | As an After-Sales Associate, I want to view all active service requests so that I can monitor ongoing repair workloads. | Lists all active ASTs<br>shows stage and assignee | Should | 2 | 2 |
