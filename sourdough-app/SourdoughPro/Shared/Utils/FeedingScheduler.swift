import Foundation

/// Predicts when a starter should next be fed based on feeding history and
/// the user's preferred lead time. Pure, easy to unit-test.
enum FeedingScheduler {

    /// Returns an estimated next-feeding date given a starter's recent feedings.
    /// Strategy:
    /// - If 3+ feedings exist, average the intervals between them.
    /// - Otherwise fall back to a 12-hour default.
    /// - Round up to the next hour so the reminder looks natural.
    static func nextFeeding(for starter: Starter, now: Date = Date()) -> Date? {
        guard let last = starter.lastFedAt ?? starter.feedings.sorted(by: { $0.date > $1.date }).first?.date else {
            return nil
        }
        let interval = averageInterval(starter.feedings) ?? 12 * 3600
        let raw = last.addingTimeInterval(interval)
        // round up to next whole hour
        let cal = Calendar.current
        let comps = cal.dateComponents([.year, .month, .day, .hour], from: raw)
        return cal.date(from: comps)?.addingTimeInterval(raw > cal.date(from: comps)! ? 3600 : 0) ?? raw
    }

    /// Hours from `now` until the next feeding. Clamped to 0 if overdue.
    static func hoursUntilNextFeeding(for starter: Starter, now: Date = Date()) -> Int? {
        guard let next = nextFeeding(for: starter, now: now) else { return nil }
        let delta = next.timeIntervalSince(now)
        return Int(max(0, delta / 3600).rounded())
    }

    /// Is the starter currently overdue for feeding?
    static func isOverdue(_ starter: Starter, now: Date = Date()) -> Bool {
        guard let next = nextFeeding(for: starter, now: now) else { return false }
        return next < now
    }

    /// Average interval between feedings in seconds, or nil if fewer than 2.
    static func averageInterval(_ feedings: [Feeding]) -> TimeInterval? {
        let sorted = feedings.sorted { $0.date < $1.date }
        guard sorted.count >= 2 else { return nil }
        let intervals = zip(sorted, sorted.dropFirst()).map { $1.date.timeIntervalSince($0.date) }
        return intervals.reduce(0, +) / Double(intervals.count)
    }
}
