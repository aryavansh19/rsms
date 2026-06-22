# TEAM5 Backlog - Sprint Plan

Source of truth: `final-backlog-team5.csv`. 77 user stories, 242 story points.

**Scale:** Fibonacci 1/2/3/5/8. Setup (GitHub, Supabase, scaffold) embedded in Sprint-1 stories TEAM5-60 & TEAM5-2.

## Summary

| Metric | Value |
|--------|-------|
| Total stories | 77 |
| Total story points | 242 |
| Must / Should / Could | 40 / 34 / 3 |
| Points 1/2/3/5/8 | 1 / 25 / 41 / 4 / 6 |

## Sprint Capacity

Total = 693 hrs (189 / 283.5 / 220.5). Velocity = 693 / 242 = **2.86 hrs/point**.

| Sprint | Stories | Points | Hours (pts x rate) | Capacity | Diff |
|--------|---------|--------|--------------------|----------|------|
| 1 | 24 | 75 | 214.8 | 189.0 | +25.8 |
| 2 | 26 | 90 | 257.7 | 283.5 | -25.8 |
| 3 | 27 | 77 | 220.5 | 220.5 | +0.0 |
| **Total** | **77** | **242** | **693.0** | **693** | - |

## Sprint 1 (24 stories, 75 pts)

| Key | Role | User Story | Epic | Pts |
|-----|------|-----------|------|-----|
| TEAM5-9 | Admin | As an Admin, I want to view each manager’s currently assigned store, so that I know who is responsible for which location at any time. | Analytics & Oversight | 2 |
| TEAM5-60 | Admin | As an Admin, I want to log in with my credentials, so that I can access only the features and data relevant to my role. | Auth & RBAC | 8 |
| TEAM5-61 | Manager | As a Manager, I want to log in with my credentials, so that I can access only the features and data relevant to my role. | Auth & RBAC | 3 |
| TEAM5-62 | Sales Associate | As a Sales Associate I want to log in with my credentials, so that I can access only the features and data relevant to my role. | Auth & RBAC | 3 |
| TEAM5-68 | Admin | As an Admin, I want to receive and review transfer requests raised by managers, so that I can evaluate stock needs across the network. | Inter-store Transfers | 2 |
| TEAM5-82 | Admin | As an Admin, I want to verify warehouse stock availability for requested items so that I can decide whether inventory can be transferred immediately. | Inter-store Transfers | 2 |
| TEAM5-84 | Admin | As an Admin, I want to create purchase orders when warehouse stock is insufficient so that required inventory can be replenished. | Inter-store Transfers | 3 |
| TEAM5-85 | Admin | As an Admin, I want to dispatch approved inventory transfers to stores so that requested products reach their destination. | Inter-store Transfers | 2 |
| TEAM5-16 | Manager | As a Manager, I want low-stock items to be flagged automatically for reorder, so that I can take action before the product runs out. | Inventory Base | 3 |
| TEAM5-88 | Manager | As a Manager, I want to view an inventory dashboard with stock levels, low-stock alerts, and a one-tap restock request to the Admin, so that I can manage store inventory in one place. | Inventory Base | 3 |
| TEAM5-15 | Manager | As a Manager, I want to raise stock requests by specifying the Stock Keeping Unit (SKU), required quantity, and urgency level so that the Admin can replenish inventory through inter-store transfers or warehouse stock before products run out. | Pricing & Stock Requests | 3 |
| TEAM5-17 | Manager | As a Manager, I want to monitor the approval status of my stock requests so that I know when requested inventory will be allocated or delivered to my store. | Pricing & Stock Requests | 2 |
| TEAM5-18 | Manager | As a Manager, I want the system to block me from saving a price below the Admin's floor, so that I cannot breach corporate pricing policy accidentally. | Pricing & Stock Requests | 2 |
| TEAM5-19 | Manager | As a Manager, I want to adjust the selling price of products within the pricing band defined by the Admin so that I can respond to local market conditions while complying with corporate pricing policies. | Pricing & Stock Requests | 3 |
| TEAM5-66 | Admin | As an Admin, I want to create a new SKU with product details and define its launch date, so that the product is catalogued and ready for distribution. | Product & Pricing | 3 |
| TEAM5-67 | Admin | As an Admin, I want to set a minimum floor price per SKU per currency, so that managers cannot discount below a level that protects brand value and margins. | Product & Pricing | 3 |
| TEAM5-58 | Admin | As an Admin, I want the manager profile view to be read-only, so that performance records cannot be altered. | Profiles | 1 |
| TEAM5-73 | Admin | As an Admin I want to delete Manager profile so that the person who has resgined is not in the database anymore. | Profiles | 2 |
| TEAM5-74 | Manager | As a Manager I want to delete Staff profile so that the person who has resgined is not in the database anymore. | Profiles | 2 |
| TEAM5-2 | Admin | As an Admin, I want to create a new store profile with name, address, and contact details, so that the store is registered in the system and visible across the platform. | Store Onboarding | 8 |
| TEAM5-6 | Admin | As an Admin, I want to assign a locale, currency, and timezone to each store, so that all transactions, reports, and communications reflect the store’s local context. | Store Onboarding | 2 |
| TEAM5-7 | Admin | As an Admin, I want to configure payment terminals (Razorpay and card) for a new store, so that the store can accept payments from day one. | Store Onboarding | 8 |
| TEAM5-72 | Admin | As an Admin I want to remove store profile so that the store which is not operational doesn't reflect in database. | Store Onboarding | 3 |
| TEAM5-8 | Admin | As an Admin, I want to assign a manager when creating a store, so that the store has operational ownership from day one. | Store Onboarding | 2 |

## Sprint 2 (26 stories, 90 pts)

| Key | Role | User Story | Epic | Pts |
|-----|------|-----------|------|-----|
| TEAM5-26 | Sales Associate | As a Sales Associate, I want the system to generate product recommendations based on a client's purchase patterns and preferences, so that I have data-driven suggestions to present. | AI Recommendations | 8 |
| TEAM5-27 | Sales Associate | As a Sales Associate, I want the system to suggest trending and similar products for new clients with no purchase history, so that I can still offer relevant options. | AI Recommendations | 3 |
| TEAM5-28 | Sales Associate | As a Sales Associate, I want the system to surface complementary products at the cart stage, so that I can suggest cross-sell options to the client. | AI Recommendations | 3 |
| TEAM5-29 | Sales Associate | As a Sales Associate, I want the system to suggest higher-value alternatives at the cart stage, so that I can offer upsell options that match the client's taste. | AI Recommendations | 3 |
| TEAM5-32 | Sales Associate | As a Sales Associate, I want the system to suggest similar alternative products when the desired item is unavailable, so that I can still serve the client without losing the sale. | AI Recommendations | 3 |
| TEAM5-63 | After-Sales | As an After-Sales Specialist I want to log in with my credentials, so that I can access only the features and data relevant to my role. | Auth & RBAC | 3 |
| TEAM5-20 | Sales Associate | As a Sales Associate, I want to create a new client card with basic consented details (name, phone number, style preferences), so that I can start building a personalised shopping experience. | Clienteling & Appointments | 3 |
| TEAM5-21 | Sales Associate | As a Sales Associate, I want to search for an existing client in the CRM by name or phone number, so that I can quickly pull up their profile when they visit. | Clienteling & Appointments | 2 |
| TEAM5-22 | Sales Associate | As a Sales Associate, I want to book an in-store or video call appointment for a client, so that I can provide a scheduled, personalised consultation. | Clienteling & Appointments | 3 |
| TEAM5-23 | Sales Associate | As a Sales Associate, I want to conduct a video consultation and share curated cart links with the client remotely, so that clients can shop without visiting the store. | Clienteling & Appointments | 8 |
| TEAM5-24 | Sales Associate | As a Sales Associate, I want to manage BOPIS (Buy Online Pick Up In Store) pickup alerts, so that I can prepare the order and notify the client when it's ready for collection. | Clienteling & Appointments | 3 |
| TEAM5-25 | Sales Associate | As a Sales Associate, I want to create ship-from-warehouse orders for remote selling, so that products not available in-store can be shipped directly to the client. | Clienteling & Appointments | 3 |
| TEAM5-11 | Manager | As a Manager, I want to create a VIP or launch event with name, date, time, venue, and description, so that the event is formally scheduled. | Events & Staff | 3 |
| TEAM5-12 | Manager | As a Manager, I want to send digital invitations to selected customers, so that they can be informed about upcoming events. | Events & Staff | 2 |
| TEAM5-13 | Manager | As a Manager, I want to review shift histories so that I can monitor employee attendance. | Events & Staff | 2 |
| TEAM5-14 | Manager | As a Manager, I want to view performance metrics, units sold, upsell rate, and client satisfaction score of the sales associate so that I can evaluate employee performance. | Events & Staff | 3 |
| TEAM5-70 | Manager | As a Manager, I want to track RSVP responses (Accepted, Declined, Pending), so that I can estimate event attendance. | Events & Staff | 2 |
| TEAM5-71 | Manager | As a Manager, I want to view event analytics and RSVP reports, so that I can evaluate event performance. | Events & Staff | 3 |
| TEAM5-83 | Admin | As an Admin, I want to approve transfer requests when sufficient stock is available so that inventory can be dispatched to stores. | Inter-store Transfers | 3 |
| TEAM5-86 | Admin | As an Admin, I want store managers to receive transfer status notifications so that they can prepare for incoming inventory. | Inter-store Transfers | 2 |
| TEAM5-30 | Sales Associate | As a Sales Associate, I want to check inventory availability (in-store, warehouse, nearby stores) before presenting a product, so that I don't recommend items that are out of stock. | Sell, QR & Payments | 3 |
| TEAM5-31 | Sales Associate | As a Sales Associate, I want to scan a product's QR code at the point of sale, so that both the client's purchase history and the store's inventory records are updated simultaneously in one action. | Sell, QR & Payments | 8 |
| TEAM5-33 | Sales Associate | As a Sales Associate, I want to take payment via Razorpay and issue a digital receipt, so that checkout is fast and compliant. | Sell, QR & Payments | 5 |
| TEAM5-34 | Sales Associate | As a Sales Associate, I want to process payments via card terminal (tap/swipe), so that clients can pay with credit or debit cards. | Sell, QR & Payments | 3 |
| TEAM5-35 | Sales Associate | As a Sales Associate, I want to route the completed order as a store sale, BOPIS reservation, or ship-from-warehouse, so that the correct fulfilment process is triggered based on the order type. | Sell, QR & Payments | 3 |
| TEAM5-87 | Sales Associate | As a Sales Associate, I want to verify a client's digital receipt at BOPIS pickup, so that only the correct person collects the reserved item. | Sell, QR & Payments | 3 |

## Sprint 3 (27 stories, 77 pts)

| Key | Role | User Story | Epic | Pts |
|-----|------|-----------|------|-----|
| TEAM5-40 | After-Sales | As an After-Sales Specialist, I want to scan a product's QR code to look up the item, so that I can quickly identify the product and pull its records. | AST Intake & Warranty | 3 |
| TEAM5-41 | After-Sales | As an After-Sales Specialist, I want to manually enter product details if the QR scan fails, so that I can still create a ticket for items with damaged labels. | AST Intake & Warranty | 2 |
| TEAM5-42 | After-Sales | As an After-Sales Specialist, I want to pull the client's purchase history linked to the product, so that I have full context on the original transaction. | AST Intake & Warranty | 2 |
| TEAM5-43 | After-Sales | As an After-Sales Specialist, I want to capture condition photos and a diagnostic report in-app at intake, so that the item's state is documented before any work begins. | AST Intake & Warranty | 3 |
| TEAM5-44 | After-Sales | As an After-Sales Specialist, I want to create an after-sales ticket (AST) tagged with the correct service type (exchange, return, repair, warranty), so that the ticket follows the right workflow. | AST Intake & Warranty | 3 |
| TEAM5-45 | After-Sales | As an After-Sales Specialist, I want to validate whether the product's warranty is still active, so that I can flag it as a warranty repair (free) or a paid repair. | AST Intake & Warranty | 3 |
| TEAM5-46 | After-Sales | As an After-Sales Specialist, I want the system to flag out-of-warranty or voided coverage clearly, so that the client is informed upfront about potential costs. | AST Intake & Warranty | 2 |
| TEAM5-75 | After-Sales | As an After-Sales Associate, I want to verify a product's authenticity so that counterfeit items are not accepted for service. | AST Intake & Warranty | 5 |
| TEAM5-76 | After-Sales | As an After-Sales Associate, I want to view a product's service history so that I can understand previous repairs before creating a new request. | AST Intake & Warranty | 3 |
| TEAM5-89 | Sales Associate | As a Sales Associate, I want to use the app in multiple languages, so that I can serve clients in their preferred language. | Accessibility & Localization | 5 |
| TEAM5-77 | After-Sales | As an After-Sales Associate, I want to view pending customer approvals so that I can follow up on delayed responses. | After-Sales Workload Views | 2 |
| TEAM5-80 | After-Sales | As an After-Sales Associate, I want to filter repair requests by status so that I can quickly locate specific service cases. | After-Sales Workload Views | 2 |
| TEAM5-81 | After-Sales | As an After-Sales Associate, I want to view all active service requests so that I can monitor ongoing repair workloads. | After-Sales Workload Views | 2 |
| TEAM5-10 | Admin | As an Admin, I want to view a cross-store revenue dashboard with monthly breakdowns, so that I can monitor business performance at a glance. | Analytics & Oversight | 5 |
| TEAM5-65 | Admin | As an Admin, I want to filter the revenue dashboard by country, so that I can analyse performance across specific geographies. | Analytics & Oversight | 2 |
| TEAM5-54 | After-Sales | As an After-Sales Specialist, I want to generate an itemised cost estimate (parts + labour + timeline), so that the client knows exactly what the repair will cost and how long it will take. | Estimate & Approval | 3 |
| TEAM5-55 | After-Sales | As an After-Sales Specialist, I want to send the cost estimate to the client digitally for approval or decline, so that no work begins without the client's consent. | Estimate & Approval | 3 |
| TEAM5-56 | After-Sales | As an After-Sales Specialist, I want the repair to proceed only after client approval, so that we avoid disputes over unauthorised work. | Estimate & Approval | 3 |
| TEAM5-57 | After-Sales | As an After-Sales Specialist, I want declined repairs to skip the repair workflow and go directly to return/pickup scheduling, so that the client can retrieve their item without delay. | Estimate & Approval | 2 |
| TEAM5-47 | After-Sales | As an After-Sales Specialist, I want to track a repair through defined stages, so that the progress is transparent and auditable. | Repair & QA | 3 |
| TEAM5-48 | After-Sales | As an After-Sales Specialist, I want a mandatory QA checklist to be completed before marking a repair as done, so that no item is returned to the client without quality verification. | Repair & QA | 3 |
| TEAM5-49 | After-Sales | As an After-Sales Specialist, I want to send items back to repair if they fail the QA check, so that issues are resolved before the client receives the product. | Repair & QA | 2 |
| TEAM5-79 | After-Sales | As an After-Sales Associate, I want to generate invoices for completed repairs so that customers receive a detailed breakdown of charges. | Repair & QA | 3 |
| TEAM5-50 | After-Sales | As an After-Sales Specialist, I want to schedule a store pickup or courier for the completed item, so that the client can conveniently collect or receive their product. | Return & Collection | 3 |
| TEAM5-51 | After-Sales | As an After-Sales Specialist, I want to generate return documentation for the completed service, so that there is a formal record of the handover. | Return & Collection | 2 |
| TEAM5-52 | After-Sales | As an After-Sales Specialist, I want the client to digitally sign off on collection, so that we have proof of delivery and the ticket can be formally closed. | Return & Collection | 3 |
| TEAM5-53 | After-Sales | As an After-Sales Specialist, I want to scan a final packaging QR before releasing the item, so that inventory records are updated and the AST is closed accurately. | Return & Collection | 3 |
