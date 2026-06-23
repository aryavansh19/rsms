import Foundation

/// Floor enforcement (TEAM5-67/18/19).
protocol PricingService { func setLocalPrice(skuID: String, storeID: String, price: Decimal) throws }
