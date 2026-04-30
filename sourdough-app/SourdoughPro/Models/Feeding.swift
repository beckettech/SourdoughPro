import Foundation

struct Feeding: Identifiable, Codable, Hashable {
    var id: UUID = UUID()
    var starterId: UUID
    var date: Date
    var starterGrams: Int
    var flourGrams: Int
    var waterGrams: Int
    var notes: String?
    var photoUrl: String?
    var riseHeightCm: Int?
    /// How many minutes after this feeding did the starter visibly peak?
    /// Logged by the user on the next feed or from memory. Used to predict "ready to bake" timing.
    var peakTimeMinutes: Int?
    var smellRating: SmellRating?
    var bubbleSize: BubbleSize?

    /// Ratio notation, e.g. "1:2:2".
    var ratio: String {
        let minimum = max(1, min(starterGrams, flourGrams, waterGrams))
        func r(_ v: Int) -> String {
            let f = Double(v) / Double(minimum)
            return f.truncatingRemainder(dividingBy: 1) == 0
                ? "\(Int(f))"
                : String(format: "%.1f", f)
        }
        return "\(r(starterGrams)):\(r(flourGrams)):\(r(waterGrams))"
    }

    var descriptionLine: String {
        "\(starterGrams)g starter + \(flourGrams)g flour + \(waterGrams)g water"
    }
}
