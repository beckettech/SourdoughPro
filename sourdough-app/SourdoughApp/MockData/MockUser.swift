import Foundation

enum MockUser {
    static let sample: User = {
        var u = User(
            email: "beck@sourdough.app",
            displayName: "Beck",
            avatarUrl: nil,
            subscriptionTier: .pro,
            subscriptionExpiresAt: Calendar.current.date(byAdding: .year, value: 1, to: Date()),
            aiScansRemaining: 999,
            createdAt: Calendar.current.date(byAdding: .day, value: -120, to: Date()) ?? Date()
        )
        u.settings = UserSettings(
            unitsSystem: .metric,
            theme: .system,
            notificationsEnabled: true,
            feedingReminderLeadTimeHours: 2,
            streakGoalDays: 7
        )
        return u
    }()

    static let achievements: [Achievement] = [
        Achievement(code: "first_loaf", title: "First Loaf",    icon: "trophy.fill",
                    earnedAt: Calendar.current.date(byAdding: .day, value: -110, to: Date()) ?? Date()),
        Achievement(code: "ten_bakes",  title: "10 Bakes",      icon: "flame.fill",
                    earnedAt: Calendar.current.date(byAdding: .day, value: -60,  to: Date()) ?? Date()),
        Achievement(code: "week_streak", title: "7-Day Streak", icon: "flame.fill",
                    earnedAt: Calendar.current.date(byAdding: .day, value: -10,  to: Date()) ?? Date()),
    ]
}
