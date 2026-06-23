import SwiftUI

/// Sales Associate shell.
struct SalesTabView: View {
    var body: some View {
        TabView {
            ClientelingView().tabItem { Label("Clients", systemImage: "circle") }
            RecommendationsView().tabItem { Label("Suggest", systemImage: "circle") }
            SellView().tabItem { Label("Sell", systemImage: "circle") }
            SalesSettingsView().tabItem { Label("Settings", systemImage: "circle") }
        }
    }
}
