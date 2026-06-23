import Foundation

struct SKU: Identifiable, Codable {
    let id: String
    var name: String
    var launchDate: Date
    var pricing: [String: PriceBand]
}
