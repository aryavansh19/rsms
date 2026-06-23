import SwiftUI

/// Manager shell.
struct ManagerTabView: View {
    var body: some View {
        TabView {
            InventoryDashboardView().tabItem { Label("Inventory", systemImage: "circle") }
            StockRequestsView().tabItem { Label("Requests", systemImage: "circle") }
            PricingBandView().tabItem { Label("Pricing", systemImage: "circle") }
            EventsView().tabItem { Label("Events", systemImage: "circle") }
            StaffView().tabItem { Label("Staff", systemImage: "circle") }
        }
    }
}
