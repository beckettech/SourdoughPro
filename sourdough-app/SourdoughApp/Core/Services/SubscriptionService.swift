import Foundation
import Combine

protocol SubscriptionService: AnyObject {
    var tierPublisher: AnyPublisher<SubscriptionTier, Never> { get }
    var tier: SubscriptionTier { get }

    func currentOfferings() async throws -> [SubscriptionOffering]
    func purchase(_ offering: SubscriptionOffering) async throws -> SubscriptionTier
    func restorePurchases() async throws -> SubscriptionTier
    func manageSubscription() -> URL?
}

struct SubscriptionOffering: Identifiable, Hashable {
    enum Period { case monthly, yearly }
    let id: String
    let tier: SubscriptionTier
    let period: Period
    let price: String
    let savingsLabel: String?   // e.g. "Save 17%"
}

final class MockSubscriptionService: SubscriptionService {
    @Published private var _tier: SubscriptionTier
    var tier: SubscriptionTier { _tier }
    var tierPublisher: AnyPublisher<SubscriptionTier, Never> { $_tier.eraseToAnyPublisher() }

    init(initial: SubscriptionTier = .pro) { self._tier = initial }

    func currentOfferings() async throws -> [SubscriptionOffering] {
        try await Task.sleep(nanoseconds: 200_000_000)
        return [
            SubscriptionOffering(id: "pro_monthly",   tier: .pro,   period: .monthly, price: "$4.99",  savingsLabel: nil),
            SubscriptionOffering(id: "pro_yearly",    tier: .pro,   period: .yearly,  price: "$49.99", savingsLabel: "Save 17%"),
            SubscriptionOffering(id: "baker_monthly", tier: .baker, period: .monthly, price: "$9.99",  savingsLabel: nil),
            SubscriptionOffering(id: "baker_yearly",  tier: .baker, period: .yearly,  price: "$99.99", savingsLabel: "Save 17%"),
        ]
    }
    func purchase(_ offering: SubscriptionOffering) async throws -> SubscriptionTier {
        try await Task.sleep(nanoseconds: 700_000_000)
        _tier = offering.tier
        return offering.tier
    }
    func restorePurchases() async throws -> SubscriptionTier {
        try await Task.sleep(nanoseconds: 400_000_000)
        return _tier
    }
    func manageSubscription() -> URL? {
        URL(string: "https://apps.apple.com/account/subscriptions")
    }
}

/// Real implementation would call RevenueCat's `Purchases.shared`.
final class RevenueCatSubscriptionService: SubscriptionService {
    @Published private var _tier: SubscriptionTier = .free
    var tier: SubscriptionTier { _tier }
    var tierPublisher: AnyPublisher<SubscriptionTier, Never> { $_tier.eraseToAnyPublisher() }

    func currentOfferings() async throws -> [SubscriptionOffering] { throw APIError.notImplemented }
    func purchase(_ offering: SubscriptionOffering) async throws -> SubscriptionTier { throw APIError.notImplemented }
    func restorePurchases() async throws -> SubscriptionTier { throw APIError.notImplemented }
    func manageSubscription() -> URL? {
        URL(string: "https://apps.apple.com/account/subscriptions")
    }
}
