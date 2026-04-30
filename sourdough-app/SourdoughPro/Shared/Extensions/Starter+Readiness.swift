import Foundation

// MARK: - ReadinessStatus

/// Predicted state of a starter relative to its bake window.
/// Computed from peak-time history recorded in Feeding.peakTimeMinutes.
enum ReadinessStatus {
    case noData                       // no peak times recorded yet
    case notFedYet                    // never fed, or no feedings at all
    case readyNow(since: Int)         // at/near peak — minutes since it peaked (0 = right now)
    case readySoon(inMinutes: Int)    // minutes until expected peak
    case pastPeak(since: Int)         // minutes past peak (over-fermentation risk)
}

// MARK: - Starter extension

extension Starter {

    /// Average peak time (minutes after feeding) across all feedings that have peak data.
    var averagePeakMinutes: Int? {
        let peaks = feedings.compactMap { $0.peakTimeMinutes }
        guard !peaks.isEmpty else { return nil }
        return peaks.reduce(0, +) / peaks.count
    }

    /// Predicted readiness based on average peak history and time since last feeding.
    var readinessStatus: ReadinessStatus {
        guard let avgPeak = averagePeakMinutes else { return .noData }
        guard let lastFed = lastFedAt else { return .notFedYet }
        let minutesSinceFed = Int(Date().timeIntervalSince(lastFed) / 60)
        let minutesToPeak = avgPeak - minutesSinceFed
        if minutesToPeak > 15 {
            return .readySoon(inMinutes: minutesToPeak)
        } else if minutesToPeak > -30 {
            return .readyNow(since: max(0, -minutesToPeak))
        } else {
            return .pastPeak(since: -minutesToPeak)
        }
    }
}
