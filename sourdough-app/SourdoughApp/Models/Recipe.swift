import Foundation

struct Recipe: Identifiable, Codable, Hashable {
    var id: UUID = UUID()
    var name: String
    var summary: String
    var difficulty: Difficulty
    /// Hands-on prep time in minutes.
    var prepTimeMinutes: Int
    /// Total elapsed time in hours (including long ferments).
    var totalDurationHours: Int
    var servings: Int
    var ingredients: [Ingredient]
    var steps: [RecipeStep]
    /// Hydration percentage.
    var hydration: Int
    var flourType: FlourType
    var imageUrl: String?
    var authorId: UUID?
    var isPremium: Bool = false
    var tags: [String] = []
    var rating: Double?
    var reviewCount: Int = 0
}

struct Ingredient: Identifiable, Codable, Hashable {
    var id: UUID = UUID()
    var name: String
    var grams: Int
    /// Baker's percentage — total flour = 100%.
    var bakersPercent: Double?
    var notes: String?
}

struct RecipeStep: Identifiable, Codable, Hashable {
    var id: UUID = UUID()
    var order: Int
    var title: String
    var instructions: String
    /// Minutes for a timed step (nil = untimed).
    var durationMinutes: Int?
    var timerType: TimerType?
    var imageUrl: String?
}
