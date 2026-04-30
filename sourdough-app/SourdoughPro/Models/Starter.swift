import Foundation

struct Starter: Identifiable, Codable, Hashable {
    var id: UUID = UUID()
    var name: String
    var createdAt: Date
    var flourType: FlourType
    /// Hydration %, usually 100.
    var hydration: Int = 100
    var feedings: [Feeding] = []
    var photos: [StarterPhoto] = []
    var healthScore: Double? = nil
    var lastFedAt: Date? = nil
    var nextFeedingAt: Date? = nil
    var isActive: Bool = true
    var notes: String = ""
    var photoUrl: String? = nil

    /// Computed: days since creation.
    var ageInDays: Int {
        Calendar.current.dateComponents([.day], from: createdAt, to: Date()).day ?? 0
    }
}

struct StarterPhoto: Identifiable, Codable, Hashable {
    var id: UUID = UUID()
    var url: String
    var takenAt: Date
    var healthScore: Double?
}
