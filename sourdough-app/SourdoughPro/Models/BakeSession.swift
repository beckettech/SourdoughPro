import Foundation

struct BakeSession: Identifiable, Codable, Hashable {
    var id: UUID = UUID()
    var starterId: UUID
    var recipeId: UUID
    var recipeName: String
    var startedAt: Date
    var completedAt: Date? = nil
    var currentStepIndex: Int = 0
    var stepHistory: [StepCompletion] = []
    var photos: [BakePhoto] = []
    var crumbAnalysisId: UUID? = nil
    var notes: String = ""
    /// 1-5 star rating after the bake.
    var rating: Int? = nil
}

struct StepCompletion: Codable, Hashable {
    var stepId: UUID
    var completedAt: Date
    /// Actual minutes taken, if different from planned.
    var actualMinutes: Int?
}

struct BakePhoto: Identifiable, Codable, Hashable {
    var id: UUID = UUID()
    var url: String
    var takenAt: Date
    var stepId: UUID?
    var caption: String?
}
