import Foundation

struct PriceBand: Identifiable, Codable {
    var basePrice: Decimal
    var floorPrice: Decimal
    var localPrice: Decimal?
}
