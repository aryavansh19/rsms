import SwiftUI

/// After-Sales Specialist shell.
struct AfterSalesTabView: View {
    var body: some View {
        TabView {
            IntakeView().tabItem { Label("Intake", systemImage: "circle") }
            EstimateView().tabItem { Label("Estimate", systemImage: "circle") }
            RepairView().tabItem { Label("Repair", systemImage: "circle") }
            ReturnView().tabItem { Label("Return", systemImage: "circle") }
            WorkloadView().tabItem { Label("Workload", systemImage: "circle") }
        }
    }
}
