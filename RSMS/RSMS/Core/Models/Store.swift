import Foundation

struct Store: Identifiable, Codable {
    let id: String
    var name: String
    var locale: String
    var currencyCode: String
    var timeZoneID: String
    var managerID: String?
}
