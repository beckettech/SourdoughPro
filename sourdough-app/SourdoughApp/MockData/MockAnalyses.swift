import Foundation

enum MockAnalyses {

    static func starter(for starterId: UUID) -> StarterAnalysis {
        StarterAnalysis(
            starterId: starterId,
            imageUrl: "mock://starter.jpg",
            createdAt: Date(),
            healthScore: 8.5,
            estimatedPeakHours: 6,
            issues: ["Slight hooch layer visible on top"],
            positives: [
                "Good bubble activity — small and large bubbles distributed evenly",
                "Healthy rise height (~4 cm from last feeding)",
                "Creamy off-white colour, no discolouration",
            ],
            recommendations: [
                "Feed within 4-6 hours for best activity window",
                "Consider increasing feeding ratio to 1:3:3 for a livelier starter",
                "Store in a warmer location (75-78°F) if possible",
            ],
            rawResponse: #"""
            {
              "health_score": 8.5,
              "issues": ["slight hooch layer visible"],
              "recommendations": [
                "Feed within 4-6 hours",
                "Consider increasing feeding ratio to 1:3:3",
                "Store in warmer location (75-78°F)"
              ],
              "estimated_peak_hours": 6
            }
            """#
        )
    }

    static func crumb(for bakeId: UUID) -> CrumbAnalysis {
        CrumbAnalysis(
            bakeSessionId: bakeId,
            imageUrl: "mock://crumb.jpg",
            createdAt: Date(),
            overallScore: 7.5,
            crumbStructure: .open,
            fermentationScore: 8,
            shapingScore: 7,
            bakeScore: 8,
            observations: [
                "Good open crumb structure with irregular hole distribution",
                "Slight denseness at the bottom suggests minor under-proofing",
                "Nice ear on the score — strong oven spring",
            ],
            recommendations: [
                "Extend bulk ferment by 30-60 minutes next time",
                "Consider slightly higher hydration (+2%) for more openness",
                "Score slightly deeper for an even more pronounced ear",
            ],
            rawResponse: #"""
            {
              "overall_score": 7.5,
              "crumb_structure": "open",
              "fermentation_score": 8,
              "shaping_score": 7,
              "bake_score": 8
            }
            """#
        )
    }
}
