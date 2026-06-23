import Foundation

struct Session: Codable {
    let userID: String
    let role: UserRole
    let storeID: String?
    let expiresAt: Date
}
