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

/// Real implementation — calls Supabase Edge Functions `analyze-starter`
/// and `analyze-crumb` which in turn invoke GPT-4o Vision with the prompts
/// from DEV_SPEC.md §7.
final class OpenAIVisionService: AIVisionService {
    private let client: APIClient
    init(client: APIClient) { self.client = client }

    func analyzeStarter(imageData: Data, starterId: UUID) async throws -> StarterAnalysis {
        // Expected request shape:
        // POST /functions/v1/analyze-starter
        //   { "image_base64": "<base64>", "starter_id": "<uuid>" }
        throw APIError.notImplemented
    }

    func analyzeCrumb(imageData: Data, bakeSessionId: UUID) async throws -> CrumbAnalysis {
        throw APIError.notImplemented
    }
}
