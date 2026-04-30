import Foundation

enum FlourType: String, Codable, CaseIterable, Identifiable {
    case bread        = "bread"
    case wholeWheat   = "whole_wheat"
    case allPurpose   = "all_purpose"
    case rye          = "rye"
    case spelt        = "spelt"
    case einkorn      = "einkorn"
    case mixed        = "mixed"

    var id: String { rawValue }
    var displayName: String {
        switch self {
        case .bread:       return "Bread flour"
        case .wholeWheat:  return "Whole wheat"
        case .allPurpose:  return "All-purpose"
        case .rye:         return "Rye"
        case .spelt:       return "Spelt"
        case .einkorn:     return "Einkorn"
        case .mixed:       return "Mixed"
        }
    }
    var helper: String? {
        switch self {
        case .bread:      return "Recommended for beginners"
        case .wholeWheat: return "More nutritious, faster ferment"
        case .allPurpose: return "Versatile, readily available"
        case .rye:        return "Tangier, denser crumb"
        default:          return nil
        }
    }
}

enum SmellRating: String, Codable, CaseIterable, Identifiable {
    case pleasant, sour, funky, off
    var id: String { rawValue }
    var displayName: String { rawValue.capitalized }
    var emoji: String {
        switch self {
        case .pleasant: return "😊"
        case .sour:     return "🍋"
        case .funky:    return "😬"
        case .off:      return "⚠️"
        }
    }
}

enum BubbleSize: String, Codable, CaseIterable, Identifiable {
    case none, small, medium, large
    var id: String { rawValue }
    var displayName: String { rawValue.capitalized }
}

enum Difficulty: String, Codable, CaseIterable, Identifiable, Comparable {
    case beginner, intermediate, advanced
    var id: String { rawValue }
    var displayName: String { rawValue.capitalized }
    private var sortOrder: Int {
        switch self { case .beginner: return 0; case .intermediate: return 1; case .advanced: return 2 }
    }
    static func < (lhs: Difficulty, rhs: Difficulty) -> Bool { lhs.sortOrder < rhs.sortOrder }
    var chipStyle: SDChipStyleBridge { // avoid exposing SDChip types to model layer
        switch self {
        case .beginner:     return .success
        case .intermediate: return .info
        case .advanced:     return .warning
        }
    }
}

/// Lightweight bridge so the model layer doesn't import SwiftUI.
enum SDChipStyleBridge { case success, info, warning, error, defaultStyle }

enum TimerType: String, Codable {
    case bulk, proof, bake, rest, mix, shape, feed
    var displayName: String {
        switch self {
        case .bulk:  return "Bulk ferment"
        case .proof: return "Proof"
        case .bake:  return "Bake"
        case .rest:  return "Rest"
        case .mix:   return "Mix"
        case .shape: return "Shape"
        case .feed:  return "Feed starter"
        }
    }
}

enum CrumbStructure: String, Codable {
    case open, tight, irregular, perfect
    var displayName: String { rawValue.capitalized }
}

enum SubscriptionTier: String, Codable, CaseIterable {
    case free, pro, baker
    var displayName: String {
        switch self {
        case .free:  return "Free"
        case .pro:   return "Pro"
        case .baker: return "Baker"
        }
    }
    var monthlyPrice: String? {
        switch self {
        case .free:  return nil
        case .pro:   return "$4.99/mo"
        case .baker: return "$9.99/mo"
        }
    }
}

enum UnitsSystem: String, Codable, CaseIterable {
    case metric, imperial
    var displayName: String { rawValue.capitalized }
}

enum AppTheme: String, Codable, CaseIterable {
    case system, light, dark
    var displayName: String { rawValue.capitalized }
}
