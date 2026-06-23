import Foundation

struct Client: Identifiable, Codable {
    let id: String
    var name: String
    var phone: String
    var consentGranted: Bool
}
