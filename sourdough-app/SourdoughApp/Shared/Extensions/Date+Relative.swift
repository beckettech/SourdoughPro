import Foundation

extension Date {
    /// Short relative string, e.g. "18h ago", "2d ago", "now", "in ~4 hours".
    func relativeShort(reference: Date = Date()) -> String {
        let delta = Int(reference.timeIntervalSince(self))
        if abs(delta) < 60 { return "now" }
        let absDelta = abs(delta)
        let future = delta < 0

        let (value, unit): (Int, String) = {
            switch absDelta {
            case ..<3600:     return (absDelta / 60, "m")
            case ..<86_400:   return (absDelta / 3600, "h")
            case ..<604_800:  return (absDelta / 86_400, "d")
            case ..<2_592_000:return (absDelta / 604_800, "w")
            default:          return (absDelta / 2_592_000, "mo")
            }
        }()
        return future ? "in \(value)\(unit)" : "\(value)\(unit) ago"
    }

    /// Long relative string, e.g. "18 hours ago".
    func relativeLong(reference: Date = Date()) -> String {
        let formatter = RelativeDateTimeFormatter()
        formatter.unitsStyle = .full
        return formatter.localizedString(for: self, relativeTo: reference)
    }

    /// "Today, 6:00 AM" / "Yesterday, 6:00 PM" / "Jan 15, 6:00 AM"
    func friendlyTimestamp(reference: Date = Date()) -> String {
        let cal = Calendar.current
        let time = DateFormatter.shortTime.string(from: self)
        if cal.isDateInToday(self)    { return "Today, \(time)" }
        if cal.isDateInYesterday(self){ return "Yesterday, \(time)" }
        if cal.isDate(self, equalTo: reference, toGranularity: .year) {
            return "\(DateFormatter.monthDay.string(from: self)), \(time)"
        }
        return "\(DateFormatter.monthDayYear.string(from: self)), \(time)"
    }

    /// Alias for `relativeShort()` — "18h ago", "2d ago", etc.
    var relativeDescription: String { relativeShort() }
}

extension DateFormatter {
    static let shortTime: DateFormatter = {
        let f = DateFormatter(); f.dateFormat = "h:mm a"; return f
    }()
    static let monthDay: DateFormatter = {
        let f = DateFormatter(); f.dateFormat = "MMM d"; return f
    }()
    static let monthDayYear: DateFormatter = {
        let f = DateFormatter(); f.dateFormat = "MMM d, yyyy"; return f
    }()
}
