import Foundation

@Observable
final class SessionStore {
    private(set) var session: Session?
    var currentRole: UserRole? { session?.role }
    func signIn(_ s: Session) { session = s }
    func signOut() { session = nil }
}
