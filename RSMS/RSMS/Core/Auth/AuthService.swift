import Foundation

protocol AuthService {
    func signInWithPasskey() async throws -> Session
    func currentSession() -> Session?
    func signOut() async
}
