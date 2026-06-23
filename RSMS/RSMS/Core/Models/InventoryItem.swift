import Foundation

struct InventoryItem: Identifiable, Codable {
    var skuID: String
    var storeID: String
    var onHand: Int
    var reorderThreshold: Int
}
