import Foundation

struct StarterAnalysis: Identifiable, Codable, Hashable {
    var id: UUID = UUID()
    var starterId: UUID
    var imageUrl: String
    var createdAt: Date
    /// 0-10 score.
    var healthScore: Double
    /// Predicted hours until peak activity.
    var estimatedPeakHours: Int?
    var issues: [String]
    var positives: [String]
    var recommendations: [String]
    /// Raw JSON/text response for debugging.
    var rawResponse: String = ""
}

struct CrumbAnalysis: Identifiable, Codable, Hashable {
    var id: UUID = UUID()
    var bakeSessionId: UUID
    var imageUrl: String
    var createdAt: Date
    var overallScore: Double
    var crumbStructure: CrumbStructure
    var fermentationScore: Double
    var shapingScore: Double
    var bakeScore: Double
    var observations: [String]
    var recommendations: [String]
    var rawResponse: String = ""
}

/// Union type surfaced by the AI vision service so callers can handle
/// starter/crumb/proof results uniformly.
enum AnalysisKind: String, Codable, CaseIterable {
    case starter, crumb, proof
    var displayName: String {
        switch self {
        case .starter: return "Starter"
        case .crumb:   return "Crumb"
        case .proof:   return "Proof"
        }
    }
}
