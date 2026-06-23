import SwiftUI

/// Admin shell.
struct AdminTabView: View {
    var body: some View {
        TabView {
            StoreOnboardingView().tabItem { Label("Stores", systemImage: "circle") }
            ProductPricingView().tabItem { Label("Products", systemImage: "circle") }
            TransfersView().tabItem { Label("Transfers", systemImage: "circle") }
            AnalyticsView().tabItem { Label("Analytics", systemImage: "circle") }
            ProfilesView().tabItem { Label("Profiles", systemImage: "circle") }
        }
    }
}
