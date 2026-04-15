import Foundation

/// Simple streak counter — consecutive days with at least one feeding.
enum StreakCounter {
    static func currentStreak(feedings: [Feeding], now: Date = Date()) -> Int {
        let cal = Calendar.current
        let days = Set(feedings.map { cal.startOfDay(for: $0.date) })
        var streak = 0
        var cursor = cal.startOfDay(for: now)
        while days.contains(cursor) {
            streak += 1
            cursor = cal.date(byAdding: .day, value: -1, to: cursor) ?? cursor
        }
        return streak
    }
}
