import Foundation

struct Order: Identifiable, Codable {
    let id: String
    var lineItems: [String]
    var paymentMethod: String
    var clientID: String?
}
