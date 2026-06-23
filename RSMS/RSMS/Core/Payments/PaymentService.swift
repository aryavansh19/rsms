import Foundation

/// TEAM5-7 setup + 33/34.
protocol PaymentService {
    func pay(amount: Decimal, currency: String) async throws
    func issueDigitalReceipt(orderID: String) async throws -> URL
}
