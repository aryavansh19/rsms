import SwiftUI

/// Role-based router (RBAC).
struct RootView: View {
    @Environment(SessionStore.self) private var session
    var body: some View {
        switch session.currentRole {
        case .none:           LoginView()
        case .admin:          AdminTabView()
        case .manager:        ManagerTabView()
        case .salesAssociate: SalesTabView()
        case .afterSales:     AfterSalesTabView()
        }
    }
}
