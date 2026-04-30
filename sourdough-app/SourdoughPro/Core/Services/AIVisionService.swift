import Foundation

protocol AIVisionService: AnyObject {
    func analyzeStarter(imageData: Data, starterId: UUID) async throws -> StarterAnalysis
    func analyzeCrumb(imageData: Data, bakeSessionId: UUID) async throws -> CrumbAnalysis
}

final class MockAIVisionService: AIVisionService {
    func analyzeStarter(imageData: Data, starterId: UUID) async throws -> StarterAnalysis {
        // Simulate the round-trip latency users will feel with GPT-4o Vision.
        try await Task.sleep(nanoseconds: 2_000_000_000)
        return MockAnalyses.starter(for: starterId)
    }

    func analyzeCrumb(imageData: Data, bakeSessionId: UUID) async throws -> CrumbAnalysis {
        try await Task.sleep(nanoseconds: 2_200_000_000)
        return MockAnalyses.crumb(for: bakeSessionId)
    }
}

// MARK: - OpenAI Vision (direct, no Supabase required)

/// Calls GPT-4o Vision directly from the app.
/// API key is read from Info.plist key `OpenAIAPIKey`, which is populated
/// from the `OPENAI_API_KEY` Xcode user-defined build setting (never hard-coded
/// or committed to git).
final class OpenAIVisionService: AIVisionService {

    private let apiKey: String
    private let session = URLSession.shared
    private let endpoint = URL(string: "https://api.openai.com/v1/chat/completions")!

    init(apiKey: String) {
        self.apiKey = apiKey
    }

    // MARK: Protocol

    func analyzeStarter(imageData: Data, starterId: UUID) async throws -> StarterAnalysis {
        let prompt = """
        You are a sourdough expert analyzing a photo of a sourdough starter.

        Analyze this starter photo and provide:
        1. Health score (0–10) based on bubble activity, rise height, color, texture, and any visible issues (hooch, mold, separation).
        2. List of issues detected (if any).
        3. Specific recommendations for improvement.
        4. Estimated hours until peak activity.
        5. Any positives you observe.

        Respond ONLY with valid JSON (no markdown fences):
        {
          "health_score": 8.5,
          "issues": ["slight hooch layer visible"],
          "positives": ["active bubbles", "good rise"],
          "recommendations": ["Feed within 4–6 hours", "Consider 1:3:3 ratio"],
          "estimated_peak_hours": 6
        }
        """
        let raw = try await callVision(imageData: imageData, prompt: prompt)
        return try parseStarterAnalysis(json: raw, starterId: starterId)
    }

    func analyzeCrumb(imageData: Data, bakeSessionId: UUID) async throws -> CrumbAnalysis {
        let prompt = """
        You are a professional baker analyzing the crumb structure of a sourdough loaf cross-section.

        Analyze this photo and provide:
        1. Overall score (0–10).
        2. Crumb structure classification: one of "open", "tight", "irregular", "perfect".
        3. Fermentation score (0–10).
        4. Shaping score (0–10).
        5. Bake score (0–10).
        6. Specific observations (2–4 items).
        7. Recommendations for improvement (2–3 items).

        Respond ONLY with valid JSON (no markdown fences):
        {
          "overall_score": 7.5,
          "crumb_structure": "open",
          "fermentation_score": 8,
          "shaping_score": 7,
          "bake_score": 8,
          "observations": ["Good open crumb", "Slight density at base"],
          "recommendations": ["Extend proof by 30 min", "Try higher hydration"]
        }
        """
        let raw = try await callVision(imageData: imageData, prompt: prompt)
        return try parseCrumbAnalysis(json: raw, bakeSessionId: bakeSessionId)
    }

    // MARK: Network

    private func callVision(imageData: Data, prompt: String) async throws -> [String: Any] {
        let base64 = imageData.base64EncodedString()

        let body: [String: Any] = [
            "model": "gpt-4o",
            "messages": [[
                "role": "user",
                "content": [
                    [
                        "type": "image_url",
                        "image_url": [
                            "url": "data:image/jpeg;base64,\(base64)",
                            "detail": "high"
                        ]
                    ],
                    [
                        "type": "text",
                        "text": prompt
                    ]
                ]
            ]],
            "max_tokens": 1000,
            "response_format": ["type": "json_object"]
        ]

        var request = URLRequest(url: endpoint)
        request.httpMethod = "POST"
        request.setValue("Bearer \(apiKey)", forHTTPHeaderField: "Authorization")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = try JSONSerialization.data(withJSONObject: body)

        let (data, response) = try await session.data(for: request)

        guard let http = response as? HTTPURLResponse else {
            throw APIError.network("No HTTP response")
        }
        guard http.statusCode == 200 else {
            let msg = String(data: data, encoding: .utf8) ?? "unknown"
            if http.statusCode == 429 { throw APIError.rateLimited }
            if http.statusCode == 401 { throw APIError.unauthorized }
            throw APIError.serverError(http.statusCode, msg)
        }

        guard
            let outer   = try JSONSerialization.jsonObject(with: data) as? [String: Any],
            let choices = outer["choices"] as? [[String: Any]],
            let first   = choices.first,
            let message = first["message"] as? [String: Any],
            let content = message["content"] as? String
        else {
            throw APIError.decoding("Unexpected OpenAI response shape")
        }

        // Strip any stray markdown fences GPT may emit despite response_format
        let cleaned = content
            .trimmingCharacters(in: .whitespacesAndNewlines)
            .replacingOccurrences(of: "```json", with: "")
            .replacingOccurrences(of: "```", with: "")
            .trimmingCharacters(in: .whitespacesAndNewlines)

        guard
            let jsonData = cleaned.data(using: .utf8),
            let result   = try JSONSerialization.jsonObject(with: jsonData) as? [String: Any]
        else {
            throw APIError.decoding("Could not parse JSON from GPT content: \(cleaned)")
        }

        return result
    }

    // MARK: Parsing

    private func parseStarterAnalysis(json: [String: Any], starterId: UUID) throws -> StarterAnalysis {
        guard let healthScore = (json["health_score"] as? Double) ?? (json["health_score"] as? Int).map(Double.init) else {
            throw APIError.decoding("Missing health_score")
        }
        let issues          = json["issues"] as? [String] ?? []
        let positives       = json["positives"] as? [String] ?? []
        let recommendations = json["recommendations"] as? [String] ?? []
        let peakHours       = (json["estimated_peak_hours"] as? Int) ?? (json["estimated_peak_hours"] as? Double).map(Int.init)

        return StarterAnalysis(
            id: UUID(),
            starterId: starterId,
            imageUrl: "",
            createdAt: Date(),
            healthScore: healthScore,
            estimatedPeakHours: peakHours,
            issues: issues,
            positives: positives,
            recommendations: recommendations,
            rawResponse: (try? JSONSerialization.data(withJSONObject: json))
                .flatMap { String(data: $0, encoding: .utf8) } ?? ""
        )
    }

    private func parseCrumbAnalysis(json: [String: Any], bakeSessionId: UUID) throws -> CrumbAnalysis {
        guard let overallScore = (json["overall_score"] as? Double) ?? (json["overall_score"] as? Int).map(Double.init) else {
            throw APIError.decoding("Missing overall_score")
        }
        let structureRaw     = json["crumb_structure"] as? String ?? "tight"
        let crumbStructure   = CrumbStructure(rawValue: structureRaw) ?? .tight
        let fermentation     = (json["fermentation_score"] as? Double) ?? (json["fermentation_score"] as? Int).map(Double.init) ?? 5
        let shaping          = (json["shaping_score"] as? Double) ?? (json["shaping_score"] as? Int).map(Double.init) ?? 5
        let bake             = (json["bake_score"] as? Double) ?? (json["bake_score"] as? Int).map(Double.init) ?? 5
        let observations     = json["observations"] as? [String] ?? []
        let recommendations  = json["recommendations"] as? [String] ?? []

        return CrumbAnalysis(
            id: UUID(),
            bakeSessionId: bakeSessionId,
            imageUrl: "",
            createdAt: Date(),
            overallScore: overallScore,
            crumbStructure: crumbStructure,
            fermentationScore: fermentation,
            shapingScore: shaping,
            bakeScore: bake,
            observations: observations,
            recommendations: recommendations,
            rawResponse: (try? JSONSerialization.data(withJSONObject: json))
                .flatMap { String(data: $0, encoding: .utf8) } ?? ""
        )
    }
}
