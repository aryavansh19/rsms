import SwiftUI

@main
struct RSMSApp: App {
    @State private var session = SessionStore()
    var body: some Scene { WindowGroup { RootView().environment(session) } }
}
