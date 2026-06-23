import Foundation

struct TransferRequest: Identifiable, Codable {
    let id: String
    var skuID: String
    var quantity: Int
    var status: String
}
