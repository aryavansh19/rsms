import Foundation

struct AfterSalesTicket: Identifiable, Codable {
    let id: String
    var type: String
    var serial: String
    var stage: String
}
