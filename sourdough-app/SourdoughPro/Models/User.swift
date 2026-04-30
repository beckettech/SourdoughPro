import Foundation

struct User: Identifiable, Codable, Hashable {
    var id: UUID = UUID()
    var email: String
    var displayName: String?
    var avatarUrl: String?
    var subscriptionTier: SubscriptionTier = .free
    var subscriptionExpiresAt: Date? = nil
    /// Remaining AI scans for the free tier. Reset monthly server-side.
    var aiScansRemaining: Int = 3
    var createdAt: Date
    var settings: UserSettings = UserSettings()

    var initials: String {
        let source = displayName ?? email
        let parts = source.split(separator: " ")
        if parts.count >= 2, let f = parts.first?.first, let l = parts.last?.first {
            return "\(f)\(l)"
        }
        return String(source.prefix(2))
    }
}

struct UserSettings: Codable, Hashable {
    var unitsSystem: UnitsSystem = .metric
    var theme: AppTheme = .system
    var notificationsEnabled: Bool = true
    var feedingReminderLeadTimeHours: Int = 2
    var streakGoalDays: Int = 7
}

/// Persisted achievement earned by the user.
struct Achievement: Identifiable, Codable, Hashable {
    var id: UUID = UUID()
    var code: String
    var title: String
    var icon: String
    var earnedAt: Date
}
